# Description
#   Item aus Datenbank holen
#
# Configuration:
#   MLAB_USER_PW
#
# Commands:
#   oac.item <Name>
#
#
# Author:
#   Kaimodo

mongo = require('mongodb').MongoClient

#Connecting to the server
  
module.exports = (robot) ->
    robot.hear /oac.item (.*)/i, (res) ->
        searchName = res.match[1]#.toLowerCase()
        console.log 'Eingabe: ', searchName
        mdbPw = process.env.MLAB_USER_PW
        url = 'mongodb://Kaimodo:'+mdbPw+'@ds157390.mlab.com:57390/resitems'
        mongo.connect url, (err, db) ->
            if err
                console.log 'MongoDB: Unable to connect . Error:', err
            else
                console.log 'MongoDB: Connection established to', url                    

            #Daten finden
            db.collection('items_de.oac-head.com_2').find({ Name: new RegExp(searchName) } , {'limit':1}).toArray (err, result) ->
                if err
                    console.log err
                else
                    console.log 'Found: ', result

                if result.length == 0
                    console.log 'nicht in DB: ', searchName
                    res.send "Sorry Item (noch)nicht in der Datenbank"
                    return

                room= res.envelope.room
                timestamp= new Date/1000|0 
                
                payload = 
                    content:
                        text: ''
                        fallback: ''
                        pretext: ''
                        title: ''
                        title_link: ''
                        author_name: ''
                        author_link: ''
                        author_icon: ''
                        thumb_url: ''
                        color: '#EEEEEE'
                        footer: 'resis'
                        footer_icon: 'https://avatars.slack-edge.com/2017-03-09/151204178657_8ed2b3731b17d14bfdf9_48.png'
                        ts: timestamp
                        fields: []

                payload.content.pretext = 'Dein gesuchter Gegenstand:'
                payload.content.title = String(result[0].Name)
                payload.content.title_link = String(result[0].url)
                payload.content.text = String(result[0].AllData)
                payload.content.thumb_url = String(result[0].Picture)
                #Fileds
                #payload.content.fields.push title: 'title', value: "value", short: true
                #payload.content.fields[].title = 
                options = { as_user: true, link_names: 1, attachments: payload }

                client = robot.adapter.client
                client.web.chat.postMessage(room, '', options)                
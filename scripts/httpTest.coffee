# Description
#   Item aus Datenbank holen
#
# Configuration:
#   None needed. 
#
# Commands:
#   reshead <Nummer>
#
#
# Author:
#   Kaimodo
#   response.send "#{data.url.items[0]}"
#   https://resishead.firebaseio.com/.json?orderBy="$key"&startAt="Zith"&endAt="b\uf8ff"&print=pretty
#   https://reshead-fbf2.restdb.io/rest/items-de-oac-head-com?q={%22Name%22:%22Brustpanzer%20des%20Glaubensverteidigers%22}
module.exports = (robot) ->

  robot.hear /reshead (.*)/i, (response) ->
    artistName = response.match[1].toLowerCase()
    if artistName is ""
      response.send "Item Nr 1-8800"
    else
      searchName = artistName.replace(" ", "+")
      robot.http("https://resishead.firebaseio.com/#{searchName}.json?print=pretty")
        .get() (err, res, body) ->
          if err
            response.send "Oh noes! #{err}"
            return
          data = JSON.parse body
          response.send "Werte: #{data["Alle Daten"]}\n
                        BildUrl: #{data.VBild}"

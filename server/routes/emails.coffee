request = require 'superagent'
_ = require 'underscore'
config = require 'config'

logger = require '../utils/log'


# Takes the client side form data object and returns Wufoo-specific data
# format (again, JS object). This looks horrible and I had to reverse-engineer
# the POST messages we sent. But Wufoo does not cause our emails to be marked
# as spam so we want to keep using it.
convertFormDataToWufooFormat = (data) ->
  if (not _.isObject data) or (not data.email?)
    throw "Cannot convert to Wufoo format: Invalid form data."
  Field7: data.name
  Field8: data.email
  Field15: data.phone
  Field9: data.company
  Field11: data.budget
  Field12: data.request
  Field13: data.description


exports.setup = (app) ->

  app.post '/', (req, res) ->
    logger.debug "Receving Wufoo email request."
    try
      wufooData = convertFormDataToWufooFormat req.body
    catch e
      # Something went wrong with the conversion.
      logger.error e
      res.send 500, e
      return

    formReq = request
      .post("https://#{config.secret.wufoo.api_key}:s@" +
        "salsita.wufoo.com/api/v3/forms/#{config.secret.wufoo.form_id}/" +
        "entries.json")

    # Add the form data to our delicious HTTP mixture.
    for key, val of wufooData
      # Make sure our data is valid (validation should be handled on the client
      # side so this is just paranoia kicking in).
      if not val? then val = ''
      formReq = formReq.field key, val

    # Let's send it!
    formReq
      .end (err, wufooRes) ->
        if err or not wufooRes.ok
          logger.error "Email not sent to Wufoo: ", err or wufooRes.text
          res.send 500, wufooRes.text
        else
          logger.debug "Email to Wufoo sent."
          res.send 200, 'ok'

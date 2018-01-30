
SerialPort = require 'serialport'

class HologramNova
  constructor: ({device}) ->
    device = device || '/dev/tty.usbmodem1411'
    @nova = SerialPort device, { baudRate: 19200, parser: SerialPort.parsers.raw }, (err) ->
      return Error err if err?
      @_beginReading()

  _beginReading: () =>
    @nova.on 'data', (@response) =>
      console.log "New Data: ", @response

  _checkResponse: (retries, callback) =>
    i=0
    while i < retries
      setTimeout (=>
        return callback @response if @response?
        console.log {@response}
      ), retries * 1000
      i++
    if !@response?
      return callback null

  _evaluateResponse: (response, success, fail, callback) =>
    @response = null if response?
    if success == null || fail == null
      return callback response
    else
      return callback null, Error 'Failure: fail' if response == fail
      return callback response if response == success

  sendCommand: (cmd, wait, success, fail, callback) =>
    @nova.write cmd, (err) =>
      console.log {cmd, wait, success, fail}
      return callback Error err if err?
      setTimeout (=>
        console.log @nova.read()
        # @_checkResponse 5, (response) =>
        #   console.log {response}
        #   @_evaluateResponse response, success, fail, (res, err) =>
        #     return callback null, Error err if err?
        #     return callback(res) if res?
      ), wait * 100

module.exports = HologramNova

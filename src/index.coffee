
SerialPort = require 'serialport'
async = require 'async'
_ = require 'lodash'

class HologramNova
  constructor: ({device, @key, @ip, @port}) ->
    device = device || '/dev/tty.usbmodem1411'
    @ip = @ip || "23.253.146.203"
    @port = @port || "9999"
    @nova = SerialPort device, { baudRate: 19200, parser: SerialPort.parsers.raw }, (err) ->
      throw err if err?
      @sendCommand "AT+CMGF=1\r\n", 10, "OK", null, (err) =>
        throw err if err?

  connect: (callback) =>
    commands = [
      ["AT+CIPSHUT\r\n", 65, "SHUT OK", null]
      ["AT+CGATT?\r\n", 10, "OK", null]
      ["AT+CIPMUX=1\r\n", 2, "OK", null]
      ["AT+CSTT=\"hologram\"\r\n", 2, "OK", null]
      ["AT+CIICR\r\n", 85, "OK", null]
      ["AT+CIFSR\r\n", 2, ".", null]
      ["AT+CIPSERVER=1,4010\r\n", 2, "SERVER OK", null]
    ]

    @sendCommands commands, callback

  disconnect: (callback) =>
    @sendCommand "AT+CIPCLOSE=1\r\n", 4, "CLOSE OK", null, callback

  sendCommand: (cmd, wait, success="OK", fail="ERROR", callback) =>
    @nova.write cmd, (err) =>
      console.log {cmd, wait, success, fail}
      return callback err if err?
      buffer = @nova.read()
      setTimeout (=>
        buffer = @nova.read()
        datas = buffer.toString().trim().split('\r\n')
        console.log datas
        return callback new Error datas[1] if datas[1] == fail
        return callback new Error data[3] if datas[3]? && datas[3] == fail
        res = {
          data: datas[1]
          code: datas[3]
        }
        callback null, res if res.code == success
      ), wait * 100

  sendCommands: (commands, callback) =>
    tasks = []
    _.each commands, (command) =>
      [cmd, wait, success, fail] = command

      tasks.push async.apply(@sendCommand, cmd, wait, success, fail)

    async.series tasks, (err, results) =>
      return callback err if err?
      callback null, results

  sendMessage: (msg, callback) =>
    return callback new Error "Missing key" unless @key?
    fullMessage = @formatMsg msg
    commands = [
      ["AT+CMGF=1\r\n", 10, "OK", null]
      ["AT+CIPSTART=1,\"TCP\",\"" + @ip + "\",\"" + @port + "\"\r\n", 75, "OK", "FAIL"]
      ["AT+CIPSEND=1," + fullMessage.length + "\r\n", 5, ">", null]
      [fullMessage, 60, "OK", "FAIL"]
    ]

    @sendCommands commands, callback

  formatMsg: (msg) =>
    msg = msg.replace("\"", "\\\"")
    return "{\"k\": \"" + @key + "\", \"d\": \"" + msg + "\"}\r\n"

module.exports = HologramNova

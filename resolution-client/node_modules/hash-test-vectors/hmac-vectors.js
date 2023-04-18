var crypto = require('crypto')
var hashes = crypto.getHashes()
//inputs taken from rfc4231.txt
var inputs = require('./key-data.json')
var hmacs = []

inputs.forEach(function (input) {
  input = {key: input.key, data: input.data}
  hashes.forEach(function (alg) {
    var output =
      crypto.createHmac(alg, new Buffer(input.key, 'hex'))
      .update(input.data, 'hex')
      .digest()

    input[alg] = (input.truncate ? output.slice(0, input.truncate) : output).toString('hex')
  })
  hmacs.push(input)
})

console.log(JSON.stringify(inputs, null, 2))


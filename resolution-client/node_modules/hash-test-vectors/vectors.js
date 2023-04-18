var fs   = require('fs')
var path = require('path')
var assert = require('assert')
var crypto = require('crypto')

//function pad(n, w) {
//  n = n + ''; return new Array(w - n.length + 1).join('0') + n;
//}
//
var dir = path.join(__dirname, 'vectors')

var vectors =
  fs.readdirSync(dir)
    .sort()
    .filter(function (t) {
      return t.match(/\.dat$/);
    })
    .map(function (t) {
      return fs.readFileSync(path.join(dir, t), 'base64')
    });


var hashes = crypto.getHashes()

var output = vectors.map(function (e) {
  return hashes.reduce(function (obj, hash) {
    obj[hash] = crypto.createHash(hash).update(obj.input, 'base64').digest('hex')
    return obj
  }, {input: e})
})


console.log(JSON.stringify(output, null, 2))

var vectors = require('./pbkdf2.json')
var crypto = require('crypto')
var assert = require('assert')

//since there is only sha1 pbkdf2 in node, I just copied the values from the RFC.
//just run it through node to double check that I got the values correct.


vectors.forEach(function (e, i) {
  console.log(i, e)
  assert.deepEqual(
    crypto.pbkdf2Sync(e.password, e.salt, e.iterations, e.length).toString('hex'),
    e.sha1
  )
})



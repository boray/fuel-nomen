# hash-test-vectors

The nist test vectors expanded to cover every hash function supported by node.js,
output is saved in a json file, so that it is possible to run tests in the browser.

NIST provides test vectors for sha and md5, and this module takes
that set and outputs a json file containing the input (in base 64)
plus all output of every hash function that node.js supports.

This makes it easy to test javascript hash functions, with fairly roboust coverage.

I took the original test vectors at http://www.nsrl.nist.gov/testdata/

## example

``` js
var vectors = require('hash-test-vectors')
var tape = require('tape')
var MySha1 = require('./my-sha1-implementation')

vectors.forEach(function (v, i) {

  tape('my-sha1 against test vector ' + i, function (t) {
    //test in bash64 encoding + as a buffer
    t.equal(new MySha1().update(v.input, 'base64').digest('hex'), v.sha1)
    t.equal(new MySha1().update(new Buffer(v.input, 'base64')).digest('hex'), v.sha1)
    t.end()
  })
})

```

## hmac example

hmac vectors taken from [rfc4231](http://tools.ietf.org/rfc/rfc4231.txt)
(included in this repo)

each test vector has `{key: hex, data: hex}` and the outputs of hmac with every
hash algorithm in node, also in hex encoding.

``` js
var vectors = require('hash-test-vectors')
var tape = require('tape')
var MySha1Hmac = require('./my-sha1-hmac-implementation')

vectors.forEach(function (v, i) {
  tape('my-sha1-hmac against test vector ' + i, function (t) {
    //test in bash64 encoding + as a buffer
    t.equal(new MySha1Hmac(new Buffer(v.key, 'hex')).update(v.data, 'hex').digest('hex'), v.sha1)
    t.end()
  })
})

```

## pbkdf2 example

pbkdf2 vectors taken from [rfc6070](http://tools.ietf.org/rfc/rfc6070.txt)
(also included in this repo)

``` js
var vectors = require('hash-test-vectors')
var tape = require('tape')
var MyPbkdf2 = require('./my-pbkdf2-implementation')

vectors.forEach(function (v, i) {
  tape('my-pbkdf2 against test vector ' + i, function (t) {
    //test in bash64 encoding + as a buffer
    var key = new MyPbkdf2(v.password, v.salt, v.iterations, v.length)
    t.equal(key.toString('hex')), v.sha1)
    t.end()
  })
})

```


## License

MIT

const readline = require('readline');
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

var gen = main()
gen.next()
rl.on('line', (line) => {
  gen.next(line)
});

function *main() {
  const T = yield
  for (var i = 0; i < T; i ++) {
    var line = yield
    var inputs = line.split(' ')
    var D = inputs[0]
    var P = inputs[1]
    console.log([D, P].join(", "))
    var code = P.split('')
    // console.log(code.join(", "))
    var lis = arr2list(code)
    console.log(lis)
    var dam = damage(lis)
    console.log('damage', dam)
  }
}

function damage(lis) {
  const iter = (lis, cur) => {
    if (lis == null) {
      return 0
    } else {
      var car = lis[0]
      if (car == 'C') {
        return iter(lis[1], cur * 2)
      } else {
        return cur + iter(lis[1], cur)
      }
    }
  }
  return iter(lis, 1)
}

function swap(lis) {
  return [lis[1][0], [lis[0], lis[1][1]]]
}

function arr2list(arr) {
  const iter = index => {
    if (index < arr.length) {
      return [arr[index], iter(index + 1)]
    } else {
      return null
    }
  }
  return iter(0)
}

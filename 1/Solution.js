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
    // console.log([D, P].join(", "))
    var code = P.split('')
    // console.log(code.join(", "))
    var lis = arr2list(code)
    // console.log(lis)
    var dam = damage(lis)
    // console.log('damage', dam)

    var lis2 = {car: null, cdr: lis}
    var ret = swapUntil(lis2, lis2, D, 0, count => console.log(['Case #', i + 1, ': ', count].join('')))
    if (ret != null) {
      console.log(['Case #', i + 1, ': IMPOSSIBLE'].join(''))
    }
    // console.log('ret', ret)
  }
}

function printList(lis) {
  const arr = []
  const iter = lis => {
    if (!lis) {
      return
    }
    arr.push(lis.car)
    iter(lis.cdr)
  }
  iter(lis)
  // console.log("list", arr)
}

function swapUntil(lis, cur, d, count, done) {
  if (cur.cdr.cdr == null) {
    return count
  }

  var ret = swapUntil(lis, cur.cdr, d, count, done)
  if (ret == null)
    return

  count = ret

  if (damage(lis.cdr) > d) {
    var swapped = null
    if (cur.cdr.car == 'C' && cur.cdr.cdr.car == 'S') {
      swapped = swap(cur.cdr)
      printList(lis.cdr)
      cur.cdr = swapped
      printList(lis.cdr)
      count ++
    }

    if (swapped) {
      var dam
      if ((dam = damage(lis.cdr)) > d) {
        // console.log('damage', dam)
        var ret = swapUntil(lis, cur.cdr, d, count, done)
        if (ret == null)
          return
        count = ret

        if (damage(lis.cdr) > d) {
          return count
        }
      }
    } else {
      return count
    }
  }
  done(count)
}

function damage(lis) {
  const iter = (lis, pow, cur) => {
    if (lis == null) {
      return 0
    }

    // if (lis.damage && lis.pow == pow) {
    //   return lis.damage
    // }

    cur = cur || Math.pow(2, pow)

    var dam
    if (lis.car == 'C') {
      dam = iter(lis.cdr, pow + 1, cur * 2)
    } else {
      dam = cur + iter(lis.cdr, pow, cur)
    }
    lis.damage = dam
    lis.pow = pow
    return dam
  }
  return iter(lis, 0, false)
}

function swap(lis) {
  return {car: lis.cdr.car, cdr: {car: lis.car, cdr: lis.cdr.cdr}}
}

function arr2list(arr) {
  const iter = index => {
    if (index < arr.length) {
      return {car: arr[index], cdr: iter(index + 1)}
    } else {
      return null
    }
  }
  return iter(0)
}

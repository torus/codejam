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
  const sqrt2quot = Math.sqrt(2) / 4

  for (var i = 0; i < T; i ++) {
    var line = yield
    var A = parseFloat(line)
    var coords

    if (A < Math.sqrt(2)) {
      // var x = (A - Math.sqrt(2 - A * A)) / 2
      // var y = Math.sqrt(1 - x * x)
      // var sin = x / 2
      // var cos = y / 2
      // var theta = Math.asin(x)
      var theta = Math.asin(A * A - 1) / 2
      var sin = Math.sin(theta) / 2
      var cos = Math.cos(theta) /2

      coords = [
        [cos, -sin, 0],
        [sin, cos, 0],
        [0, 0, 0.5],
      ]

    } else {
      var theta = Math.asin((A - Math.sqrt(4 * (3 - A * A))) / 3)
      var sin = Math.sin(theta)
      var cos = Math.cos(theta)
      coords = [
        [
          - cos / 2,
          sin / 2,
          0
        ],
        [
          sin / 2,
          cos / 2,
          sqrt2quot
        ],
        [
          sin / 2,
          cos / 2,
          - sqrt2quot
        ]
      ]

    }
    console.log('Case #' + i + ':')
    console.log(coords.map(c => c.join(' ')).join('\n'))
  }
}

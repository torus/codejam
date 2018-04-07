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
  while (true) {
    var line = yield
    console.log('gen Received:', line)
  }
}

const T = 30

console.log(T)

for (var i = 0; i < T; i ++) {
  console.log((1 - i / T)* Math.sqrt(2) + Math.sqrt(3) * i / T)
}

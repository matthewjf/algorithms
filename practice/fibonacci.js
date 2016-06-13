// bottom up implementation
// linear time
// constant space

function btmUpFibonacci(n) {
  var idx = 1;
  var last1 = 1;
  var last2 = 1;
  while (idx <= n) {
    var f = idx <= 2 ? 1 : last1 + last2;
    last2 = last1;
    last1 = f;
    idx += 1;
  }
  return f;
}

// memoized version
var _memo = {};

function memoFibonacci(n) {
  if (_memo[n])
    return _memo[n];
  if (n <= 2)
    return 1;

  _memo[n - 2] = memoFibonacci(n - 2);
  _memo[n - 1] = memoFibonacci(n - 1);
  return _memo[n - 2] + _memo[n - 1];
}

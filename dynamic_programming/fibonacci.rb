def fib_rec(n, memo = {})
  # memoized ruby implementation (scope)
  return memo[n] if memo[n]
  return 1 if n <= 2

  memo[n-2] = fib_rec(n-2, memo)
  memo[n-1] = fib_rec(n-1, memo)
  memo[n] = memo[n-2] + memo[n-1]
end

def fib_btm_up(n)
  # linear constant space bottom up implementation
  last1 = 0
  last2 = 0
  f = 0

  1.upto(n) do |k|
    f = k <= 2 ? 1 : last1 + last2
    last1 = last2
    last2 = f
  end
  return f
end

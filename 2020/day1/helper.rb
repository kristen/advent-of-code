def is_sum_2020(nums)
  sum = nums.inject(0) {|acc, x| acc + x }
  sum == 2020
end

def multiply(nums)
  nums.inject(1) {|acc, x| acc * x }
end

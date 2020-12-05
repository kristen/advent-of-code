require_relative "helper"

input = File.read("#{__dir__}/day9-input").split(",").map(&:to_i)
# size of input is 973
result = int_code input, [2]
puts result.inspect

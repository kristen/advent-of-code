require_relative "helper"

input = File.read("#{__dir__}/input").split("\n").map(&:to_i)
memo = Hash.new

(0..(input.length-1)).each do |i|
  (i+1..(input.length-1)).each do |j|
    pair = [input[i], input[j]]
    key = pair.sort.join('-')
    if !memo[key]
      memo[key] = true
      if is_sum_2020(pair)
        puts pair.inspect
        result = multiply(pair)
        puts result
        return result
      end
    end
  end
end


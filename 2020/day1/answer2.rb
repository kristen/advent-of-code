require_relative "helper"

input = File.read("#{__dir__}/input").split("\n").map(&:to_i)
memo = Hash.new

(0..(input.length-1)).each do |i|
  (i+1..(input.length-1)).each do |j|
    (j+1..(input.length-1)).each do |k|
      tuple = [input[i], input[j], input[k]]
      key = tuple.sort.join('-')
      if !memo[key]
        memo[key] = true
        if is_sum_2020(tuple)
          puts tuple.inspect
          result = multiply(tuple)
          puts result
          return result
        end
      end
    end
  end
end
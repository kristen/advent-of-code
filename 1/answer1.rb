def is_sum_2020(x, y)
  x + y == 2020
end

input = File.read('input1').split("\n").map(&:to_i)
memo = Hash.new

(0..(input.length-1)).each do |i|
  (0..(input.length-1)).each do |j|
    pair = [input[i], input[j]]
    key = pair.sort.join('-')
    puts key
    if memo[key]
      # do nothing, you already saw this
    else
      memo[key] = true
      if is_sum_2020(*pair)
        puts pair.inspect
        result = pair[0] * pair[1]
        puts result
        return result
      end
    end
  end
end
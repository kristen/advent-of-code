def is_sum_2020(x, y, z)
  x + y + z == 2020
end

input = File.read('input1').split("\n").map(&:to_i)
memo = Hash.new

(0..(input.length-1)).each do |i|
  (0..(input.length-1)).each do |j|
    (0..(input.length-1)).each do |k|
      tuple = [input[i], input[j], input[k]]
      key = tuple.sort.join('-')
      puts key
      if memo[key]
        # do nothing, you already saw this
      else
        memo[key] = true
        if is_sum_2020(*tuple)
          puts tuple.inspect
          result = tuple[0] * tuple[1] * tuple[2]
          puts result
          return result
        end
      end
    end
  end
end
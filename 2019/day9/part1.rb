require_relative "helper"

def test codes, inputs, expected
  result = int_code codes.dup, inputs
  puts "match: #{result == expected}; expected: #{expected}; int_codes(#{codes}) = #{result}"
  puts "\n---------------------\n"
end

# test [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99], [], [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
# test [1102,34915192,34915192,7,4,7,99,0], [], [1219070632396864]
# test [104,1125899906842624,99], [], [1125899906842624]


input = File.read("#{__dir__}/input").split(",").map(&:to_i)
# size of input is 973
result = int_code input, [1]
puts result.inspect

ADD = 1
MULTIPLY = 2
FINISHED = 99

def int_code codes
  i = 0
  while i < codes.length
    code = codes[i]
    index_a = codes[i+1]
    index_b = codes[i+2]
    index_result = codes[i+3]
    case code
    when ADD
      codes[index_result] = codes[index_a] + codes[index_b]
    when MULTIPLY
      codes[index_result] = codes[index_a] * codes[index_b]
    when FINISHED
      break;
    end

    i += 4
  end
  codes
end

def test codes, expected
  result = int_code codes
  puts "match: #{result == expected}; expected: #{expected}; int_codes(#{codes}) = #{result}"
end

test [1,9,10,3,2,3,11,0,99,30,40,50], [3500,9,10,70,
  2,3,11,0,
  99,
  30,40,50]
test [1,0,0,0,99], [2,0,0,0,99]
test [2,3,0,3,99], [2,3,0,6,99]
test [2,4,4,5,99,0], [2,4,4,5,99,9801]
test [1,1,1,4,99,5,6,0,99], [30,1,1,4,2,5,6,0,99]

input = File.read('day2-input').split(",").map(&:to_i)
input[1] = 12
input[2] = 2
result = int_code input
puts result.inspect
puts result[0]
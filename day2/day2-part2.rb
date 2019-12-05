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

EXPECTED = 19690720

def test noun, verb
  input = File.read('day2-input').split(",").map(&:to_i)
  input[1] = noun
  input[2] = verb
  result = int_code input
  result.first == EXPECTED
end


for i in 0..99
  noun = i
  for j in 0..99
    verb = j
    match = test noun, verb
    puts "noun: #{noun}; verb: #{verb}; 100 * noun + verb = #{100 * noun + verb}" if match
  end
end

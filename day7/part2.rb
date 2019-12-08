LOGGING = false

ADD = 1
MULTIPLY = 2
INPUT = 3
OUTPUT = 4
JUMP_IF_TRUE = 5
JUMP_IF_FALSE = 6
LESS_THAN = 7
EQUALS = 8
FINISHED = 99

POSITION_MODE = 0  # index of where value is
IMMEDIATE_MODE = 1 # value

def opcode_name opcode
  case opcode
  when ADD
    "ADD"
  when MULTIPLY
    "MULTIPLY"
  when INPUT
    "INPUT"
  when OUTPUT
    "OUTPUT"
  when JUMP_IF_TRUE
    "JUMP_IF_TRUE"
  when JUMP_IF_FALSE
    "JUMP_IF_FALSE"
  when LESS_THAN
    "LESS_THAN"
  when EQUALS
    "EQUALS"
  when FINISHED
    "FINISHED"
  end
end

def get_opcode code_digits
  (code_digits[1] || 0) * 10 + code_digits[0]
end

def bool_to_i bool
  bool ? 1 : 0
end


OPCODE_LENGTH = 2
def get_parameters code, codes, num_of_parameters, offset
  params = []

  for i in 0..num_of_parameters-1
    mode = code[OPCODE_LENGTH + i] || POSITION_MODE

    value = case mode
    when POSITION_MODE
      codes[codes[offset+i+1]]
    when IMMEDIATE_MODE
      codes[offset+i+1]
    end

    puts "p_mode_#{i}: #{mode}; value_#{i}: #{value}" if LOGGING
    params << value
  end

  params
end

def int_code codes, inputs, i = 0
  puts "inputs: #{inputs.join(",")}" if LOGGING
  while i < codes.length
    puts "codes: #{codes}" if LOGGING
    puts "i: #{i}" if LOGGING
    code = codes[i].digits
    opcode = get_opcode code
    puts "code: #{codes[i]} -> #{code} opcode_name: #{opcode_name(opcode)}" if LOGGING
    case opcode
    when ADD
      value_a, value_b = get_parameters(code, codes, 2, i)
      result = value_a + value_b

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "saving #{result} to index #{index_result}" if LOGGING
      codes[index_result] = result

      i += 4
    when MULTIPLY
      value_a, value_b = get_parameters(code, codes, 2, i)
      result = value_a * value_b

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "saving #{result} to index #{index_result}" if LOGGING
      codes[index_result] = result

      i += 4
    when INPUT
      index_save = codes[i+1]
      input = inputs.shift
      puts "Saving #{input} to index #{index_save}" if LOGGING
      codes[index_save] = input
      i += 2
    when OUTPUT
      # Parameters that an instruction writes to will never be in immediate mode
      index_output = codes[i+1]
      output = codes[index_output]
      puts "output: #{output}" if LOGGING
      i += 2
      return [output, i]
    when JUMP_IF_TRUE
      value_a, value_b = get_parameters(code, codes, 2, i)

      if value_a != 0
        i = value_b
      else
        i+=3
      end
    when JUMP_IF_FALSE
      value_a, value_b = get_parameters(code, codes, 2, i)

      if value_a == 0
        i = value_b
      else
        i+= 3
      end
    when LESS_THAN
      value_a, value_b = get_parameters(code, codes, 2, i)
      result = bool_to_i(value_a < value_b)

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "saving #{result} to index #{index_result}" if LOGGING
      codes[index_result] = result

      i+=4
    when EQUALS
      value_a, value_b = get_parameters(code, codes, 2, i)
      result = bool_to_i(value_a == value_b)

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "saving #{result} to index #{index_result}" if LOGGING
      codes[index_result] = result
      
      i+=4
    when FINISHED
      break;
    end
  end
end

def possible_phase_settings
  # phase settings 0, 1, 2, 3, 4
  # each one used exactly once
  (5..9).to_a.permutation.to_a
end

def max_thruster_signal codes
  max = 0
  max_phase_settings = []

  possible_phase_settings.each do |phase_settings|
    puts "testing phase setting: #{phase_settings}"
    output = thruster_signal codes, phase_settings
    if output > max
      max = output
      max_phase_settings = phase_settings
      puts "NEW_MAX: phase setting #{phase_settings} produced max output #{max}"
    end
  end

  [max, max_phase_settings]
end

def print_amplifier i
  amp = case i
  when 0
    "A"
  when 1 
    "B"
  when 2 
    "C"
  when 3 
    "D"
  when 4 
    "E"
  end
  puts "-------------- AMP #{amp} --------------"
end

def thruster_signal codes, phase_settings
  memo_index = [0,0,0,0,0]
  memo_codes = [codes.dup, codes.dup, codes.dup, codes.dup, codes.dup]
  memo_inputs = phase_settings.map {|setting| [setting] }
  curr_output = 0
  i = 0
  while i < phase_settings.length
    print_amplifier i if LOGGING
    puts "i: #{i}; memo_index: #{memo_index}" if LOGGING
    inputs = memo_inputs[i]
    inputs << curr_output

    # potentially only give phase_setting on first time
    output, index = int_code memo_codes[i], inputs, memo_index[i]
    if output
      curr_output = output
      # memo[i] = index % codes.length # remember where you left off at
      memo_index[i] = index # remember where you left off at
      i = (i + 1) % 5 # paused so make sure to increment and loop back
    else
      i += 1 # done so increment
    end

  end
  curr_output
end

def test_thruster_signal codes, phase_settings, expected
  result = thruster_signal codes, phase_settings
  puts "match: #{result == expected}; expected: #{expected}; thruster_signal(codes, #{phase_settings}) = #{result}"
end

# test_thruster_signal [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5], [9,8,7,6,5], 139629729
# test_thruster_signal [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10], [9,7,8,5,6], 18216

def test codes, expected
  result, phase_settings = max_thruster_signal codes
  puts "match: #{result == expected[0]}; expected: #{expected[0]}; expected phase_setting: #{expected[1]}; max_thruster_signal(#{codes}) = #{result}, phase_settings: #{phase_settings}"
end

input = File.read('input').split(",").map(&:to_i)
puts max_thruster_signal input
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

def int_code codes, inputs
  puts "inputs: #{inputs.join(",")}" if LOGGING
  outputs = []
  i = 0
  while i < codes.length
    puts "codes: #{codes}" if LOGGING
    puts "i: #{i}" if LOGGING
    code = codes[i].digits
    opcode = get_opcode code
    puts "code: #{codes[i]} -> #{code} opcode_name: #{opcode_name(opcode)}" if LOGGING
    case opcode
    when ADD
      value_a, value_b = get_parameters(code, codes, 2, i)

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "index_result: #{index_result}" if LOGGING

      codes[index_result] = value_a + value_b

      i += 4
    when MULTIPLY
      value_a, value_b = get_parameters(code, codes, 2, i)

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "index_result: #{index_result}" if LOGGING

      codes[index_result] = value_a * value_b

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
      outputs << output
      i += 2
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

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "index_result: #{index_result}" if LOGGING

      codes[index_result] = bool_to_i(value_a < value_b)
      i+=4
    when EQUALS
      value_a, value_b = get_parameters(code, codes, 2, i)

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "index_result: #{index_result}" if LOGGING

      codes[index_result] = bool_to_i(value_a == value_b)
      i+=4
    when FINISHED
      break;
    end

  end
  outputs
end

def possible_phase_settings
  # phase settings 0, 1, 2, 3, 4
  # each one used exactly once
  (0..4).to_a.permutation.to_a
end

def max_thruster_signal codes
  max = 0
  max_phase_settings = []

  possible_phase_settings.each do |phase_settings|
    puts "testing phase setting: #{phase_settings}"
    output = thruster_signal codes.dup, phase_settings
    if output > max
      max = output
      max_phase_settings = phase_settings
      puts "NEW_MAX: phase setting #{phase_settings} produced max output #{max}"
    end
  end

  [max, max_phase_settings]
end

def thruster_signal codes, phase_settings
  curr_output = 0
  phase_settings.each do |phase_setting|
    result = int_code codes, [phase_setting, curr_output]
    if result.size != 1
      puts "result has less than 1 input: #{result}"
      return
    end
    curr_output = result.last
  end
  curr_output
end

def test_thruster_signal codes, phase_settings, expected
  result = thruster_signal codes, phase_settings
  puts "match: #{result == expected}; expected: #{expected}; thruster_signal(codes, #{phase_settings}) = #{result}"
end

# test_thruster_signal [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0], [4,3,2,1,0], 43210

def test codes, expected
  result, phase_settings = max_thruster_signal codes
  puts "match: #{result == expected[0]}; expected: #{expected[0]}; expected phase_setting: #{expected[1]}; max_thruster_signal(#{codes}) = #{result}, phase_settings: #{phase_settings}"
end

# test [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0], [43210, [4,3,2,1,0]]
# test [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0], [54321, [0,1,2,3,4]]
# test [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0], [65210,[0,4,3,2]]



input = File.read('input').split(",").map(&:to_i)
puts max_thruster_signal input
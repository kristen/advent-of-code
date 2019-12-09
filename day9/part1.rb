LOGGING = true

ADD = 1
MULTIPLY = 2
INPUT = 3
OUTPUT = 4
JUMP_IF_TRUE = 5
JUMP_IF_FALSE = 6
LESS_THAN = 7
EQUALS = 8
RELATIVE_BASIS = 9
FINISHED = 99

POSITION_MODE = 0  # index of where value is
IMMEDIATE_MODE = 1 # value
RELATIVE_MODE = 2 # relative index (relative basis + the value)

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
  when RELATIVE_BASIS
    "RELATIVE_BASIS"
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
def get_parameters code, codes, num_of_parameters, offset, basis
  params = []

  for i in 0..num_of_parameters-1
    mode = code[OPCODE_LENGTH + i] || POSITION_MODE

    value = case mode
    when POSITION_MODE
      codes[codes[offset+i+1]]
    when IMMEDIATE_MODE
      codes[offset+i+1]
    when RELATIVE_BASIS
      codes[codes[basis+offset+i+1]]
    end

    puts "p_mode_#{i}: #{mode}; value_#{i}: #{value}" if LOGGING
    params << value
  end

  params
end

def int_code codes, inputs
  puts "inputs: #{inputs.join(",")}" if LOGGING
  outputs = []
  basis = 0
  i = 0
  while i < codes.length
    puts "codes: #{codes}" if LOGGING
    puts "i: #{i}" if LOGGING
    code = codes[i].digits
    opcode = get_opcode code
    puts "code: #{codes[i]} -> #{code} opcode_name: #{opcode_name(opcode)}" if LOGGING
    case opcode
    when ADD
      value_a, value_b = get_parameters(code, codes, 2, i, basis)

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "index_result: #{index_result}" if LOGGING

      codes[index_result] = value_a + value_b

      i += 4
    when MULTIPLY
      value_a, value_b = get_parameters(code, codes, 2, i, basis)

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
      return outputs
      i += 2
    when JUMP_IF_TRUE
      value_a, value_b = get_parameters(code, codes, 2, i, basis)

      if value_a != 0
        i = value_b
      else
        i+=3
      end
    when JUMP_IF_FALSE
      value_a, value_b = get_parameters(code, codes, 2, i, basis)

      if value_a == 0
        i = value_b
      else
        i+= 3
      end
    when LESS_THAN
      value_a, value_b = get_parameters(code, codes, 2, i, basis)

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "index_result: #{index_result}" if LOGGING

      codes[index_result] = bool_to_i(value_a < value_b)
      i+=4
    when EQUALS
      value_a, value_b = get_parameters(code, codes, 2, i, basis)

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "index_result: #{index_result}" if LOGGING

      codes[index_result] = bool_to_i(value_a == value_b)
      i+=4
    when RELATIVE_BASIS
      add_basis = codes[i+1]
      puts "increasing basis #{basis} by #{add_basis}" if LOGGING
      basis += add_basis
      i+=2
    when FINISHED
      break;
    end

  end
  outputs
end

def test codes, inputs, expected
  result = int_code codes.dup, inputs
  puts "match: #{result == expected}; expected: #{expected}; int_codes(#{codes}) = #{result}"
end

# test [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99], [], [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
# test [1102,34915192,34915192,7,4,7,99,0], [], 1219070632396864
test [104,1125899906842624,99], [], 1125899906842624


# input = File.read('day5-input').split(",").map(&:to_i)
# int_code input

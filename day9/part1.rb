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

def get_pmode mode
  case mode
  when POSITION_MODE
    "POSITION_MODE"
  when IMMEDIATE_MODE
    "IMMEDIATE_MODE"
  when RELATIVE_MODE
    "RELATIVE_MODE"
  end
end

OPCODE_LENGTH = 2
def get_parameters code, codes, num_of_parameters, offset, basis
  indexes = get_index_of_parameters code, codes, num_of_parameters, offset, basis

  indexes.map do |index|
    if !codes[index]
      codes[index] = 0
    end
    value = codes[index]

    puts "value: #{value}" if LOGGING
    value
  end

end

def get_index_of_parameters code, codes, num_of_parameters, offset, basis
  indexes = []

  for i in 0..num_of_parameters-1
    mode = code[OPCODE_LENGTH + i] || POSITION_MODE

    index = case mode
      when POSITION_MODE
        parameter = codes[offset+i+1]
        index = parameter || 0
        puts "parameter: #{parameter}; index: #{index}" if LOGGING
        index
      when IMMEDIATE_MODE
        index = offset+i+1
        puts "index: #{index}" if LOGGING
        index
      when RELATIVE_MODE
        parameter = codes[offset+i+1]
        index = basis + parameter
        puts "parameter: #{parameter} + basis: #{basis} = #{index}" if LOGGING
        index
    end

    puts "p_mode: #{get_pmode(mode)}; index_#{i}: #{index}" if LOGGING
    indexes << index
  end
  indexes
end

def fill_zeros codes, start
  for i in start..codes.length-1
    if !codes[i]
      codes[i] = 0
    end
  end
end

def int_code codes, inputs
  puts "inputs: #{inputs.join(",")}" if LOGGING
  outputs = []
  basis = 0
  i = 0
  while i < codes.length
    code = codes[i].digits
    opcode = get_opcode code
    puts "i: #{i}; code: #{codes[i]} -> #{code}; opcode_name: #{opcode_name(opcode)}; codes: #{codes}" if LOGGING
    case opcode
    when ADD
      value_a, value_b = get_parameters(code, codes, 2, i, basis)
      result = value_a + value_b

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "saving #{result} to index: #{index_result}" if LOGGING

      codes[index_result] = result

      i += 4
    when MULTIPLY
      value_a, value_b = get_parameters(code, codes, 2, i, basis)
      result = value_a * value_b

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "saving #{result} to index: #{index_result}" if LOGGING

      codes[index_result] = result

      i += 4
    when INPUT
      index_save = get_index_of_parameters(code, codes, 1, i, basis).first
      input = inputs.shift
      puts "Saving #{input} to index #{index_save}" if LOGGING
      codes[index_save] = input
      i += 2
    when OUTPUT
      # Parameters that an instruction writes to will never be in immediate mode
      output = get_parameters(code, codes, 1, i, basis).first

      puts "output: #{output}" if LOGGING
      outputs << output
      # return outputs
      i += 2
    when JUMP_IF_TRUE
      value_a, value_b = get_parameters(code, codes, 2, i, basis)

      if value_a != 0
        puts "updating i from #{i} to #{value_b}" if LOGGING
        i = value_b
      else
        puts "not jumping" if LOGGING
        i+=3
      end
    when JUMP_IF_FALSE
      value_a, value_b = get_parameters(code, codes, 2, i, basis)

      if value_a == 0
        puts "updating i from #{i} to #{value_b}" if LOGGING
        i = value_b
      else
        puts "not jumping" if LOGGING
        i+= 3
      end
    when LESS_THAN
      value_a, value_b = get_parameters(code, codes, 2, i, basis)
      result = bool_to_i(value_a < value_b)

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "saving #{result} to index: #{index_result}" if LOGGING

      codes[index_result] = result
      i+=4
    when EQUALS
      value_a, value_b = get_parameters(code, codes, 2, i, basis)
      result = bool_to_i(value_a == value_b)

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "saving #{result} to index: #{index_result}" if LOGGING

      codes[index_result] = result
      i+=4
    when RELATIVE_BASIS
      # add_basis = codes[i+1]
      add_basis = get_parameters(code, codes, 1, i, basis).first
      puts "increasing basis #{basis} by #{add_basis}" if LOGGING
      basis += add_basis
      i+=2
    when FINISHED
      break;
    end
    fill_zeros codes, i

  end
  outputs
end

def test codes, inputs, expected
  result = int_code codes.dup, inputs
  puts "match: #{result == expected}; expected: #{expected}; int_codes(#{codes}) = #{result}"
  puts
  puts "---------------------"
  puts
end

# test [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99], [], [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
# test [1102,34915192,34915192,7,4,7,99,0], [], [1219070632396864]
# test [104,1125899906842624,99], [], [1125899906842624]


input = File.read('input').split(",").map(&:to_i)
# size of input is 973
result = int_code input, [1]
puts result.inspect

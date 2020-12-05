LOGGING = false

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

UP = "^"
DOWN = "v"
LEFT = "<"
RIGHT = ">"

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
def get_parameters codes, indexes
  indexes.map do |index|
    if !codes[index]
      codes[index] = 0
    end
    value = codes[index]

    puts "value: #{value}" if LOGGING
    value
  end
end

def get_mode code, i
  mode = code[OPCODE_LENGTH + i]
  if mode.nil?
    return POSITION_MODE
  end
  mode
end

def get_index_of_parameters code, codes, num_of_parameters, offset, basis
  indexes = []

  for i in 0..num_of_parameters-1
    mode = get_mode(code, i)

    index = case mode
      when POSITION_MODE
        parameter = codes[offset+i]
        index = parameter || 0
        puts "parameter: #{parameter}; index: #{index}" if LOGGING
        index
      when IMMEDIATE_MODE
        index = offset+i
        puts "index: #{index}" if LOGGING
        index
      when RELATIVE_MODE
        parameter = codes[offset+i]
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
    puts "i: #{i}; code: #{codes[i]} -> #{code}; opcode_name: #{opcode_name(opcode)};\n codes: #{codes}" if LOGGING
    case opcode
    when ADD
      index_a, index_b, index_result = get_index_of_parameters(code, codes, 3, i+1, basis)
      value_a, value_b = get_parameters(codes, [index_a, index_b])
      result = value_a + value_b

      puts "saving #{result} to index: #{index_result}" if LOGGING

      codes[index_result] = result

      i += 4
    when MULTIPLY
      index_a, index_b, index_result = get_index_of_parameters(code, codes, 3, i+1, basis)
      value_a, value_b = get_parameters(codes, [index_a, index_b])
      result = value_a * value_b

      puts "saving #{result} to index: #{index_result}" if LOGGING

      codes[index_result] = result

      i += 4
    when INPUT
      index_save = get_index_of_parameters(code, codes, 1, i+1, basis).first
      input = inputs.shift
      puts "Saving #{input} to index #{index_save}" if LOGGING
      codes[index_save] = input
      i += 2
    when OUTPUT
      # Parameters that an instruction writes to will never be in immediate mode
      indexes = get_index_of_parameters(code, codes, 1, i+1, basis)
      output = get_parameters(codes, indexes).first

      puts "output: #{output}" if LOGGING
      outputs << output
      # return outputs
      i += 2
    when JUMP_IF_TRUE
      indexes = get_index_of_parameters(code, codes, 2, i+1, basis)
      value_a, value_b = get_parameters(codes, indexes)

      if value_a != 0
        puts "updating i from #{i} to #{value_b}" if LOGGING
        i = value_b
      else
        puts "not jumping" if LOGGING
        i+=3
      end
    when JUMP_IF_FALSE
      indexes = get_index_of_parameters(code, codes, 2, i+1, basis)
      value_a, value_b = get_parameters(codes, indexes)

      if value_a == 0
        puts "updating i from #{i} to #{value_b}" if LOGGING
        i = value_b
      else
        puts "not jumping" if LOGGING
        i+= 3
      end
    when LESS_THAN
      index_a, index_b, index_result = get_index_of_parameters(code, codes, 3, i+1, basis)
      value_a, value_b = get_parameters(codes, [index_a, index_b])
      result = bool_to_i(value_a < value_b)

      puts "saving #{result} to index: #{index_result}" if LOGGING

      codes[index_result] = result
      i+=4
    when EQUALS
      index_a, index_b, index_result = get_index_of_parameters(code, codes, 3, i+1, basis)
      value_a, value_b = get_parameters(codes, [index_a, index_b])
      result = bool_to_i(value_a == value_b)

      puts "saving #{result} to index: #{index_result}" if LOGGING

      codes[index_result] = result
      i+=4
    when RELATIVE_BASIS
      indexes = get_index_of_parameters(code, codes, 1, i+1, basis)
      add_basis = get_parameters(codes, indexes).first
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


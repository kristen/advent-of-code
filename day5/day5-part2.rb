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

    puts "p_mode_#{i}: #{mode}; value_#{i}: #{value}"
    params << value
  end

  params
end

def int_code codes
  i = 0
  while i < codes.length
    puts "i: #{i}"
    code = codes[i].digits
    puts "code: #{codes[i]} -> #{code}"
    opcode = get_opcode code
    puts "opcode_name: #{opcode_name(opcode)}"
    case opcode
    when ADD
      value_a, value_b = get_parameters(code, codes, 2, i)

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "index_result: #{index_result}"

      codes[index_result] = value_a + value_b

      i += 4
    when MULTIPLY
      value_a, value_b = get_parameters(code, codes, 2, i)

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "index_result: #{index_result}"

      codes[index_result] = value_a * value_b

      i += 4
    when INPUT
      index_save = codes[i+1]

      puts "Enter a digit"
      input = gets.chomp.to_i
      puts "Saving #{input} to index #{index_save}"
      codes[index_save] = input
      i += 2
    when OUTPUT
      # Parameters that an instruction writes to will never be in immediate mode
      index_output = codes[i+1]
      puts "output: #{codes[index_output]}"
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
      puts "index_result: #{index_result}"

      codes[index_result] = bool_to_i(value_a < value_b)
      i+=4
    when EQUALS
      value_a, value_b = get_parameters(code, codes, 2, i)

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "index_result: #{index_result}"

      codes[index_result] = bool_to_i(value_a == value_b)
      i+=4
    when FINISHED
      break;
    end

  end
  codes
end

def test codes, expected
  result = int_code codes
  puts "match: #{result == expected}; expected: #{expected}; int_codes(#{codes}) = #{result}"
end

# test [1002,4,3,4,33], [1002,4,3,4,99]


input = File.read('day5-input').split(",").map(&:to_i)
int_code input
# result = int_code input
# puts result.inspect
# puts result[0]
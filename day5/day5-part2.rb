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
      p_mode_a = code[2] || POSITION_MODE
      p_mode_b = code[3] || POSITION_MODE
     
      value_a = case p_mode_a
      when POSITION_MODE
        codes[codes[i+1]]
      when IMMEDIATE_MODE
        codes[i+1]
      end

      puts "p_mode_a: #{p_mode_a}; value_a: #{value_a}"
      
      value_b = case p_mode_b
      when POSITION_MODE
        codes[codes[i+2]]
      when IMMEDIATE_MODE
        codes[i+2]
      end

      puts "p_mode_b: #{p_mode_b}; value_b: #{value_b}"

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "index_result: #{index_result}"

      codes[index_result] = value_a + value_b

      i += 4
    when MULTIPLY
      p_mode_a = code[2] || POSITION_MODE
      p_mode_b = code[3] || POSITION_MODE
     
      value_a = case p_mode_a
      when POSITION_MODE
        codes[codes[i+1]]
      when IMMEDIATE_MODE
        codes[i+1]
      end

      puts "p_mode_a: #{p_mode_a}; value_a: #{value_a}"

      value_b = case p_mode_b
      when POSITION_MODE
        codes[codes[i+2]]
      when IMMEDIATE_MODE
        codes[i+2]
      end
      puts "p_mode_b: #{p_mode_b}; value_b: #{value_b}"

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
      p_mode_a = code[2] || POSITION_MODE
      p_mode_b = code[3] || POSITION_MODE
     
      value_a = case p_mode_a
      when POSITION_MODE
        codes[codes[i+1]]
      when IMMEDIATE_MODE
        codes[i+1]
      end

      puts "p_mode_a: #{p_mode_a}; value_a: #{value_a}"

      value_b = case p_mode_b
      when POSITION_MODE
        codes[codes[i+2]]
      when IMMEDIATE_MODE
        codes[i+2]
      end
      puts "p_mode_b: #{p_mode_b}; value_b: #{value_b}"

      if value_a != 0
        i = value_b
      else
        i+=3
      end
    when JUMP_IF_FALSE
      p_mode_a = code[2] || POSITION_MODE
      p_mode_b = code[3] || POSITION_MODE
     
      value_a = case p_mode_a
      when POSITION_MODE
        codes[codes[i+1]]
      when IMMEDIATE_MODE
        codes[i+1]
      end

      puts "p_mode_a: #{p_mode_a}; value_a: #{value_a}"

      value_b = case p_mode_b
      when POSITION_MODE
        codes[codes[i+2]]
      when IMMEDIATE_MODE
        codes[i+2]
      end
      puts "p_mode_b: #{p_mode_b}; value_b: #{value_b}"

      if value_a == 0
        i = value_b
      else
        i+= 3
      end
    when LESS_THAN
      p_mode_a = code[2] || POSITION_MODE
      p_mode_b = code[3] || POSITION_MODE
     
      value_a = case p_mode_a
      when POSITION_MODE
        codes[codes[i+1]]
      when IMMEDIATE_MODE
        codes[i+1]
      end

      puts "p_mode_a: #{p_mode_a}; value_a: #{value_a}"

      value_b = case p_mode_b
      when POSITION_MODE
        codes[codes[i+2]]
      when IMMEDIATE_MODE
        codes[i+2]
      end
      puts "p_mode_b: #{p_mode_b}; value_b: #{value_b}"

      # Parameters that an instruction writes to will never be in immediate mode
      index_result = codes[i+3]
      puts "index_result: #{index_result}"

      codes[index_result] = bool_to_i(value_a < value_b)
      i+=4
    when EQUALS
      p_mode_a = code[2] || POSITION_MODE
      p_mode_b = code[3] || POSITION_MODE
     
      value_a = case p_mode_a
      when POSITION_MODE
        codes[codes[i+1]]
      when IMMEDIATE_MODE
        codes[i+1]
      end

      puts "p_mode_a: #{p_mode_a}; value_a: #{value_a}"

      value_b = case p_mode_b
      when POSITION_MODE
        codes[codes[i+2]]
      when IMMEDIATE_MODE
        codes[i+2]
      end
      puts "p_mode_b: #{p_mode_b}; value_b: #{value_b}"

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
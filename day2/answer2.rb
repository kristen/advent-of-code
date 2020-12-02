require_relative "helper"

input = File.read("#{__dir__}/input").split("\n")

def is_valid positions, letter, password
  puts "positions: #{positions}, letter: #{letter}, password: #{password}"
  pos1, pos2 = positions
  pos1_match = password[pos1-1] == letter
  pos2_match = password[pos2-1] == letter
  pos1_match && !pos2_match || !pos1_match && pos2_match
end

def run num_valid, row
  positions, letter, password = parse_password_with_policy row
  if is_valid positions, letter, password
    puts "valid password: '#{row}'"
    num_valid + 1
  else
    puts "invalid password: '#{row}'"
    num_valid
  end
end

num_valid_passwords = input.inject(0) { |acc, row| run acc, row }

puts "number of valid passwords: #{num_valid_passwords}"

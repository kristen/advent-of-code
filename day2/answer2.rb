require_relative "helper"

input = File.read("#{__dir__}/input").split("\n")

def is_valid positions, letter, password
  puts "positions: #{positions}, letter: #{letter}, password: #{password}"
  pos1, pos2 = positions
  pos1_match = password[pos1-1] == letter
  pos2_match = password[pos2-1] == letter
  pos1_match && !pos2_match || !pos1_match && pos2_match
end

num_valid_passwords = input.inject(0) { |acc, row| run acc, row }

puts "number of valid passwords: #{num_valid_passwords}"

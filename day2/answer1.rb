require_relative "helper"

input = File.read("#{__dir__}/input").split("\n")

def is_valid bounds, letter, password
  puts "bounds: #{bounds}, letter: #{letter}, password: #{password}"
  lower_bound, upper_bound = bounds
  count = password.count(letter)
  lower_bound <= count && count <= upper_bound
end

num_valid_passwords = input.inject(0) { |acc, row| run acc, row }

puts "number of valid passwords: #{num_valid_passwords}"

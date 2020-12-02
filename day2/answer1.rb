require_relative "helper"

input = File.read("#{__dir__}/input").split("\n")

def parse_password_with_policy password_with_policy
  num, letter, password = result = password_with_policy.split(' ')
  [num.split('-').map(&:to_i), letter[0], password]
end

def is_valid bounds, letter, password
  puts "bounds: #{bounds}, letter: #{letter}, password: #{password}"
  lower_bound, upper_bound = bounds
  count = password.count(letter)
  lower_bound <= count && count <= upper_bound
end

def run num_valid, row
  bounds, letter, password = parse_password_with_policy row
  if is_valid bounds, letter, password
    puts "valid password: '#{row}'"
    num_valid + 1
  else
    puts "invalid password: '#{row}'"
    num_valid
  end
end

num_valid_passwords = input.inject(0) { |acc, row| run acc, row }

puts "number of valid passwords: #{num_valid_passwords}"

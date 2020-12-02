def parse_password_with_policy password_with_policy
  num, letter, password = result = password_with_policy.split(' ')
  [num.split('-').map(&:to_i), letter[0], password]
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

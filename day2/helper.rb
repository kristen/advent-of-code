def parse_password_with_policy password_with_policy
  num, letter, password = result = password_with_policy.split(' ')
  [num.split('-').map(&:to_i), letter[0], password]
end

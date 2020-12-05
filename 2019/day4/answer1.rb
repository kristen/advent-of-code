R1 = 130254
R2 = 678275

def adjacent_digits_same? password
  for i in 0..password.length-1
    return true if password[i] == password[i+1]
  end
  false
end

def increasing? password
  for i in 0..password.length-2
    d1 = password[i].to_i
    d2 = password[i+1].to_i
    # puts "d1: #{d1}; d2: #{d2}"
    return false if d1 > d2
  end
  true
end

puts increasing? 840000.to_s
puts increasing? 111111.to_s
puts increasing? 223456.to_s

def is_valid? password
  # six digits
  # within range of r1-r2
  # two adjacent digits are the same (required)
  adjacent_digits_same?(password) &&
  # going from left to right, the digits never decrease
  # (only increase or stay same)
    increasing?(password)
end

def number_of_passwords
  result = 0
  for i in R1..R2
    if is_valid? i.to_s
      result += 1
      puts i
    end
  end
  result
end

puts number_of_passwords

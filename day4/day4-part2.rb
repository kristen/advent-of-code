R1 = 382345
R2 = 843167

def adjacent_digits_same? password
  prev = password[0]
  count = 1
  counts = []
  for i in 1..password.length-1
    if password[i] == prev
      count += 1
    else
      counts << count
      count = 1
      prev = password[i]
    end
  end
  # puts "prev: #{prev}; last: #{password[password.length-1]}"
  # count += 1 if password[password.length - 1] == prev
  counts << count
  counts.any? { |c| c == 2 }
end

puts true == adjacent_digits_same?("112233")
puts false == adjacent_digits_same?("123444")
puts true == adjacent_digits_same?("111122")
puts true == adjacent_digits_same?("123455")
puts false == adjacent_digits_same?("111123")

def increasing? password
  for i in 0..password.length-2
    d1 = password[i].to_i
    d2 = password[i+1].to_i
    return false if d1 > d2
  end
  true
end


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

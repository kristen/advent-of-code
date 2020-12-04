class Passport
  @@required_fields = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']
  @@optional_fields = ['cid']

  def initialize str
    @fields = str.split(/\s/)
      .inject({}) do |h, pair|
        k, v = pair.split(':')
        h[k] = v
        h
      end
  end

  def valid_year? year_str, lower, upper
    return false unless year_str.match(/^\d{4}$/)
    year = year_str.to_i
    lower <= year && year <= upper
  end

  def byr_valid? byr
    valid_year? byr, 1920, 2002
  end

  def iyr_valid? iyr
    valid_year? iyr, 2010, 2020
  end

  def eyr_valid? eyr
    valid_year? eyr, 2020, 2030
  end

  def hgt_valid? hgt
    match = hgt.match(/^(\d+)(cm|in)$/)
    return false unless match
    height = match[1].to_i
    case match[2]
    when 'cm'
      150 <= height && height <= 193
    when 'in'
      59 <= height && height <= 76
    end
  end

  def hcl_valid? hcl
    hcl.match(/^#[0-9a-f]{6}$/)
  end

  def ecl_valid? ecl
    %w(amb blu brn gry grn hzl oth).include? ecl
  end

  def pid_valid? pid
    pid.match(/^\d{9}$/)
  end

  def field_valid? field, value
    case field
    when 'byr'
      byr_valid? value
    when 'iyr'
      iyr_valid? value
    when 'eyr'
      eyr_valid? value
    when 'hgt'
      hgt_valid? value
    when 'hcl'
      hcl_valid? value
    when 'ecl'
      ecl_valid? value
    when 'pid'
      pid_valid? value
    else
      true
    end
  end

  def valid?
    if (@@required_fields - @fields.keys).length > 0
      return false
    end
    @fields.all? {|k,v| field_valid? k,v }
  end
end

input = File.read("#{__dir__}/input")
  .split("\n\n")
  .map {|row| Passport.new(row)}

puts input.count { |passport| passport.valid? }

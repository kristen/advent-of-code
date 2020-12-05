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

  def valid?
    (@@required_fields - @fields.keys).length == 0
  end
end

input = File.read("#{__dir__}/input")
  .split("\n\n")
  .map {|row| Passport.new(row)}

puts input.count { |passport| passport.valid? }
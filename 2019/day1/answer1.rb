def get_fuel_required mass
  (mass / 3).floor - 2
end

input = File.read("#{__dir__}/input").split("\n").map(&:to_i)
puts input.map { |mass| get_fuel_required mass }.sum

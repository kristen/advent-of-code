input = File.read('day-1-input').split("\n").map(&:to_i)

def get_fuel_required mass
  (mass / 3).floor - 2
end

result = input.map { |mass| get_fuel_required mass }.sum
puts result
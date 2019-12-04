def get_fuel_required mass
  (mass / 3).floor - 2
end

def get_fuel_required_recursive mass
  def loop fuel_acc, rest_mass
    fuel = get_fuel_required rest_mass
    puts "fuel: #{fuel}"
    if fuel <= 0
      fuel_acc
    else
      loop(fuel_acc + fuel, fuel)
    end
  end
  loop(0, mass)
end

puts get_fuel_required_recursive 14
puts get_fuel_required_recursive 1969

input = File.read('day-1-input').split("\n").map(&:to_i)
puts input.map { |mass| get_fuel_required_recursive mass }.sum
LOGGING = true

DIM_X = 25
DIM_Y = 6

def get_max_0_layer layers
  layers.min { |layer1, layer2| layer1.count {|n| n == 0} <=> layer2.count {|n| n == 0} }
end

def mult_one_by_two data, dimx, dimy
  layers = data.split("").map(&:to_i).each_slice(dimx * dimy).to_a
  puts layers.inspect if LOGGING
  max_zero_layer = get_max_0_layer layers
  puts max_zero_layer.inspect if LOGGING
  ones = max_zero_layer.count {|n| n == 1 }
  twos = max_zero_layer.count {|n| n == 2 }
  puts "num of ones = #{ones} and num of twos #{twos}"
  ones * twos
end

def test data, dimx, dimy, expected
  result = mult_one_by_two data, dimx, dimy
  puts "match: #{result == expected}; expected: #{expected}; get_layers(#{data}) = #{result}"
end


# test "123456789012", 3, 2, 1
puts mult_one_by_two File.read("#{__dir__}/input"), DIM_X, DIM_Y
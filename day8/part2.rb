LOGGING = false

BLACK = 0
WHITE = 1
TRANSPARENT = 2

def image data, dimx, dimy
  layers = data.split("").map(&:to_i).each_slice(dimx * dimy).to_a.map { |layer| layer.each_slice(dimx).to_a }
  puts layers.inspect if LOGGING
  result = Array.new(dimy) { Array.new(dimx, TRANSPARENT) }
  for k in 0..layers.size-1
    layer = layers[k]
    for i in 0..dimy-1
      for j in 0..dimx-1
        pixel = layer[i][j]
        puts "pixel: #{pixel}" if LOGGING
        if result[i][j] == TRANSPARENT
          result[i][j] = pixel
        end
      end
    end
  end
  result
end

def test data, dimx, dimy, expected
  result = image data, dimx, dimy
  puts "match: #{result == expected}; expected: #{expected}; image(#{data}) = #{result}"
end


# test "0222112222120000", 2, 2, [[0,1],[1,0]]

def print_result result
  result.each do |row|
    puts row.map {|n| n == 1 ? "*" : " " }.join("")
  end
end

DIM_X = 25
DIM_Y = 6
result = image File.read('input'), DIM_X, DIM_Y
print_result result
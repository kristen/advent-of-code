require_relative "helper"

input = File.read("#{__dir__}/input").split("\n")

right = 3

def count_trees map, slope
  (1..map.length - 1).inject(0) do |trees, i|
    row = map[i].dup
    pos = (i * slope) % row.length
    location = row[pos]
    if is_tree location
      row[pos] = "X"
      puts row
      trees + 1
    else
      row[pos] = "O"
      puts row
      trees
    end
  end
end


trees = count_trees input, right

puts trees

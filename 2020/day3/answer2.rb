require_relative "helper"

input = File.read("#{__dir__}/input").split("\n")

def count_trees map, slopeX, slopeY
  def inner_loop map, slopeX, slopeY, trees, i, j
    if j >= map.length
      trees
    else
      row = map[j].dup
      pos = i % row.length
      location = row[pos]
      if is_tree location
        row[pos] = "X"
        puts row
        inner_loop(map, slopeX, slopeY, trees + 1, i+slopeX, j+slopeY)
      else
        row[pos] = "O"
        puts row
        inner_loop(map, slopeX, slopeY, trees, i+slopeX, j+slopeY)
      end
    end
  end

  inner_loop map, slopeX, slopeY, 0, slopeX, slopeY
end

trees1 = count_trees input, 1, 1
trees3 = count_trees input, 3, 1
trees5 = count_trees input, 5, 1
trees7 = count_trees input, 7, 1
treesDown2 = count_trees input, 1, 2

puts trees1
puts trees3
puts trees5
puts trees7
puts treesDown2

puts "----"
puts trees1 * trees3 * trees5 * trees7 * treesDown2

require_relative "helper"

input = File.read("#{__dir__}/input").split("\n")

right = 3

trees = 0

def is_tree location
  location == '#'
end

(1..input.length - 1).each do |i|
  row = input[i].dup
  pos = (i * right) % row.length
  location = row[pos]
  if is_tree location
    row[pos] = "X"
    trees = trees + 1
  else
    row[pos] = "O"
  end
  puts row
end

puts trees

require_relative "helper"

LOGGING = true

input = File.read("#{__dir__}/input").split("\n")

plane_seats = Array.new(170){Array.new(7)}

input.each do |code|
  row, col = binary_space_partitioning code
  puts "row: #{row}, col: #{col}" if LOGGING
  id = seat_id row, col
  puts "seat ID: #{id}"
  plane_seats[row][col] = id
end

puts plane_seats.inspect


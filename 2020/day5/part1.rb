require_relative "helper"

LOGGING = true

input = File.read("#{__dir__}/input").split("\n")

def get_seat_id_from_binary code
  row, col = binary_space_partitioning code
  puts "row: #{row}, col: #{col}" if LOGGING
  seat_id row, col
end

puts get_seat_id_from_binary 'FBFBBFFRLR'
puts get_seat_id_from_binary 'BFFFBBFRRR'
puts get_seat_id_from_binary 'FFFBBBFRRR'
puts get_seat_id_from_binary 'BBFFBBFRLL'

seat_ids = input.map {|code| get_seat_id_from_binary code}
puts seat_ids.max

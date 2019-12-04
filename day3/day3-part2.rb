class Point
  attr_accessor :x, :y
  def initialize x, y
    @x = x
    @y = y
  end

  def taxicab_distance other
    (other.x - x).abs + (other.y - y).abs
  end

  def == other
    other.x == x && other.y == y
  end

  def to_s
    "(#{x}, #{y})"
  end
end

class Segment
  attr_accessor :point1, :point2
  def initialize point1, point2
    @point1 = point1
    @point2 = point2
  end

  def intersection other
    if point1.x == point2.x
      max_x = [other.point1.x, other.point2.x].max
      min_x = [other.point1.x, other.point2.x].min
      max_y = [point1.y, point2.y].max
      min_y = [point1.y, point2.y].min
      # puts "max_x: #{max_x}; min_x: #{min_x}; max_y: #{max_y}; min_y: #{min_y};"
      
      if point1.x <= max_x && point1.x >= min_x && point2.x <= max_x && point2.x >= min_x &&
        other.point1.y <= max_y && other.point1.y >= min_y && other.point2.y <= max_y && other.point2.y >= min_y
        Point.new(point1.x, other.point1.y)
      end
    else
      max_x = [point1.x, point2.x].max
      min_x = [point1.x, point2.x].min
      max_y = [other.point1.y, other.point2.y].max
      min_y = [other.point1.y, other.point2.y].min
      # puts "max_x: #{max_x}; min_x: #{min_x}; max_y: #{max_y}; min_y: #{min_y};"

      if other.point1.x <= max_x && other.point1.x >= min_x && other.point2.x <= max_x && other.point2.x >= min_x &&
        point1.y <= max_y && point1.y >= min_y && point2.y <= max_y && point2.y >= min_y

        Point.new(other.point1.x, point1.y)
      end
    end
  end

  def == other
    other.point1 == point1 && other.point2 == point2 ||
      other.point1 == point2 && other.point2 == point1
  end

  def to_s
    "[p1: #{point1} p2: #{point2}]"
  end
end

UP = "U"
DOWN = "D"
LEFT = "L"
RIGHT = "R"

def segments_from_path path
  result = []
  current_pos = Point.new(0,0)
  for i in 0..path.length-1
    move = path[i]
    dir = move[0]
    spaces = move[1..move.length-1].to_i

    next_pos = case dir
      when UP
        Point.new(current_pos.x, current_pos.y + spaces)
      when DOWN
        Point.new(current_pos.x, current_pos.y - spaces)
      when LEFT
        Point.new(current_pos.x - spaces, current_pos.y)
      when RIGHT
        Point.new(current_pos.x + spaces, current_pos.y)
      end

    result << Segment.new(current_pos, next_pos)
    current_pos = next_pos
  end
  result
end

def get_fewest_steps path1, path2
  shortest_steps = nil
  # iterate through paths to find pairs of x,y corrdinates that make a segment

  segments_path1 = segments_from_path path1
  segments_path2 = segments_from_path path2

  # iterate through combinations of segments in order
  # when you hit first intersection, add up steps prior to that i, j and return
  for i in 0..segments_path1.length-1
    for j in i..segments_path2.length-1
      s1 = segments_path1[i]
      s2 = segments_path2[j]
      puts "cur move #{path1[i]} s1: #{s1}"
      puts "cur move #{path2[j]} s2: #{s2}"
      intersection = s1.intersection(s2)
      if intersection
        puts "intersection: #{intersection}"
        moves1 = path1[0..i-1]
        moves2 = path2[0..j-1]

        steps_before_intersection = moves1.map { |move| move[1..move.length-1].to_i }.sum +
          moves2.map{ |move| move[1..move.length-1].to_i }.sum

        prev1 = s1.point1
        curr_move1 = path1[i][0]

        curr_step1 = case curr_move1
        when UP, DOWN
          # delta of prev1.y with intersection.y
          (prev1.y - intersection.y).abs
        when LEFT, RIGHT
          (prev1.x - intersection.x).abs
        end

        prev2 = s2.point1
        curr_move2 = path2[j][0]
        curr_step2 = case curr_move2
        when UP, DOWN
          # delta of prev1.y with intersection.y
          (prev2.y - intersection.y).abs
        when LEFT, RIGHT
          (prev2.x - intersection.x).abs
        end

        steps = steps_before_intersection + curr_step1 + curr_step2
        shortest_steps = steps if shortest_steps.nil? || steps < shortest_steps
      end
    end
  end

  shortest_steps
end

def test path1, path2, expected
  result = get_fewest_steps path1, path2
  puts "match: #{result == expected}; expected: #{expected}; get_fewest_steps(#{path1}, #{path2}) = #{result}"
end
test ["R8", "U5", "L5"], ["U7", "R6", "D4"], 30
# test ["R8", "U5", "L5", "D3"], ["U7", "R6", "D4", "L4"], 30
# test ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"], ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"], 610
# test ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"], ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"], 410


path1, path2 = File.read('day-3-input').split("\n").map { |l| l.split(",") }
puts get_fewest_steps path1, path2

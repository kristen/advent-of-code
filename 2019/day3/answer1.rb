

# find manhattan distance

# do we just find the intersection of any of the lines?
# How do we find intersections in math?
# These are segments, not lines
# central port is point (0, 0)

# nested loop
# check if line segments intersect
# if they intersect, find manhatan distance from (0, 0) of intersection

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

def test_segment_intersect s1, s2, expected
  result = s1.intersection s2
  puts "match: #{result == expected}; expected: #{expected}; #{s1}.intersection #{s2} = #{result}"
end

# segment1 = Segment.new(Point.new(3, 2), Point.new(3, 4))
# segment2 = Segment.new(Point.new(1, 3), Point.new(4, 3))
# test_segment_intersect segment1, segment2, Point.new(3, 3)

# segment1 = Segment.new(Point.new(8, 5), Point.new(3, 5))
# segment2 = Segment.new(Point.new(6, 7), Point.new(6, 3))
# test_segment_intersect segment1, segment2, Point.new(6, 5)

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

def test_segments_from_path path, expected
  result = segments_from_path path
  puts "match: #{result == expected}; expected: #{expected}; segments_from_path(#{path}) = #{result}"
end

# test_segments_from_path ["R8", "U5", "L5", "D3"], [
#   Segment.new(Point.new(0, 0), Point.new(8, 0)),
#   Segment.new(Point.new(8, 0), Point.new(8, 5)),
#   Segment.new(Point.new(8, 5), Point.new(3, 5)),
#   Segment.new(Point.new(3, 5), Point.new(3, 2))
# ]

def manhattan_distance path1, path2
  closest_intersection = nil

  # iterate through paths to find pairs of x,y corrdinates that make a segment

  segments_path1 = segments_from_path path1
  segments_path2 = segments_from_path path2

  for i in 0..segments_path1.length-1
    for j in i..segments_path2.length-1
      s1 = segments_path1[i]
      s2 = segments_path2[j]
      intersection = s1.intersection(s2)
      if intersection && i != 0
        puts "intersection: #{intersection}"
        distance = intersection.taxicab_distance Point.new(0, 0)
        puts "distance: #{distance}"
        closest_intersection = distance if closest_intersection.nil? || distance < closest_intersection
      end
    end
  end

  closest_intersection
end

def test path1, path2, expected
  result = manhattan_distance path1, path2
  puts "match: #{result == expected}; expected: #{expected}; manhattan_distance(#{path1}, #{path2}) = #{result}"
end

# test ["R8", "U5", "L5"], ["U7", "R6", "D4"], 11
# test ["R8", "U5", "L5", "D3"], ["U7", "R6", "D4", "L4"], 6
# test ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"], ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"], 159
# test ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"], ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"], 135

path1, path2 = File.read("#{__dir__}/input").split("\n").map { |l| l.split(",") }
puts manhattan_distance path1, path2
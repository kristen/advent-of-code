LOGGING = true

class Asteroid
  attr_accessor :x, :y
  attr_reader :visible_asteroids
  def initialize x, y
    @x = x
    @y = y
    @visible_asteroids = {}
  end

  def add_asteroid other
    s = slope other
    d = distance other
    stats = Stats.new(s, d, other)
    puts "stats: #{stats}" if LOGGING
    if @visible_asteroids[s]
      puts "visible asteroids already has an asteroid with same slope" if LOGGING
      a = @visible_asteroids[s]
      if a.distance < d
        puts "keeping #{a} in visible asteroids because it is closer" if LOGGING
      else
        puts "overriding visible distance with #{other} because it is closer" if LOGGING
        @visible_asteroids[s] = stats
      end
    else
      puts "saving asteroid to visible asteroids #{stats}"
      @visible_asteroids[s] = stats
    end
  end

  def number_of_visible_asteroids
    @visible_asteroids.size
  end

  def slope other
    delta_x = x - other.x
    return nil if delta_x == 0
    delta_y = y - other.y
    m = delta_y / (delta_x * 1.0)
    puts "delta x: #{delta_x}; detla y: #{delta_y}" if LOGGING
    dir = if delta_y == 0 && delta_x > 0 || delta_x > 0 && delta_y > 0 || delta_x < 0 && delta_y < 0
      "pos"
    else
      "neg"
    end
    [m.abs, dir]
  end

  def distance other
    Math.sqrt((x - other.x)**2 + (y - other.y)**2)
  end

  def == other
    other.x == x && other.y == y
  end

  def to_s
    "(#{x}, #{y})"
  end

  def inspect
    to_s
  end
end

class Stats
  attr_reader :slope, :distance, :asteroid
  def initialize slope, distance, asteroid
    @slope = slope
    @distance = distance
    @asteroid = asteroid
  end

  def to_s
    m, dir = slope
    "#{asteroid}; slope: #{m&.round(2)}; dir: #{dir}; dis: #{distance.round(2)}"
  end

  def inspect
    to_s
  end
end

def astroid? point
  point == "#"
end

def get_best_location map
  asteroids = []
  for i in 0..map.length-1
    for j in 0..map[0].length-1
      if astroid? map[i][j]
        asteroids << Asteroid.new(j, i)
      end
    end
  end
  # for i in 0..asteroids.length-1
  #   for j in 0..asteroids.length-1
  #     a1 = asteroids[i]
  #     a2 = asteroids[j]
  #     puts "asteroids: #{a1} & #{a2}" if LOGGING
  #     a1.add_asteroid(a2) if a1 != a2
  #   end
  # end

  a1 = asteroids[4]
  for i in 0..asteroids.length-1
    a2 = asteroids[i]
    puts "asteroids: #{a1} & #{a2}" if LOGGING
    a1.add_asteroid(a2) if a1 != a2
  end
  puts "visible asteroids #{a1.visible_asteroids}" if LOGGING

  asteroids.each do |asteroid|
    puts "asteroid: #{asteroid}; number of visible asteroids: #{asteroid.number_of_visible_asteroids}" if LOGGING
  end
  asteroids.map { |a| a.number_of_visible_asteroids }.max
end

def parse_input input
  input.split("\n").map { |l| l.split("") }
end

def test input, expected
  map = parse_input input
  puts map.inspect
  result = get_best_location map
  puts "match: #{result == expected}; expected: #{expected}; get_best_location(map) = #{result}"
end

test ".#..#
.....
#####
....#
...##", 8
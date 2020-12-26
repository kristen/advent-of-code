require_relative "helper"

LOGGING = true
# LOGGING = false
TEST = true
# TEST = false

input = File.read("#{__dir__}/#{TEST ? 'test-' : ''}input").split("\n")

def parse str
  level1 = str.match(/^(\w+ \w+) bags contain ([\d\w\s,]+).$/)
  puts "level1" if LOGGING
  puts "ERROR: level1 match not found, #{str}" unless level1
  puts level1.inspect if LOGGING
  puts if LOGGING
  level2Str = level1[2].split(",").map(&:strip)
  puts "level2Str" if LOGGING
  puts level2Str.inspect if LOGGING
  puts if LOGGING
  puts "ERROR: level2 has more than 3 items, size: #{level2Str.size}" if level2Str.size > 4
  level2 = level2Str.map do |s|
    l2Match = s.match(/^no other bags$|^(\d) (\w+ \w+) bag(s)?$/)
    puts "ERROR: level2 match not found: #{s}" unless l2Match
    l2Match
  end
  puts "level2" if LOGGING
  puts level2.inspect if LOGGING
  puts "---" if LOGGING
  [level1[1], level2.inject([]) do |acc, l|
    if l[2]
      acc << l[2]
    end
    acc
  end]
end

puts
data = input.map {|row| parse row }
puts data.inspect if LOGGING

result = Hash.new
roots = []
children = []
data.each do |d|
  head, leaves = d
  puts "head: #{head}, leaves: #{leaves}" if LOGGING
  roots << head
  children = children + leaves
  result[head] ||= {}
  leaves.each do |leaf|
    result[leaf] ||= {}
    result[head][leaf] = result[leaf]
  end
end
roots = roots - children

puts result.inspect if LOGGING
puts roots.inspect if LOGGING

trees = roots.map do |root|
  result[root]
end

puts trees.inspect
MATCH = "shiny gold"

def tree_hash_to_array tree
  def inner_loop acc, rest
    if rest.nil? || rest.empty?
      acc
    else
      keys = rest.keys
      values = rest.values

      puts "keys: #{keys}, values: #{values}" if LOGGING

      new_acc = inner_loop acc + keys, values[0]
      new_acc_2 = inner_loop new_acc, values[1]
      new_acc_3 = inner_loop new_acc_2, values[2]
      inner_loop new_acc_3, values[3]
    end
  end

  inner_loop [], tree
end

r = trees.map{|tree| tree_hash_to_array tree}.flatten
puts r.inspect if LOGGING
puts r.count {|bag| bag == MATCH}

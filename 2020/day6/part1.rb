require_relative "helper"

input = File.read("#{__dir__}/input")
  .split("\n\n")
  .map{|r| r.split("\n")}

# puts input.inspect


def count_questions group
  memo = Hash.new
  group.each do |person|
    person.each_char do |question|
      memo[question] = true
    end
  end
  memo.count {|k, v| v }
end

# puts count_questions ['abc']
# puts count_questions ['a', 'b', 'c']
# puts count_questions ['ab', 'ac']
# puts count_questions ['a', 'a', 'a', 'a']
# puts count_questions ['b']

questions = input.map { |group| count_questions group }
puts questions.sum
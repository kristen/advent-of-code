input = File.read("#{__dir__}/input")
  .split("\n\n")
  .map{|r| r.split("\n")}

def count_questions group
  memo = Hash.new(0)
  group.each do |person|
    person.each_char do |question|
      memo[question] += 1
    end
  end
  memo.count {|k, v| v == group.length }
end

# puts count_questions ['abc']
# puts count_questions ['a', 'b', 'c']
# puts count_questions ['ab', 'ac']
# puts count_questions ['a', 'a', 'a', 'a']
# puts count_questions ['b']

questions = input.map { |group| count_questions group }
puts questions.sum
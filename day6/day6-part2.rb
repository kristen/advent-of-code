class Orbit
  attr_accessor :orbit_object
  attr_reader :name
  def initialize name, orbit_object
    @name = name
    # every object in space orbits around exactly one object! # except COM!!!!
    @orbit_object = orbit_object
  end

  def to_s
    "#{orbit_object&.name})#{name}"
  end

  def inspect
    "Orbit(name: #{name}, orbits: #{orbit_object&.name || "nil"})"
  end
end



def get_transfers orbit_map
  orbits_hash = Hash.new

  for i in 0..orbit_map.length - 1
    center_object_name, orbiter_name = orbit_map[i]
    
    center_object = orbits_hash[center_object_name] || Orbit.new(center_object_name, nil)
    orbiter = orbits_hash[orbiter_name] || Orbit.new(orbiter_name, center_object)

    orbiter.orbit_object = center_object
    orbits_hash[center_object_name] = center_object
    orbits_hash[orbiter_name] = orbiter
  end

  you = orbits_hash["YOU"]
  santa = orbits_hash["SAN"]
  get_num_of_transfers you, santa
end

def get_num_of_transfers obj_a, obj_b
  hash = Hash.new
  p = obj_a
  while p.orbit_object
    hash[p.name] = p
    p = p.orbit_object
  end
  p = obj_b
  while p.orbit_object
    if hash.has_key? p.name
      # found shared parent
      p = p.orbit_object
      break
    else
      # put in hash
      hash[p.name] = p
      p = p.orbit_object
    end
  end

  while p.orbit_object
    # if remaining p because we broke out of hash
    # remove other objects from hash to cound transfers
    hash.delete p.name
    p = p.orbit_object
  end

  hash.delete obj_a.name
  hash.delete obj_b.name

  hash.size - 1
end


def test orbit_map, expected
  result = get_transfers orbit_map
  puts "match: #{result == expected}; expected: #{expected}; get_orbits(#{orbit_map}) = #{result}"
end

test [["COM", "B"], ["B", "C"], ["C", "D"], ["D", "E"], ["E", "F"], ["B", "G"], ["G", "H"], ["D", "I"], ["E", "J"], ["J", "K"], ["K", "L"], ["K", "YOU"], ["I", "SAN"]], 4
test [["B", "C"], ["C", "D"], ["E", "F"], ["COM", "B"], ["B", "G"], ["G", "H"], ["D", "E"], ["D", "I"], ["E", "J"], ["J", "K"], ["K", "L"], ["K", "YOU"], ["I", "SAN"]], 4


input = File.read('day6-input').split("\n").map { |o| o.split(")") }
# puts input[0..5].inspect
test input, 292
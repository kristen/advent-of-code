class Orbit
  attr_accessor :indirect_orbits, :orbit_object
  attr_reader :name
  def initialize name, orbit_object
    @name = name
    # every object in space orbits around exactly one object! # except COM!!!!
    @orbit_object = orbit_object
    @indirect_orbits = 0
  end

  def to_s
    "#{orbit_object&.name})#{name}"
  end

  def inspect
    "Orbit(name: #{name}, orbits: #{orbit_object&.name}, indirect_orbits: #{indirect_orbits})"
  end
end



def get_transfers orbit_map
  orbits_hash = Hash.new
  # com = Orbit.new("COM", nil)
  # orbits_hash[com.name] = com

  # iterate through orbits
  # check if orbit is in hash
  
  # if orbit in hash
  # 
  
  # if orbit NOT in hash
  #    create new orbit
  #    store in hash with orbit name as key
  
  # increment indirect orbits

  for i in 0..orbit_map.length - 1
    center_object_name, orbiter_name = orbit_map[i]
    puts "#{orbiter_name} orbits #{center_object_name}"
    
    center_object = orbits_hash[center_object_name] # might be nil!!!
    orbiter = orbits_hash[orbiter_name]

    if center_object && orbiter
      puts "center object #{center_object_name} already in hash"
      puts "orbiter #{orbiter_name} already in hash"
      # update orbiter with center object
      orbiter.orbit_object = center_object
    elsif center_object && !orbiter
      puts "center object #{center_object_name} already in hash"
      # save orbiter with center object
      orbiter = Orbit.new(orbiter_name, center_object)
      orbits_hash[orbiter_name] = orbiter
    elsif !center_object && orbiter
      puts "orbiter #{orbiter_name} already in hash"
      # update orbiter with center object
      center_object = Orbit.new(center_object_name, nil)
      orbiter.orbit_object = center_object
      orbits_hash[center_object_name] = center_object
    else
      puts "neither center #{center_object_name} or orbiter #{orbiter_name} in hash"
      
      center_object = Orbit.new(center_object_name, nil)
      orbiter = Orbit.new(orbiter_name, center_object)

      orbits_hash[center_object_name] = center_object
      orbits_hash[orbiter_name] = orbiter
    end

  end


  orbits = 0

  orbits_hash.values.each do |orbit|
    p = orbit
    indirect_orbits = 0
    while p.orbit_object
      p = p.orbit_object
      indirect_orbits += 1
    end
    orbit.indirect_orbits = indirect_orbits
    puts "#{orbit.name} has #{indirect_orbits} indirect orbits"

    orbits += indirect_orbits
  end
  puts orbits_hash.inspect

  you = orbits_hash["YOU"]
  santa = orbits_hash["SAN"]
  num_of_transfers = get_num_of_transfers you, santa

  num_of_transfers
end

def get_num_of_transfers obj_a, obj_b
  hash = Hash.new
  p = obj_a
  while p.orbit_object
    hash[p.name] = p
    p = p.orbit_object
  end
  puts hash
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

  puts hash
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
puts get_transfers input
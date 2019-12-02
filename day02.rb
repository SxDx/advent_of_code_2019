# frozen_string_literal: true

input = DATA.read.split(",").map(&:to_i)

def run(input, noun = 12, verb = 2)
  input = input.dup
  input[1] = noun
  input[2] = verb

  ip = 0
  while (opcode = input[ip])
    break if opcode == 99

    params = input[ip + 1, 3]
    ia1, ia2, oa = params
    iv1 = input[ia1]
    iv2 = input[ia2]

    ov =
      case opcode
      when 1
        iv1 + iv2
      when 2
        iv1 * iv2
      else
        raise "Unknown Opcode #{opcode}"
      end

    input[oa] = ov

    ip += 4
  end

  input[0]
end

# Part 1
puts run(input)

# Part 2
100.times do |noun|
  100.times do |verb|
    puts "#{noun * 100 + verb}" if run(input, noun, verb) == 19690720
  end
end

__END__
1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,6,19,1,19,5,23,2,13,23,27,1,10,27,31,2,6,31,35,1,9,35,39,2,10,39,43,1,43,9,47,1,47,9,51,2,10,51,55,1,55,9,59,1,59,5,63,1,63,6,67,2,6,67,71,2,10,71,75,1,75,5,79,1,9,79,83,2,83,10,87,1,87,6,91,1,13,91,95,2,10,95,99,1,99,6,103,2,13,103,107,1,107,2,111,1,111,9,0,99,2,14,0,0
# frozen_string_literal: true

class Intcode
  OPERATIONS = {
    1 => { type: :add, params: 3, outputs: 1 },
    2 => { type: :multiply, params: 3, outputs: 1 },
    3 => { type: :input, params: 1, outputs: 1 },
    4 => { type: :output, params: 1, outputs: 0 },
    5 => { type: :jump_if_true, params: 2, outputs: 0 },
    6 => { type: :jump_if_false, params: 2, outputs: 0 },
    7 => { type: :less_than, params: 3, outputs: 0 },
    8 => { type: :equals, params: 3, outputs: 0 },
    99 => { type: :halt, params: 0, outputs: 0 }
  }.freeze

  def self.run(input, noun = nil, verb = nil, user_input = nil)
    input = input.dup
    output = []
    input[1] = noun unless noun.nil?
    input[2] = verb unless verb.nil?

    ip = 0
    while (instruction = input[ip])
      op_type, op_code, num_params, params, inputs = Intcode.extract(input, instruction, ip)
      break if op_type.eql?(:halt)

      jump_to = nil
      case op_type
      when :add
        input[params.last] = inputs[0] + inputs[1]
      when :multiply
        input[params.last] = inputs[0] * inputs[1]
      when :input
        input[params.last] = user_input
      when :output
        output.concat(inputs)
      when :jump_if_true
        jump_to = inputs[1] unless inputs[0].zero?
      when :jump_if_false
        jump_to = inputs[1] if inputs[0].zero?
      when :less_than
        input[params.last] = inputs[0] < inputs[1] ? 1 : 0
      when :equals
        input[params.last] = inputs[0] == inputs[1] ? 1 : 0
      else
        raise "Unknown Opcode #{op_code}"
      end

      jump_to = ip + num_params + 1 if jump_to.nil?
      ip = jump_to
    end

    puts output

    [input[0], output]
  end

  def self.extract(input, instruction, ip)
    instruction = instruction.to_s.rjust(5, "0")
    op_code = instruction.split(//).last(2).join.to_i

    operation = OPERATIONS[op_code]
    op_type = operation[:type]

    num_params = operation[:params]
    num_outputs = operation[:outputs]
    num_inputs = num_params - num_outputs

    params = input[ip + 1, num_params]
    modes = instruction.split(//).first(3).map(&:to_i).reverse

    # puts "Instruction: #{instruction.inspect}"
    # puts "Modes: #{modes}"
    # puts "Params: #{params.take(num_inputs).zip(modes).inspect}"

    inputs = params.take(num_inputs).zip(modes).map do |param, mode|
      mode.eql?(1) ? param : input[param]
    end

    [op_type, op_code, num_params, params, inputs]
  end
end

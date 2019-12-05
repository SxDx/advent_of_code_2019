# frozen_string_literal: true

range = "231832-767346"
range = range.split("-")
min, max = range.map(&:to_i)

def increasing?(number)
  number.digits.each_cons(2).all? { |a, b| a >= b }
end

def any_double_digits?(number)
  number.digits.each_cons(2).map { |a, b| a == b }.count { |v| v }.positive?
end

def x(number)
  number.digits.each_cons(2).map { |a, b| a == b }
end

increasing_numbers = (min..max).select(&method(:increasing?))

# Part 1
puts increasing_numbers.count(&method(:any_double_digits?))

# Part 2
numbers = increasing_numbers.map do |x|
  x.digits.group_by(&:itself).values.map(&:size)
end

puts numbers.count { |d| d.include?(2) }

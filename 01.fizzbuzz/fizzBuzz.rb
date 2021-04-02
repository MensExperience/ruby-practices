#!/usr/bin/env ruby

(1..20).each do |i|
  if i % 15 == 0
    puts "FizzBuzz"    
  elseif i % 5 == 0
    puts "Buzz"
  elseif i % 3 == 0
    puts "Fizz"
end
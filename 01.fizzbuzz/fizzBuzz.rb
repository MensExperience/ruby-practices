#!/usr/bin/env ruby

flg = 20
i = 1
while flg >= i
    case
    when i%15 == 0
        puts "FizzBunzz"
    when i%5 == 0
        puts "Buzz"
    when i%3 == 0
        puts"Fizz"
    else
        puts i
    end
    i += 1
end


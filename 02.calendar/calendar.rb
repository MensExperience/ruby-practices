#!/usr/bin/env ruby

require 'optparse'
require 'date'

params = ARGV.getopts("", "y:#{Date.today.year}", "m:#{Date.today.month}")

year = params["y"].to_i
month = params["m"].to_i

# 初日と曜日
first_day = Date.new(year,month,1)
first_day_wday = first_day.wday

# 最終日
last_day = Date.new(year,month,-1)

puts ("#{month}" + "月" + " " + "#{year}").center(20)
puts ["日", "月", "火", "水", "木", "金", "土"] .join(" ")

#初週の開始位置決めにスペース挿入
(0..first_day_wday -1).each do |space|
  print("   ")
end

#表示
(first_day..last_day).each do |n|
  print("#{n.day.to_s.rjust(2)}" + " ")
  print ("\n") if n.saturday?
end

print "\n\n"

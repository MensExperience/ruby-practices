#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |s|
  if s == 'X'
    shots.push(10)
    shots.push(0)
  else
    shots.push s.to_i
  end
end
frames = shots.each_slice(2).to_a

# 2ストライク OR 1ストライク1スペア
if frames.size == 12
  frames[9].pop
  frames[9].push(frames[10].first).push(frames[11].first)
  frames.pop(2)
# 1スペアのみ OR ストライク・スペアなし
elsif frames.size == 11
  frames[9].push(frames[10].first)
  frames.pop
end

point = frames.each_with_index.sum do |frame, i|
  if i <= 7 && frame.first == 10 && frames[i + 1].first == 10
    20 + frames[i + 2].first
  elsif i <= 8 && frame.first == 10
    10 + frames[i.next][0..1].sum
  elsif i != 9 && frame.sum == 10
    10 + frames[i.next].first
  else
    frame.sum
  end
end

p point

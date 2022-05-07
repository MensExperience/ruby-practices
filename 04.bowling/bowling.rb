#!/usr/bin/env ruby
# frozen_string_literal: true
text_scores = ARGV[0].split(',')
frame = []
text_scores.each do |text_score|
  if text_score == 'X'
    frame.push(10, 0)
  else
    frame.push text_score.to_i
  end
end

frames = frame.each_slice(2).to_a
total_score =
 frames.each_with_index.sum do |frame, i|
  if i + 1 >= 10 #last_game
    frame.sum
  elsif frame.first == 10 && frames[i.next].first == 10 #double_strike
    20 + frames[i + 2].first
  elsif frame.first == 10 #single_strike
    10 + frames[i.next][0..1].sum
  elsif frame.sum == 10 #spare
    10 + frames[i.next].first
  else
    frame.sum
  end
end

p total_score

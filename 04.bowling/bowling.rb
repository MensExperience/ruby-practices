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
  strike = (frame.first == 10)
  spare =(!strike && frame.sum == 10)
  if i + 1 >= 10
    frame.sum
  elsif strike
    if frames[i.next].first == 10
      20 + frames[i + 2].first
    else
      10 + frames[i.next][0..1].sum
    end
  elsif spare
    10 + frames[i.next].first
  else
    frame.sum
  end
end

p total_score

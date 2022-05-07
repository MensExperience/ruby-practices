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
  last_frame = (i + 1 >= 10)
  next_frame = frames[i.next]
  after_next_frame = frames[i + 2]

  if last_frame
    frame.sum
  elsif strike
    double = (frames[i.next].first == 10)
    if double
      20 + after_next_frame.first
    else
      10 + next_frame.sum
    end
  elsif spare
    10 + next_frame.first
  else
    frame.sum
  end
end

p total_score

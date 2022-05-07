#!/usr/bin/env ruby
# frozen_string_literal: true

score_text = ARGV[0]
scores = score_text.split(',')

frame = []
scores.each do |score|
  if score == 'X'
    frame.push(10, 0)
  else
    frame.push score.to_i
  end
end

game_score = frame.each_slice(2).to_a
if game_score.size == 12
  game_score[9].pop
  game_score[9].push(game_score[10].first).push(game_score[11].first)
  game_score.pop(2)
elsif game_score.size == 11
  game_score[9].push(game_score[10].first)
  game_score.pop
end

total_point = game_score.each_with_index.sum do |frame, i|
  if i <= 7 && frame.first == 10 && game_score[i + 1].first == 10
    20 + game_score[i + 2].first
  elsif i <= 8 && frame.first == 10
    10 + game_score[i.next][0..1].sum
  elsif i != 9 && frame.sum == 10
    10 + game_score[i.next].first
  else
    frame.sum
  end
end

p total_point

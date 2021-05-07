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

frames = []
shots.each_slice(2) do |s|
  frames.push(s)
end

# 10フレームの前処理 Start
# 2ストライク OR 1ストライク1スペア
if frames[9].first == 10 && frames[10].sum == 10
  frames[9].pop
  frames[9].insert(-1, frames[10].first, frames[11].first)
  frames.each { frames.delete_at(10) }
# 1スペアのみ OR ストライク・スペアなし
elsif frames[9].sum == 10 && frames[10].sum != 10
  frames[9].insert(-1, frames[10].first)
  frames.each { frames.delete_at(10) }
end
# 10フレームの前処理 End

point = 0
frames.each_with_index do |frame_exec, i|
  point +=
    if i <= 7 && frame_exec.first == 10 && frames[i + 1][0] == 10 # ダブルストライク
      20 + frames[i + 2].first
    elsif i <= 7 && frame_exec.first == 10 # シングルストライク
      10 + frames[i + 1].sum
    elsif i == 8 && frame_exec.first == 10 # ストライク(9フレーム目)
      10 + frames[i + 1][0..1].sum
    elsif i != 9 && frame_exec.sum == 10 # スペア（10フレーム目を除く）
      10 + frames[i + 1].first
    else
      frame_exec.sum
    end
end
p point

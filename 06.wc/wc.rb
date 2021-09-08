#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

class Main
  def main
    opt = ARGV.getopts('l')
    file_paths = ARGV
    display(file_paths, opt)
  end

  def display(file_paths, opt)
    total_line = 0
    total_word = 0
    total_bytesize = 0
    if file_paths.empty?
      file_text = $stdin.read
      display_detailed_information(file_text, opt)
      puts
    else
      file_paths.each do |file_path|
        file_text = File.read(file_path)
        display_detailed_information(file_text, opt)
        puts " #{adjust_display_position(file_path)}"
      end
      total_line += count_line(file_text)
      unless opt['l']
        total_word += count_word(file_text)
        total_bytesize += count_bytesize(file_text)
      end
      display_total_count(total_line, total_word, total_bytesize, opt) if file_paths.size > 1
    end
  end

  private

  def display_detailed_information(file_text, opt)
    print " #{adjust_display_position(count_line(file_text))}"
      unless opt['l']
        print " #{adjust_display_position(count_word(file_text))}"
        print " #{adjust_display_position(count_bytesize(file_text))}"
      end
  end

  def display_total_count(total_line, total_word, total_bytesize, opt)
    print " #{adjust_display_position(total_line)}"
    unless opt['l']
      print " #{adjust_display_position(total_word)}"
      print " #{adjust_display_position(total_bytesize)}"
    end
    puts ' total'
  end

  def adjust_display_position(info)
    info.to_s.rjust(7)
  end

  def count_line(file_text)
    file_text.split(/\R/).size
  end

  def count_word(file_text)
    file_text.split(/\s+/).size
  end

  def count_bytesize(file_text)
    file_text.bytesize
  end
end

Main.new.main

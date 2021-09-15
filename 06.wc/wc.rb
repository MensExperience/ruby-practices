#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

class Main
  def main
    opt = ARGV.getopts('l')
    file_paths = ARGV
    file_paths.empty? ? display_for_stdin(opt) : display_filepath_input(file_paths, opt)
  end

  private

  def display_for_stdin(opt)
    file_text = $stdin.read
    line_count, word_count, bytesize_count = count_file_info(file_text)
    display_detailed_info(line_count, word_count, bytesize_count, nil, opt)
  end

  def display_filepath_input(file_paths, opt)
    total_line = 0
    total_word = 0
    total_bytesize = 0
    file_paths.each do |file_path|
      file_text = File.read(file_path)
      line_count, word_count, bytesize_count = count_file_info(file_text)
      display_detailed_info(line_count, word_count, bytesize_count, file_path, opt)
      total_line += line_count
      total_word += word_count
      total_bytesize += bytesize_count
    end
    display_detailed_info(total_line, total_word, total_bytesize, 'total', opt) if file_paths.size > 1
  end

  def display_detailed_info(line_count, word_count, bytesize_count, file_path, opt)
    print " #{format_value(line_count)}"
    unless opt['l']
      print " #{format_value(word_count)}"
      print " #{format_value(bytesize_count)}"
    end
    puts " #{file_path}"
  end

  def count_file_info(file_text)
    line_count = count_line(file_text)
    word_count = count_word(file_text)
    bytesize_count = count_bytesize(file_text)
    [line_count, word_count, bytesize_count]
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

  def format_value(value)
    value.to_s.rjust(7)
  end
end

Main.new.main

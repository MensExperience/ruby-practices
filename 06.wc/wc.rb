#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

class Main
  def main
    opt = ARGV.getopts('l')
    read_files = ARGV
    if read_files.empty?
      opt['l'] ? StanderdInput.new.standard_input_l : StanderdInput.new.standard_input
    else
      opt['l'] ? FileArguments.new.disp_l(read_files) : FileArguments.new.disp(read_files)
    end
  end
end

class FileArguments
  def disp_total(total_line, total_word, total_bytesize)
    print " #{total_line.to_s.rjust(7)}"
    print " #{total_word.to_s.rjust(7)}"
    print " #{total_bytesize.to_s.rjust(7)}"
    puts ' total'
  end

  def disp_total_l(total_line)
    print " #{total_line.to_s.rjust(7)}"
    puts ' total'
  end

  def disp(read_files)
    total_line = 0
    total_word = 0
    total_bytesize = 0
    read_files.each do |file|
      read_file = File.read(file)
      print " #{read_file.split(/\R/).size.to_s.rjust(7)}"
      print " #{read_file.split(/\s+/).size.to_s.rjust(7)}"
      print " #{read_file.bytesize.to_s.rjust(7)}"
      puts " #{file}"
      total_line += read_file.split(/\R/).size
      total_word += read_file.split(/\s+/).size
      total_bytesize += read_file.bytesize
    end
    disp_total(total_line, total_word, total_bytesize) if read_files.size > 1
  end

  def disp_l(read_files)
    total_line = 0
    read_files.each do |file|
      read_file = File.read(file)
      print " #{read_file.split(/\R/).size.to_s.rjust(7)}"
      puts " #{file}"
      total_line += read_file.lines.count
    end
    disp_total_l(total_line) if read_files.size > 1
  end
end

class StanderdInput
  def standard_input
    input = $stdin.read
    print " #{input.split(/\R/).size.to_s.rjust(7)}"
    print " #{input.split(/\s+/).size.to_s.rjust(7)}"
    puts " #{input.bytesize.to_s.rjust(7)}"
  end

  def standard_input_l
    input = $stdin.read
    puts " #{input.split(/\R/).size.to_s.rjust(7)}"
  end
end

Main.new.main

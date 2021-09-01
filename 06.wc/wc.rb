#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

class Main
  def main
    opt = ARGV.getopts('l')
    read_files = ARGV
    if read_files.empty?
      StanderdInput.new.disp_standard_input(opt)
    else
      FileArguments.new.disp(read_files, opt)
    end
  end
end

class FileArguments
  def adjust_display(info)
    info.to_s.rjust(7)
  end

  def disp_total(total_line, total_word, total_bytesize, opt)
    print " #{adjust_display(total_line)}"
    print " #{adjust_display(total_word)}" unless opt['l']
    print " #{adjust_display(total_bytesize)}" unless opt['l']
    puts ' total'
  end

  def disp(read_files, opt)
    total_line = 0
    total_word = 0
    total_bytesize = 0
    file_arguments = CalcFileInfo.new
    read_files.each do |file|
      read_file = File.read(file)
      print " #{file_arguments.count_word(read_file)}"
      print " #{file_arguments.count_line(read_file)}" unless opt['l']
      print " #{file_arguments.count_bytesize(read_file)}" unless opt['l']
      puts " #{file}"
      total_line += file_arguments.calc_word(read_file)
      total_word += file_arguments.calc_line(read_file) unless opt['l']
      total_bytesize += file_arguments.calc_bytesize(read_file) unless opt['l']
    end
    disp_total(total_line, total_word, total_bytesize, opt) if read_files.size > 1
  end
end

class StanderdInput
  def disp_standard_input(opt)
    read_file = $stdin.read
    standerd_input = CalcFileInfo.new
    print " #{standerd_input.count_word(read_file)}"
    print " #{standerd_input.count_line(read_file)}" unless opt['l']
    print " #{standerd_input.count_bytesize(read_file)}" unless opt['l']
    puts
  end
end

class CalcFileInfo
  def count_word(read_file)
    read_file.split(/\R/).size.to_s.rjust(7)
  end

  def count_line(read_file)
    read_file.split(/\s+/).size.to_s.rjust(7)
  end

  def count_bytesize(read_file)
    read_file.bytesize.to_s.rjust(7)
  end

  def calc_word(read_file)
    read_file.split(/\R/).size
  end

  def calc_line(read_file)
    read_file.split(/\s+/).size
  end

  def calc_bytesize(read_file)
    read_file.bytesize
  end
end

Main.new.main

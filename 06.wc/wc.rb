#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

class Main
  def main
    opt = ARGV.getopts('l')
    read_files = ARGV
    if read_files.empty?
      StanderdInput.new.standard_input(opt)
    else
      FileArguments.new.disp(read_files, opt)
    end
  end
end

class FileArguments
  def disp_total(total_line, total_word, total_bytesize, opt)
    print " #{total_line.to_s.rjust(7)}"
    print " #{total_word.to_s.rjust(7)}" unless opt['l']
    print " #{total_bytesize.to_s.rjust(7)}" unless opt['l']
    puts ' total'
  end

  def disp(read_files, opt)
    total_line = 0
    total_word = 0
    total_bytesize = 0
    read_files.each do |file|
      read_file = File.read(file)
      print " #{read_file.split(/\R/).size.to_s.rjust(7)}"
      print " #{read_file.split(/\s+/).size.to_s.rjust(7)}" unless opt['l']
      print " #{read_file.bytesize.to_s.rjust(7)}" unless opt['l']
      puts " #{file}"
      total_line += read_file.split(/\R/).size
      total_word += read_file.split(/\s+/).size unless opt['l']
      total_bytesize += read_file.bytesize unless opt['l']
    end
    disp_total(total_line, total_word, total_bytesize, opt) if read_files.size > 1
  end
end

class StanderdInput
  def standard_input(opt)
    input = $stdin.read
    print " #{input.split(/\R/).size.to_s.rjust(7)}"
    print " #{input.split(/\s+/).size.to_s.rjust(7)}" unless opt['l']
    print " #{input.bytesize.to_s.rjust(7)}" unless opt['l']
    puts
  end
end

Main.new.main

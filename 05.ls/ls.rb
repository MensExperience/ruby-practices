#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

DISP_COLUMN = 3
DEFINED_FILESTYPE = {
  'file': '-',
  'directory': 'd',
  'character special': 'c',
  'block special': 'b', 'socket': 's',
  'symbolic link': 'l'
}.freeze
DEFINED_PERMISSION = {
  '0': '---',
  '1': '--x',
  '2': '-w-',
  '3': '-wx',
  '4': 'r--',
  '5': 'r-x',
  '6': 'rw-',
  '7': 'rwx'
}.freeze

class Main
  def main
    opt = ARGV.getopts('a', 'l', 'r')
    option_a = FilesInADirectory.new
    files = opt['a'] ? option_a.retrieve_all_files : option_a.retrieve_files
    files = files.reverse if opt['r']
    if opt['l']
      option_l = DetailedFileInformation.new
      option_l.disp(files)
    else
      displayed_files = Displayedfiles.new
      disp_files = displayed_files.make_displayedfiles(files)
      displayed_files.disp(disp_files)
    end
  end
end

class FilesInADirectory
  def retrieve_files
    Array.new(Dir.glob('*').sort)
  end

  def retrieve_all_files
    Array.new(Dir.glob('*', File::FNM_DOTMATCH).sort)
  end
end

class Displayedfiles
  def make_displayedfiles(files)
    files << nil until (files.size % DISP_COLUMN).zero?
    disp_row = files.size / DISP_COLUMN
    files = files.each_slice(disp_row).to_a
    files.transpose
  end

  def disp(disp_files)
    disp_files.each do |i|
      i.each do |j|
        print j.to_s.ljust(20)
      end
      print "\n"
    end
  end
end

class DetailedFileInformation
  def disp(files)
    blocks_total = files.sum { |n| File::Stat.new(n).blocks }
    puts "total #{blocks_total}"
    files.each do |f|
      stat =  File::Stat.new(f)
      print DEFINED_FILESTYPE.values_at(stat.ftype.to_sym).first
      print DEFINED_PERMISSION.values_at(stat.mode.to_s(8)[-3].to_sym).first
      print DEFINED_PERMISSION.values_at(stat.mode.to_s(8)[-2].to_sym).first
      print DEFINED_PERMISSION.values_at(stat.mode.to_s(8)[-1].to_sym).first
      print " #{stat.nlink}".rjust(3)
      print " #{Etc.getpwuid(stat.uid).name} "
      print " #{Etc.getgrgid(stat.gid).name} "
      print " #{stat.size}".rjust(5)
      print " #{stat.mtime.strftime('%_m %e %H:%M')}".rjust(5)
      puts " #{f}".ljust(5)
    end
  end
end

Main.new.main

#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

DISP_COLUMN = 3 # 表示数
DEFINED_FILESTYPE = { 'file': '-', 'directory': 'd', 'character special': 'c', 'block special': 'b', 'socket': 's', 'symbolic link': 'l' }.freeze
DEFINED_PERMISSION = { '0': '---', '1': '--x', '2': '-w-', '3': '-wx', '4': 'r--', '5': 'r-x', '6': 'rw-', '7': 'rwx' }.freeze

class Main
  def main
    opt = ARGV.getopts('a', 'l', 'r')

    # オプションa
    option_a = OptionA.new
    files = opt['a'] ? option_a.retrieve_all_files : option_a.retrieve_files

    # オプションr
    files = files.reverse if opt['r']

    # オプションl
    if opt['l']
      option_l = OptionL.new
      option_l.disp(files)
    else
      displayed_files = Displayedfiles.new
      disp_files = displayed_files.make_displayedfiles(files)
      displayed_files.disp(disp_files)
    end
  end
end

class OptionA
  def retrieve_files
    Array.new(Dir.glob('*').sort)
  end

  # aオプション
  def retrieve_all_files
    Array.new(Dir.glob('*', File::FNM_DOTMATCH).sort)
  end
end

class Displayedfiles
  # 表示分割
  def make_displayedfiles(files)
    files = files.each_slice(DISP_COLUMN).to_a
    files.last << nil until files.last.size >= DISP_COLUMN
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

class OptionL
  def disp(files)
    # トータルブロック数
    blocks_total = []
    files.each do |f|
      blocks_total.push(File::Stat.new(f).blocks)
    end
    puts "total #{blocks_total.sum}"
    # ファイル情報詳細
    files.each do |f|
      stat =  File::Stat.new(f)
      # ファイルタイプ
      print DEFINED_FILESTYPE.values_at(stat.ftype.to_sym).first
      # パーミッション
      print DEFINED_PERMISSION.values_at(stat.mode.to_s(8)[-3].to_sym).first
      print DEFINED_PERMISSION.values_at(stat.mode.to_s(8)[-2].to_sym).first
      print DEFINED_PERMISSION.values_at(stat.mode.to_s(8)[-1].to_sym).first
      # ハードリンク
      print " #{stat.nlink}".rjust(3)
      # 所有ユーザー
      print " #{Etc.getpwuid(stat.uid).name} "
      # 所有グループ
      print " #{Etc.getgrgid(stat.gid).name} "
      # サイズ
      print " #{stat.size}".rjust(5)
      # タイムスタンプ
      print "  #{stat.mtime.strftime('%-m %e %H:%M')}".rjust(5)
      # ファイル名
      puts " #{f}".ljust(5)
    end
  end
end

Main.new.main

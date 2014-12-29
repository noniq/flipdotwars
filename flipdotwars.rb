require_relative "lib/charset"
require_relative "lib/display"
require_relative "lib/movie"

require "pry"

EMPTY_LINE = " " * 144

DISPLAY_IPS = %w(2001:67C:20A1:1095:C49D:E22D:6891:DCD 2001:67C:20A1:1095:34B1:6957:8DDB:3A79  2001:67C:20A1:1095:552A:1594:871F:D9C2)
DISPLAY_PORT = 2323

skip_frames = ARGV[0].to_i || 0

charset = Charset.new("#{__dir__}/data/charset.txt")
movie   = Movie.new("#{__dir__}/data/movie.txt")
display = Display.new(DISPLAY_IPS, DISPLAY_PORT)

trap "SIGINT" do
  puts "Exiting at frame #{@frame_nr}"
  exit 130
end

movie.frames[skip_frames..-1].each_slice(8).with_index do |frames, i|
  @frame_nr = skip_frames + i * 8
  frame = frames.first
  display_lines = [EMPTY_LINE] * 34
  frame.each do |line|
    display_lines += charset.convert(line).map{ |l| "     #{l}     " }
  end
  display_lines += [EMPTY_LINE] * 34
  display.show(display_lines)
  print "\e[2J\e[f"
  puts display_lines
  sleep(0.7)
end
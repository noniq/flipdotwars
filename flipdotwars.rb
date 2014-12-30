require_relative "lib/charset"
require_relative "lib/display"
require_relative "lib/movie"

require "pry"

DISPLAY_IPS = %w(2001:67C:20A1:1095:C49D:E22D:6891:DCD 2001:67C:20A1:1095:34B1:6957:8DDB:3A79  2001:67C:20A1:1095:552A:1594:871F:D9C2)
DISPLAY_PORT = 2323
DELAY        = 0.55 # Delay (in seconds) between sending the frames

@current_frame = ARGV[0].to_i || 0

#charset = Charset.new("#{__dir__}/data/charset-2x4.txt", 2, 4)
charset = Charset.new("#{__dir__}/data/charset-3x6.txt", 3, 6)

movie   = Movie.new("#{__dir__}/data/movie.txt")
display = Display.new(DISPLAY_IPS, DISPLAY_PORT)

trap "SIGINT" do
  puts "Exiting at frame #{@current_frame.to_i}"
  exit 130
end

while @current_frame < movie.frames.length
  frame = movie.frames[@current_frame.to_i]
  converted_frame = frame.map{ |line| charset.convert(line) }.flatten
  display.show(converted_frame)
  print "\e[2J\e[f"
  puts converted_frame
  sleep(DELAY)
  @current_frame += 15.0 / (1.0 / DELAY) # Original movie has about 15 FPS
end
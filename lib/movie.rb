class Movie
  LINES_PER_FRAME = 13 # Do not include the separator line in this number
  
  attr_reader :frames
  
  def initialize(path)
    @frames = []
    read_frames_from(path)
  end
  
  private
  
  def read_frames_from(path)
    File.readlines(path).map(&:chomp).each_slice(LINES_PER_FRAME + 1) do |lines|
      frame = lines[1..LINES_PER_FRAME].map{ |line| line.ljust(67) }
      repeat_count = lines[0].to_i
      repeat_count.times do
        @frames << frame
      end
    end
  end
end

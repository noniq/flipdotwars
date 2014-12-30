class Charset
  attr_reader :width, :height
  
  def initialize(path, width, height)
    @width, @height = width, height
    @data = {}
    read_data_from(path)
  end
  
  def convert(line)
    line.split("").map{ |c| self[c] }.transpose.map(&:join)
  end
  
  def [](character)
    @data.fetch(character)
  end
  
  private
  
  def read_data_from(path)
    File.readlines(path).map(&:chomp).each_slice(height + 2) do |lines|
      until lines.first.empty?
        parse_character_data(lines.map{ |line| line.slice!(0..(height + 1))})
      end
    end
  end
  
  def parse_character_data(lines)
    lines = lines.map{ |line| line.tr("·", " ") }
    character = lines[0][0]
    raise "Multiple definitions for '#{character}'!" if @data.has_key?(character)
    @data[character] = lines[1..height].map{ |line| line.scan(compress_char_width_regexp).join }
  end
  
  # Used to discard every second row of the character data (there should be an easier way – pull requests welcome!)
  def compress_char_width_regexp
    @compress_char_width_regexp ||= Regexp.new("(.)." * width)
  end
end
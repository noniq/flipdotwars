class Charset
  def initialize(path)
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
    File.readlines(path).map(&:chomp).each_slice(6) do |lines|
      until lines.first.empty?
        parse_character_data(lines.map{ |line| line.slice!(0..5)})
      end
    end
  end
  
  def parse_character_data(lines)
    lines = lines.map{ |line| line.tr("·", " ") }
    character = lines[0][0]
    raise "Multiple definitions for '#{character}'!" if @data.has_key?(character)
    @data[character] = lines[1..4].map{ |line| line.scan(/(.).(.)./)[0].join }
  end
    
end
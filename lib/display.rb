require "socket"

class Display
  EMPTY_LINE = " " * 144
  
  attr_reader :ips, :port, :socket
  
  def initialize(ips, port)
    @ips = ips
    @port = port
    @socket ||= UDPSocket.new(Socket::AF_INET6)
  end
  
  def show(frame)
    frame = pad_frame(frame)
    bytes = [[], [], []]
    0.upto(2).each do |panel|
      0.upto(47).each do |col|
        byte = ""
        119.downto(0).each do |row|
          byte += frame[row][panel * 48 + col] != " " ? "1" : "0"
          if byte.length == 8
            bytes[panel] << byte.to_i(2)
            byte = ""
          end
        end
      end
      socket.send bytes[panel].pack("c" * 720), 0, ips[panel], port
    end
  end
  
  # Pad frame with blank lines and spaces so we get exactly 120 lines, containing 144 characters each.
  def pad_frame(frame)
    frame = frame.map{ |line| line.center(144) }    
    blank_lines = 120 - frame.size
    [EMPTY_LINE] * (blank_lines / 2.0).ceil + frame + [EMPTY_LINE] * (blank_lines / 2.0).floor
  end
end
require "socket"

class Display
  attr_reader :ips, :port, :socket
  
  def initialize(ips, port)
    @ips = ips
    @port = port
    @socket ||= UDPSocket.new(Socket::AF_INET6)
  end
  
  # frame has to be an array of 120 strings, each containing 144 characters.
  def show(frame)
    bytes = [[], [], []]
    0.upto(2).each do |panel|
      0.upto(47).each do |col|
        byte = ""
        119.downto(0).each do |row|
          byte += frame[row][panel * 48 + col] == " " ? "1" : "0"
          if byte.length == 8
            bytes[panel] << byte.to_i(2)
            byte = ""
          end
        end
      end
      socket.send bytes[panel].pack("c" * 720), 0, ips[panel], port
    end
    
  end
end
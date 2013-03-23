#script test de socket?
require $LOAD_PATH[3]+'/socket.so'

# Add a menu item to launch GESTURE plugin.
UI.menu("Plugins").add_item("Sockettest..") {
  
  #call Splash Screen function to load resources
runsocket  
}

$hostname = 'localhost'
$port = 2000

               # Close the socket when done


def runsocket
      puts "Establishing a connection..."
     # SKSocket.connect('127.0.0.1', 2000) 
      #puts "Connection established."
      #SKSocket.add_socket_listener { |e| socket_listener(e) } 
	  
#	s = TCPSocket.open(host, port)
#	puts "Connection established."
#	while line = s.gets   # Read lines from the socket
#		puts line.chop      # And print with platform line terminator
#	end
#	s.close
	   
$streamSock = TCPSocket.new($hostname, $port)#TCPSocket.new( "127.0.0.1", 20000 )  
 
puts "Connection established"

#streamSock.send( "Hello\n" ) 
#Thread.new{
	puts "new thread start"
	loop{
	#while line = $streamSock.gets   # Read lines from the socket
	#	puts line.chop      # And print with platform line terminator
	#end
#while (str = $streamSock.recv(2))
#		puts "ff"
		strr = $streamSock.read(32)
		#str = $streamSock.recv(32)
		puts strr  
		}
#	end
	#$streamSock.close
	puts "Socket closed"
##}
#include Socket::Constants
#$socket = Socket.new( AF_INET, SOCK_STREAM, 0 )
#sockaddr = Socket.pack_sockaddr_in( 2000, '127.0.0.1' )
#$socket.connect( sockaddr )



#wrote= $socket.write(Time.now) 
#puts wrote

#Thread.new{
#puts "new thread start"
#puts $socket.read
#puts "3"
#while line = $socket.read   # Read lines from the socket
 # puts "in the line"
  #puts line.chop      # And print with platform line terminator
#end#}
#server = TCPServer.new('localhost', 20000)  
#while(true) do  
#  Thread.start(dts.accept) do |s|  
#    print(s, " is accepted\n")  
#    s.write(Time.now)  
#    print(s, " is gone\n")  
#    s.close  
#  end  
#end  

#while (client!=nil) do
#  client = server.accept    # Wait for a client to connect
#  client.puts "Hello !"
#  client.puts "Time is #{Time.now}"
#  client.close
#end


end 

def socket_listener(v) 
      if v[0..2] == "RDY" 
        puts "Sending version..."
        SKSocket.write "1:12".ljust(11) 
        puts "Version sent."
      end 
end 
	


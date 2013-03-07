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
	   
streamSock = TCPSocket.new( "127.0.0.1", 20000 )  
streamSock.send( "Hello\n" )  
#str = streamSock.recv( 100 )  
#print str  
streamSock.close
	  
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
	


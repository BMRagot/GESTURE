
require 'GESTURE/Control/socket.so'

#require 'socket'

# Add a menu item to launch GESTURE plugin.
UI.menu("Plugins").add_item("socket...") {
  
  #call Splash Screen function to load resources
  runsocket
  
}


def runsocket
createserver
createclient
end


$hostname = 'localhost'
$port = 2000

def createserver
server = TCPServer.open($port)  # Socket to listen on port 2000
loop {                         # Servers run forever
  
  Thread.start(server.accept) do |client|
    client.puts(Time.now.ctime) # Send the time to the client
	client.puts "Closing the connection. Bye!"
    client.close     
  
  end
  
  
  #client = server.accept       # Wait for a client to connect
  #client.puts(Time.now.ctime)  # Send the time to the client
  #client.puts "Closing the connection. Bye!"
  #client.close                 # Disconnect from the client
}
end

def createclient
s = TCPSocket.open($hostname, $port)

while line = s.gets   # Read lines from the socket
  puts line.chop      # And print with platform line terminator
end
s.close  
end




#require 'socket'
#client = TCPSocket.open('localhost', 'finger')
#client.send("oracle\n", 0)    # 0 means standard packet
#puts client.readlines
#client.close


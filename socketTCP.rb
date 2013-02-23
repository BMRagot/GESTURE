#script test de socket?

require 'socket'

# Add a menu item to launch GESTURE plugin.
UI.menu("Plugins").add_item("Sockettest..") {
  
  #call Splash Screen function to load resources
runsocket  
}

def runsocket
      puts "Establishing a connection..."
      SKSocket.connect('127.0.0.1', 2000) 
      puts "Connection established."
      SKSocket.add_socket_listener { |e| socket_listener(e) } 
end 

def socket_listener(v) 
      if v[0..2] == "RDY" 
        puts "Sending version..."
        SKSocket.write "1:12".ljust(11) 
        puts "Version sent."
      end 
end 
	


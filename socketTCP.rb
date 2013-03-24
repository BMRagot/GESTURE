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

$data = []
$model = Sketchup.active_model
$view = $model.active_view
#streamSock.send( "Hello\n" ) 
	Thread.new{  
#UI.start_timer(0,false){
	puts "new thread start"
	loop{
	#while line = $streamSock.gets   # Read lines from the socket
	#	puts line.chop      # And print with platform line terminator
	#end
#while (str = $streamSock.recv(2))
#		puts "ff"
		$strr = $streamSock.read(120)
		#str = $streamSock.recv(32)
		$data << $strr  
		puts $strr
		$order=$strr.split('/')
		puts $order[0]
		if ($order[0]=="B")
			c=0
			a =$order[1].to_f/4.8#-$model.active_entities[0].transformation.to_a[13]
			b =$order[2].to_f/6.4 #-$model.active_entities[0].transformation.to_a[14]
			#c =$order[3].to_f#-$model.active_entities[0].transformation.to_a[15]
			new_transformation = Geom::Transformation.new([a,b,c])
			$model.active_entities[0].move! new_transformation
			
			refreshed_view = $view.refresh
		end
		}
#	end
	#$streamSock.close
	puts "Socket closed"
}

UI.start_timer(0,false){
#Thread.new{
	log(1,"")
loop{
	log(2,$strr)
	puts $data
	
	
	}
}




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

def move_copy( component, distance )

=begin
Creates an outer array, moving a component "distance" as many times as
specified.

"distance" is a vector, an array of [r, g, b].

"number_of_copies" is like the "Nx" in the VCB after a Move/Copy.
For 15 steps, you make 14 copies.
=end

    ents = Sketchup.active_model.entities[component]

    #defi = component.definition # the original component's definition
    #trans = component.transformation # the original's transformation
    trans = ents.transformation
	pt = trans.origin # the original's location, a Point3d

  
        pt += distance
            # add vector to Point3d getting new Point3d
        trans = Geom::Transformation.new( pt )
            # create new Transformation at the new Point3d
        ents=ents*trans
		#ents.add_instance( defi, trans )
            # add another instance at the new Point3d
   

end # of move_copy()




def socket_listener(v) 
      if v[0..2] == "RDY" 
        puts "Sending version..."
        SKSocket.write "1:12".ljust(11) 
        puts "Version sent."
      end 
end 
	


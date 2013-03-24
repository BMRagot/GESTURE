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
#	s = TCPSocket.open(host, port)
#	puts "Connection established."
#	while line = s.gets   # Read lines from the socket
#		puts line.chop      # And print with platform line terminator
#	end
#	s.close
 


$data = []
$model = Sketchup.active_model
$view = $model.active_view
$number_obj = $model.active_entities.length
$strr= "0"

#streamSock.send( "Hello\n" ) 	$t1=Thread.new{  

$streamSock = TCPSocket.new($hostname, $port)#TCPSocket.new( "127.0.0.1", 20000 )  
puts "Connection established"
id=UI.start_timer(0,false){
	puts "new thread start"
	old= nil
	tomove=0
	loop{
		$mem = $streamSock.read(120)
		#strr = $streamSock.recv(120)
		if ($mem != $strr)
			$strr=$mem
			$data << $strr  
		end
		
		$order=$strr.split('/')
		puts $order[0]
		
		nex2=1000000
		if($order[0]=="B" && old=="A")
			for i in 1..$number_obj-1
				nex1=$model.active_entities[0].transformation.to_a[13..15].distance $model.active_entities[i].transformation.to_a[13..15]
				if (nex1<nex2)
					toselect=i
					nex2=nex1
				end
			end
			$model.active_entities[0].visible=false
			vector = Geom::Vector3d.new 0,0,0
			t = Geom::Transformation.translation vector
			$model.active_entities[0].move!(t)
			tomove=toselect
		elsif ($order[0]=="A" && old=="B")
			$model.active_entities[0].visible=true
			tomove=0
		
		elsif ($order[0]=="B" && old=="B")
			a = $order[1].to_f/4.8 
			b = -$order[2].to_f/6.4
			c = $order[3].to_f/10
			vector = Geom::Vector3d.new a,b,c
			t = Geom::Transformation.translation vector
			$model.active_entities[tomove].transform! (t)
			refreshed_view = $view.refresh
		elsif($order[0]=="A" && old=="A")
			a = $order[1].to_f/4.8 
			b = -$order[2].to_f/6.4
			c = $order[3].to_f/10
			vector = Geom::Vector3d.new a,b,c
			t = Geom::Transformation.translation vector
			$model.active_entities[0].transform! t
			refreshed_view = $view.refresh
		
		elsif ($order[0].include? "QUIT")
			break
			UI.stop_timer(id)
		end
		old=$order[0]
	}
	$streamSock.close
	puts "Socket closed"
}
#$t1.abort_on_exception = true
#UI.start_timer(0,false){
#$t2=Thread.new{
#loop{
#	refreshed_view = $view.refresh
##}
##}
#$t2.abort_on_exception = true
#UI.start_timer(0,false){

#Thread.new{
#	log(1,"")
#loop{
#	log(2,$strr)
#	puts $data	
#	}
##}




#include Socket::Constants
#$socket = Socket.new( AF_INET, SOCK_STREAM, 0 )
#sockaddr = Socket.pack_sockaddr_in( 2000, '127.0.0.1' )
#$socket.connect( sockaddr )
 

end 
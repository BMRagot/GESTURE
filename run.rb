#script test de socket?
require $LOAD_PATH[3]+'/socket.so'
#require $LOAD_PATH[3]+'/thread.so'
# Add a menu item to launch GESTURE plugin.
UI.menu("Plugins").add_item("run..") {
  
  #call Splash Screen function to load resources
runxx
}

def runxx
puts "go"

Thread.new{
loop{
$result = $io.readlines()
}
}


Thread.new{
#UI.start_timer(0,false){###someiteratingcodehere### 
puts "new thread start"
$io = IO.popen("C:/Program Files (x86)/Google/Google SketchUp 8/Plugins/TCPserver.exe","r")
#"C:/Program Files (x86)/Google/Google SketchUp 8/Plugins/GESTURE/Interpretation/test sigmanil/TCP/TCPserver/Debug/TCPserver.exe", "rw")
#f = IO.popen("uname")
#puts f.readlines
#puts "Parent is #{Process.pid}"
#IO.popen ("date") { |f| puts f.gets }
#IO.popen("-") {|f| $stderr.puts "#{Process.pid} is here, f is #{f}"}
#p $?
puts io

#while i_have_stuff_to_compute
 #   arguments = get_arguments()
    # Write arguments on the program's input stream
  #  IO.puts(arguments)
    # Read reply from the program's output stream
    #$result =$io.readlines()
#end

#puts $result[0]
#io.close()

}

##}
puts "end"
#puts $result[0]
end
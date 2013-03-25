#
#         _______  _______  _______ _________          _______  _______ 
#        (  ____ \(  ____ \(  ____ \\__   __/|\     /|(  ____ )(  ____ \
#        | (    \/| (    \/| (    \/   ) (   | )   ( || (    )|| (    \/
#        | |      | (__    | (_____    | |   | |   | || (____)|| (__    
#        | | ____ |  __)   (_____  )   | |   | |   | ||     __)|  __)   
#        | | \_  )| (            ) |   | |   | |   | || (\ (   | (      
#        | (___) || (____/\/\____) |   | |   | (___) || ) \ \__| (____/\
#        (_______)(_______/\_______)   )_(   (_______)|/   \__/(_______/
#                                                                      
#	author: B. MARICHAL & A. VERON
#	date: 02/2013
#	name: GESTURE Plugins
#	version: 0.1
#	description: 
#		The GESTURE plugins allows you to manipulate your 3D objects using a Kinect.
#		You can find more information about project here: www.gesture.com
#		
#
#
#



# First we pull in the standard API hooks.
require 'sketchup.rb'
require 'loadpath.rb'
require $LOAD_PATH[3]+'/socket.so'

#############################################################
#					DEVELOPMENT								#
#############################################################
# Show the Ruby Console at startup so we can
# see any programming errors we may make.
Sketchup.send_action "showRubyPanel:"

#open Test.skp file
Sketchup.open_file 'C:\Program Files (x86)\Google\Google SketchUp 8\Plugins\Test.skp'


#############################################################
#						END DELETE 							#
#############################################################


# Add a menu item to launch GESTURE plugin.
UI.menu("Plugins").add_item("GESTURE...") {
  
  
   @model=Sketchup.active_model
        path=@model.path.tr("\\", "/")
        if not path or path==""
            UI.messagebox("GESTURE Plugins:\n\nVeuillez enregistrer votre fichier avant d'utiliser le contrôle gestuel.\n")
            return nil
        else
			#create log file
			log(1,'start')
			#call Splash Screen function to load resources
			splashscreen
		end
 
}





#############################################################
#						TODO								#
#############################################################

#		#Enable "start" BUtton if Status is "NOK"
#		#Add Tips to menu status
#		#Add alt img to splashscreen
#		#Modify Frame
#		#Detect windows closing fermeture des fenetre
#		#Complete log file with splashscreen result


#############################################################
#						Splash Screen						#
#############################################################
def splashscreen
	
	progressbar_score = 0
	
	#create WebDialog UI
	splashscreen_width =677 #660
  	splashscreen_height = 435 #420
  	
	#get sreen size to set the position of UI
  	$c = Sketchup.active_model.active_view.center
	
  	$dlgSplashScreen = UI::WebDialog.new("-=- GESTURE -=-", false, "GESTURE", splashscreen_width, splashscreen_height, $c[0]-splashscreen_width/2, $c[1]-splashscreen_height/2, true);
  	$dlgSplashScreen.set_file File.dirname(__FILE__) + "/GESTURE/Control/splashscreen.html"
	
	
	$dlgSplashScreen.min_height = 435
  	$dlgSplashScreen.min_width = 677
	$dlgSplashScreen.max_height = 435
  	$dlgSplashScreen.max_width = 677
	
	$dlgSplashScreen.set_position $c[0]-splashscreen_width/2, $c[1]-splashscreen_height/2
	$dlgSplashScreen.set_size splashscreen_width, splashscreen_height
	
	$dlgSplashScreen.show
	#splashscreen stucks on the top
	$dlgSplashScreen.show_modal
	
	#callback to get the video status
	$dlgSplashScreen.add_action_callback("SPLASHSCREEN_VID") do |js_wd, message|
		#1 video ended
		#useless
		#splashscreen_video=message.to_i
		# just +1 to update
		progressbar_score = progressbar_score + 70
		update_progress(progressbar_score)
	end

	# Test Kinect Connection
	
	# Get Sketchup environment data
	$SUversion = Sketchup.version
	$model = Sketchup.active_model
	$titlemodel = $model.title
	$materials = $model.materials
	$objects = $model.active_entities
	$number_obj = $model.active_entities.length
	
	$view = $model.active_view
	$camera = $view.camera
	$eye = $camera.eye
	$target = $camera.target
	$up = $camera.up
	$direction = $camera.direction	
	#log(2,"###SketchUp Object")
	log(2,'SU Version: '+$SUversion.to_s)
	##lo
	progressbar_score = progressbar_score + 10
	update_progress(progressbar_score)
	
	#Ruby resources
	$rb=RUBY_VERSION
	log(2,'###RUBY RESOURCES')
	log(2,'Ruby Version :'+$rb.to_s)
	if File.exist?($LOAD_PATH[3]) && File.exist?($LOAD_PATH[2]) && $rb=="1.8.6"
		$rbres=true
		log(2,"Load Path updated: All OK")
	else
		$rbres=false
		log(2,"Load Path updated: NOT OK")		
	end
	progressbar_score = progressbar_score + 10
	update_progress(progressbar_score)
	

	
	# Load C++ module
	idCpp=UI.start_timer(0,false){
		$CppLaunch = UI.openURL("C:/Program Files (x86)/Google/Google SketchUp 8/Plugins/GESTURE/Interpretation/GESTURE/x64/Release/GESTURE.exe")
	}
	if $CppLaunch 
		log(2,"Load GESTURE.exe: OK")
	else
		log(2,"Load GESTURE.exe: NOT OK")
	end
	progressbar_score = progressbar_score + 10
	update_progress(progressbar_score)
	
	# Create TCPServer
	$hostname = 'localhost'
	$port = 2000
	puts "Establishing a connection..."
#	$streamSock = TCPSocket.new($hostname, $port)#TCPSocket.new( "127.0.0.1", 20000 )  

	idsocket=UI.start_timer(2.0,false){
		puts "new thread start"
		
		
		#loop{
		$streamSock = TCPSocket.new($hostname, $port)
		$strr = $streamSock.read(120)
		#strr = $streamSock.recv(120)
		$order=$strr.split('/')
		puts $order[0]
		if $order[0].include? "hello"
			UI.stop_timer(idsocket)
			$SocketTest=true
		end
	#TCPSocket.new( "127.0.0.1", 20000 )  
		puts "Connection established"
	#while ($streamSock == nil)
#		$streamSock = TCPSocket.new($hostname, $port)#TCPSocket.new( "127.0.0.1", 20000 )  
#	end
	
		#}
	}
	if $streamSock != nil
		$SocketTest=true
		
	else
		$SocketTest=true
	end
	
	
	#test all component
	
 		
 	#if user closes splashscreen???
 	puts $dlgSplashScreen.visible?

 	# test progressbarscore==100%
#	dlgSplashScreen.close
 #	 menu
 	
end


#function to update progress bar
   	def update_progress(a)
		script = 'update(\''+a.to_s+'%\');'
		puts script
		$dlgSplashScreen.execute_script( script )
		
		if (a==100)
			$dlgSplashScreen.close
			menu
		end
	end


#############################################################
#						Menu								#
#############################################################
def menu

	#create WebDialog UI menu
	menu_width = 617  #600
  	menu_height = 525  #500

  	$dlgMenu = UI::WebDialog.new("-=- GESTURE -=-", false, "GESTURE", menu_width, menu_height, $c[0]-menu_width/2, $c[1]-menu_height/2, true);
  	$dlgMenu.set_file File.dirname(__FILE__) + "/GESTURE/Control/menu.html"
	
	$dlgMenu.min_height = 525
  	$dlgMenu.min_width = 617
	$dlgMenu.max_height = 525
  	$dlgMenu.max_width = 617
  	 	
	$dlgMenu.set_position $c[0]-menu_width/2, $c[1]-menu_height/2
	$dlgMenu.set_size menu_width, menu_height

	$dlgMenu.show
	
	$dlgMenu.add_action_callback("GESTURE_QUIT") {|dialog, params|
	    result = UI.messagebox("You quit GESTURE ", MB_OKCANCEL)
	    if result==1
	     	$dlgMenu.close
	     	#tuer le plugins????? TCP C++ y touti
	    end
   	}
   	
   	$dlgMenu.add_action_callback("GESTURE_START") {|dialog, params|
	     $dlgMenu.close
	     controlgesture
	     ##...
   	}
   	
   	$dlgMenu.add_action_callback("GESTURE_apprentissage") {|dialog, params|
	     $dlgMenu.close
	     #..
   	}
   	
   	$dlgMenu.add_action_callback("MENU_READY") {|dialog, params|
   		# Get all Status
   		add_status("Kinect","NOK")
   		if $CppLaunch
			add_status("CppGesture","OK")
		end
   		
   		add_status("versionSU", $SUversion.to_f.to_s)
   		if $rbres
			add_status("versionrb",$rb)
		end
		add_status("nomenv", $titlemodel.to_s + ".skp")
   		add_status("nbrobj", $number_obj.to_s)
		
		
		#if test des errors....
		#add_status("error",codeerror)
		#end
   	}

end

def add_status(a,b)
		script1 = 'add_statuts(\''+a+'\',\''+b+'\');'
#				document.getElementById("Kinect").textContent=\'4\';'
		puts script1
		$dlgMenu.execute_script( script1 )   	
end





#############################################################
#						Control 							#
#############################################################
def controlgesture

  	control_width = 345
  	control_height = 645


	$dlgControl = UI::WebDialog.new("-=- GESTURE -=-", true, "GESTUREcontrol", control_width , control_height,  0, 0, true);
  	$dlgControl.set_file File.dirname(__FILE__) + "/GESTURE/Control/control.html"
	
	$dlgControl.set_position 2*$c[0]-control_width, 2*$c[1]-control_height
	$dlgControl.set_size control_width, control_height
	
	$dlgControl.show	
	
	$dlgControl.add_action_callback("GESTURE_GETMENU") {|dialog, params|
	     $dlgControl.close
	     $dlgMenu.show
	     ##pause de l'interpreation???
   	}
	
	$dlgControl.add_action_callback("GESTURE_INTERPRETATION") {|dialog, params|
	     ##pause de l'interpreation
		 if params.to_s=='on'
			#UI.messagebox("faut demarrer ")
		 else 
			#UI.messagebox("faut arreter ")
			#ajouter  le retour de statu dans la console			
		 end
		 
   	}
	
	$dlgControl.add_action_callback("GESTURE_CONTROLRESIZE_P") {|dialog, params|
		control_height = control_height+params.to_i
		$dlgControl.set_size control_width, control_height
	}
	
	$dlgControl.add_action_callback("GESTURE_CONTROLRESIZE_N") {|dialog, params|
		control_height = control_height-params.to_i
		$dlgControl.set_size control_width, control_height
	}
end
def update_console(a)
		script2 = 'update_console(\''+a+'\');'
		puts script2
		$dlgControl.execute_script( script2 )   	
end




#############################################################
#						LOG Function						#
#############################################################
def log(opt,data)
  $log_path="C:/Program Files (x86)/Google/Google SketchUp 8/Plugins/GESTURE/log"
  if opt==1
	#create new lo file
	$log_name = "logesture_" + Time.now.year.to_s + Time.now.month.to_s + Time.now.day.to_s + Time.now.to_i.to_s + ".txt"
	$log_file = File.open($log_path + '/' + $log_name,'a+') 
	#add header
	$log_file.puts("##########################################################################################" )
	$log_file.puts("				GESTURE Plugins ")
	$log_file.puts("					Log File")
	$log_file.puts("		Plugin started :" + Time.now.to_s)
	$log_file.puts("						Gesture 2013 Copyright")
	$log_file.puts("##########################################################################################" )
	$log_file.close
  elsif opt==2
	#write data into log file
	$log_file = File.open($log_path + '/' + $log_name,'a+') 
	$log_file.puts(data.to_s )
	$log_file.close	
  end
end 


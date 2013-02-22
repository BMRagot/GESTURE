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
#	description: 



# First we pull in the standard API hooks.
require 'sketchup.rb'

##DEV to delete 
# Show the Ruby Console at startup so we can
# see any programming errors we may make.
Sketchup.send_action "showRubyPanel:"

# Add a menu item to launch GESTURE plugin.
UI.menu("Plugins").add_item("GESTURE...") {
  
  #call Splash Screen function to load resources
  splashscreen
  
}

#############################################################
#						Splash Screen						#
#############################################################
def splashscreen
	
	progressbar_score = 0
	
	#create WebDialog UI
	splashscreen_width = 660
  	splashscreen_height = 420
  	
  	c = Sketchup.active_model.active_view.center
  	
  	$dlgSplashScreen = UI::WebDialog.new("-=- GESTURE -=-", false, "GESTURE", splashscreen_width, splashscreen_height, c[0]-splashscreen_width/2, c[1]-splashscreen_height/2, true);
  	$dlgSplashScreen.set_file File.dirname(__FILE__) + "/GESTURE/Control/splashscreen.html"
	
	
	$dlgSplashScreen.min_height = 420
  	$dlgSplashScreen.min_width = 660
	$dlgSplashScreen.max_height = 420
  	$dlgSplashScreen.max_width = 660
	
	$dlgSplashScreen.show
	
	#callback to get the video status
	$dlgSplashScreen.add_action_callback("SPLASHSCREEN_VID") do |js_wd, message|
		#1 video ended
		#useless
		#splashscreen_video=message.to_i
		# just +1 to update
		progressbar_score = progressbar_score + 100
		update_progress(progressbar_score)
	end

	# Test Kinect Connection
	
	# Get Sketchup environment data
	$model = Sketchup.active_model
	$materials = $model.materials
	$number_materials = $materials.length

	$view = $model.active_view
	$camera = $view.camera
	$eye = $camera.eye
	$target = $camera.target
	$up = $camera.up
	$direction = $camera.direction	
	
	# Create TCPServer
	
	# Load C++ module
	
	#test all component
	
	#save result
	#log file??
	
	
 	#transfert result
 	
 	
 	#if user closes splashscreen???
 	$dlgSplashScreen.visible?
 	UI.messagebox("Your model has " + $number_materials.to_s + " materials.")

 	# test progressbarscore==100%
#	dlgSplashScreen.close
 	# menu
 	
 	
 	
 	
 	
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
	menu_width = 600
  	menu_height = 500

	c = Sketchup.active_model.active_view.center
  	$dlgMenu = UI::WebDialog.new("-=- GESTURE -=-", false, "GESTURE", menu_width, menu_height, c[0]-menu_width/2, c[1]-menu_height/2, true);
  	$dlgMenu.set_file File.dirname(__FILE__) + "/GESTURE/Control/menu.html"
	
	
	$dlgMenu.min_height = 500
  	$dlgMenu.min_width = 600
	$dlgMenu.max_height = 500
  	$dlgMenu.max_width = 600
  	 	
   	#Show Dialog
	$dlgMenu.show

	
	$dlgMenu.add_action_callback("GESTURE_QUIT") {|dialog, params|
	     UI.messagebox("You quit GESTURE " + params.to_s)
	     $dlgMenu.close
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

	repere_width = 150
  	repere_height = 200
  	
  	control_width = 300
  	control_height = 300

	toolbar_width = 300
  	toolbar_height = 60

	c = Sketchup.active_model.active_view.center
	
	dlgRepere = UI::WebDialog.new("-=- GESTURE -=-", true, "GESTURE", repere_width, repere_height, 0, 2*c[1]-repere_height/2, true);
  	dlgRepere.set_file File.dirname(__FILE__) + "/GESTURE/Control/repere.html"
		
	dlgRepere.show

	dlgControl = UI::WebDialog.new("-=- GESTURE -=-", true, "GESTURE", control_width, control_height, 2*c[0], 2*c[1], true);
  	dlgControl.set_file File.dirname(__FILE__) + "/GESTURE/Control/control.html"
		
	dlgControl.show	
	
	dlgToolbar = UI::WebDialog.new("-=- GESTURE -=-", true, "GESTURE", toolbar_width, toolbar_height, 2*c[0], 0, true);
  	dlgToolbar.set_file File.dirname(__FILE__) + "/GESTURE/Control/toolbar.html"
		
	dlgToolbar.show


end


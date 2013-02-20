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
#
#



# First we pull in the standard API hooks.
require 'sketchup.rb'


# Show the Ruby Console at startup so we can
# see any programming errors we may make.
Sketchup.send_action "showRubyPanel:"

# Add a menu item to launch GESTURE plugin.
UI.menu("Plugins").add_item("GESTURE...") {
  
  #call function
  splashscreen
  
}


#Splash Screen
def splashscreen

	splashscreen_width = 640
  	splashscreen_height = 400
  	
  	c = Sketchup.active_model.active_view.center
  	dlgSplashScreen = UI::WebDialog.new("-=- GESTURE -=-", true, "GESTURE", splashscreen_width, splashscreen_height, c[0]-splashscreen_width/2, c[1]-splashscreen_height/2, true);
  	dlgSplashScreen.set_file File.dirname(__FILE__) + "/GESTURE/splashscreen.html"
	
	dlgSplashScreen.show
	
	#load videoplayer
	
	#test all component
	
	#save result
	
	#progress bar
	
 	#transfert result
# 	pause 20
# 	dlgSplashScreen.close
 	
 	menu
 	
end


#menu
def menu

	menu_width = 600
  	menu_height = 400

	c = Sketchup.active_model.active_view.center
  	dlgMenu = UI::WebDialog.new("-=- GESTURE -=-", true, "GESTURE", menu_width, menu_height, c[0]-menu_width/2, c[1]-menu_height/2, true);
  	dlgMenu.set_file File.dirname(__FILE__) + "/GESTURE/menu.html"
	
	dlgMenu.show
	
	dlgMenu.add_action_callback("GESTURE_QUIT") {|dialog, params|
	     UI.messagebox("You quit GESTURE " + params.to_s)
	     dlgMenu.close
   	}
   	
   	dlgMenu.add_action_callback("GESTURE_START") {|dialog, params|
	     dlgMenu.close
	     controlgesture
	     ##...
   	}
   	
   	dlgMenu.add_action_callback("GESTURE_apprentissage") {|dialog, params|
	     dlgMenu.close
	     #..
   	}

end

#Control 
def controlgesture

	repere_width = 150
  	repere_height = 200
  	
  	control_width = 300
  	control_height = 300

	toolbar_width = 300
  	toolbar_height = 60

	c = Sketchup.active_model.active_view.center
	
	dlgRepere = UI::WebDialog.new("-=- GESTURE -=-", true, "GESTURE", repere_width, repere_height, 0, 2*c[1]-repere_height/2, true);
  	dlgRepere.set_file File.dirname(__FILE__) + "/GESTURE/repere.html"
		
	dlgRepere.show

	dlgControl = UI::WebDialog.new("-=- GESTURE -=-", true, "GESTURE", control_width, control_height, 2*c[0], 2*c[1], true);
  	dlgControl.set_file File.dirname(__FILE__) + "/GESTURE/control.html"
		
	dlgControl.show	
	
	dlgToolbar = UI::WebDialog.new("-=- GESTURE -=-", true, "GESTURE", toolbar_width, toolbar_height, 2*c[0], 0, true);
  	dlgToolbar.set_file File.dirname(__FILE__) + "/GESTURE/toolbar.html"
		
	dlgToolbar.show


end


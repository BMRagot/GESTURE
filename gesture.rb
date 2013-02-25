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
            UI.messagebox("OBJExporter:\n\nEnregistrez le fichier SKP avant de l'exporter en OBJ\n")
            return nil
        else
			#call Splash Screen function to load resources
			splashscreen
		end#if
 
}





#############################################################
#						TODO								#
#############################################################

#		#Demande d'enrgistrement avant de lancer le plugins?
#		#DEscription fichier 
#		#entete fichier html
#		#recherche pour ejecter la webdialog
#DONE	#creer fonction de log
#		#code error
#		#test du teuber
#DONE	# nom de fichier complet lors du statut
#		#si statu NOK prevoir griser btouton d'action
#		#rajouter les tips sur les status?
#		#IMPORTANT differencier le code selon macOS ou microshiotte windaube
#DONE	#ranger file 
#		#splashscreen image alternative
#		#regler taille fenetre

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
	#splashscreen stucks on the top
	$dlgSplashScreen.show_modal
	
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
	
	# Create TCPServer
	
	# Load C++ module
	
	#test all component
	
	#save result
	#log file??
	
	
 	#transfert result
 	
 	
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

	c = Sketchup.active_model.active_view.center
  	$dlgMenu = UI::WebDialog.new("-=- GESTURE -=-", false, "GESTURE", menu_width, menu_height, c[0]-menu_width/2, c[1]-menu_height/2, true);
  	$dlgMenu.set_file File.dirname(__FILE__) + "/GESTURE/Control/menu.html"
	
	
	$dlgMenu.min_height = 525
  	$dlgMenu.min_width = 617
	$dlgMenu.max_height = 525
  	$dlgMenu.max_width = 617
  	 	
   	#Show Dialog on modal mode
	#$dlgMenu.show_modal marche pas sinn ca bloque le javascript
	$dlgMenu.show
	
	$dlgMenu.add_action_callback("GESTURE_QUIT") {|dialog, params|
	    result = UI.messagebox("You quit GESTURE "), MB_OKCANCEL
		#BUG API sketchup non imlemente windaube
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
   		
   		
   		add_status("version", $SUversion.to_f.to_s)
   		add_status("nomenv", $titlemodel.to_s + ".skp")
   		add_status("nbrobj", $number_obj.to_s)
		
		
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




#############################################################
#						LOG Function						#
#############################################################
def log(opt,data)
  $log_path="C:/Program Files (x86)/Google/Google SketchUp 8/Plugins/GESTURE/log"
  if opt==1
	#create new lo file
	$log_name = "logesture_" + Time.now.day.to_s + Time.now.month.to_s + Time.now.year.to_s + Time.now.to_i.to_s + ".txt"
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
  elsif opt==3
	#close log file
	
  end
end 


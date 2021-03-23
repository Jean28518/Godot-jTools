extends Control

func open_window():
	var node = get_tree().get_current_scene()
	var instance = self.duplicate()
	node.add_child(instance)
	instance.owner = node
	instance.updateSettingsWindow()
	instance.show()
	
func closeAndSaveSettings():
	saveSettings()
	applySettings()
	_on_Back_pressed()
	
func closeAndDiscardSettings():
	queue_free()
	

func _on_Back_pressed():
	queue_free()

func _on_Apply_pressed():
	saveSettings()
	applySettings()
	

################################################################################

func _ready():
	if get_parent().name == "root":
		hide()
	
	if getFullscreen() == null:
		setFullscreen(true)
		
	if getShadows() == null:
		setShadows(true)
		
	if getAntiAliasing() == null:
		setAntiAliasing(2)
	
	if getMainVolume() == null:
		setMainVolume(0)
	
	if getMusicVolume() == null:
		setMusicVolume(0)
	
	if getGameVolume() == null:
		setGameVolume(0)
	
	applySettings()
	


func applySettings():
	OS.window_fullscreen = jSaveManager.get_setting("fullscreen")
	ProjectSettings.set_setting("rendering/quality/filters/msaa", getAntiAliasing())
	
	## This can only be used, if JAudioManager is in project.
	if jAudioManager.jAudioManagerBus: 
		jAudioManager.set_main_volume_db(getMainVolume())
		jAudioManager.set_game_volume_db(getGameVolume())
		jAudioManager.set_music_volume_db(getMusicVolume())
	

func saveSettings():
	setFullscreen($ScrollContainer/GridContainer/Fullscreen.pressed)
	setShadows($ScrollContainer/GridContainer/Shadows.pressed)
	setAntiAliasing($ScrollContainer/GridContainer/AntiAliasing.selected)
	setMainVolume($ScrollContainer/GridContainer/MainVolume.value)
	setMusicVolume($ScrollContainer/GridContainer/MusicVolume.value)
	setGameVolume($ScrollContainer/GridContainer/GameVolume.value)
	
	
func updateSettingsWindow():
	$ScrollContainer/GridContainer/Fullscreen.pressed = getFullscreen()
	$ScrollContainer/GridContainer/Shadows.pressed = getShadows()
	$ScrollContainer/GridContainer/AntiAliasing.selected = getAntiAliasing()
	$ScrollContainer/GridContainer/MainVolume.value = getMainVolume()
	$ScrollContainer/GridContainer/MusicVolume.value = getMusicVolume()
	$ScrollContainer/GridContainer/GameVolume.value = getGameVolume()
	
	if not jAudioManager.jAudioManagerBus:
		$ScrollContainer/GridContainer/Label4.hide()
		$ScrollContainer/GridContainer/GameVolume.hide()
		$ScrollContainer/GridContainer/Label5.hide()
		$ScrollContainer/GridContainer/MusicVolume.hide()


################################################################################

func getFullscreen():
	return jSaveManager.get_setting("fullscreen")

func setFullscreen(val : bool):
	jSaveManager.save_setting("fullscreen", val)


func setShadows(val : bool):
	jSaveManager.save_setting("shadows", val)

func getShadows():
	return jSaveManager.get_setting("shadows")


func setAntiAliasing(val : int):
	jSaveManager.save_setting("antiAliasing", val)

func getAntiAliasing():
	return jSaveManager.get_setting("antiAliasing")


func setMainVolume(val : float):
	jSaveManager.save_setting("mainVolume", val)

func getMainVolume():
	return jSaveManager.get_setting("mainVolume")


func setMusicVolume(val : float):
	jSaveManager.save_setting("musicVolume", val)

func getMusicVolume():
	return jSaveManager.get_setting("musicVolume")
	
	
func setGameVolume(val : bool):
	jSaveManager.save_setting("gameVolume", val)

func getGameVolume():
	return jSaveManager.get_setting("gameVolume")

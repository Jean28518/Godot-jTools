extends Node

## Here you can configure the filename
var fileName = "jSaveManager.save"

onready var save_path = "res://"+ fileName
onready var config = ConfigFile.new()
onready var load_response = config.load(save_path)

func save_value(key : String, value):
	config.set_value("Main", key, value)
	config.save(save_path)

func get_value(key):
	return config.get_value("Main", key, null)
	
func save_setting(key, value):
	config.set_value("Settings", key, value)
	config.save(save_path)
	
func get_setting(key):
	return config.get_value("Settings", key, null)

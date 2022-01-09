class_name jSaveModule
extends Reference

# Example: "res://Levels/Level1/Level1.save"
export (String) var save_path = ""


func set_save_path(save_path : String):
	print("Save Path set.")
	self.save_path = save_path
	reload()


func save_value(key : String, value):
	_value_changed = true
	_cache_main[key] = value


func get_value(key,  default_value = null):

	if _cache_main.has(key):

		return _cache_main[key]
	if _config == null:
		print_debug("Save path not configured correctly. Returning default_value.")
		return default_value
	if _config.has_section_key("Main", key):
		var value =  _config.get_value("Main", key, default_value)
		_cache_main[key] = value
		return value
	return default_value


func reload():
	_invalidate_cache()
	_load_current_config()


func write_to_disk():
	if _config == null:
		Logger.err("Save path not configured correctly. Don't saving anything...", self)
		return
	for key in _cache_main.keys():
		_config.set_value("Main", key, _cache_main[key])
	_config.save(save_path)


func load_everything_into_cache():
	reload()
	for key in _config.get_section_keys("Main"):
		_cache_main[key] = _config.get_value("Main", key, null)


## Internal Code ###############################################################
var _config
var _cache_main = {}
var _value_changed = false


func _invalidate_cache():
	_cache_main = {}


func _ready():
	_load_current_config()


func _load_current_config():
	if save_path == "":
		Logger.err("Save path not configured correctly. Not initializing jSaveModlue ", self)
		return
	_config = ConfigFile.new()

	var dir = Directory.new()
	dir.open(save_path.get_base_dir())

	if not dir.file_exists(save_path):
		dir.make_dir_recursive(save_path.get_base_dir())

	_config.load(save_path)

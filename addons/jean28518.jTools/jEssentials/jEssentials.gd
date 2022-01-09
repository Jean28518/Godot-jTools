extends Node


func call_delayed(delay : float, object : Object, method : String, arg_array : Array = []):
	_delayed_call_table.delay.append(delay)
	_delayed_call_table.object.append(object)
	_delayed_call_table.method.append(method)
	_delayed_call_table.arg_array.append(arg_array)


func remove_all_pending_delayed_calls():
	_delayed_call_table = {"delay" : [], "object" : [], "method" : [], "arg_array" : [] }


func find_files_recursively(directory_path : String, file_extension : String):
	var found_files = {"Array" : []}
	_find_files_recursively_helper(directory_path, found_files, file_extension)
	return found_files["Array"]


func copy_folder_recursively(from : String, to : String):
	var dir = Directory.new()
	dir.make_dir_recursive(to)
	if not dir.dir_exists(from):
		return
	if not from.ends_with("/"):
		from += "/"
	if not to.ends_with("/"):
		to += "/"
	_copy_folder_recursively_helper(from, to)


func create_directory(path : String):
	var dir = Directory.new()
	dir.make_dir_recursive(path)


func copy_file(from : String, to : String):
	var dir = Directory.new()
	dir.copy(from, to)

# Could be also used for moving files
func rename_file(from: String, to : String):
	var dir = Directory.new()
	dir.rename(from, to)

func remove_folder_recursively(path: String):
	var dir = Directory.new()
	if not dir.dir_exists(path):
		return
	if not path.ends_with("/"):
		path += "/"
	if dir.open(path) != OK: return
	dir.list_dir_begin()
	while(true):
		var file = dir.get_next()
		if file == "": break
		if file == ".": continue
		if file == "..": continue
		if dir.current_is_dir():
			remove_folder_recursively(path + file + "/")
		else:
			var dir2 = Directory.new()
			dir2.remove(path + file)
	dir.list_dir_end()
	dir.remove(path)


func remove_duplicates(array : Array) -> Array:
	var return_value = []
	for item in array:
		if not return_value.has(item):
			return_value.append(item)
	return return_value


func show_message(message : String, title : String = ""):
	var message_box = AcceptDialog.new()
	message_box.dialog_text = message
	message_box.window_title = title
	get_tree().current_scene.add_child(message_box)
	message_box.anchor_left = 0.4
	message_box.anchor_right = 0.5
	message_box.anchor_top = 0.5
	message_box.anchor_bottom = 0.5
	message_box.pause_mode = Node.PAUSE_MODE_PROCESS
	_saved_mouse_mode = Input.get_mouse_mode()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	message_box.connect("confirmed", self, "_on_message_box_okay_pressed")
	message_box.show()


func does_path_exist(path : String):
	var dir = Directory.new()
	return dir.dir_exists(path) or dir.file_exists(path)


func get_subfolders_of(directory_path : String):
	var dir = Directory.new()
	if dir.open(directory_path) != OK: return
	dir.list_dir_begin()
	var folder_names = []
	while(true):
		var file = dir.get_next()
		if file == "": break
		if file.begins_with("."): continue
		if dir.current_is_dir():
			folder_names.append(file)
	dir.list_dir_end()
	return folder_names


## Internal Code ###############################################################

var _delayed_call_table := {"delay" : [], "object" : [], "method" : [], "arg_array" : [] }
var _saved_mouse_mode


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS


func _process(delta):
	if get_tree().paused:
		return
	_handle_delayed_calls(delta)


func _handle_delayed_calls(delta):
	var i = 0
	while(i < _delayed_call_table.delay.size()): ## We need here a while loop, because want to keep track of the (changing) table size.
		_delayed_call_table.delay[i] -= delta
		if _delayed_call_table.delay[i] <= 0:
			var object = _delayed_call_table.object[i]
			if is_instance_valid(object):
				object.callv(_delayed_call_table.method[i], _delayed_call_table.arg_array[i])
			_delayed_call_table.delay.remove(i)
			_delayed_call_table.object.remove(i)
			_delayed_call_table.method.remove(i)
			_delayed_call_table.arg_array.remove(i)
			i -= 1 ## Because we remove here an entry
		i += 1


func _find_files_recursively_helper(directory_path,found_files,file_extension):
	var dir = Directory.new()
	if dir.open(directory_path) != OK: return
	dir.list_dir_begin()
	while(true):
		var file = dir.get_next()
		if file == "": break
		if file.begins_with("."): continue
		if dir.current_is_dir():
			if directory_path.ends_with("/"):
				_find_files_recursively_helper(directory_path+file, found_files, file_extension)
			else:
				_find_files_recursively_helper(directory_path+"/"+file, found_files, file_extension)
		else:
			if file.get_extension() == file_extension:
				var exportString
				if directory_path.ends_with("/"):
					exportString = directory_path +file
				else:
					exportString = directory_path +"/"+file
				found_files["Array"].append(exportString)
	dir.list_dir_end()


func _copy_folder_recursively_helper(from, to):
	var dir = Directory.new()
	dir.make_dir_recursive(to)
	if dir.open(from) != OK: return
	dir.list_dir_begin()
	while(true):
		var file = dir.get_next()
		if file == "": break
		if file == ".": continue
		if file == "..": continue
		if dir.current_is_dir():
			print(from + file + "/" + "     " + to + file + "/")
			_copy_folder_recursively_helper(from + file + "/", to + file + "/")
		else:
			var dir2 = Directory.new()
			print(from + file + "     " + to + file)
			dir2.copy(from + file, to + file)
	dir.list_dir_end()


func _on_message_box_okay_pressed():
	Input.set_mouse_mode(_saved_mouse_mode)

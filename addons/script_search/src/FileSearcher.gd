@tool

const BLACKLIST := ["res://.godot", "res://addons"] 

static func get_files(path: String, files := []) -> Array:
	var dir := DirAccess.open(path)
	if not dir: return files

	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	
	while file_name != "":
		var full_name = _join_paths(path, file_name)
		
		if dir.current_is_dir():
			if not BLACKLIST.has(full_name):
				files.append_array(get_files(full_name))
		else:
			files.append(full_name)
		
		file_name = dir.get_next()
	
	return files

static func _join_paths(path_1, path_2) -> String:
	if path_1 == "res://": return path_1 + path_2
	return path_1 + "/" + path_2

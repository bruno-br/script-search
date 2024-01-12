class_name FileSearcher

const BLACKLIST := ["res://.godot", "res://addons"] 

static func get_files(path: String, files := [], searched_dirs := {}) -> Array:
	var dir := DirAccess.open(path)
	if not dir: return files

	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		var full_name = _join_paths(path, file_name)
		
		if dir.current_is_dir():
			if _should_search_dir(full_name, searched_dirs):
				searched_dirs[full_name] = get_files(full_name)
		else:
			files.append(full_name)
		
		file_name = dir.get_next()
	
	for directory in searched_dirs.keys():
		files.append_array(searched_dirs[directory])
	
	return files

static func _join_paths(path_1, path_2) -> String:
	if path_1 == "res://": return path_1 + path_2
	return path_1 + "/" + path_2

static func _should_search_dir(dir: String, searched_dirs: Dictionary) -> bool:
	return (not searched_dirs.has(dir) && not BLACKLIST.has(dir))

@tool

const BLACKLIST := ["res://.godot", "res://addons"]
const ALLOWED_EXTENSIONS := ["gd", "gdshader"]

static func get_files(path: String, files := []) -> Array:
	var dir := DirAccess.open(path)
	if not dir: return files

	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	
	while file_name != "":
		var full_name = _join_paths(path, file_name)
		var valid_files = _find_valid_files(dir, full_name)
		files.append_array(valid_files)
		
		file_name = dir.get_next()
	
	return files

static func _join_paths(path_1, path_2) -> String:
	if path_1 == "res://": return path_1 + path_2
	return path_1 + "/" + path_2

static func _find_valid_files(dir: DirAccess, full_name: String) -> Array:
	if dir.current_is_dir():
		return get_files(full_name) if _is_dir_valid(full_name) else []
	return [full_name] if _is_file_valid(full_name) else []

static func _is_dir_valid(dir_name: String) -> bool:
	return not BLACKLIST.has(dir_name)

static func _is_file_valid(file_name: String) -> bool:
	return ALLOWED_EXTENSIONS.has(file_name.get_extension())

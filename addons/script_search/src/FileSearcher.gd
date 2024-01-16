@tool

const CONFIG_FILE_PATH = "res://addons/script_search/config.json"

const DEFAULT_ALLOWED_EXTENSIONS := ["gd", "gdshader"]
const DEFAULT_DIR_BLACKLIST := ["res://.godot", "res://addons"]

var _allowed_extensions := DEFAULT_ALLOWED_EXTENSIONS
var _dir_blacklist := DEFAULT_DIR_BLACKLIST

func _init():
	if not FileAccess.file_exists(CONFIG_FILE_PATH): return
	
	var file = FileAccess.open(CONFIG_FILE_PATH, FileAccess.READ)
	var json_content = JSON.new().parse_string(file.get_as_text())
	
	if json_content != null:
		update_allowed_extensions(json_content.get("allowed_extensions"))
		update_dir_blacklist(json_content.get("dir_blacklist"))

func get_files(path: String, files := []) -> Array:
	var dir := DirAccess.open(path)
	if not dir: return files
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		var full_name = path.path_join(file_name)
		var valid_files = _find_valid_files(dir, full_name)
		insert_ordered(files, valid_files)
		file_name = dir.get_next()
	
	return files

func _find_valid_files(dir: DirAccess, full_name: String) -> Array:
	if dir.current_is_dir():
		return get_files(full_name) if _is_dir_valid(full_name) else []
	return [full_name] if _is_file_valid(full_name) else []

func update_allowed_extensions(allowed_extensions):
	self._allowed_extensions = _normalize_string_array(
		allowed_extensions, 
		self._allowed_extensions
	)

func update_dir_blacklist(dir_blacklist):
	self._dir_blacklist = _normalize_string_array(
		dir_blacklist, 
		self._dir_blacklist
	)

func _normalize_string_array(array, default):
	if not array is Array: return default
	return array.filter(func(element): return element is String)

func _is_dir_valid(dir_name: String) -> bool:
	return not self._dir_blacklist.has(dir_name)

func _is_file_valid(file_name: String) -> bool:
	return self._allowed_extensions.has(file_name.get_extension())

func insert_ordered(array: Array, new_elements: Array):
	for element in new_elements:
		var insert_pos := array.bsearch(element)
		array.insert(insert_pos, element)

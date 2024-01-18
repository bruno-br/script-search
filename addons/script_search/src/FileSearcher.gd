@tool

var _allowed_extensions := []
var _directory_blacklist := []

func _init(params = {}):
	update_params(params)

func update_params(params: Dictionary):
	self._allowed_extensions = params.get("allowed_extensions", [])
	self._directory_blacklist = params.get("directory_blacklist", [])

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


func _is_dir_valid(dir_name: String) -> bool:
	return not self._directory_blacklist.has(dir_name)

func _is_file_valid(file_name: String) -> bool:
	return self._allowed_extensions.has(file_name.get_extension())

func insert_ordered(array: Array, new_elements: Array):
	for element in new_elements:
		var insert_pos := array.bsearch(element)
		array.insert(insert_pos, element)

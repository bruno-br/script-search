const CONFIG_FILE_PATH = "res://addons/script_search/config.json"
const DEFAULT_ALLOWED_EXTENSIONS := ["gd", "gdshader"]
const DEFAULT_DIRECTORY_BLACKLIST := ["res://.godot", "res://addons"]

static func load_config_file() -> Resource:
	return load(CONFIG_FILE_PATH)

static func load_and_normalize_config() -> Dictionary:
	var file_content = read_config_file()
	
	var normalized_content = {
		"allowed_extensions": _get_allowed_extensions(file_content), 
		"directory_blacklist": _get_directory_blacklist(file_content)
	}
	
	save_config_file(normalized_content)
	
	return normalized_content

static func read_config_file() -> Dictionary:
	if not FileAccess.file_exists(CONFIG_FILE_PATH): return {}
	
	var file = FileAccess.open(CONFIG_FILE_PATH, FileAccess.READ)
	var json_content = _parse_json(file)
	
	file.close()
	
	return json_content if json_content != null else {}

static func _parse_json(file):
	if file == null: return null
	return JSON.new().parse_string(file.get_as_text())

static func save_config_file(data: Dictionary) -> void:
	var json_string = JSON.stringify(data, "\t")
	var file = FileAccess.open(CONFIG_FILE_PATH, FileAccess.WRITE)
	
	if file != null:
		file.store_string(json_string)
		file.close()

static func _get_allowed_extensions(json_content):
	var value = json_content.get("allowed_extensions")
	return _normalize_string_array(value, DEFAULT_ALLOWED_EXTENSIONS)

static func _get_directory_blacklist(json_content):
	var value = json_content.get("directory_blacklist")
	return _normalize_string_array(value, DEFAULT_DIRECTORY_BLACKLIST)

static func _normalize_string_array(array, default):
	if not array is Array: return default
	return array.filter(func(element): return element is String)

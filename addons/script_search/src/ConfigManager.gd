const CONFIG_FILE_PATH = "res://addons/script_search/.config.json"
const DEFAULT_ALLOWED_EXTENSIONS := ["gd", "gdshader"]
const DEFAULT_DIRECTORY_BLACKLIST := ["res://.godot", "res://addons"]
const DEFAULT_CASE_SENSITIVE := false

static func load_config_file() -> Resource:
	return load(CONFIG_FILE_PATH)

static func load_and_normalize_config() -> Dictionary:
	var file_content = read_config_file()
	var normalized_content = normalize_content(file_content)
	
	save_config_file(normalized_content)
	
	return normalized_content

static func read_config_file() -> Dictionary:
	if not FileAccess.file_exists(CONFIG_FILE_PATH): return {}
	
	var file = FileAccess.open(CONFIG_FILE_PATH, FileAccess.READ)
	var json_content = _parse_json(file)
	
	file.close()
	
	return json_content if json_content != null else {}

static func normalize_content(content: Dictionary) -> Dictionary:
	return {
		"allowed_extensions": _get_allowed_extensions(content), 
		"directory_blacklist": _get_directory_blacklist(content),
		"case_sensitive": _get_case_sensitive(content)
	}

static func save_config_file_normalized(data: Dictionary) -> void:
	return save_config_file(normalize_content(data))

static func save_config_file(normalized_data: Dictionary) -> void:
	var json_string = JSON.stringify(normalized_data)
	var file = FileAccess.open(CONFIG_FILE_PATH, FileAccess.WRITE)
	
	if file != null:
		file.store_string(json_string)
		file.close()

static func _parse_json(file):
	if file == null: return null
	return JSON.new().parse_string(file.get_as_text())

static func _get_allowed_extensions(json_content):
	var value = json_content.get("allowed_extensions")
	return _normalize_string_array(value, DEFAULT_ALLOWED_EXTENSIONS)

static func _get_directory_blacklist(json_content):
	var value = json_content.get("directory_blacklist")
	return _normalize_string_array(value, DEFAULT_DIRECTORY_BLACKLIST)

static func _get_case_sensitive(json_content):
	var value = json_content.get("case_sensitive")
	return value if typeof(value) == TYPE_BOOL else false

static func _normalize_string_array(array, default):
	if not array is Array: return default
	
	var normalized_array = []
	var previous_elements = {}
	
	for element in array:
		if _is_valid_string_element(element, previous_elements):
			normalized_array.append(element)
			previous_elements[element] = true
	return normalized_array

static func _is_valid_string_element(element, previous_elements):
	return (
		element is String 
		&& not element.is_empty() 
		&& not previous_elements.has(element)
	)

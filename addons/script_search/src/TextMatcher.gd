const CHAR_TERM_SEPARATOR = ","
const CHAR_BASENAME_ONLY = ":"

static func matches(file_name: String, text: String, is_case_sensitive: bool) -> bool:
	if not is_case_sensitive:
		text = text.to_lower()
		file_name = file_name.to_lower()
	
	for search_term in text.split(CHAR_TERM_SEPARATOR, false):
		search_term = _trim_spaces(search_term)
		if search_term.is_empty(): continue
		if not _file_name_contains_term(file_name, search_term): return false
	
	return true

static func _trim_spaces(text: String) -> String:
	return text.lstrip(" ").rstrip(" ")

static func _file_name_contains_term(file_name: String, term: String) -> bool:
	if term.begins_with(CHAR_BASENAME_ONLY):
		return _compare_file_name_without_path(file_name, term)
	return file_name.contains(term)

static func _compare_file_name_without_path(file_name: String, term: String):
	var base_name = file_name.get_file()
	return base_name.contains(term.trim_prefix(CHAR_BASENAME_ONLY))

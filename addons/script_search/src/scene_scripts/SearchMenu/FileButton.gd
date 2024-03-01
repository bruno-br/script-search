@tool

extends MarginContainer

signal script_selected
signal button_hovered

var _file_name = ""

func _ready():
	hide()

func remove():
	hide()
	queue_free()

func set_file_name(full_name: String):
	self._file_name = full_name
	var simple_name = full_name.get_file()
	
	$Button/FileNameLabel.set_text(simple_name)
	$Button/FilePathLabel.set_text(full_name.trim_prefix("res://"))

func select():
	emit_signal("script_selected", get_file_name())

func get_button():
	return $Button
	
func get_file_name():
	return self._file_name

func set_highlight(is_active: bool):
	var button = get_button()
	
	button.remove_theme_stylebox_override("normal")
	button.remove_theme_stylebox_override("hover")
	
	if is_active:
		_update_button_style(button, "normal", "hover")
	else:
		_update_button_style(button, "hover", "normal")

func _update_button_style(button: Button, style_to_override, style_to_copy):
	var copied_style = button.get_theme_stylebox(style_to_copy).duplicate()
	button.add_theme_stylebox_override(style_to_override, copied_style)

func _on_button_pressed():
	emit_signal("script_selected", get_file_name())

func _on_mouse_entered():
	emit_signal("button_hovered", self)

func _on_search_text_updated(new_text: String, is_case_sensitive: bool):
	if not new_text.is_empty() && _file_name_matches_text(new_text, is_case_sensitive):
		show()
	else:
		hide()

func _file_name_matches_text(text: String, is_case_sensitive: bool) -> bool:
	var file_name = self._file_name
	
	if not is_case_sensitive:
		text = text.to_lower()
		file_name = file_name.to_lower()
	
	for search_term in text.split(" "):
		if search_term.is_empty(): continue
		if not _file_name_contains_term(file_name, search_term): return false
	
	return true

func _file_name_contains_term(file_name: String, term: String) -> bool:
	if term.begins_with(":"):
		return _compare_file_name_without_path(file_name, term)
	return self._file_name.contains(term)

func _compare_file_name_without_path(file_name: String, term: String):
	file_name = file_name.get_file()
	term = term.trim_prefix(":")
	
	return file_name.contains(term)

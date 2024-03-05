@tool

extends MarginContainer

signal script_selected
signal button_hovered

const TextMatcher := preload("res://addons/script_search/src/TextMatcher.gd")

var _file_name = ""

func _ready():
	hide()

func remove():
	hide()
	queue_free()

func set_file_name(full_name: String):
	self._file_name = full_name
	var base_name = full_name.get_file()
	
	var file_name_label = get_file_name_label()
	if file_name_label != null: file_name_label.set_text(base_name)
	
	var file_path_label = get_file_path_label()
	if file_path_label != null: file_path_label.set_text(full_name.trim_prefix("res://"))

func select():
	emit_signal("script_selected", get_file_name())

func get_button():
	return $Button
	
func get_file_name():
	return self._file_name

func get_file_name_label():
	return get_node_or_null("Button/FileNameLabel")

func get_file_path_label():
	return get_node_or_null("Button/FilePathLabel")

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
	return TextMatcher.matches(self._file_name, text, is_case_sensitive)

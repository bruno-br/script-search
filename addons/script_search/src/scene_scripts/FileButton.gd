@tool

extends MarginContainer

signal script_selected
signal button_hovered

var _file_name = ""

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

func _on_search_text_updated(new_text: String):
	if new_text.is_empty() || self._file_name.contains(new_text):
		show()
	else:
		hide()

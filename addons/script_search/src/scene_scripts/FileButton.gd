@tool

extends MarginContainer

signal script_selected

var _file_name = ""

func set_file_name(full_name: String):
	self._file_name = full_name
	var simple_name = full_name.get_file()
	
	$Button/FileNameLabel.set_text(simple_name)
	$Button/FilePathLabel.set_text(full_name.trim_prefix("res://"))

func get_button():
	return $Button
	
func get_file_name():
	return self._file_name

func _on_button_pressed():
	emit_signal("script_selected", get_file_name())

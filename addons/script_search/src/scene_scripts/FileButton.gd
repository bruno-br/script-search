@tool

extends MarginContainer

class_name FileButton

var _file_name = ""

func set_file_name(full_name: String):
	self._file_name = full_name
	var simple_name = full_name.get_file()
	
	$Button/FileNameLabel.set_text(simple_name)
	$Button/FilePathLabel.set_text(full_name.trim_prefix("res://"))

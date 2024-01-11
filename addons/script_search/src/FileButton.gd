extends MarginContainer

class_name FileButton

var _file_name = ""

func set_file_name(file_name):
	self._file_name = file_name
	$Button.set_text(file_name)

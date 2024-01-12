extends Control

@onready var _file_buttons: FileButtons = $Panel/MarginContainer/VSplitContainer/ScrollContainer/FileButtons

var _matching_files = []

func _ready():
	var files = FileSearcher.get_files("res://")
	update_matching_files(files)

func update_matching_files(matching_files: Array):
	self._matching_files = matching_files
	self._file_buttons.update(matching_files)

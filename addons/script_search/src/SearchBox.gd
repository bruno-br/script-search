extends Control

@onready var _file_buttons: FileButtons = $Panel/MarginContainer/VSplitContainer/ScrollContainer/FileButtons

var _matching_files = []

func _ready():
	update_matching_files(["File 1", "File 2", "File 3"])

func update_matching_files(matching_files: Array):
	self._matching_files = matching_files
	self._file_buttons.update(matching_files)

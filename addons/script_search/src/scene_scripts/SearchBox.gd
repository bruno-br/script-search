@tool

extends Control
var _matching_files = []

func open():
	update_matching_files()
	_get_file_buttons().open(self._matching_files)
	_get_search_input().grab_focus()

func close():
	_get_file_buttons().close()
	self._matching_files = []

func update_matching_files():
	self._matching_files = FileSearcher.get_files("res://")

func _get_file_buttons():
	return $Panel/MarginContainer/VSplitContainer/ScrollContainer/FileButtons

func _get_search_input():
	return $Panel/MarginContainer/VSplitContainer/SearchInput

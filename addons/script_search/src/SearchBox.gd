@tool

extends Control

var _matching_files = []

func open():
	update_matching_files()
	$Panel/MarginContainer/VSplitContainer/ScrollContainer/FileButtons.open(self._matching_files)
	$Panel/MarginContainer/VSplitContainer/SearchInput.grab_focus()

func close():
	$Panel/MarginContainer/VSplitContainer/ScrollContainer/FileButtons.close()
	self._matching_files = []

func update_matching_files():
	self._matching_files = FileSearcher.get_files("res://")

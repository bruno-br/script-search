@tool

extends Control

const FileSearcher := preload("res://addons/script_search/src/FileSearcher.gd")

var _matching_files = []

func open():
	update_matching_files()
	get_file_buttons().open(self._matching_files)
	get_search_input().open()

func close():
	get_file_buttons().close()
	get_search_input().close()
	self._matching_files = []

func update_matching_files():
	self._matching_files = FileSearcher.get_files("res://")

func get_file_buttons():
	return $Panel/MarginContainer/VSplitContainer/ScrollContainer/FileButtons

func get_search_input():
	return $Panel/MarginContainer/VSplitContainer/SearchInput

@tool

extends Control

const FileSearcher := preload("res://addons/script_search/src/FileSearcher.gd")

var _file_searcher = null
var _matching_files = []
var _buttons_update_pending := false
var _is_updating_matching_files := false

func _ready():
	self._file_searcher = FileSearcher.new()
	update_matching_files()
	get_file_buttons().update_buttons(self._matching_files)

func open():
	show()
	get_search_input().open()
	get_file_buttons().open()

func close():
	hide()
	get_search_input().close()
	if self._buttons_update_pending: _update_file_buttons()

func update_matching_files():
	if not self._is_updating_matching_files:
		_do_update_matching_files()

func _do_update_matching_files():
	self._is_updating_matching_files = true
	self._matching_files = self._file_searcher.get_files("res://")
	self._is_updating_matching_files = false
	
	_enqueue_file_buttons_update()

func _enqueue_file_buttons_update():
	if is_visible():
		self._buttons_update_pending = true
	else:
		_update_file_buttons()

func _update_file_buttons():
	self._buttons_update_pending = false
	get_file_buttons().update_buttons(self._matching_files)

func get_file_buttons():
	return $Panel/MarginContainer/VSplitContainer/ScrollContainer/FileButtons

func get_search_input():
	return $Panel/MarginContainer/VSplitContainer/SearchInput

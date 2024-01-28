@tool

extends Control

const FileSearcher := preload("res://addons/script_search/src/FileSearcher.gd")
const ConfigManager := preload("res://addons/script_search/src/ConfigManager.gd")

var _matching_files = []
var _file_searcher = null
var _is_case_sensitive := false
var _buttons_update_pending := false
var _is_updating_matching_files := false

func _ready():
	_reload_config()
	update_matching_files()
	_do_update_file_buttons()

func open():
	show()
	get_search_input().open()
	get_file_buttons().open()

func close():
	hide()
	get_search_input().close()
	get_file_buttons().close()
	if self._buttons_update_pending: _update_file_buttons()

func update_config():
	_reload_config()
	update_matching_files()

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
	_do_update_file_buttons()

func _do_update_file_buttons():
	get_file_buttons().update_buttons(
		self._matching_files, 
		self._is_case_sensitive
	)

func _reload_config():
	var config_params = ConfigManager.load_and_normalize_config()
	self._file_searcher = FileSearcher.new(config_params)
	self._is_case_sensitive = config_params.get("case_sensitive", false)

func get_file_buttons():
	return $Panel/MarginContainer/VSplitContainer/ScrollContainer/FileButtons

func get_config_button():
	return $Panel/MarginContainer/VSplitContainer/HSplitContainer/ConfigButton

func get_search_input():
	return $Panel/MarginContainer/VSplitContainer/HSplitContainer/SearchInput

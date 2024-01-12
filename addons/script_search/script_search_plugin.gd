@tool

extends EditorPlugin

const SearchMenuScene := preload("res://addons/script_search/scenes/SearchMenu.tscn")

const ACTION_NAME = "addon_script_search_open"

var _search_menu

func _enter_tree() -> void:
	_setup_input_action()
	self._search_menu = SearchMenuScene.instantiate()
	self._search_menu.hide()
	get_editor_interface().get_base_control().add_child(self._search_menu)

func _exit_tree() -> void:
	self._search_menu.hide()
	self._search_menu.queue_free()

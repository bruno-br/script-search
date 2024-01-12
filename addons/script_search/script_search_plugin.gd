@tool

extends EditorPlugin

const SearchMenuScene := preload("./scenes/SearchMenu.tscn")
const InputManager := preload("./src/InputManager.gd")

var _search_menu = null
var _input_manager = null
var _modifiers_mask = null

func _enter_tree() -> void:
	self._input_manager = InputManager.new()
	self._search_menu = SearchMenuScene.instantiate()
	self._search_menu.hide()
	get_editor_interface().get_base_control().add_child(self._search_menu)

func _exit_tree() -> void:
	self._search_menu.hide()
	self._search_menu.queue_free()

func _input(event):
	if self._input_manager.matches_action(event):
		self._search_menu.show()

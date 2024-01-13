@tool

extends EditorPlugin

const SearchMenuScene := preload("./scenes/SearchMenu.tscn")
const InputManager := preload("./src/InputManager.gd")

var _search_menu = null
var _input_manager = null

func _enter_tree() -> void:
	self._input_manager = InputManager.new()
	self._search_menu = SearchMenuScene.instantiate()
	self._search_menu.hide()
	get_editor_interface().get_base_control().add_child(self._search_menu)
	_connect_script_selected()

func _connect_script_selected():
	var file_buttons = self._search_menu.get_search_box().get_file_buttons()
	file_buttons.script_selected.connect(_on_script_selected)

func _exit_tree() -> void:
	self._search_menu.hide()
	self._search_menu.queue_free()

func _input(event):
	if self._input_manager.matches_action(event):
		self._search_menu.show()

func _on_script_selected(file_name: String):
	var script = load(file_name)
	
	if script is Script:
		var editor_interface := get_editor_interface()
		editor_interface.set_main_screen_editor("Script")
		editor_interface.select_file(file_name)
		editor_interface.edit_resource(script)

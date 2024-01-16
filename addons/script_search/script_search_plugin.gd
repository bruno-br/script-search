@tool

extends EditorPlugin

const SearchMenuScene := preload("./scenes/SearchMenu.tscn")
const InputManager := preload("./src/InputManager.gd")

const FS_UPDATE_INTERVAL = 200

var _search_menu = null
var _input_manager = null

var _last_resource_saved := 0
var _last_filesystem_change = null
var _last_matching_files_update = null

func _enter_tree() -> void:
	self._input_manager = InputManager.new()
	self._search_menu = SearchMenuScene.instantiate()
	self._search_menu.hide()
	
	_connect_editor_interface()
	_connect_resource_filesystem()
	_connect_file_buttons()
	
	resource_saved.connect(_on_resource_saved)

func _connect_editor_interface():
	var editor_interface := get_editor_interface()
	editor_interface.get_base_control().add_child(self._search_menu)

func _connect_resource_filesystem(editor_interface=get_editor_interface()):
	var resource_filesystem := editor_interface.get_resource_filesystem()
	resource_filesystem.filesystem_changed.connect(_on_filesystem_changed)

func _connect_file_buttons():
	var file_buttons = self._search_menu.get_search_box().get_file_buttons()
	file_buttons.script_selected.connect(_on_script_selected)

func _on_resource_saved(_res):
	self._last_resource_saved = Time.get_ticks_msec()

func _on_filesystem_changed():
	var curr_time = Time.get_ticks_msec()
	if (curr_time - self._last_resource_saved) > FS_UPDATE_INTERVAL:
		self._search_menu.get_search_box().update_matching_files()

func _exit_tree() -> void:
	self._search_menu.hide()
	self._search_menu.queue_free()

func _input(event: InputEvent):
	if self._input_manager.matches_action(event):
		self._search_menu.show()

func _on_script_selected(file_name: String):
	var script = load(file_name)
	
	if script is Script:
		var editor_interface := get_editor_interface()
		editor_interface.set_main_screen_editor("Script")
		editor_interface.select_file(file_name)
		editor_interface.edit_resource(script)
		self._search_menu.hide()

@tool

extends EditorPlugin

const SearchMenuScene := preload("./scenes/SearchMenu.tscn")
const InputManager := preload("./src/InputManager.gd")

const FS_UPDATE_INTERVAL = 200
const CONFIG_FILE_PATH = "res://addons/script_search/config.json"

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
	_connect_config_button()
	
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

func _connect_config_button():
	var file_buttons = self._search_menu.get_search_box().get_config_button()
	file_buttons.pressed.connect(_on_config_selected)

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
	_open_script(file_name, true)

func _on_config_selected():
	_open_script(CONFIG_FILE_PATH)

func _open_script(file_name, show_on_file_system=false):
	if not FileAccess.file_exists(file_name): return
	
	var script = load(file_name)
	
	if script != null:
		var editor_interface := get_editor_interface()
		editor_interface.set_main_screen_editor("Script")
		editor_interface.edit_resource(script)
	
		if show_on_file_system: 
			editor_interface.select_file(file_name)
	
	self._search_menu.hide()

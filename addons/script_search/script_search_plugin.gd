@tool

extends EditorPlugin

const SearchMenuScene := preload("./scenes/SearchMenu.tscn")
const ConfigMenuScene := preload("./scenes/ConfigMenu.tscn")

const ConfigManager := preload("./src/ConfigManager.gd")
const InputManager := preload("./src/InputManager.gd")
const UpdateManager := preload("./src/UpdateManager.gd")

var _search_menu = null
var _config_menu = null

var _input_manager = null
var _config_file = null
var _update_manager = null

func _enter_tree() -> void:
	self._input_manager = InputManager.new()
	var editor_interface := get_editor_interface()
	_setup_search_menu(editor_interface)
	_setup_config_menu(editor_interface)
	_setup_update_manager(editor_interface)
	_setup_buttons()

func _exit_tree() -> void:
	for menu in [self._search_menu, self._config_menu]:
		menu.hide()
		menu.queue_free()

func _input(event: InputEvent):
	if self._input_manager.matches_action(event):
		self._search_menu.show()
		get_viewport().set_input_as_handled()

func _setup_search_menu(editor_interface):
	self._search_menu = SearchMenuScene.instantiate()
	self._search_menu.hide()
	editor_interface.get_base_control().add_child(self._search_menu)

func _setup_config_menu(editor_interface):
	self._config_menu = ConfigMenuScene.instantiate()
	self._config_menu.hide()
	editor_interface.get_base_control().add_child(self._config_menu)

func _setup_buttons():
	var search_box = self._search_menu.get_search_box()
	search_box.get_file_buttons().script_selected.connect(_on_script_selected)
	search_box.get_config_button().pressed.connect(_on_config_selected)

func _setup_update_manager(editor_interface):
	var resource_filesystem = editor_interface.get_resource_filesystem()
	
	self._update_manager = UpdateManager.new(
		self._search_menu.get_search_box(), 
		resource_filesystem.filesystem_changed,
		resource_saved,
		self._config_menu.config_saved
	)

func _on_script_selected(file_name: String):
	_open_script(file_name, true)

func _on_config_selected():
	self._search_menu.hide()
	self._config_menu.show()

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

@tool

extends EditorPlugin

const SearchMenuScene := preload("res://addons/script_search/scenes/SearchMenu.tscn")

const ACTION_NAME = "addon_script_search_open"

var _search_menu = null
var _modifiers_mask = null

func _enter_tree() -> void:
	_setup_input_action()
	self._search_menu = SearchMenuScene.instantiate()
	self._search_menu.hide()
	get_editor_interface().get_base_control().add_child(self._search_menu)

func _exit_tree() -> void:
	self._search_menu.hide()
	self._search_menu.queue_free()

func _input(event):
	if _matches_action(event):
		self._search_menu.show()

func _matches_action(event) -> bool:
	return (
		event is InputEventKey
		&& event.is_action(ACTION_NAME)
		&& event.get_modifiers_mask() == self._modifiers_mask
	)

func _setup_input_action():
	var input_event = _get_input_event()
	
	InputMap.action_erase_events(ACTION_NAME)
	InputMap.action_add_event(ACTION_NAME, input_event)
	
	self._modifiers_mask = input_event.get_modifiers_mask()

func _get_input_event() -> InputEvent:
	var input_action = ProjectSettings.get_setting("input/" + ACTION_NAME)
	
	if input_action is Dictionary:
		for event in input_action.get("events", []):
			if event is InputEvent: return event
	
	return _default_input_event()

func _default_input_event() -> InputEventKey:
	var event = InputEventKey.new()
	event.set_keycode(KEY_P)
	event.set_ctrl_pressed(true)
	return event

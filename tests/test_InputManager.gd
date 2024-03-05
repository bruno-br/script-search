extends "res://tests/test.gd"

const InputManager := preload("res://addons/script_search/src/InputManager.gd")

const ACTION_NAME = "addon_script_search_open"
const SETTING_NAME = "input/" + ACTION_NAME

func before_each():
	_cleanup()

func after_all():
	_cleanup()

func _cleanup():
	if InputMap.has_action(ACTION_NAME):
		InputMap.erase_action(ACTION_NAME)
	
	if ProjectSettings.has_setting(SETTING_NAME):
		ProjectSettings.set_setting(SETTING_NAME, null)

func test_when_action_is_not_present_on_input_map_should_create():
	assert_false(InputMap.has_action(ACTION_NAME))
	assert_false(ProjectSettings.has_setting(SETTING_NAME))
	
	var input_manager = InputManager.new()
	assert_true(InputMap.has_action(ACTION_NAME))
	
	var default_input_event = input_manager.get_default_input_event()
	assert_eq(
		InputMap.action_get_events(ACTION_NAME).map(_get_code), 
		[default_input_event].map(_get_code)
	)
	assert_true(input_manager.matches_action(default_input_event))

func test_when_action_is_present_on_input_map_should_replace_event():
	assert_false(ProjectSettings.has_setting(SETTING_NAME))
	
	var input_event = _create_input_event()
	
	InputMap.add_action(ACTION_NAME)
	InputMap.action_add_event(ACTION_NAME, input_event)
	
	assert_true(InputMap.has_action(ACTION_NAME))
	assert_eq(InputMap.action_get_events(ACTION_NAME), [input_event])
	
	var input_manager = InputManager.new()
	var default_input_event = input_manager.get_default_input_event()
	
	assert_true(InputMap.has_action(ACTION_NAME))
	assert_ne(_get_code(default_input_event), _get_code(input_event))
	assert_eq(
		InputMap.action_get_events(ACTION_NAME).map(_get_code), 
		[default_input_event].map(_get_code)
	)
	
	assert_true(input_manager.matches_action(default_input_event))
	assert_false(input_manager.matches_action(input_event))

func test_when_action_is_present_on_project_settings_should_keep_event():
	var input_event = _create_input_event()
	
	ProjectSettings.set_setting(SETTING_NAME, {"deadzone": 0.5, "events": [input_event]})
	
	assert_true(ProjectSettings.has_setting(SETTING_NAME))
	assert_false(InputMap.has_action(ACTION_NAME))
	
	var input_manager = InputManager.new()
	var default_input_event = input_manager.get_default_input_event()
	
	assert_true(InputMap.has_action(ACTION_NAME))
	assert_ne(_get_code(default_input_event), _get_code(input_event))
	assert_eq(
		InputMap.action_get_events(ACTION_NAME).map(_get_code), 
		[input_event].map(_get_code)
	)
	
	assert_false(input_manager.matches_action(default_input_event))
	assert_true(input_manager.matches_action(input_event))

func _get_code(e): 
	return e.get_key_label_with_modifiers()

func _create_input_event() -> InputEventKey:
	var event = InputEventKey.new()
	event.set_keycode(KEY_0)
	event.set_shift_pressed(true)
	return event

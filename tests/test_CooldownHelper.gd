extends "res://tests/test.gd"

const CooldownHelper := preload("res://addons/script_search/src/CooldownHelper.gd")

var _call_count = 0

func test_call_with_cooldown():
	var cooldown = 0.1
	var cooldown_helper := CooldownHelper.new({"test": cooldown})
	var cooldown_instance = cooldown_helper.get_cooldown_instance("test")
	
#	Timer should not be created yet
	assert_eq(cooldown_instance, {"cooldown": cooldown, "timer": null})
	
	cooldown_helper.call_with_cooldown(self._scene_tree, "test", _increase_call_count)
	
#	Timer should be created now
	assert_eq(cooldown_instance["cooldown"], cooldown)
	assert_ne(cooldown_instance["timer"], null)
	assert_has_type(cooldown_instance["timer"], SceneTreeTimer)
	
#	Ensures call count increases by 1
	assert_eq(self._call_count, 0)
	await cooldown_instance["timer"].timeout
	assert_eq(self._call_count, 1)
	
#	Calling method 10 times during cooldown should increase only by 1
	for times in range(0, 10):
		cooldown_helper.call_with_cooldown(self._scene_tree, "test", _increase_call_count)

	await cooldown_instance["timer"].timeout
	assert_eq(self._call_count, 2)

func _increase_call_count():
	self._call_count += 1

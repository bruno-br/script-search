extends RefCounted

var _cooldown_instances := {}

const DEFAULT_COOLDOWN = 0.1

func _init(cooldown_instances: Dictionary):
	for key in cooldown_instances.keys():
		var cooldown = cooldown_instances[key]
		
		self._cooldown_instances[key] = {
			"cooldown": cooldown if typeof(cooldown) == TYPE_FLOAT else DEFAULT_COOLDOWN, 
			"timer": null
		}

func call_with_cooldown(scene_tree: SceneTree, key: String, callable: Callable):
	if _has_inactive_timer_with(key):
		var cooldown_timer := _create_timer(key, scene_tree)
		
		await cooldown_timer.timeout
		
		callable.call()
		_clear_timer(key)

func _has_inactive_timer_with(key: String):
	return (
		self._cooldown_instances.has(key) 
		&& self._cooldown_instances.get("timer", null) == null
	)

func _create_timer(key: String, scene_tree: SceneTree) -> SceneTreeTimer:
	var cooldown = self._cooldown_instances[key]["cooldown"]
	var timer = scene_tree.create_timer(cooldown)
	
	self._cooldown_instances[key]["timer"] = timer
	
	return timer

func _clear_timer(key: String):
	self._cooldown_instances[key]["timer"] = null

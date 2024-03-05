extends Node

var _errors = []
var _assertions = 0
var _scene_tree = null

func before_all():
	pass

func after_all():
	pass

func before_each():
	pass

func after_each():
	pass

func assert_eq(result, expected, error_msg=null, stack=get_stack()):
	self._assertions += 1
	
	if (typeof(result) != typeof(expected) || result != expected):
		if error_msg == null: error_msg = str(result) + " != " + str(expected)
		var last_stack = stack[1]
		self._errors.append(
			error_msg + " at [color=gray]" + last_stack["source"] + ":" + str(last_stack["line"]) + "[/color]"
		)
		return false
	return true

func assert_ne(result, expected, error_msg=null, stack=get_stack()):
	self._assertions += 1
	
	if (typeof(result) == typeof(expected) && result == expected):
		if error_msg == null: error_msg = str(result) + " == " + str(expected)
		var last_stack = stack[1]
		self._errors.append(
			error_msg + " at [color=gray]" + last_stack["source"] + ":" + str(last_stack["line"]) + "[/color]"
		)
		return false
	return true

func assert_has_type(element, expected_type, error_msg=null, stack=get_stack()):
	if error_msg == null: error_msg = str(element) + " type is not " + str(expected_type)
	
	var type = typeof(element)
	
	if type == TYPE_OBJECT:
		assert_eq(is_instance_of(element, expected_type), true, error_msg, stack)
	else:
		assert_eq(type, expected_type, error_msg, stack)

func assert_true(result, error_msg=null, stack=get_stack()):
	assert_eq(result, true, error_msg, stack)

func assert_false(result, error_msg=null, stack=get_stack()):
	assert_eq(result, false, error_msg, stack)

func run_tests(scene_tree: SceneTree = null):
	self._scene_tree = scene_tree
	
	var result := { "passed": [], "failed": [] }
	
	before_all()
	
	for method in get_method_list():
		if not method.name.begins_with("test_"): continue
		
		self._errors = []
		self._assertions = 0
		
		before_each()
		
		await call(method.name)
		
		after_each()
		
		if self._errors.is_empty():
			var message = "passed with " + str(self._assertions) + " successful assertions."
			result["passed"].append({"messages": [message], "method": method.name})
		else:
			result["failed"].append({"messages": self._errors.duplicate(), "method": method.name})
	
	after_all()
	
	return result

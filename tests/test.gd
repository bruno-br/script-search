extends Node

var _errors = []
var _assertions = 0

func assert_eq(result, expected, error_msg=null):
	self._assertions += 1
	if result != expected:
		if error_msg == null: error_msg = str(result) + " != " + str(expected)
		var last_stack = get_stack()[1]
		self._errors.append(
			error_msg + " at [color=gray]" + last_stack["source"] + ":" + str(last_stack["line"]) + "[/color]"
		)
		return false
	return true

func run_tests():
	var result := { "passed": [], "failed": [] } 
	
	for method in get_method_list():
		if not method.name.begins_with("test_"): continue
		
		self._errors = []
		self._assertions = 0
		
		call(method.name)
		
		if self._errors.is_empty():
			var message = "passed with " + str(self._assertions) + " successful assertions."
			result["passed"].append({"messages": [message], "method": method.name})
		else:
			result["failed"].append({"messages": self._errors.duplicate(), "method": method.name})
	
	return result

@tool

extends PopupPanel

func _on_visibility_changed():
	if is_visible():
		_call_method_on_children("open")
	else:
		_call_method_on_children("close")

func _call_method_on_children(method_name):
	for child in get_children():
		if child.has_method(method_name):
			child.call(method_name)

func get_search_box():
	return $SearchBox

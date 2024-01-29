@tool

extends "./FileButton.gd"

var _prev:
	get = get_prev,
	set = set_prev

var _next:
	get = get_next,
	set = set_next

func _ready():
	show()

func get_prev():
	return _prev

func set_prev(prev):
	_prev = prev

func get_next():
	return _next

func set_next(next):
	_next = next

func _on_search_text_updated(new_text: String, _is_case_sensitive):
	if new_text.is_empty():
		show()
	else:
		hide()

func _on_search_box_hidden():
	remove()

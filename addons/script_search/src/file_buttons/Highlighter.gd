var _file_buttons_container = null

func _init(file_buttons_container):
	self._file_buttons_container = file_buttons_container

func highlight(file_button):
	var highlighted_button = self._file_buttons_container.get_highlighted_button()
	
	if highlighted_button == file_button: return
	if highlighted_button != null: highlighted_button.set_highlight(false)
	
	if file_button != null:
		file_button.set_highlight(true)
		_ensure_is_visible(file_button)
	
	self._file_buttons_container.set_highlighted_button(file_button)

func _ensure_is_visible(file_button):
	self._file_buttons_container.get_parent().ensure_control_visible(file_button)

func highlight_prev():
	var highlighted_button = self._file_buttons_container.get_highlighted_button()
	
	if _can_get_prev_highlight():
		highlight(highlighted_button.get_prev())
	else:
		_move_highlight(highlighted_button, "get_prev_visible")

func highlight_next():
	var highlighted_button = self._file_buttons_container.get_highlighted_button()
	
	if _can_get_next_highlight():
		highlight(highlighted_button.get_next())
	else:
		_move_highlight(highlighted_button, "get_next_visible")

func _can_get_prev_highlight() -> bool:
	return _highlighted_button_has("get_prev")

func _can_get_next_highlight() -> bool:
	return _highlighted_button_has("get_next")

func _highlighted_button_has(method_name) -> bool:
	var highlighted_button = self._file_buttons_container.get_highlighted_button()
	return(highlighted_button != null && highlighted_button.has_method(method_name))

func _move_highlight(highlighted_button, method):
	var file_buttons_collection = self._file_buttons_container.get_collection()
	
	if not file_buttons_collection.has_visible(): return
	highlight(file_buttons_collection.call(method, highlighted_button))

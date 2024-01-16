@tool

extends LineEdit

signal highlight_prev
signal highlight_next
signal selected

const INVISIBLE := Color("00000000")

var _prev_caret_column := 0
var _is_changing_highlight := false

func _unhandled_input(event):
	if _event_is_selected(event):
		emit_signal("selected")

func _gui_input(event):
	_update_caret()
	
	if _event_is_highlight_next_element(event):
		_handle_highlight_change(event, "highlight_next")
	elif _event_is_highlight_prev_element(event):
		_handle_highlight_change(event, "highlight_prev")
	
	grab_focus()

func open():
	grab_focus()

func close():
	update_text("")

func update_text(new_text):
	set_text(new_text)
	emit_signal("text_changed", new_text)

func _update_caret():
	if self._is_changing_highlight:
		_hide_caret()
		set_caret_column(self._prev_caret_column)
	else:
		_show_caret()
		self._prev_caret_column = get_caret_column()

func _hide_caret():
	if not has_theme_color_override("caret_color"):
		add_theme_color_override("caret_color", INVISIBLE)

func _show_caret():
	if has_theme_color_override("caret_color"):
		remove_theme_color_override("caret_color")

func _event_is_selected(event: InputEvent) -> bool:
	return _event_is_key(event, KEY_ENTER)

func _event_is_highlight_next_element(event: InputEvent) -> bool:
	return _event_is_key(event, KEY_DOWN)

func _event_is_highlight_prev_element(event: InputEvent) -> bool:
	return _event_is_key(event, KEY_UP)

func _event_is_key(event: InputEvent, key) -> bool:
	return (event is InputEventKey && event.get_keycode() == key)

func _handle_highlight_change(event, signal_name):
	if event.is_pressed():
		self._is_changing_highlight = true
	else:
		self._is_changing_highlight = false
		emit_signal(signal_name)
	_update_caret()

func _on_focus_exited():
	grab_focus()

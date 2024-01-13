@tool

extends LineEdit

signal highlight_prev
signal highlight_next

const INVISIBLE := Color("00000000")

var _prev_caret_column := 0
var _is_changing_highlight := false

func _gui_input(event):
	_update_caret()
	
	if _event_is_highlight_next_element(event):
		_handle_highlight_change(event, "highlight_next")
	elif _event_is_highlight_prev_element(event):
		_handle_highlight_change(event, "highlight_prev")
	
	grab_focus()

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

func _event_is_highlight_next_element(event: InputEvent) -> bool:
	return (event is InputEventKey && event.get_keycode() == KEY_DOWN)

func _event_is_highlight_prev_element(event: InputEvent) -> bool:
	return (event is InputEventKey && event.get_keycode() == KEY_UP)

func _handle_highlight_change(event, signal_name):
	if event.is_pressed():
		self._is_changing_highlight = true
	else:
		self._is_changing_highlight = false
		emit_signal(signal_name)
	_update_caret()

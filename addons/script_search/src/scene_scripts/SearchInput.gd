@tool

extends LineEdit

signal highlight_prev
signal highlight_next

func _unhandled_key_input(event: InputEvent):
	if _should_highlight_next_element(event):
		emit_signal("highlight_next")
	if _should_highlight_prev_element(event):
		emit_signal("highlight_prev")
	grab_focus()

func _should_highlight_next_element(event: InputEvent) -> bool:
	return (
		event is InputEventKey && event.get_keycode() == KEY_DOWN
	)

func _should_highlight_prev_element(event: InputEvent) -> bool:
	return (
		event is InputEventKey && event.get_keycode() == KEY_UP
	)

extends LineEdit

func _ready():
	grab_focus()

func _unhandled_key_input(event: InputEvent):
	if _should_focus_next_element(event):
		_focus_next_element()

func _should_focus_next_element(event: InputEvent) -> bool:
	return (
		event is InputEventKey
		&& event.get_keycode() == KEY_DOWN
		&& has_focus()
	) 

func _focus_next_element():
	var next_element = find_next_valid_focus()
	next_element.grab_focus()

extends LineEdit

func _ready():
	grab_focus()

func _unhandled_key_input(event: InputEvent):
	if event.is_action("ui_down") && has_focus():
		_focus_next_element()

func _focus_next_element():
	var next_element = find_next_valid_focus()
	next_element.grab_focus()

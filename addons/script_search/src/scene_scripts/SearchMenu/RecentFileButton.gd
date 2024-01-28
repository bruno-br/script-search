@tool

extends "./FileButton.gd"

func _ready():
	show()

func _on_search_text_updated(new_text: String, _is_case_sensitive):
	if new_text.is_empty():
		show()
	else:
		hide()

func _on_search_box_hidden():
	remove()

@tool

extends VBoxContainer

signal script_selected

const FileButtonScene := preload('res://addons/script_search/scenes/FileButton.tscn')

func open(files: Array):
	_add_buttons(files)

func close():
	_clear_buttons()

func _add_buttons(files: Array):
	var prev_button = null
	
	for file in files:
		var file_button = FileButtonScene.instantiate()
		file_button.set_file_name(file)
		file_button.script_selected.connect(_on_script_selected)
		add_child(file_button)
		
		var curr_button = file_button.get_button()
		_set_buttons_focus(prev_button, curr_button)
		prev_button = curr_button

func _set_buttons_focus(prev_button, curr_button):
	if prev_button == null: return
	
	curr_button.focus_neighbor_top = curr_button.get_path_to(prev_button)
	prev_button.focus_neighbor_bottom = prev_button.get_path_to(curr_button)

func _clear_buttons():
	for child in get_children():
		child.hide()
		child.queue_free()

func _on_script_selected(script):
	emit_signal("script_selected", script)

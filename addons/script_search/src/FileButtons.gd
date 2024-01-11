extends VBoxContainer

class_name FileButtons

const FileButtonScene := preload('res://addons/script_search/scenes/FileButton.tscn')

func update(files: Array):
	_clear_buttons()
	_add_buttons(files)

func _clear_buttons():
	for child in get_children():
		child.hide()
		child.queue_free()

func _add_buttons(files: Array):
	for file in files:
		var file_button: FileButton = FileButtonScene.instantiate()
		file_button.set_file_name(file)
		add_child(file_button)

@tool

extends VBoxContainer

signal script_selected
signal search_text_updated

const FileButtonScene := preload('res://addons/script_search/scenes/FileButton.tscn')
const SEARCH_MATCH_TIME := 0.05

var _buttons := []
var _highlighted_button = null

var _search_text: String = ""
var _search_update_timer: SceneTreeTimer = null

func open(files: Array):
	_add_buttons(files)
	if not self._buttons.is_empty(): _highlight_file_button(self._buttons[0])

func close():
	_clear_buttons()

func _add_buttons(files: Array):
	for file in files:
		var file_button = FileButtonScene.instantiate()
		file_button.set_file_name(file)
		file_button.script_selected.connect(_on_script_selected)
		file_button.button_hovered.connect(_on_button_hovered)
		search_text_updated.connect(file_button._on_search_text_updated)
		self._buttons.append(file_button)
		add_child(file_button)

func _clear_buttons():
	for child in get_children():
		child.hide()
		child.queue_free()
	self._buttons = []

func _on_script_selected(script):
	emit_signal("script_selected", script)

func _on_button_hovered(file_button):
	_highlight_file_button(file_button)

func _on_highlight_prev():
	if self._buttons.is_empty(): return
	
	if self._highlighted_button == null:
		_highlight_file_button(self._buttons[0])
		return
	
	var prev = self._buttons[-1]
	
	for button in self._buttons:
		if button == self._highlighted_button:
			_highlight_file_button(prev)
			return
		prev = button

func _on_highlight_next():
	if self._buttons.is_empty(): return
	
	if self._highlighted_button == null:
		_highlight_file_button(self._buttons[0])
		return
	
	for index in range(self._buttons.size()):
		if self._buttons[index] == self._highlighted_button:
			var next = index + 1
			if next < self._buttons.size():
				_highlight_file_button(self._buttons[next])
				return
	
	_highlight_file_button(self._buttons[0])

func _highlight_file_button(file_button):
	if self._highlighted_button == file_button: 
		return
	
	if self._highlighted_button != null:
		self._highlighted_button.set_highlight(false)
	
	file_button.set_highlight(true)
	get_parent().ensure_control_visible(file_button)
	self._highlighted_button = file_button

func _on_selected():
	if self._highlighted_button != null:
		self._highlighted_button.select()

func _on_search_input_text_changed(new_text):
	self._search_text = new_text
	
	if self._search_update_timer == null && not new_text.is_empty():
		self._search_update_timer = get_tree().create_timer(SEARCH_MATCH_TIME)
		
		await self._search_update_timer.timeout
		
		emit_signal("search_text_updated", self._search_text)
		self._search_update_timer = null

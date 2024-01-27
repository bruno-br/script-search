@tool

extends VBoxContainer

signal script_selected
signal search_text_updated

const FileButtonCollection := preload("res://addons/script_search/src/FileButtonCollection.gd")
const FileButtonScene := preload('res://addons/script_search/scenes/SearchMenu/FileButton.tscn')

const SEARCH_MATCH_TIME := 0.05
const BUTTONS_UPDATE_TIME := 0.02

var _file_buttons = FileButtonCollection.new()
var _highlighted_button = null

var _search_text: String = ""
var _search_update_timer: SceneTreeTimer = null
var _visible_buttons_update_timer: SceneTreeTimer = null
var _is_case_sensitive := false

func open():
	_highlight_file_button(self._file_buttons.get_first_visible())

func update_buttons(file_names: Array, is_case_sensitive: bool):
	_clear_buttons()
	for file_name in file_names: _add_button(file_name)
	self._is_case_sensitive = is_case_sensitive

func _add_button(file_name):
	var file_button = FileButtonScene.instantiate()
	file_button.set_file_name(file_name)
	
	file_button.script_selected.connect(_on_script_selected)
	file_button.button_hovered.connect(_on_button_hovered)
	file_button.visibility_changed.connect(_on_button_visibility_changed)
	search_text_updated.connect(file_button._on_search_text_updated)
	
	add_child(file_button)
	self._file_buttons.append(file_button)

func _clear_buttons():
	for child in get_children():
		child.hide()
		child.queue_free()
	self._file_buttons.update([])

func _on_script_selected(script):
	emit_signal("script_selected", script)

func _on_button_hovered(file_button):
	_highlight_file_button(file_button)

func _on_highlight_prev():
	_move_highlight("get_prev_visible")

func _on_highlight_next():
	_move_highlight("get_next_visible")

func _move_highlight(method):
	if not self._file_buttons.has_visible(): return
	
	_highlight_file_button(
		self._file_buttons.call(method, self._highlighted_button)
	)

func _on_selected():
	if self._highlighted_button != null:
		self._highlighted_button.select()

func _on_search_input_text_changed(new_text):
	self._search_text = new_text
	
	if self._search_update_timer == null:
		self._search_update_timer = get_tree().create_timer(SEARCH_MATCH_TIME)
		
		await self._search_update_timer.timeout
		
		emit_signal(
			"search_text_updated", 
			self._search_text, 
			self._is_case_sensitive
		)
		
		self._search_update_timer = null

func _on_button_visibility_changed():
	if self._highlighted_button != null: _highlight_file_button(null)
	_try_update_visible_buttons()

func _try_update_visible_buttons():
	if self._visible_buttons_update_timer != null: return
	
	self._visible_buttons_update_timer = get_tree().create_timer(BUTTONS_UPDATE_TIME)
	
	await self._visible_buttons_update_timer.timeout
	_do_update_visible_buttons()
	
	self._visible_buttons_update_timer = null

func _do_update_visible_buttons():
	self._file_buttons.update_visible_elements()
	_highlight_file_button(self._file_buttons.get_first_visible())

func _highlight_file_button(file_button):
	if self._highlighted_button == file_button: return
	
	if self._highlighted_button != null:
		self._highlighted_button.set_highlight(false)
	
	if file_button != null:
		file_button.set_highlight(true)
		_ensure_is_visible(file_button)
	
	self._highlighted_button = file_button

func _ensure_is_visible(file_button):
	get_parent().ensure_control_visible(file_button)

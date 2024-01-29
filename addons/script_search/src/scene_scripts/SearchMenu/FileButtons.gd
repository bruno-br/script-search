@tool

extends VBoxContainer

signal script_selected
signal search_text_updated

const FileButtonCollection := preload("res://addons/script_search/src/FileButtonCollection.gd")
const Queue := preload("res://addons/script_search/src/Queue.gd")

const FileButtonScene := preload('res://addons/script_search/scenes/SearchMenu/FileButton.tscn')
const RecentFileButtonScene := preload('res://addons/script_search/scenes/SearchMenu/RecentFileButton.tscn')

const SEARCH_MATCH_TIME := 0.05
const BUTTONS_UPDATE_TIME := 0.02

var _file_buttons = FileButtonCollection.new()
var _recent_files = Queue.new()
var _highlighted_button = null

var _search_text: String = ""
var _search_update_timer: SceneTreeTimer = null
var _visible_buttons_update_timer: SceneTreeTimer = null
var _is_case_sensitive := false

func open():
	show()
	_highlight_file_button(self._file_buttons.get_first_visible())
	_update_recent_files()
	_update_recent_file_buttons()

func close():
	hide()

func update_buttons(file_names: Array, is_case_sensitive: bool):
	_clear_buttons()
	for file_name in file_names: _add_file_button(file_name)
	self._is_case_sensitive = is_case_sensitive

func _add_file_button(file_name):
	var file_button = _build_button(file_name, FileButtonScene)
	self._file_buttons.append(file_button)

func _update_recent_files():
	var file_names = self._recent_files.get_elements()
	var valid_file_names = file_names.filter(
		func(file_name): return FileAccess.file_exists(file_name)
	)
	
	if file_names.size() != valid_file_names.size():
		self._recent_files = Queue.new(valid_file_names)

func _update_recent_file_buttons():
	var first = null
	var last = null
	
	for file_name in self._recent_files.get_elements():
		var file_button = _build_recent_file_button(file_name)
		_link_recent_file_buttons(last, file_button)
		
		if first == null: first = file_button
		last = file_button
	
	_highlight_file_button(first)
	_link_recent_file_buttons(last, first)

func _build_recent_file_button(file_name, previous=null):
	var recent_file_button = _build_button(file_name, RecentFileButtonScene)
	hidden.connect(recent_file_button._on_search_box_hidden)
	return recent_file_button

func _link_recent_file_buttons(prev, next):
	if prev == null: return
	prev.set_next(next)
	next.set_prev(prev)

func _build_button(file_name, scene):
	var file_button = scene.instantiate()
	file_button.set_file_name(file_name)
	
	file_button.script_selected.connect(_on_script_selected)
	file_button.button_hovered.connect(_on_button_hovered)
	file_button.visibility_changed.connect(_on_button_visibility_changed)
	search_text_updated.connect(file_button._on_search_text_updated)
	
	add_child(file_button)
	
	return file_button

func _clear_buttons():
	for child in get_children(): child.remove()
	self._file_buttons.update([])

func _on_script_selected(file_name):
	self._recent_files.push(file_name)
	emit_signal("script_selected", file_name)

func _on_button_hovered(file_button):
	_highlight_file_button(file_button)

func _on_highlight_prev():
	if _can_get_prev_highlight():
		_highlight_file_button(self._highlighted_button.get_prev())
	else:
		_move_highlight("get_prev_visible")
	
func _on_highlight_next():
	if _can_get_next_highlight():
		_highlight_file_button(self._highlighted_button.get_next())
	else:
		_move_highlight("get_next_visible")

func _can_get_prev_highlight() -> bool:
	return _highlighted_button_has("get_prev")

func _can_get_next_highlight() -> bool:
	return _highlighted_button_has("get_next")

func _highlighted_button_has(method_name) -> bool:
	return(
		self._highlighted_button != null 
		&& self._highlighted_button.has_method(method_name)
	)

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
	if not _is_highlighted_button_visible():
		_highlight_file_button(null)
	_try_update_visible_buttons()

func _try_update_visible_buttons():
	if self._visible_buttons_update_timer != null: return
	
	self._visible_buttons_update_timer = get_tree().create_timer(BUTTONS_UPDATE_TIME)
	
	await self._visible_buttons_update_timer.timeout
	_do_update_visible_buttons()
	
	self._visible_buttons_update_timer = null

func _do_update_visible_buttons():
	self._file_buttons.update_visible_elements()
	
	if self._file_buttons.has_visible():
		_highlight_file_button(self._file_buttons.get_first_visible())
	elif not _is_highlighted_button_visible():
		_highlight_file_button(null)

func _is_highlighted_button_visible() -> bool:
	return (
		self._highlighted_button != null
		&& self._highlighted_button.is_visible()
	)

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

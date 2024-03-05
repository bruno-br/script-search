var _all := []
var _visible := []

func _init(all=[]):
	update(all)

func append(element):
	if element.is_visible(): self._visible.append(element)
	self._all.append(element)

func get_all():
	return self._all

func has_visible() -> bool:
	return not self._visible.is_empty()

func update(value: Array):
	self._all = value
	update_visible_elements()

func update_visible_elements():
	self._visible = self._all.filter(func(button): return button.is_visible())

func get_first_visible():
	if has_visible(): return self._visible[0]
	return null

func get_next_visible(element):
	if not has_visible(): return null
	if element == null: return get_first_visible()
	
	var pos = _find_element_position(element, self._visible)
	var next = pos + 1 if pos + 1 < self._visible.size() else 0
	
	return self._visible[next]

func get_prev_visible(element):
	if not has_visible(): return null
	if element == null: return get_first_visible()
	
	var pos = _find_element_position(element, self._visible)
	var prev = pos - 1 if pos - 1 >= 0 else self._visible.size() - 1
	
	return self._visible[prev]

func _find_element_position(element, array) -> int:
	return array.bsearch_custom(
		element.get_file_name(), _is_file_button_name_lower
	)
	
func _is_file_button_name_lower(file_button, searched_text) -> bool:
	return (file_button.get_file_name() < searched_text)

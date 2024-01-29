const DEFAULT_MAX_SIZE = 5

var _max_size := DEFAULT_MAX_SIZE
var _elements := []

func _ready(elements=[], max_size=DEFAULT_MAX_SIZE):
	self._elements = elements
	self._max_size = max_size

func get_elements() -> Array:
	return self._elements

func push(new_element):
	var index := self._elements.find(new_element)
	
	match(index):
		0: pass
		-1: _push_and_handle_size(new_element)
		_: _move_to_front(index)

func _push_and_handle_size(element):
	self._elements.push_front(element)
	if self._elements.size() > self._max_size: self._elements.pop_back()

func _move_to_front(index):
	var element = self._elements.pop_at(index)
	self._elements.push_front(element)

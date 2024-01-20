@tool

extends Control

signal config_saved
signal config_cancel

var _config_content = null
var _config_items = []

func _ready():
	self._config_items = $Panel.get_children().filter(
		func(child): return _is_config_item(child)
	)

func update_values(config: Dictionary):
	self._config_content = config
	_do_update_values(config)

func _is_config_item(node: Node) -> bool:
	return (
		node.has_method("get_param_key")
		&& node.has_method("set_param_value")
	)

func _do_update_values(config: Dictionary):
	for item in self._config_items: _update_param_value(item, config)

func _update_param_value(node: Node, config: Dictionary):
	var param_key: String = node.get_param_key()
	var param_value = config.get(param_key, [])
	
	node.set_param_value(str(param_value))

func _on_save_button_pressed():
	var new_config_values := {}
	
	for item in self._config_items: 
		var key = item.get_param_key()
		var string_value = item.get_param_value()
		var value = _convert_string_to_array(string_value)
		if not value is Array: value = ""
		
		new_config_values[key] = value
	
	emit_signal("config_saved", new_config_values)

func _convert_string_to_array(str: String):
	if not str.begins_with("["): str = "[" + str
	if not str.ends_with("]"): str = str + "]"
	return str_to_var(str)

func _on_cancel_button_pressed():
	emit_signal("config_cancel")

func _on_reset_button_pressed():
	if self._config_content != null:
		_do_update_values(self._config_content)

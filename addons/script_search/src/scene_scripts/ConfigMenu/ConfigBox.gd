@tool

extends Control

func update_values(config: Dictionary):
	for child in $Panel.get_children():
		if _is_config_item(child):
			_update_param_value(child, config)

func _is_config_item(node: Node) -> bool:
	return (
		node.has_method("get_param_key")
		&& node.has_method("set_param_value")
	)

func _update_param_value(node: Node, config: Dictionary):
	var param_key: String = node.get_param_key()
	var param_value = config.get(param_key, [])
	
	node.set_param_value(str(param_value))

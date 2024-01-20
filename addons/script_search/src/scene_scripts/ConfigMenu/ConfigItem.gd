@tool

extends Control

@export var param_name := "Param": 
		set = set_param_name

@export var param_key := "param": 
		get = get_param_key, 
		set = set_param_key

@export var param_description := "param description":  
		set = set_param_description

func set_param_name(value: String): 
	param_name = value
	$Label.set_text(value + ": ")

func get_param_key() -> String: 
	return param_key

func set_param_key(value: String): 
	param_key = value

func set_param_description(value: String): 
	param_description = value
	set_tooltip_text(value)

func get_param_value() -> String:
	return $TextEdit.get_text()

func set_param_value(value: String):
	$TextEdit.set_text(value)

func set_saved(was_saved: bool):
	if was_saved:
		$SaveIndicationLabel.hide()
	else:
		$SaveIndicationLabel.show()

func _on_text_edit_text_changed():
	set_saved(false)

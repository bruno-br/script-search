@tool

extends Control

@export var param_name := "Param": 
		set = set_param_name

@export var param_key := "param": 
		get = get_param_key, 
		set = set_param_key

func set_param_name(value: String): 
	param_name = value
	$Label.set_text(value + ": ")

func get_param_key() -> String: 
	return param_key

func set_param_key(value: String): 
	param_key = value

func set_param_value(value: String):
	$TextEdit.set_text(value)

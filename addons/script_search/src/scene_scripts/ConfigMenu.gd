@tool

extends PopupPanel

const ConfigManager := preload("res://addons/script_search/src/ConfigManager.gd")

func _ready():
	_update_from_config()

func _on_visibility_changed():
	_update_from_config()

func _update_from_config():
	$ConfigBox.update_values(
		ConfigManager.load_and_normalize_config()
	)


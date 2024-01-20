@tool

extends PopupPanel

const ConfigManager := preload("res://addons/script_search/src/ConfigManager.gd")

func _ready():
	var config_box = $ConfigBox
	
	_update_from_config(config_box)
	_connect_signals(config_box)

func _on_visibility_changed():
	_update_from_config($ConfigBox)

func _update_from_config(config_box):
	config_box.update_values(
		ConfigManager.load_and_normalize_config()
	)

func _connect_signals(config_box):
	config_box.config_saved.connect(_on_config_saved)
	config_box.config_cancel.connect(_on_config_cancel)

func _on_config_saved(new_config: Dictionary):
	ConfigManager.save_config_file_normalized(new_config)
	_update_from_config($ConfigBox)

func _on_config_cancel():
	hide()

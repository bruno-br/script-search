@tool

extends PopupPanel

signal config_saved

const ConfigManager := preload("res://addons/script_search/src/ConfigManager.gd")

var _last_saved_config = null

func _ready():
	var config_box = $ConfigBox
	
	_update_from_config(config_box)
	_connect_signals(config_box)

func _on_visibility_changed():
	_update_from_config($ConfigBox)

func _update_from_config(config_box):
	config_box.update_values(
		ConfigManager.load_and_normalize_config(),
		true
	)

func _connect_signals(config_box):
	config_box.config_saved.connect(_on_config_saved)
	config_box.config_cancel.connect(_on_config_cancel)
	config_box.config_reset.connect(_on_config_reset)

func _on_config_saved(new_config: Dictionary):
	var new_config_normalized = ConfigManager.normalize_content(new_config)

	if new_config_normalized != self._last_saved_config:
		self._last_saved_config = new_config_normalized
		ConfigManager.save_config_file(new_config_normalized)
		emit_signal("config_saved")
	
	_update_from_config($ConfigBox)

func _on_config_cancel():
	hide()

func _on_config_reset():
	var default_content = ConfigManager.normalize_content({})
	$ConfigBox.update_values(default_content)

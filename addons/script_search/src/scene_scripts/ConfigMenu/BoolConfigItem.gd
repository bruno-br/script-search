@tool

extends "./ConfigItem.gd"

func get_param_value():
	return $CheckButton.is_pressed()

func set_param_value(value):
	$CheckButton.set_pressed(value == true)

func _on_check_button_toggled(toggled_on):
	set_param_value(toggled_on)
	set_saved(false)

@tool

extends TextureButton

const OsHelper := preload("res://addons/script_search/src/OsHelper.gd")

const NORMAL_COLOR := Color("5e6369")
const HOVER_COLOR := Color("8c9298")

func _ready():
	# Tooltip text caused a focus bug on Linux
	OsHelper.on_windows(func(): set_tooltip_text("Edit Configurations"))

func _on_mouse_entered():
	set_modulate(HOVER_COLOR)

func _on_mouse_exited():
	set_modulate(NORMAL_COLOR)

func _on_button_down():
	set_modulate(NORMAL_COLOR)

@tool

extends TextureButton

const NORMAL_COLOR := Color("5e6369")
const HOVER_COLOR := Color("8c9298")

func _on_mouse_entered():
	set_modulate(HOVER_COLOR)

func _on_mouse_exited():
	set_modulate(NORMAL_COLOR)

func _on_pressed():
	print_debug("PRESSED")

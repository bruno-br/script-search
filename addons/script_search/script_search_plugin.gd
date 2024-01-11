@tool
extends EditorPlugin

const MenuScene := preload("res://addons/script_search/scenes/SearchMenu.tscn")

var _menu

func _enter_tree() -> void:
	self._menu = MenuScene.instantiate()
	self._menu.show()

func _exit_tree() -> void:
	self._menu.hide()
	self._menu.queue_free()

extends "res://tests/test.gd"

const FileButtonCollection := preload("res://addons/script_search/src/FileButtonCollection.gd")
const FileButton := preload("res://addons/script_search/src/scene_scripts/SearchMenu/FileButton.gd")

var file_button_visible
var file_button_visible_2
var file_button_visible_3
var file_button_hidden

func before_all():
	file_button_visible = FileButton.new()
	file_button_visible.set_file_name("FileButton 1")
	
	file_button_visible_2 = FileButton.new()
	file_button_visible_2.set_file_name("FileButton 2")
	
	file_button_visible_3 = FileButton.new()
	file_button_visible_3.set_file_name("FileButton 3")
	
	file_button_hidden = FileButton.new()
	file_button_hidden.set_file_name("FileButton 4")
	file_button_hidden.set_visible(false)

func after_all():
	file_button_visible.free()
	file_button_visible_2.free()
	file_button_visible_3.free()
	file_button_hidden.free()

func test_append():
	var file_button_collection = FileButtonCollection.new()
	
	assert_eq(file_button_collection.get_all(), [])
	
	file_button_collection.append(file_button_visible)
	file_button_collection.append(file_button_hidden)
	
	assert_eq(file_button_collection.get_all(), [file_button_visible, file_button_hidden])

func test_hidden_file_button():
	var file_button_collection = FileButtonCollection.new([file_button_hidden])
	assert_eq(file_button_collection.has_visible(), false)
	assert_eq(file_button_collection.get_first_visible(), null)
	
func test_visible_file_button():
	var file_button_collection = FileButtonCollection.new([file_button_visible])
	assert_eq(file_button_collection.has_visible(), true)
	assert_eq(file_button_collection.get_first_visible(), file_button_visible)

func test_update():
	var file_button_collection = FileButtonCollection.new([file_button_hidden])
	var file_buttons = [file_button_hidden, file_button_visible]
	
	file_button_collection.update(file_buttons)
	
	assert_eq(file_button_collection.get_all(), file_buttons)
	assert_eq(file_button_collection.has_visible(), true)
	assert_eq(file_button_collection.get_first_visible(), file_button_visible)

func test_update_visible_elements():
	var file_buttons = [file_button_visible, file_button_hidden]
	var file_button_collection = FileButtonCollection.new(file_buttons)
	assert_eq(file_button_collection.has_visible(), true)
	
	file_button_visible.set_visible(false)
	file_button_collection.update_visible_elements()
	assert_eq(file_button_collection.has_visible(), false)
	
	file_button_visible.set_visible(true)
	file_button_collection.update_visible_elements()
	assert_eq(file_button_collection.has_visible(), true)

func test_get_prev_visible():
	var empty_collection = FileButtonCollection.new([])
	assert_eq(empty_collection.get_prev_visible(file_button_visible), null)
	
	var hidden_only_collection = FileButtonCollection.new([file_button_hidden])
	assert_eq(hidden_only_collection.get_prev_visible(file_button_hidden), null)
	
	var one_visible_collection = FileButtonCollection.new([file_button_visible])
	assert_eq(
		one_visible_collection.get_prev_visible(file_button_visible), 
		file_button_visible
	)
	assert_eq(
		one_visible_collection.get_prev_visible(file_button_hidden), 
		file_button_visible
	)
	
	var visible_buttons_collection = FileButtonCollection.new([
		file_button_visible, file_button_visible_2, file_button_visible_3
	])
	assert_eq(
		visible_buttons_collection.get_prev_visible(file_button_visible), 
		file_button_visible_3
	)
	assert_eq(
		visible_buttons_collection.get_prev_visible(file_button_visible_2), 
		file_button_visible
	)
	assert_eq(
		visible_buttons_collection.get_prev_visible(file_button_visible_3), 
		file_button_visible_2
	)

func test_get_next_visible():
	var empty_collection = FileButtonCollection.new([])
	assert_eq(empty_collection.get_next_visible(file_button_visible), null)
	
	var hidden_only_collection = FileButtonCollection.new([file_button_hidden])
	assert_eq(hidden_only_collection.get_next_visible(file_button_hidden), null)
	
	var one_visible_collection = FileButtonCollection.new([file_button_visible])
	assert_eq(one_visible_collection.get_next_visible(file_button_visible), file_button_visible)
	
	var visible_buttons_collection = FileButtonCollection.new([
		file_button_visible, file_button_visible_2, file_button_visible_3
	])
	assert_eq(
		visible_buttons_collection.get_next_visible(file_button_visible), 
		file_button_visible_2
	)
	assert_eq(
		visible_buttons_collection.get_next_visible(file_button_visible_2), 
		file_button_visible_3
	)
	assert_eq(
		visible_buttons_collection.get_next_visible(file_button_visible_3), 
		file_button_visible
	)

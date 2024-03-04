extends "res://tests/test.gd"

const TextMatcher := preload("res://addons/script_search/src/TextMatcher.gd")

func test_match_case_sensitive():
	var is_case_sensitive = true
	var file_name = "res://file.gd"
	
	assert_eq(TextMatcher.matches(file_name, "File", is_case_sensitive), false)
	assert_eq(TextMatcher.matches(file_name, "file", is_case_sensitive), true)
	
	file_name = "res://File.gd"
	assert_eq(TextMatcher.matches(file_name, "File", is_case_sensitive), true)
	assert_eq(TextMatcher.matches(file_name, "file", is_case_sensitive), false)

func test_match_case_insensitive():
	var is_case_sensitive = false
	var file_name = "res://file.gd"
	
	assert_eq(TextMatcher.matches(file_name, "File", is_case_sensitive), true)
	assert_eq(TextMatcher.matches(file_name, "file", is_case_sensitive), true)
	
	file_name = "res://File.gd"
	assert_eq(TextMatcher.matches(file_name, "File", is_case_sensitive), true)
	assert_eq(TextMatcher.matches(file_name, "file", is_case_sensitive), true)

func test_match_basename_case_sensitive():
	var file_name_1 = "res://src/weapon/sword.gd"
	var file_name_2 = "res://src/weapon.gd"
	var is_case_sensitive = true
	
	var search_text = "weapon"
	assert_eq(TextMatcher.matches(file_name_1, search_text, is_case_sensitive), true)
	assert_eq(TextMatcher.matches(file_name_2, search_text, is_case_sensitive), true)
	
	search_text = ":weapon"
	assert_eq(TextMatcher.matches(file_name_1, search_text, is_case_sensitive), false)
	assert_eq(TextMatcher.matches(file_name_2, search_text, is_case_sensitive), true)

	search_text = ":Weapon"
	assert_eq(TextMatcher.matches(file_name_1, search_text, is_case_sensitive), false)
	assert_eq(TextMatcher.matches(file_name_2, search_text, is_case_sensitive), false)
	
	search_text = ":weapon"
	assert_eq(TextMatcher.matches(file_name_1.to_upper(), search_text, is_case_sensitive), false)
	assert_eq(TextMatcher.matches(file_name_2.to_upper(), search_text, is_case_sensitive), false)

func test_match_basename_case_insensitive():
	var file_name_1 = "res://src/weapon/sword.gd"
	var file_name_2 = "res://src/weapon.gd"
	var is_case_sensitive = false
	
	var search_text = ":weapon"
	assert_eq(TextMatcher.matches(file_name_1, search_text, is_case_sensitive), false)
	assert_eq(TextMatcher.matches(file_name_2, search_text, is_case_sensitive), true)
	
	search_text = ":Weapon"
	assert_eq(TextMatcher.matches(file_name_1, search_text, is_case_sensitive), false)
	assert_eq(TextMatcher.matches(file_name_2, search_text, is_case_sensitive), true)
	
	search_text = ":weapon"
	assert_eq(TextMatcher.matches(file_name_1.to_upper(), search_text, is_case_sensitive), false)
	assert_eq(TextMatcher.matches(file_name_2.to_upper(), search_text, is_case_sensitive), true)

func test_match_multiterm_search():
	var file_name_1 = "res://src/dir_1/dir_2/script.gd"
	var file_name_2 = "res://src/script.gd"
	var is_case_sensitive = false
	
	var search_text = "script"
	assert_eq(TextMatcher.matches(file_name_1, search_text, is_case_sensitive), true)
	assert_eq(TextMatcher.matches(file_name_2, search_text, is_case_sensitive), true)
	
	search_text = "script,dir_1"
	assert_eq(TextMatcher.matches(file_name_1, search_text, is_case_sensitive), true)
	assert_eq(TextMatcher.matches(file_name_2, search_text, is_case_sensitive), false)
	
	search_text = "script, dir_1"
	assert_eq(TextMatcher.matches(file_name_1, search_text, is_case_sensitive), true)
	assert_eq(TextMatcher.matches(file_name_2, search_text, is_case_sensitive), false)
	
	search_text = "  script     ,   dir_1 "
	assert_eq(TextMatcher.matches(file_name_1, search_text, is_case_sensitive), true)
	assert_eq(TextMatcher.matches(file_name_2, search_text, is_case_sensitive), false)

func test_match_file_name_with_spaces():
	var file_name_1 = "res://player scripts/movement.gd"
	var file_name_2 = "res://scripts/player.gd"
	var is_case_sensitive = false
	
	var search_text = "player scripts"
	assert_eq(TextMatcher.matches(file_name_1, search_text, is_case_sensitive), true)
	assert_eq(TextMatcher.matches(file_name_2, search_text, is_case_sensitive), false)
	
	search_text = "player  scripts"
	assert_eq(TextMatcher.matches(file_name_1, search_text, is_case_sensitive), false)
	assert_eq(TextMatcher.matches(file_name_2, search_text, is_case_sensitive), false)
	
	search_text = "player, scripts"
	assert_eq(TextMatcher.matches(file_name_1, search_text, is_case_sensitive), true)
	assert_eq(TextMatcher.matches(file_name_2, search_text, is_case_sensitive), true)

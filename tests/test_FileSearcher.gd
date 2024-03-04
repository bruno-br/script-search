extends "res://tests/test.gd"

const FileSearcher := preload("res://addons/script_search/src/FileSearcher.gd")
const MOCK_DIR = "res://tests/mock_dir/"

func test_get_files():
	var file_searcher = FileSearcher.new({
		"allowed_extensions": ["gd"], 
		"directory_blacklist": []
	})
	
	var expected =  [
		"res://tests/mock_dir/dir_1/script.gd", 
		"res://tests/mock_dir/dir_2/script.gd", 
		"res://tests/mock_dir/player.gd", 
		"res://tests/mock_dir/script.gd", 
		"res://tests/mock_dir/script_dir/ANOTHER.gd",
		"res://tests/mock_dir/script_dir/other.gd"
	]
	
	assert_eq(file_searcher.get_files(MOCK_DIR), expected)

func test_get_files_directory_blacklist():
	var file_searcher = FileSearcher.new({
		"allowed_extensions": ["gd"], 
		"directory_blacklist": [
			"res://tests/mock_dir/script_dir", 
			"res://tests/mock_dir/dir_2"
		]
	})
	
	var expected =  [
		"res://tests/mock_dir/dir_1/script.gd", 
		"res://tests/mock_dir/player.gd", 
		"res://tests/mock_dir/script.gd"
	]

	
	assert_eq(file_searcher.get_files(MOCK_DIR), expected)

func test_get_files_txt_as_allowed_extension():
	var file_searcher = FileSearcher.new({
		"allowed_extensions": ["txt"], 
		"directory_blacklist": []
	})
	
	var expected =  [
		"res://tests/mock_dir/script_dir/script.txt"
	]
	
	assert_eq(file_searcher.get_files(MOCK_DIR), expected)

func test_get_files_no_allowed_extensions():
	var file_searcher = FileSearcher.new({
		"allowed_extensions": [], 
		"directory_blacklist": []
	})
	
	assert_eq(file_searcher.get_files(MOCK_DIR), [])

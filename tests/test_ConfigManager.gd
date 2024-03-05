extends "res://tests/test.gd"

const ConfigManager := preload("res://addons/script_search/src/ConfigManager.gd")

const DEFAULT_CONFIG := {
	"allowed_extensions": ["gd", "gdshader"], 
	"case_sensitive": false, 
	"directory_blacklist": ["res://.godot", "res://addons"]
}

func test_load_config_file():
	var expected = load("res://addons/script_search/.config.json")
	assert_eq(ConfigManager.load_config_file(), expected)

func test_read_config_file():
	assert_eq(ConfigManager.read_config_file(), DEFAULT_CONFIG)
	
func test_normalize_content():
	var content = {}
	var expected = DEFAULT_CONFIG
	assert_eq(ConfigManager.normalize_content(content), expected)
	
	content = {"allowed_extensions": null, "directory_blacklist": null, "case_sensitive": null}
	assert_eq(ConfigManager.normalize_content(content), expected)
	
	content = {"allowed_extensions": {}, "directory_blacklist": "test", "case_sensitive": "true"}
	assert_eq(ConfigManager.normalize_content(content), expected)
	
	content = {"allowed_extensions": [], "directory_blacklist": [], "case_sensitive": []}
	expected = {"allowed_extensions": [], "directory_blacklist": [], "case_sensitive": false}
	assert_eq(ConfigManager.normalize_content(content), expected)
	
	content = {
		"allowed_extensions": ["gd", [], "txt", null, "", 0, "txt", "txt"], 
		"directory_blacklist": [null, {}, {}, ""], 
		"case_sensitive": true
	}
	expected = {
		"allowed_extensions": ["gd", "txt"], 
		"directory_blacklist": [], 
		"case_sensitive": true
	}
	assert_eq(ConfigManager.normalize_content(content), expected)

func test_load_and_normalize_config():
	ConfigManager.save_config_file({})
	assert_eq(ConfigManager.read_config_file(), {})
	
	assert_eq(ConfigManager.load_and_normalize_config(), DEFAULT_CONFIG)
	assert_eq(ConfigManager.read_config_file(), DEFAULT_CONFIG)
	
func test_save_config_file_normalized():
	ConfigManager.save_config_file({})
	assert_eq(ConfigManager.read_config_file(), {})
	
	ConfigManager.save_config_file_normalized({})
	assert_eq(ConfigManager.read_config_file(), DEFAULT_CONFIG)

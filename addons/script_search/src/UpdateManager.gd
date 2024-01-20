const ConfigManager := preload("./ConfigManager.gd")

const FS_UPDATE_INTERVAL = 200

var _config_file = null
var _search_box = null
var _last_resource_save_time := 0

func _init(
	search_box,
	signal_filesystem_changed,
	signal_resource_saved,
	signal_config_saved
):
	self._search_box = search_box
	signal_resource_saved.connect(_on_resource_saved)
	signal_filesystem_changed.connect(_on_filesystem_changed)
	signal_config_saved.connect(_on_config_saved)
	_load_config_file()

func _on_resource_saved(resource):
	self._last_resource_save_time = Time.get_ticks_msec()
	if _is_config_file(resource):
		_request_config_reload()

func _on_filesystem_changed():
	if _enough_time_passed_since_last_resource_saved():
		self._search_box.update_matching_files()

func _on_config_saved():
	_request_config_reload()

func _enough_time_passed_since_last_resource_saved() -> bool:
	var curr_time = Time.get_ticks_msec()
	return (curr_time - self._last_resource_save_time) > FS_UPDATE_INTERVAL

func _request_config_reload():
	self._search_box.update_config()

func _is_config_file(resource) -> bool:
	if self._config_file == null: 
		_load_config_file()
	return (resource != null) && (resource == self._config_file)

func _load_config_file():
	self._config_file = ConfigManager.load_config_file()

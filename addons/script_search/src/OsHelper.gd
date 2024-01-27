
static func on_windows(callable: Callable):
	if OS.get_name() == "Windows": callable.call()

extends Panel

const TESTS_PATH := "res://tests"
const FileSearcher := preload("res://addons/script_search/src/FileSearcher.gd")

var _file_searcher = FileSearcher.new({"allowed_extensions": ["gd"]})

func run_tests():
	var logs_label: RichTextLabel = get_logs_label()
	logs_label.clear()
	
	var failing_test_logs = []
	var final_result = {"passed": 0, "failed": 0}
	
	for file_name in self._file_searcher.get_files(TESTS_PATH):
		var file_basename = file_name.get_file()
		if not file_basename.begins_with("test_"): continue
		
		var test_file = load(file_name).new()
		var results = await test_file.run_tests(get_tree())
		
		if results.get("failed", []).size() > 0:
			failing_test_logs.append(func(): log_test_results(logs_label, results, file_basename))
		else:
			log_test_results(logs_label, results, file_basename)
		
		final_result["passed"] += results.get("passed", []).size()
		final_result["failed"] += results.get("failed", []).size()
	
	for failing_test_log in failing_test_logs:
		failing_test_log.call()
	
	logs_label.append_text(
		"\n---\n > [color=green]" + str(final_result["passed"]) + " tests passed.[/color]\n" 
		+ " > [color=red]" + str(final_result["failed"]) + " tests failed.[/color]\n"
	)

func log_test_results(logs_label: RichTextLabel, test_results: Dictionary, test_file: String):
		logs_label.append_text("\n[color=gray]-- " + test_file + " --[/color]\n")
		
		for successful_test in test_results.get("passed", []):
			logs_label.append_text(
				"\n" + successful_test["method"] + "\n"
				+ _build_test_message("[color=green]Passed: [/color]", successful_test["messages"])
			)
		
		for failing_test in test_results.get("failed", []):
			logs_label.append_text(
				"\n" + failing_test["method"] + "\n"
				+ _build_test_message("[color=red]Failed: [/color]", failing_test["messages"])
			)

func _build_test_message(prefix: String, messages: Array):
	if messages.is_empty(): return ""
	
	messages.push_front("")
	
	return messages.reduce(
		func(acc, msg): return acc + prefix + msg + "\n"
	)

func get_logs_label():
	return $PanelContainer/LogsLabel

func _on_run_button_pressed():
	run_tests()

extends Node
class_name FileReader

func read_file(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	return content

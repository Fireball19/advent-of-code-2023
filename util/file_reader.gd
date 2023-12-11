extends Node
class_name FileReader

func read_file_as_string(file_path: String):
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var content: String = file.get_as_text()
	return content
	
func read_file_as_lines(file_path: String):
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var content: String = file.get_as_text()
	var lines: PackedStringArray = content.split("\n", false)
	return lines

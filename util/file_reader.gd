extends Node
class_name FileReader

func read_file_as_string(file_path: String):
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	
	var content: String = file.get_as_text()
	
	return content
	
func read_file_as_lines(file_path: String):
	var content: String = read_file_as_string(file_path)
	
	var lines: PackedStringArray = content.split("\n", false)
	
	return lines
	
func read_file_as_char_matrix(file_path: String):
	var content: PackedStringArray = read_file_as_lines(file_path)
	
	var matrix: Array = []
	var tmp_array: Array = []
	for s in content:
		tmp_array = []
		for c in s:
			tmp_array.append(c)
		matrix.append(tmp_array)
		
	return matrix

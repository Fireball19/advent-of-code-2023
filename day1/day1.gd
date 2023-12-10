extends Node

@onready var file_reader: FileReader = $FileReader
@export var example_file_path: String
@export var example2_file_path: String
@export var input_file_path: String

var spelled_digits: Array = ["one", "two", "three", "four", "five", 
							"six", "seven", "eight", "nine"]
	
var spelled_digits_dict: Dictionary = {
	"one": "o1e",
	"two": "t2o",
	"three": "t3e",
	"four": "f4r",
	"five": "f5e",
	"six": "s6x",
	"seven": "s7n",
	"eight": "e8t",
	"nine": "n9e",
}

func _ready():
	var example_file_content: String = file_reader.read_file(example_file_path)
	_calculate_calibration_value(example_file_content)
	
	var input_file_content: String = file_reader.read_file(input_file_path)
	_calculate_calibration_value(input_file_content)
	
	var example2_file_content: String = file_reader.read_file(example2_file_path)
	_calculate_actual_calibration_value(example2_file_content)
	
	_calculate_actual_calibration_value(input_file_content)

func _calculate_calibration_value(file_content: String):
	var lines: PackedStringArray = file_content.split("\n", false)
	
	var first_digit: String = ""
	var last_digit: String = ""
	var sum: int = 0
	for l in lines:
		for c in l:
			if c.is_valid_int():
				if (first_digit == ""):
					first_digit = c
				last_digit = c
		sum += (first_digit + last_digit).to_int()
		
		first_digit = ""
		last_digit = ""
		
	print(sum)
	
func _contains_any_spelled_digit(line: String):
	for digit in spelled_digits:
		if (line.contains(digit)):
			return true
	return false
	
func _convert_letters_to_numbers(file_content: String):
	var lines: PackedStringArray = file_content.split("\n", false)
	
	var first_found: String
	var first_found_index: int
	var tmp_find_result: int
	var index_lines: int = 0
	for l in lines:
		while _contains_any_spelled_digit(l):
			first_found = ""
			first_found_index = l.length()
			tmp_find_result = -1
			for digit in spelled_digits:
				tmp_find_result = l.find(digit)
							
				if tmp_find_result > -1:
					if tmp_find_result < first_found_index:
						first_found_index = tmp_find_result
						first_found = digit
		
			if (first_found_index > -1):
				l = l.replace(first_found, 
				spelled_digits_dict.get(first_found))

		lines.set(index_lines, l)
		index_lines += 1
	
	file_content = "\n".join(lines)
	
	return file_content

func _calculate_actual_calibration_value(file_content: String):
	file_content = _convert_letters_to_numbers(file_content)
	_calculate_calibration_value(file_content)

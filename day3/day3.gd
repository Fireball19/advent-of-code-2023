extends Node

@onready var file_reader: FileReader = $FileReader
@export var example_file_path: String
@export var input_file_path: String

func _ready():
	var example_char_matrix: Array = file_reader.read_file_as_char_matrix(
		example_file_path)
	_calculate_sum_of_array(
		_find_part_numbers(example_char_matrix))
	
	var input_char_matrix: Array = file_reader.read_file_as_char_matrix(
		input_file_path)
	_calculate_sum_of_array(
		_find_part_numbers(input_char_matrix))
		
	_calculate_sum_of_array(
		_find_gear_ratios(example_char_matrix, 
		_mark_part_numbers_matrix(example_char_matrix)))
		
	_calculate_sum_of_array(
		_find_gear_ratios(input_char_matrix, 
		_mark_part_numbers_matrix(input_char_matrix)))
	
func _find_part_numbers(char_matrix: Array):
	var x: int = 0
	var y: int = 0
	
	var part_numbers: Array = []
	var tmp_part_number: String = ""
	var is_valid_part_number: bool = false
	
	for line in char_matrix:
		y = 0
		is_valid_part_number = false
		tmp_part_number = ""
		for c in line:
			if c.is_valid_int():
				tmp_part_number += c
				if _check_number(char_matrix, x, y):
					is_valid_part_number = true
			else:
				if is_valid_part_number and not tmp_part_number.is_empty():
					part_numbers.append(tmp_part_number.to_int())
				
				is_valid_part_number = false
				tmp_part_number = ""
			
			y += 1
			
		# new line
		if is_valid_part_number and not tmp_part_number.is_empty():
			part_numbers.append(tmp_part_number.to_int())
		
		x += 1
		
	return part_numbers
	
func _calculate_sum_of_array(array : Array):
	var sum: int = 0
	for i in array:
		sum += i
	
	print(sum)
	
func _is_valid_symbol(string: String):
	return not string.is_valid_int() and string != "."
	
func _check_number(char_matrix: Array, x: int, y: int):
	if x + 1 < char_matrix.size():
		if _is_valid_symbol(char_matrix[x + 1][y]):
			return true
	if x - 1 > -1:
		if _is_valid_symbol(char_matrix[x - 1][y]):
			return true
	if y + 1 < char_matrix[x].size():
		if _is_valid_symbol(char_matrix[x][y + 1]):
			return true
	if y - 1 > -1:
		if _is_valid_symbol(char_matrix[x][y - 1]):
			return true
	if x + 1 < char_matrix.size() and y + 1 < char_matrix[x].size():
		if _is_valid_symbol(char_matrix[x + 1][y + 1]):
			return true
	if x + 1 < char_matrix.size() and y - 1 > -1:
		if _is_valid_symbol(char_matrix[x + 1][y - 1]):
			return true
	if x - 1 > -1 and y + 1 < char_matrix[x].size():
		if _is_valid_symbol(char_matrix[x - 1][y + 1]):
			return true
	if x - 1 > -1 and y - 1 > -1:
		if _is_valid_symbol(char_matrix[x - 1][y - 1]):
			return true
	return false

func _mark_part_numbers_matrix(char_matrix: Array):
	var marked_matrix: Array = []
	var tmp_array: Array = []
	for i in char_matrix.size():
		tmp_array = []
		for j in char_matrix[i].size():
			tmp_array.append(-1)
		marked_matrix.append(tmp_array)
	
	var x: int = 0
	var y: int = 0
	
	var tmp_part_number_indices: Array = []
	var tmp_part_number: String = ""
	var is_valid_part_number: bool = false
	
	for line in char_matrix:
		y = 0
		is_valid_part_number = false
		tmp_part_number_indices = []
		tmp_part_number = ""
		for c in line:
			if c.is_valid_int():
				tmp_part_number += c
				tmp_part_number_indices.append(Vector2i(x, y))
				if _check_number(char_matrix, x, y):
					is_valid_part_number = true
			else:
				if is_valid_part_number and not tmp_part_number.is_empty():
					for index in tmp_part_number_indices:
						marked_matrix[index.x][index.y] = tmp_part_number.to_int()
				
				is_valid_part_number = false
				tmp_part_number_indices = []
				tmp_part_number = ""
			
			y += 1
			
		# new line
		if is_valid_part_number and not tmp_part_number.is_empty():
			for index in tmp_part_number_indices:
				marked_matrix[index.x][index.y] = tmp_part_number.to_int()
		
		x += 1
		
	return marked_matrix
	
func _is_part_number(number: int):
	return number != -1

func _check_exactly_two_part_numbers(marked_matrix: Array, x: int, y: int):
	var part_numbers: Array = []
	
	if y + 1 < marked_matrix[x].size():
		if _is_part_number(marked_matrix[x][y + 1]):
			part_numbers.append(marked_matrix[x][y + 1])
	if y - 1 > -1:
		if _is_part_number(marked_matrix[x][y - 1]):
			part_numbers.append(marked_matrix[x][y - 1])

	var is_already_part_number: bool = false
	if x + 1 < marked_matrix.size() and y - 1 > -1:
		if _is_part_number(marked_matrix[x + 1][y - 1]):
			if not is_already_part_number:
				part_numbers.append(marked_matrix[x + 1][y - 1])
			is_already_part_number = true
		else:
			is_already_part_number = false
	if x + 1 < marked_matrix.size():
		if _is_part_number(marked_matrix[x + 1][y]):
			if not is_already_part_number:
				part_numbers.append(marked_matrix[x + 1][y])
			is_already_part_number = true
		else:
			is_already_part_number = false
	if x + 1 < marked_matrix.size() and y + 1 < marked_matrix[x].size():
		if _is_part_number(marked_matrix[x + 1][y + 1]):
			if not is_already_part_number:
				part_numbers.append(marked_matrix[x + 1][y + 1])
			is_already_part_number = true
		else:
			is_already_part_number = false
			
	is_already_part_number = false
	if x - 1 > -1 and y - 1 > -1:
		if _is_part_number(marked_matrix[x - 1][y - 1]):
			if not is_already_part_number:
				part_numbers.append(marked_matrix[x - 1][y - 1])
			is_already_part_number = true
		else:
			is_already_part_number = false
	if x - 1 > -1:
		if _is_part_number(marked_matrix[x - 1][y]):
			if not is_already_part_number:
				part_numbers.append(marked_matrix[x - 1][y])
			is_already_part_number = true
		else:
			is_already_part_number = false
	if x - 1 > -1 and y + 1 < marked_matrix[x].size():
		if _is_part_number(marked_matrix[x - 1][y + 1]):
			if not is_already_part_number:
				part_numbers.append(marked_matrix[x - 1][y + 1])
			is_already_part_number = true
		else:
			is_already_part_number = false
	
	if part_numbers.size() != 2:
		return 0
	else: 
		return part_numbers[0] * part_numbers[1]

func _find_gear_ratios(char_matrix: Array, marked_matrix: Array):
	var gear_rations: Array = []
	
	var x: int = 0
	var y: int = 0
	
	for line in char_matrix:
		y = 0
		for c in line:
			if c == "*":
				gear_rations.append(
					_check_exactly_two_part_numbers(marked_matrix, x, y))
			y += 1
		x += 1

	return gear_rations

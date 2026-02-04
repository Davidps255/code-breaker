extends Node
class_name CommandLine

@export var line_edit: LineEdit 

var function_1: Array[String]
var function_2: Array[String]
var function_3: Array[String]

# index in function list/array
var index: int = 0


func received_command(input: String):
	# general formatting of input
	input = input.remove_chars(" ") #removes spaces
	input = input.to_lower() #to lowercase
	
	if (input == "end"):
		index = 0
	elif (input.begins_with("function") or index > 0):
		write_func(input)
	elif input.contains("/") and input.contains("@"):
		parse_command(input)
	else:
		print("invalid command")
	
	line_edit.text = "" #clears command after execution


func write_func(input: String):
	if (index == 0):
		# get the name of created function
		function_1[index] = input.substr(8)
	else:
		function_1[index] = input


func parse_command(input: String):
	# separating arguments
	var slash = input.find("/") #index of slash
	var at = input.find("@") #index of at symbol
	
	var object = input.substr(0, slash) 
	var action = input.substr(
		slash + 1, 
		at - object.length() - 1)
	var location = input.substr(at + 1)
	
	print(object)
	print(action)
	print(location)

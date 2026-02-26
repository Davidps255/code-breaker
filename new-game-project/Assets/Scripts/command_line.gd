extends Node
class_name CommandLine

@export var line_edit: LineEdit 

var function_array: Array[String]

signal basic_order(object: String, action: String, parameter: String)

# index in function array 
var index: int = 0

# OBJECT / ACTION @ ARGUMENT
func received_command(input: String):
	# general formatting of input
	input = input.remove_chars(" ") #removes spaces
	input = input.to_lower() #to lowercase
	
	if (input == "end"):
		index = 0
	elif (input.begins_with("function") or index > 0):
		write_function(input)
	elif input.contains("/") and input.contains("@"):
		parse_command(input)
	else:
		print("invalid command")
	
	line_edit.text = "" #clears command after execution


func write_function(input: String):
	if (index == 0):
		# get the name of created function
		function_array[index] = input.substr(8)
	else:
		function_array[index] = input


func parse_command(input: String):
	# separating arguments
	var slash = input.find("/") #index of slash
	var at = input.find("@") #index of at symbol
	
	var object = input.substr(0, slash) 
	var action = input.substr(
		slash + 1, 
		at - object.length() - 1)
	var argument = input.substr(at + 1)
	
	print(object)
	print(action)
	print(argument)
	emit_signal("basic_order", object, action, argument)


# actions
	#north, south, east, west (movment, takes numerical argument)
	#

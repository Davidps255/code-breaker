extends Node
class_name CommandLine

@export var line_edit: LineEdit 

var function_array: Array = []
var read_mode: bool = false

signal basic_order(object: String, action: String, parameter: String)
signal function_order(list_of_orders)

# index in function array 
var index: int = 0

# OBJECT / ACTION @ ARGUMENT
func received_command(input: String):
	# general formatting of input
	input = input.remove_chars(" ") #removes spaces
	input = input.to_lower() #to lowercase
	
	if (input == "end"):
		read_mode=false
		set("theme_override_colors/font_color",Color(0.865, 0.879, 0.873, 1.0))
		emit_signal("function_order", function_array)
		print(function_array)
		function_array=[]
		

	elif (input.begins_with("func()")):
		read_mode = true
		set("theme_override_colors/font_color",Color(0.573, 0.979, 0.722, 1.0))

	elif input.contains("/") and input.contains("@"):
		parse_command(input, read_mode)
	elif (input.contains("move") or input.contains("grab")) and input.length()>8:
		parse_movement_or_grab(input, read_mode)
	else:
		if read_mode:
			function_array=[]
			exit_read_mode()
		print("invalid command")
	
	line_edit.text = "" #clears command after execution





func parse_command(input: String, is_func: bool):
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
	if is_func==false:
		emit_signal("basic_order", object, action, argument)
	else:
		function_array.append( [object, action, argument] )

func parse_movement_or_grab(input: String, is_func: bool):
	var quote = input.find('"')
	var action = "move_miki"
	var object = "miki"
	if "grab" in input:
		action = "grab_miki"
	var argument= input.substr(
		quote+1,
		input.length() - 8)
	print(object)
	print(action)
	print(argument)
	if is_func==false:
		emit_signal("basic_order", object, action, argument)
	else:
		function_array.append( [object, action, argument] )

func exit_read_mode():
	read_mode=false
	set("theme_override_colors/font_color",Color(0.865, 0.879, 0.873, 1.0))
	emit_signal("function_order", function_array)
	print(function_array)
	function_array=[]

# actions
	#north, south, east, west (movment, takes numerical argument)
	#

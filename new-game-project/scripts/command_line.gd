extends Node
class_name CommandLine

@export var line_edit: LineEdit 

# returns true if "valid" command
func received_command(input: String):
	if input.contains("/") and input.contains("@"):
		# general formatting
		input = input.remove_chars(" ") #removes spaces
		input = input.to_lower() #to lowercase
		
		
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
	else:
		print("invalid command")
	
	line_edit.text = "" #clears command after execution

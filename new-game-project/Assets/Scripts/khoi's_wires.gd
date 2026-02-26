extends Node3D

var connections_dict = [
	{1: null},
	{1: null, 2: null}
	#{1: null, 2: null, 3: null}
]

@onready var tutorial2 = "../TutorialRoom2/Props"
@onready var tutorial3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connections_dict[0][1] = $"../TutorialRoom/Props/pressure_plate"
	connections_dict[1][1] = get_node(tutorial2 + "/pressure_plate")
	connections_dict[1][2] = get_node(tutorial2 + "/pressure_plate2")
	for room in connections_dict:
		var room_keys = room.keys()
		var room_values = room.values()
		for i in range(room.size()):
			room_values[i].pressed.connect(activated.bind(room_values[i], room_keys[i]))
	
func activated(activator, wire_num:int):
	await get_tree().create_timer(0.1).timeout
	if activator.active:
		print("wire "+str(wire_num)+"should turn blue.")

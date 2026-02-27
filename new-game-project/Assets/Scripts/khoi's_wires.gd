extends Node3D

var connections_dict = [
	{1: null},
	{1: null, 2: null} #exclude printer wire
	#{1: null, 2: null, 3: null}
]
var colors = [Color(0.0,0.0,0.0,1.0), Color(0.196,1.0,1.0,1.0)]

@onready var tutorial2 = "../TutorialRoom2/Props"
@onready var tutorial3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connections_dict[0][1] = $"../TutorialRoom/Props/pressure_plate"
	connections_dict[1][1] = get_node(tutorial2 + "/pressure_plate")
	connections_dict[1][2] = get_node(tutorial2 + "/pressure_plate2")
	for roomn in range(connections_dict.size()):
		var room = connections_dict[roomn]
		var room_values = room.values()
		for i in range(room.size()):
			room_values[i].pressed.connect(change_color.bind(roomn, i, 1))
			room_values[i].unpressed.connect(change_color.bind(roomn, i, 0))
	
func change_color(roomn:int, wire_num:int, color:int):
	var wire = get_node("Room" + str(roomn+1) + "wires/wire" + str(wire_num+1))
	for mesh in wire.get_children():
		mesh.get_active_material(0).albedo_color = colors[color]

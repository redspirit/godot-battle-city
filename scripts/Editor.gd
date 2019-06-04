extends Node2D



var map
var dataFileName = "map.txt"


func _ready():
	pass

func _on_Button_pressed():
	var data = []
	for point in map.get_used_cells():
		data.append([point.x, point.y, map.get_cell(point.x, point.y)]);
	
	var file = File.new()
	file.open("res://maps/" + dataFileName, File.WRITE)
	file.store_string(JSON.print(data))
	file.close()
	print("SAVED!")




extends Node2D

var dataFileName = "map_8.txt"

func _ready():
	pass

func _on_Button_pressed():
	var map = $TileMap
	var maps = []
	for point in map.get_used_cells():
		maps.append([point.x, point.y, map.get_cell(point.x, point.y)]);
	
	
	var data = {
		"enemies": [],
		"map": maps
	}
	
	var file = File.new()
	file.open("res://maps/" + dataFileName, File.WRITE)
	file.store_string(JSON.print(data))
	file.close()
	print("SAVED!")




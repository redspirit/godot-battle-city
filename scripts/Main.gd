extends Node2D

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Editor.tscn")


func _ready():
	loadMap("map.txt")


func loadMap(fileName) :
	
	var FieldTile = preload("res://scenes/FieldTile.tscn")
	
	var file = File.new()
	
	if file.file_exists("res://maps/" + fileName) :
		
		file.open("res://maps/" + fileName, File.READ)
		var data = JSON.parse(file.get_as_text())
		file.close()
		
		for item in data.result:
			var tile = FieldTile.instance()
			tile.drawTile(item)
			$tiles.add_child(tile)
		
	else :
		
		print("Map not found")


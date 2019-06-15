extends Node

var tankPosition = Vector2()
var selectedItem = 0

static func is_bit_enabled(mask, index):
    return mask & (1 << index) != 0

static func enable_bit(mask, index):
    return mask | (1 << index)

static func disable_bit(mask, index):
    return mask & ~(1 << index)
	
		
static func loadMap(num) :
	var MapData = preload("res://scripts/Maps.gd");
	var data = MapData.new()
	return data.maplist[num - 1]
	

static func saveMap(num, data):
	var file = File.new()
	var fn = "res://maps/map_" + str(num) + ".txt";
	file.open(fn, File.WRITE)
	file.store_string(JSON.print(data))
	file.close()

		
static func loadGame() :
	var file = File.new()
	var savePath = "user://save.dat"
	if file.file_exists(savePath) :
		file.open(savePath, File.READ)
		var data = JSON.parse(file.get_as_text())
		file.close()
		return data.result
	else :
		return null
		
static func saveGame(num):
	var file = File.new()
	var savePath = "user://save.dat"
	file.open(savePath, File.WRITE)
	var data = {"stage":num}
	file.store_string(JSON.print(data))
	file.close()
	
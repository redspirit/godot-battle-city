extends KinematicBody2D

var indexToFrame = {
	0: 2,		#block
	1: 3,		#grass
	2: 4,		#ice
	3: 5,		#brick
	4: 'water'	#water
}

var colLayers = {
	0: [3,0],
	1: [0,0],
	2: [0,0],
	3: [3,0],
	4: [4,0]
}


func drawTile(tileData) :
	
	var index = int(tileData[2])
	
	var frame = indexToFrame[index]
	var collayer = colLayers[index]
	
	position.x = tileData[0] * 16 + 8
	position.y = tileData[1] * 16 + 8
	
	collision_layer = collayer[0]
	collision_mask = collayer[1]
	
	if typeof(frame) == TYPE_STRING :
		$sprite/anim.play('water')
	else :
		$sprite.frame = frame

	if index == 1 :
		z_index = 10
	
	if index == 3 :
		#isBrick = true
		
		$sprite.visible = false
		$collision.disabled = true
		
		$brick.visible = true
		
		for node in $brick.get_children():
			node.get_node("coll").disabled = false

func explodeBrick(body):
	var n = body.name
	var angle = Global.tankPosition.angle_to_point(body.get_parent().global_position) * 57.295

	var line = ""
	if angle > -45 && angle < 45:
		line = "H"
	elif angle > -135 && angle < -45:
		line = "V"
	elif angle > 45 && angle < 135:
		line = "V"
	else :
		line = "H"
		
	if n == "DL" && line == "V" : 
		remove_node("DR")
	if n == "DR" && line == "V": 
		remove_node("DL")
	if n == "UL" && line == "V" : 
		remove_node("UR")
	if n == "UR" && line == "V": 
		remove_node("UL")

	if n == "DL" && line == "H" : 
		remove_node("UL")
	if n == "UL" && line == "H": 
		remove_node("DL")
	if n == "DR" && line == "H" : 
		remove_node("UR")
	if n == "UR" && line == "H": 
		remove_node("DR")
		
	body.queue_free()
	
	
func remove_node(name):
	if $brick.has_node(name):
		$brick.get_node(name).queue_free()
	
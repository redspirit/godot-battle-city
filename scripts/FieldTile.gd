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
	
	if index == 1 :
		z_index = 10
	
	if typeof(frame) == TYPE_STRING :
		
		$sprite/anim.play('water')
	
	else :
		
		$sprite.frame = frame

	
func _ready():
	print()

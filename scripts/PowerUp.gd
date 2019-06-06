extends Area2D

var states = {
	"kaska": 272,
	"clock": 273,
	"shovel": 274,
	"star": 275,
	"granade": 276,
	"tank": 277 
}

func _ready():
	$sprite.visible = false
	randomize()
	randomSpawn()

func _physics_process(delta):
	print('>> ', get_overlapping_bodies().size())
	

func randomSpawn() :	
	var index = int(rand_range(272, 277+1))
	$sprite.frame = index
	print("spawn ", index)
	
	
	
	while (get_overlapping_bodies().size() > 0) :
		
		var pos = Vector2(rand_range(32, 448), rand_range(32, 448)).snapped(Vector2(8, 8))
		print(pos)
		position = pos
	
	
	$sprite.visible = true
	
	#connect("body_entered", self, "_on_PowerUp_body_entered")
	


func _on_PowerUp_body_entered(body):
	#print("power up ", body.name)
	pass

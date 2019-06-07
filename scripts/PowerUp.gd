extends Area2D

var states = {
	"kaska": 272,
	"clock": 273,
	"shovel": 274,
	"star": 275,
	"granade": 276,
	"tank": 277 
}

var isFirstTick = true;
var isStand = false
var currentState = 0
var lifeTime = 10 #seconds
var timeElapsed = 0

func _ready():
	randomize()
	currentState = int(rand_range(272, 277+1))
	$sprite.visible = false
	$sprite.frame = currentState
	print("spawn ", currentState)
	

func _physics_process(delta):
	
	if isStand :
		timeElapsed += delta
		if timeElapsed > lifeTime :
			queue_free()
		return false;
	
	if isFirstTick :
		isFirstTick = false
		return true
		
	if get_overlapping_bodies().size() > 0 :
		position = Vector2(rand_range(32, 448), rand_range(32, 448)).snapped(Vector2(8, 8))
	else :
		isStand = true
		$sprite.visible = true
		$sprite/anim.play("blink")
		connect("body_entered", self, "_on_PowerUp_body_entered")
	

func _on_PowerUp_body_entered(body):
	if body.name == "tank" :
		print("power up ", currentState)
		queue_free()

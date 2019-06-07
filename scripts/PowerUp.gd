extends Area2D

signal catchPowerUp(name)

var names = {
	272: "helmet",		#временное силовое поле, неуязвимость
	273: "timer",		#замораживает врагов
	274: "shovel",		#окапывает штаб бронью
	275: "star",		#повышение ранга
	276: "granade",		#убивает всех врагов
	277: "tank" 		#+1 жизнь
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
		emit_signal("catchPowerUp", names[currentState])
		queue_free()

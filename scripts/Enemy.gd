extends KinematicBody2D

signal enemyKilled

var isFirstTick = true;
var isStand = false

func _ready():
	randomize()
	$sprite.visible = false
	$spawnSprite.visible = false


func _physics_process(delta):
	
	if isStand :
		return false
		
	if isFirstTick :
		isFirstTick = false
		return true

	if $Area2D.get_overlapping_bodies().size() > 0 :
		position = Vector2(rand_range(32, 448), rand_range(32, 448)).snapped(Vector2(16, 16))
	else :
		isStand = true
		$spawnSprite.visible = true
		$spawnSprite/anim.play("spawn")



# анимация спавна кончается
func _on_anim_animation_finished(anim_name):
	$spawnSprite.visible = false
	$sprite.visible = true


# ловим пулю
func _on_Area2D_area_entered(area):
	if area.name == "bulletArea" :
		$sprite.visible = false
		$explode.visible = true
		$explode/anim.play("explode")

func _on_explode_animation_finished(anim_name):
	emit_signal("enemyKilled")
	queue_free()

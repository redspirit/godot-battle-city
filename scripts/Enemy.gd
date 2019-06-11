extends KinematicBody2D

signal enemyKilled

var isEnemy = true
var isFirstTick = true;
var isSpawned = false
var motion = Vector2()
var SPEED = 50
var dir = "down"

var Bullet = preload("res://scenes/Bullet.tscn");

func _ready():
	randomize()
	$Area2D/coll.disabled = true
	$sprite.visible = false
	$spawnSprite.visible = true
	$spawnSprite/anim.play("spawn")
	
func setDir() :
	dir = ["up", "left", "right", "down"][int(rand_range(0, 4))];
	$sprite.playDirection(dir)
	if dir == "up":
		motion = Vector2(0, -1)
	if dir == "down":
		motion = Vector2(0, 1)
	if dir == "left":
		motion = Vector2(-1, 0)
	if dir == "right":
		motion = Vector2(1, 0)
		
	$movieTimer.start()


func _physics_process(delta):
	
	var offset = move_and_slide(motion * SPEED);
	
	if isSpawned && offset.length() == 0 && motion.length() > 0:
		setDir()
	


# анимация спавна кончается
func _on_anim_animation_finished(anim_name):
	$spawnSprite.visible = false
	$sprite.visible = true
	setDir()
	$sprite.setSkin(int(rand_range(1, 5)))
	isSpawned = true
	$shotTimer.start()
	$Area2D/coll.disabled = false


# ловим пулю
func _on_Area2D_area_entered(area):
#	pass
	if area.name == "bulletArea" && area.get_parent().get("isPlayerBullet"):
		$sprite.visible = false
		$explode.visible = true
		$explode/anim.play("explode")
		motion = Vector2()
		$movieTimer.stop()
		$shotTimer.stop()
		

func _on_explode_animation_finished(anim_name):
	emit_signal("enemyKilled")
	queue_free()


func _on_Timer_timeout():
	set_position( position.snapped(Vector2(8, 8)) )
	setDir()


func _on_shotTimer_timeout():
	var bul = Bullet.instance()
	bul.shoot(get_position(), dir, false)
	$"../../bulletList".add_child(bul)

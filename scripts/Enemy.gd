extends KinematicBody2D

signal enemyKilled

var isFirstTick = true;
var isStand = false
var isSpawned = false
var motion = Vector2()
var SPEED = 50
var dir = "down"

var Bullet = preload("res://scenes/Bullet.tscn");

func _ready():
	randomize()
	$sprite.visible = false
	$spawnSprite.visible = false

	

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
		
	$Timer.start()


func _physics_process(delta):
	
	var offset = move_and_slide(motion * SPEED);
	
	if isSpawned && offset.length() == 0 && motion.length() > 0:
		setDir()
	
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
	setDir()
	$sprite.setSkin(int(rand_range(1, 5)))
	isSpawned = true


# ловим пулю
func _on_Area2D_area_entered(area):
	if area.name == "bulletArea" :
		$sprite.visible = false
		$explode.visible = true
		$explode/anim.play("explode")
		motion = Vector2()
		$Timer.stop()

func _on_explode_animation_finished(anim_name):
	emit_signal("enemyKilled")
	queue_free()


func _on_Timer_timeout():
	#var bul = Bullet.instance()
	#bul.start(position, dir)
	#$"../../bulletList".add_child(bul)
	setDir()


extends KinematicBody2D


var SPEED = 80
var dir = ""
var inertia = 0
var startForce = 1
var isMoving = false
var canMove = false

var Bullet = preload("res://scenes/Bullet.tscn");

func _ready():
	dir = "up"
	$sprite.visible = false
	$spawnSprite.visible = true
	$spawnSprite/anim.play("spawn")

var isOldMoving = false
var motion = Vector2()

func _physics_process(delta):

	if Input.is_action_pressed("ui_up"):
		#motion = Vector2(0, -1);
		motion.y += -startForce
		motion.x = 0
		if motion.y < -1 :
			motion.y = -1
		$anim.play("up")
		dirChanged(dir, "up")
		dir = "up"
		isMoving = true
	elif Input.is_action_pressed("ui_down"):
		#motion = Vector2(0, 1);
		motion.y += startForce
		motion.x = 0
		if motion.y > 1 :
			motion.y = 1
		$anim.play("down")
		dirChanged(dir, "down")
		dir = "down"
		isMoving = true
	elif Input.is_action_pressed("ui_left"):
		#motion = Vector2(-1, 0);
		motion.x += -startForce
		motion.y = 0
		if motion.x < -1 :
			motion.x = -1
		$anim.play("left")
		dirChanged(dir, "left")
		dir = "left"
		isMoving = true
	elif Input.is_action_pressed("ui_right"):
		#motion = Vector2(1, 0);
		motion.x += startForce
		motion.y = 0
		if motion.x > 1 :
			motion.x = 1
		$anim.play("right")
		dirChanged(dir, "right")
		dir = "right"
		isMoving = true
	else :
		$anim.stop()
		isMoving = false
		motion = motion * inertia
		if motion.length() < 0.05 :
			motion = Vector2()
		
	if !canMove :
		motion = Vector2()
		
	if(isMoving != isOldMoving) :
		if isMoving :
			changeMove(1)
		else :
			changeMove(0)
	
	isOldMoving = isMoving
		
	if isMoving :
		if $area.get_overlapping_bodies().size() > 0 :
			inertia = 0.95
			startForce = 0.02
		else :
			inertia = 0
			startForce = 1
		
		
	if Input.is_action_just_pressed("ui_select") :
		if($"../bulletList".get_child_count() == 0) :
			var bul = Bullet.instance()
			bul.start(position, dir)
			$"../bulletList".add_child(bul)
		
		
		
	var res = move_and_slide(motion * SPEED);
	motion = res / SPEED
	
	
	Global.tankPosition = global_position


func dirChanged(oldDir, newDir) :
	
	if (oldDir == "up" || oldDir == "down") && newDir == "right":
		snapToGrid("right")
	
	if (oldDir == "up" || oldDir == "down") && newDir == "left":
		snapToGrid("left")
	
	if (oldDir == "right" || oldDir == "left") && newDir == "up":
		snapToGrid("up")
	
	if (oldDir == "right" || oldDir == "left") && newDir == "down":
		snapToGrid("down")
	
	
func snapToGrid(_dir) :
	var step = 8;
	position = position.snapped(Vector2(step, step))
	
func changeMove(moving):
	pass
		
		
		
# SPAWN ANIMATION		
func _on_anim_animation_finished(anim_name):
	$sprite.visible = true
	$spawnSprite.visible = false
	canMove = true

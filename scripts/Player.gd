extends KinematicBody2D


var SPEED = 80;
var dir = "";

var Bullet = preload("res://scenes/Bullet.tscn");

func _ready():
	dir = "up"

var oldMotion = Vector2()

func _physics_process(delta):

	var motion = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		motion = Vector2(0, -1);
		$anim.play("up")
		dirChanged(dir, "up")
		dir = "up"
	elif Input.is_action_pressed("ui_down"):
		motion = Vector2(0, 1);
		$anim.play("down")
		dirChanged(dir, "down")
		dir = "down"
	elif Input.is_action_pressed("ui_left"):
		motion = Vector2(-1, 0);
		$anim.play("left")
		dirChanged(dir, "left")
		dir = "left"
	elif Input.is_action_pressed("ui_right"):
		motion = Vector2(1, 0);
		$anim.play("right")
		dirChanged(dir, "right")
		dir = "right"
	else :
		$anim.stop()
		
	if(motion.length() != oldMotion.length()) :
		if motion.x == 0 && motion.y == 0 :
			changeMove(0)
		else :
			changeMove(1)
	
	oldMotion = motion
		
	if Input.is_action_just_pressed("ui_select") :
		
		if($"../bulletList".get_child_count() == 0) :
			var bul = Bullet.instance()
			bul.start(position, dir)
			$"../bulletList".add_child(bul)
		
		
		
		
		
	move_and_slide(motion * SPEED);
	
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
	#print("MOVING ", moving)
	var ices = $area.get_overlapping_bodies()
	if ices.size() > 0 :
		print('COLLL ', ices.size())
		
		
		
			
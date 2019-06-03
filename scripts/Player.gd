extends KinematicBody2D


var SPEED = 80;
var dir = "";

var Bullet = preload("res://scenes/Bullet.tscn");

func _ready():
	dir = "up"

func _physics_process(delta):

	var motion = Vector2();
	
	if Input.is_action_pressed("ui_up"):
		motion = Vector2(0, -1);
		$anim.play("up")
		dir = "up"
	elif Input.is_action_pressed("ui_down"):
		motion = Vector2(0, 1);
		$anim.play("down")
		dir = "down"
	elif Input.is_action_pressed("ui_left"):
		motion = Vector2(-1, 0);
		$anim.play("left")
		dir = "left"
	elif Input.is_action_pressed("ui_right"):
		motion = Vector2(1, 0);
		$anim.play("right")
		dir = "right"
	else :
		$anim.stop()
		
	if Input.is_action_just_pressed("ui_select") :
		
		if($"../bulletList".get_child_count() == 0) :
			var bul = Bullet.instance()
			bul.start(position, dir)
			$"../bulletList".add_child(bul)
		
		
		
	move_and_slide(motion * SPEED);

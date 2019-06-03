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
		$anim.current_animation = "up"
		dir = "up"
	elif Input.is_action_pressed("ui_down"):
		motion = Vector2(0, 1);
		$anim.current_animation = "down"
		dir = "down"
	elif Input.is_action_pressed("ui_left"):
		motion = Vector2(-1, 0);
		$anim.current_animation = "left"
		dir = "left"
	elif Input.is_action_pressed("ui_right"):
		motion = Vector2(1, 0);
		$anim.current_animation = "right"
		dir = "right"
	else :
		$anim.current_animation = ""
		
	if Input.is_action_just_pressed("ui_select") :
		var bul = Bullet.instance()
		bul.start(position, dir)
		$"../".add_child(bul)
		
	move_and_slide(motion * SPEED);

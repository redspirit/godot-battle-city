extends KinematicBody2D


var SPEED = 80;

func _physics_process(delta):

	var motion = Vector2();
	
	if Input.is_action_pressed("ui_up"):
		motion = Vector2(0, -1);
		$anim.current_animation = "up"
	elif Input.is_action_pressed("ui_down"):
		motion = Vector2(0, 1);
		$anim.current_animation = "down"
	elif Input.is_action_pressed("ui_left"):
		motion = Vector2(-1, 0);
		$anim.current_animation = "left"
	elif Input.is_action_pressed("ui_right"):
		motion = Vector2(1, 0);
		$anim.current_animation = "right"
	else :
		$anim.current_animation = ""
		
		
	move_and_slide(motion * SPEED);

extends KinematicBody2D


var SPEED = 300;
var dir = ''
var motion = Vector2()

func _ready():
	pass

func _physics_process(delta):
	position += motion * SPEED * delta



func start(point, _dir) :
	dir = _dir;
	position = point
	
	if dir == 'up' :
		position.y -= 20
		motion = Vector2(0, -1);
		$Sprite.frame = 0
	if dir == 'down' :
		position.y += 20
		motion = Vector2(0, 1);
		$Sprite.frame = 6
	if dir == 'left' :
		position.x -= 20
		motion = Vector2(-1, 0);
		$Sprite.frame = 1
	if dir == 'right' :
		position.x += 20
		motion = Vector2(1, 0);
		$Sprite.frame = 7


func _on_Area2D_body_entered(body):
	if body.name != 'bullet' && body.name != 'tank' : 
		motion = Vector2()
		$explode_sprite.visible = true;
		$explode_sprite/anim.play("explode");


	if body.get_parent().name == "brick":
		body.get_parent().get_parent().explodeBrick(body)



func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
	
	

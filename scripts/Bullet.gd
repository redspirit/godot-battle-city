extends KinematicBody2D


var SPEED = 300;
var dir = ''
var motion = Vector2()
var isPlayerBullet = true

func _ready():
	pass

func _physics_process(delta):
	position += motion * SPEED * delta



func start(point, _dir, isPlayer) :
	dir = _dir;
	position = point
	isPlayerBullet = isPlayer
	
	if isPlayer:
		$bulletArea.collision_layer = 2
	else :
		$bulletArea.collision_layer = 8
	
	print(dir)
	var dist = 20
	
	if dir == 'up' :
		position.y -= dist
		motion = Vector2(0, -1);
		$Sprite.frame = 0
	if dir == 'down' :
		position.y += dist
		motion = Vector2(0, 1);
		$Sprite.frame = 6
	if dir == 'left' :
		position.x -= dist
		motion = Vector2(-1, 0);
		$Sprite.frame = 1
	if dir == 'right' :
		position.x += dist
		motion = Vector2(1, 0);
		$Sprite.frame = 7


func _on_Area2D_body_entered(body):
	if (body.name != 'bullet') || ( body.name == 'tank' && !isPlayerBullet) : 
		motion = Vector2()
		$explode_sprite.visible = true;
		$explode_sprite/anim.play("explode");


	if body.get_parent().name == "brick":
		body.get_parent().get_parent().explodeBrick(body)



func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
	
	

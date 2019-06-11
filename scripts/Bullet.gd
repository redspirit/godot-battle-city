extends KinematicBody2D


var SPEED = 300;
var dir = ''
var motion = Vector2()
var isPlayerBullet = true
var startPoint

func _ready():
	pass

func _physics_process(delta):
	position += motion * SPEED * delta



func shoot(point, _dir, isPlayer) :
	dir = _dir;
	position = point
	startPoint = point
	isPlayerBullet = isPlayer
	
	if isPlayer:
		$bulletArea.collision_layer = 2
		add_to_group("player")
	else :
		$bulletArea.collision_layer = 8
		add_to_group("enemy")
	
	var dist = 16
	
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


func explode() :
	motion = Vector2()
	$explode_sprite.visible = true;
	$explode_sprite/anim.play("explode");
	

func _on_Area2D_body_entered(body):
	
	if body.get_parent().name == "brick":
		body.get_parent().get_parent().explodeBrick(body, startPoint)
	
	if isPlayerBullet && body.name != 'tank' :
		explode()
		
	if !isPlayerBullet && !body.get("isEnemy") :
		explode()


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
	

# ловим попадание пули в пулю
func _on_bulletArea_area_entered(area):
	if area.name == "bulletArea":
		if area.get_parent().get("isPlayerBullet") && !isPlayerBullet:
			explode()
		if !area.get_parent().get("isPlayerBullet") && isPlayerBullet:
			explode()

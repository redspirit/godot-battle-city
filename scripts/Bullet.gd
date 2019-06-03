extends KinematicBody2D


var SPEED = 150;
var dir = ''
var isAction = false
var motion = Vector2()

func _ready():
	pass

func _physics_process(delta):
	if isAction :
		position += motion * SPEED * delta
		


func start(point, _dir) :
	dir = _dir;
	isAction = true;
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
	
	print('START ', dir);
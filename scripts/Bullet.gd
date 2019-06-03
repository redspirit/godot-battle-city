extends KinematicBody2D


var SPEED = 4;
var dir = ''
var isAction = false

func _ready():
	pass

func _physics_process(delta):
	if isAction :
		if dir == 'up' :
			position.y -= SPEED
		if dir == 'down' :
			position.y += SPEED
		if dir == 'left' :
			position.x -= SPEED
		if dir == 'right' :
			position.x += SPEED


func start(_dir) :
	dir = _dir;
	isAction = true;
	print('START');
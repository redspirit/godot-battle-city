extends Sprite

export(int, "Player", "Enemy") var tank_type
export(float, 2) var walk_interval = 1.0

var currentWalkInterval = 0
var isPlay = false

var frameSet = [0, 1]
var frameIndex = 0
var skinOffset = 0

func _ready():
	pass

func _physics_process(delta):
	
	currentWalkInterval += delta
	if currentWalkInterval >= walk_interval :
		currentWalkInterval = 0
		if isPlay :
			onFrame()
	

func onFrame() :
	frameIndex += 1
	if frameIndex > 1 :
		frameIndex = 0
		
	set_frame(frameSet[frameIndex] + skinOffset + (tank_type * 72))

var oldDir = "";

func playDirection(dir): 
	
	if dir == "up" :
		frameSet = [0, 1]
	elif dir == "left" :
		frameSet = [2, 3]
	elif dir == "down" :
		frameSet = [4, 5]
	elif dir == "right" :
		frameSet = [6, 7]

	if oldDir != dir :
		onFrame()

	isPlay = true
	oldDir = dir;


func setSkin(num): 
	skinOffset = (num - 1) * 16

	
func stop() :
	isPlay = false
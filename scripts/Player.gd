extends KinematicBody2D

signal playerKilled

var baseSpeed = 60
var baseBulletSpeed = 160
var dir = ""
var inertia = 0
var startForce = 1
var isMoving = false
var canMove = false

var isShield = false;
var shieldCurrentTime = 0
var shieldTotalTime = 5

var tiers = [
	{"skin": 1, "speed": 1, 	"bulletsCount": 1, "bulletSpeed": 1},
	{"skin": 2, "speed": 1.5, 	"bulletsCount": 1, "bulletSpeed": 1.7},
	{"skin": 3, "speed": 2, 	"bulletsCount": 2, "bulletSpeed": 2.3},
	{"skin": 4, "speed": 2, 	"bulletsCount": 2, "bulletSpeed": 3}
]

var currentTierNum = 0
var currentTier = tiers[currentTierNum]

var Bullet = preload("res://scenes/Bullet.tscn");

func _ready():
	visible = false
	
var isOldMoving = false
var motion = Vector2()

var pressedMask = 0
	

func _physics_process(delta):

	if isShield :
		shieldCurrentTime += delta
	if shieldCurrentTime > shieldTotalTime :
		setShield(false, 0)

	if Input.is_action_pressed("ui_up") && (dir == "up" || !isMoving):

		motion.y += -startForce
		motion.x = 0
		if motion.y < -1 :
			motion.y = -1
		dirChanged(dir, "up")
		dir = "up"
		isMoving = true
		
	elif Input.is_action_pressed("ui_down") && (dir == "down" || !isMoving):

		motion.y += startForce
		motion.x = 0
		if motion.y > 1 :
			motion.y = 1
		dirChanged(dir, "down")
		dir = "down"
		isMoving = true
		
	elif Input.is_action_pressed("ui_left") && (dir == "left" || !isMoving):

		motion.x += -startForce
		motion.y = 0
		if motion.x < -1 :
			motion.x = -1
		dirChanged(dir, "left")
		dir = "left"
		isMoving = true
		
	elif Input.is_action_pressed("ui_right") && (dir == "right" || !isMoving):

		motion.x += startForce
		motion.y = 0
		if motion.x > 1 :
			motion.x = 1
		dirChanged(dir, "right")
		dir = "right"
		isMoving = true
		
	else :
		
		$sprite.stop()
		isMoving = false
		motion = motion * inertia
		if motion.length() < 0.05 :
			motion = Vector2()
		
		
			
	if !canMove :
		motion = Vector2()
		
	if(isMoving != isOldMoving) :
		if isMoving :
			changeMove(1)
		else :
			changeMove(0)
	
	isOldMoving = isMoving
		
	if isMoving :
		if $area.get_overlapping_bodies().size() > 0 :
			inertia = 0.95
			startForce = 0.02
		else :
			inertia = 0
			startForce = 1
		
		
	if Input.is_action_just_pressed("ui_select") :
		
		if get_tree().get_nodes_in_group("player").size() < currentTier.bulletsCount:
			var bul = Bullet.instance()
			bul.shoot(get_position(), dir, true, baseBulletSpeed * currentTier.bulletSpeed)
			$"../bulletList".add_child(bul)
		
		
		
	var speed = baseSpeed * currentTier.speed
	var res = move_and_slide(motion * speed);
	motion = res / speed
	
	
	Global.tankPosition = get_position()


func dirChanged(oldDir, newDir) :
	
	$sprite.playDirection(newDir)
	
	if (oldDir == "up" || oldDir == "down") && newDir == "right":
		snapToGrid()
	
	if (oldDir == "up" || oldDir == "down") && newDir == "left":
		snapToGrid()
	
	if (oldDir == "right" || oldDir == "left") && newDir == "up":
		snapToGrid()
	
	if (oldDir == "right" || oldDir == "left") && newDir == "down":
		snapToGrid()
	
func snapToGrid() :
	var step = 8;
	set_position( position.snapped(Vector2(step, step)) )
	
func changeMove(isMovie) :
#	if isMovie :
#		$anim.play(dir)
#	else :
#		$anim.stop()
	pass
	

func setShield(state, timeout):
	isShield = state
	if state: 
		shieldTotalTime = timeout
		$shield.visible = true
		$shield/anim.play("active")
	else :
		shieldCurrentTime = 0
		$shield.visible = false
		$shield/anim.stop()

func powerMe() :
	currentTierNum += 1
	if currentTierNum > 3:
		currentTierNum = 3
		
	currentTier = tiers[currentTierNum]
	$sprite.setSkin(currentTier.skin, false)


func respawn(startPos):
	position.x = startPos.x
	position.y = startPos.y
	dir = "up"
	visible = true
	$sprite.visible = false
	$spawnSprite.visible = true
	$spawnSprite/anim.play("spawn")
	$area/areaColl.disabled = true
	
	# reset tier
	currentTierNum = 0
	currentTier = tiers[currentTierNum]
	$sprite.setSkin(currentTier.skin, false)

# SPAWN ANIMATION
func _on_anim_animation_finished(anim_name):
	$sprite.visible = true
	$spawnSprite.visible = false
	canMove = true
	setShield(true, 2)
	$area/areaColl.disabled = false


func _on_shield_animation_finished(anim_name):
	$shield.visible = false


func _on_area_area_entered(area):
	if area.name == "bulletArea":
		$sprite.visible = false
		$explode.visible = true
		$explode/anim.play("explode")
		canMove = false

#конец анимации взрыва - уничтожаем игрока
func _on_explode_animation_finished(anim_name):
	$explode.visible = false
	emit_signal("playerKilled")

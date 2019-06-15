extends KinematicBody2D

signal enemyKilled(isPowered)

var isEnemy = true
var isFirstTick = true;
var isSpawned = false
var isStand = false
var motion = Vector2()
var baseSpeed = 40
var baseBulletSpeed = 150
var dir = "down"
var health = 1
var isPowered = false
var isFreeze = false

var tiers = [
	{"speed": 1, "skin": 1, "health": 1, "bulletSpeed": 1},
	{"speed": 3, "skin": 2, "health": 1, "bulletSpeed": 2},
	{"speed": 2, "skin": 3, "health": 1, "bulletSpeed": 3},
	{"speed": 2, "skin": 4, "health": 3, "bulletSpeed": 2}
]

var currentTier

var Bullet = preload("res://scenes/Bullet.tscn");

func _ready():
	pass
	
	
func spawn(tierNum, _isPowered):
	randomize()
	isPowered = _isPowered
	$sprite.visible = false
	currentTier = tiers[tierNum - 1]
	health = currentTier.health
	visible = false
	
func setDir() :
	dir = ["up", "left", "right", "down"][int(rand_range(0, 4))];
	$sprite.playDirection(dir)
	if dir == "up":
		motion = Vector2(0, -1)
	if dir == "down":
		motion = Vector2(0, 1)
	if dir == "left":
		motion = Vector2(-1, 0)
	if dir == "right":
		motion = Vector2(1, 0)
		
	$movieTimer.start()

func _physics_process(delta):
	
	if isFirstTick :
		isFirstTick = false
		return true
		
	if isFreeze:
		return
		
	if !isStand:
		
		if $SpawnArea.get_overlapping_bodies().size() > 0 :
			position = Vector2(rand_range(32, 448), 32).snapped(Vector2(16, 16))
			#print(position)
		else :
			isStand = true
			visible = true
			$spawnSprite.visible = true
			$spawnSprite/anim.play("spawn")
			$Area2D/coll.disabled = true

	else :
	
		var offset = move_and_slide(motion * currentTier.speed * baseSpeed * Global.speed);
		if isSpawned && offset.length() == 0 && motion.length() > 0:
			setDir()


# анимация спавна кончается
func _on_anim_animation_finished(anim_name):
	$spawnSprite.visible = false
	$sprite.visible = true
	setDir()
	$sprite.setSkin(currentTier.skin, isPowered)
	isSpawned = true
	$shotTimer.start()
	$Area2D/coll.disabled = false


# ловим пулю
func _on_Area2D_area_entered(area):
	if area.name == "bulletArea" && area.get_parent().get("isPlayerBullet"):
		health -= 1
		if health == 0:
			explodeMe()
		
		
func explodeMe() :
	$sprite.visible = false
	$explode.visible = true
	$explode/anim.play("explode")
	motion = Vector2()
	$movieTimer.stop()
	$shotTimer.stop()

func freeze(timeout) :
	isFreeze = true
	$freezeTimer.start(timeout)

func _on_explode_animation_finished(anim_name):
	emit_signal("enemyKilled", isPowered)
	queue_free()


func _on_Timer_timeout():
	if isFreeze:
		return
	set_position( position.snapped(Vector2(8, 8)) )
	setDir()


func _on_shotTimer_timeout():
	if isFreeze:
		return
	var bul = Bullet.instance()
	bul.shoot(position, dir, false, currentTier.bulletSpeed * baseBulletSpeed)
	$"../../bulletList".add_child(bul)

func _on_freezeTimer_timeout():
	isFreeze = false

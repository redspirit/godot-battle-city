extends Node2D

var PowerUp = preload("res://scenes/PowerUp.tscn")
var Enemy = preload("res://scenes/Enemy.tscn")
var tankPos = Vector2()

var lives = 3
var enimiesStack = [		# [offset, tier, isPowered]
	[0,1,false], [208,1,false], [416,1,false],
	[0,1,true], [208,2,false], [416,1,false],
	[0,1,false], [208,1,false], [416,2,false],
	[0,2,false], [208,3,true], [416,1,false],
	[0,3,false], [208,2,false], [416,3,false],
	[0,1,false], [208,2,true], [416,3,false],
	[0,4,false], [208,4,false]
]

var livingEnemies = enimiesStack.size()


func _on_Button_pressed():
	#get_tree().change_scene("res://scenes/Editor.tscn")
	spawnPowerUp()
	pass



func _ready():

	$ChangeStageUI.show()
	
	

func spawnEnemy():
	
	var enemy = Enemy.instance()
	var info = enimiesStack.pop_front()
	var offset = info[0]
	var tier = info[1]
	var isPowered = info[2]
	enemy.spawn(tier, isPowered)
	enemy.set_position(Vector2(16 + 16 + offset, 16 + 16))
	$enemies.add_child(enemy)
	enemy.connect("enemyKilled", self, "_on_EnemyKilled")
	
	
func _on_EnemyKilled(isPoweredEnemy):
	livingEnemies -= 1
	$UI/EnemiesLabel.text = str(livingEnemies)
	
	if isPoweredEnemy :
		spawnPowerUp()
	
	if enimiesStack.size() > 0 :
		spawnEnemy()
		
	if livingEnemies == 0 :
		print("VICTORY")
		
	
func _on_PlayerKilled():
	lives -= 1
	$UI/livesLabel.text = str(lives)
	if lives == 0:
		$tank.queue_free()
		doGameOver()
	else :
		$tank.respawn(tankPos)
	

func doGameOver() :
	get_tree().change_scene("res://scenes/GameOver.tscn")
	
func loadMap(fileName) :

	var FieldTile = preload("res://scenes/FieldTile.tscn")
	
	var file = File.new()
	
	if file.file_exists("res://maps/" + fileName) :
		
		file.open("res://maps/" + fileName, File.READ)
		var data = JSON.parse(file.get_as_text())
		file.close()
		
		for item in data.result:
			if item[2] == 5 :		#eagle
				$Eagle.position.x = item[0] * 16 + 32
				$Eagle.position.y = item[1] * 16 + 32
			elif item[2] == 6 :		#tank
				tankPos.x = item[0] * 16 + 32
				tankPos.y = item[1] * 16 + 32
			else :
				var tile = FieldTile.instance()
				tile.drawTile(item)
				$tiles.add_child(tile)
		
		onMapLoaded()
		
	else :
		
		print("Map not found")


func onMapLoaded() :
	$tank.respawn(tankPos)
	spawnEnemy()
	spawnEnemy()
	spawnEnemy()

func _on_Eagle_fortressDestroyed():
	doGameOver()


func spawnPowerUp():
	var pu = PowerUp.instance()
	$powerups.add_child(pu)
	pu.connect("catchPowerUp", self, "_on_catchPowerUp")
	
func destroyAllEnemies():
	for en in $enemies.get_children():
		en.explodeMe()

func freezeAllEnemies():
	for en in $enemies.get_children():
		en.freeze(10)
	
func _on_catchPowerUp(name) :
	print("catch PowerUp ", name)
	if name == "helmet" :		#временное силовое поле, неуязвимость
		$tank.setShield(true, 10)
	elif name == "timer" :		#замораживает врагов
		freezeAllEnemies()
	elif name == "shovel" :		#окапывает штаб бронью
		pass
	elif name == "star":		#повышение ранга
		$tank.powerMe()
	elif name == "granade" :	#убивает всех врагов
		destroyAllEnemies()
	elif name == "tank":		#+1 жизнь
		lives += 1
		$UI/livesLabel.text = str(lives)

func _on_ChangeStageUI_endShowing():
	loadMap("map2.txt")
	$tank.connect("playerKilled", self, "_on_PlayerKilled")
	$UI/livesLabel.text = str(lives)
	$UI/EnemiesLabel.text = str(livingEnemies)

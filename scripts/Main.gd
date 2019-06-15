extends Node2D

var PowerUp = preload("res://scenes/PowerUp.tscn")
var Enemy = preload("res://scenes/Enemy.tscn")
var FieldTile = preload("res://scenes/FieldTile.tscn")
var tankPos = Vector2()
var currentMapNum

var lives = 3
var enimiesStack = []

var livingEnemies = 0

func _ready():
	$tank.connect("playerKilled", self, "_on_PlayerKilled")
	
	if Global.selectedItem == 0 :		# new game
		currentMapNum = 1
		Global.saveGame(1)
	elif Global.selectedItem == 1 :		#continue
		var gameData = Global.loadGame()
		if gameData:
			currentMapNum = gameData.stage
		else :
			currentMapNum = 1
	$ChangeStageUI.showed(currentMapNum)
	
	
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
		endStage()
		
	
func endStage():
	currentMapNum += 1
	if currentMapNum > 10 :
		print("GAME ENDED!")
	else :
		Global.saveGame(currentMapNum)
		$ChangeStageUI.showed(currentMapNum)

	
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
	
func loadMap() :
	
	
	for it in $tiles.get_children():
		it.queue_free()
	
	var data = Global.loadMap(currentMapNum)
	
	if data:
		
		enimiesStack = data.enemies
		livingEnemies = enimiesStack.size()
		
		for item in data.map:
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
		print("Map not loaded")


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

var blockTilesSet = []
func protectFortress(isBlock) :
	var coords = [ [0,0], [1,0], [2,0], [3,0], [0,1], [0,2], [3,1], [3,2] ]
	var tileIndex = 3
	if isBlock:
		tileIndex = 0
		$fortressTimer.start(10)
		
	if !isBlock:
		for t in blockTilesSet:
			t.queue_free()
		blockTilesSet = []
		
	for coord in coords:
		var tx = coord[0] + 12
		var ty = coord[1] + 25
		var finded = $tiles.get_node("tile_" + str(tx) + "_" + str(ty))
		if finded:
			finded.queue_free()
		var tile = FieldTile.instance()
		tile.drawTile([ tx, ty, tileIndex ])
		$tiles.add_child(tile)
		if isBlock:
			blockTilesSet.append(tile)
	
func _on_fortressTimer_timeout():
	protectFortress(false)
	
func _on_catchPowerUp(name) :
	print("catch PowerUp ", name)
	if name == "helmet" :		#временное силовое поле, неуязвимость
		$tank.setShield(true, 10)
	elif name == "timer" :		#замораживает врагов
		freezeAllEnemies()
	elif name == "shovel" :		#окапывает штаб бронью
		protectFortress(true)
	elif name == "star":		#повышение ранга
		$tank.powerMe()
	elif name == "granade" :	#убивает всех врагов
		destroyAllEnemies()
	elif name == "tank":		#+1 жизнь
		lives += 1
		$UI/livesLabel.text = str(lives)

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Editor.tscn")
	#endStage()
	#spawnPowerUp()
	pass

func _on_ChangeStageUI_endShowing():
	loadMap()
	$UI/livesLabel.text = str(lives)
	$UI/EnemiesLabel.text = str(livingEnemies)


extends Node2D


var PowerUp = preload("res://scenes/PowerUp.tscn")
var Enemy = preload("res://scenes/Enemy.tscn")
var tankPos = Vector2()

var lives = 3

func _on_Button_pressed():
	#get_tree().change_scene("res://scenes/Editor.tscn")
	spawnEnemy()


func _ready():
	loadMap("map2.txt")
	$tank.connect("playerKilled", self, "_on_PlayerKilled")
	$UI/livesLabel.text = str(lives)


func spawnEnemy():
	var enemy = Enemy.instance()
	$enemies.add_child(enemy)
	enemy.connect("enemyKilled", self, "_on_EnemyKilled")
	
func _on_EnemyKilled():
	print('_on_EnemyKilled')
	spawnEnemy()
	
func _on_PlayerKilled():
	lives -= 1
	$UI/livesLabel.text = str(lives)
	if lives == 0:
		print("GAME OVER")
		$tank.queue_free()
	else :
		$tank.respawn(tankPos)
	

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
		
		$tank.respawn(tankPos)
		
	else :
		
		print("Map not found")



func _on_Eagle_fortressDestroyed():
	print("RUN GAME OVER")
	
	var pu = PowerUp.instance()
	$powerups.add_child(pu)
	pu.connect("catchPowerUp", self, "_on_catchPowerUp")
	
	
func _on_catchPowerUp(name) :
	print("_on_catchPowerUp ", name)
extends Node2D


var cursorCoords = [240, 289, 333]
var cursorIndex = 0
var continueDisabled = true
var canMove = true

func _ready():
	$Tank/fireSprite.visible = false
	$Tank/movieSprite.visible = true
	$Tank/movieSprite/anim.play("move")
	$Tank/anim.play("roll")
	
	$MainTheme.play()
	
	var gameData = Global.loadGame()
	if gameData:
		continueDisabled = !(gameData.stage > 1)
	
	if continueDisabled :
		$TextMenu/Label2.set("custom_colors/font_color", Color("2e2e2e"))
		

func _process(delta):

	if Input.is_action_just_pressed("ui_down") && canMove:
		cursorIndex += 1
		if cursorIndex >= 2:
			cursorIndex = 2
		$SelectSound.play()

	if Input.is_action_just_pressed("ui_up") && canMove:
		cursorIndex -= 1
		if cursorIndex <= 0:
			cursorIndex = 0
		$SelectSound.play()
	
	if Input.is_action_just_pressed("ui_accept") :
		
		if continueDisabled && cursorIndex == 1 :
			return
		
		$Shot.play()
		$Tank/fireSprite.visible = true
		$Tank/movieSprite.visible = false
		$Tank/fireSprite/anim.play("fire")
		canMove = false

	
	$Tank.position.y = cursorCoords[cursorIndex] - 5
	
	
func selectItem():
	Global.selectedItem = cursorIndex
	if cursorIndex == 0 :
		get_tree().change_scene("res://scenes/Main.tscn")
	elif cursorIndex == 1:
		get_tree().change_scene("res://scenes/Main.tscn")
	elif cursorIndex == 2:
		get_tree().quit()
		




func _on_Timer_timeout():
	pass


func _on_Fire_animation_finished(anim_name):
	selectItem()

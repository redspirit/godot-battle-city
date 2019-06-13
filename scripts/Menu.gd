extends Node2D


var cursorCoords = [240, 289, 333]
var cursorIndex = 0


func _ready():
	$Tank/fireSprite.visible = false
	$Tank/movieSprite.visible = true
	$Tank/movieSprite/anim.play("move")
	$Tank/anim.play("roll")

func _process(delta):

	if Input.is_action_just_pressed("ui_down") :
		cursorIndex += 1
		if cursorIndex >= 2:
			cursorIndex = 2

	if Input.is_action_just_pressed("ui_up") :
		cursorIndex -= 1
		if cursorIndex <= 0:
			cursorIndex = 0
	
	if Input.is_action_just_pressed("ui_accept") :
		$Shot.play()
		$Tank/fireSprite.visible = true
		$Tank/movieSprite.visible = false
		$Tank/fireSprite/anim.play("fire")

	
	$Tank.position.y = cursorCoords[cursorIndex] - 5
	
	
func selectItem():
	if cursorIndex == 0 :
		get_tree().change_scene("res://scenes/Main.tscn")
	elif cursorIndex == 1:
		print("CONTUNIE")
		get_tree().change_scene("res://scenes/GameOver.tscn")
	elif cursorIndex == 2:
		get_tree().quit()
		




func _on_Timer_timeout():
	$MainTheme.play()


func _on_Fire_animation_finished(anim_name):
	selectItem()

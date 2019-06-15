extends Node2D

signal doExit

func _ready():
	$Sound.play()

func _process(delta):
	
	if Input.is_action_just_pressed("ui_accept") :
		emit_signal("doExit")
		get_tree().change_scene("res://scenes/Menu.tscn")

func _on_AudioStreamPlayer_finished():
	$Sound.stop()

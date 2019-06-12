extends Node2D

signal doExit

func _ready():
	pass

func _process(delta):
	
	if Input.is_action_just_pressed("ui_accept") :
		emit_signal("doExit")
		get_tree().change_scene("res://scenes/Menu.tscn")
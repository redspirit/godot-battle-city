extends Node2D

signal endShowing


func show() :
	visible = true
	$StageTimer.start()
	$StageLabel.rect_position.y = -10
	$StageLabel/anim.play("roll-up")



func _on_StageTimer_timeout():
	visible = false
	emit_signal("endShowing")

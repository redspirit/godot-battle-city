extends Node2D

signal endShowing

func showed(num) :
	visible = true
	$StageTimer.start()
	$StageLabel.text = "STAGE " + str(num)
	$StageLabel.rect_position.y = -10
	$StageLabel/anim.play("roll-up")


func _on_StageTimer_timeout():
	visible = false
	emit_signal("endShowing")

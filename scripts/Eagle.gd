extends KinematicBody2D


func _on_Area2D_area_entered(area):
	#print(area.name)
	if area.name == "bulletArea" :
		$sprite.frame = 257
		$explode.visible = true
		$explode/anim.play("explode")
		$eagleArea.set_deferred("monitoring", false)
		print("GAME OVER!")

func _on_anim_animation_finished(anim_name):
	$explode.visible = false

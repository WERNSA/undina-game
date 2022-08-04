extends Sprite


func _on_BtnPause_pressed():
	$SoundPress.play()
	get_tree().call_deferred("change_scene", "res://Scenes/MenuPlay/MenuPlay.tscn")

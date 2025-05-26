extends Sprite2D


func _on_BtnPause_pressed():
	$SoundPress.play()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/MenuPlay/MenuPlay.tscn")

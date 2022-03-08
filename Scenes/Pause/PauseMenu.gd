extends Sprite


func _on_BtnPause_pressed():
	get_tree().call_deferred("change_scene", "res://Scenes/MenuPlay/MenuPlay.tscn")

extends Control



func _on_BtnBack_pressed():
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Menu/Menu.tscn")

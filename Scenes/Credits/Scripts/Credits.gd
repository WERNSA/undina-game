extends Control



func _on_BtnBack_pressed():
	get_tree().call_deferred("change_scene", "res://Scenes/Menu/Menu.tscn")

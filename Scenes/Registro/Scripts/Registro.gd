extends Control


func _on_LogName_pressed():
	Global.write_data($TextEdit.text)
	Global.player_name = $TextEdit.text
	get_tree().call_deferred("change_scene", "res://Scenes/Menu/Menu.tscn")

extends Control

func _ready():
	var file_data = Global.read_data()
	print(file_data)
	if file_data:
		print(file_data)
		Global.player_name = file_data
	pass


func _on_Timer_timeout():
	$AnimationSplash.play("FZT")

func _on_AnimationSplash_animation_finished(_anim_name):
	$TimerChangeScene.start()

func _on_TimerChangeScene_timeout():
	if Global.player_name:
		get_tree().call_deferred("change_scene", "res://Scenes/Menu/Menu.tscn")
	else:
		get_tree().call_deferred("change_scene", "res://Scenes/Registro/Registro.tscn")

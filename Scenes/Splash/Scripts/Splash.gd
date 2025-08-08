extends Control

func _ready():
	var file_data = Global.read_data()
	var file_points = Global.read_points()
	var mini_games = Global.read_minigames()
	if file_data:
		print(file_data)
		Global.player_name = file_data
	if file_points:
		Global.player_points = file_points
	else:
		Global.write_points(0)
		Global.player_points = 0
	
	if mini_games:
		Global.mini_games = mini_games.split(',')
	else:
		Global.mini_games = []


func _on_AnimationSplash_animation_finished(_anim_name):
	$TimerChangeScene.start()

func _on_TimerChangeScene_timeout():
	if Global.player_name:
				get_tree().call_deferred("change_scene_to_file", "res://Scenes/Menu/Menu.tscn")
	else:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Registro/Registro.tscn")


func _on_timer_timeout() -> void:
	$AnimationSplash.play("Splash")

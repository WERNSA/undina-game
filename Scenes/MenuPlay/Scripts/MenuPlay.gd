extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.player_name:
		$TitleContainer/PlayerName.text = Global.player_name
	if Global.player_points:
		$TitleContainer/PlayerPoints.text = "PUNTUACIÓN: " + str(Global.player_points)
	else:
		$TitleContainer/PlayerPoints.text = "PUNTUACIÓN: " + str(0)


func _on_BtnBack_pressed():
	$SoundPress.play()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Menu/Menu.tscn")

func _on_BtnFish_pressed():
	$SoundPress.play()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/MenuPlay/PESCAR/Pescar.tscn")

func _on_BtnQuiz_pressed():
	$SoundPress.play()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Games/Trivia/Trivia.tscn")

func _on_BtnClean_pressed():
	$SoundPress.play()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/MenuPlay/COCOSTA/Cocosta.tscn")

func _on_BtnTime_pressed():
	$SoundPress.play()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Games/PescaSobreAgua/Nivel1/PescaSobreAgua.tscn")

func _on_BtnObstacle_pressed():
	$SoundPress.play()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Games/ObstacleRace/Nivel1/ObstacleRace.tscn")


func _on_btn_story_pressed() -> void:
	$SoundPress.play()
	#get_tree()

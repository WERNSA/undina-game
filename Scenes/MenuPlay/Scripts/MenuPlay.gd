extends Control

var mini_games
@onready var all_minigames = [
	{'name': 'cocosta', 'button': 'btnClean', 'src': 'VBoxContainer/ButtonsContainer/SecondContainer/CleanContainer/BtnClean'},
	{'name': 'coralimpio', 'button': 'btnFish', 'src': 'VBoxContainer/ButtonsContainer/FirstContainer/FishContainer/BtnFish'},
	{'name': 'pescando', 'button': 'btnTime', 'src': 'VBoxContainer/ButtonsContainer/FirstContainer/TimeContainer/BtnTime'},
	{'name': 'carrera_obstaculos', 'button': 'btnObstacle', 'src': 'VBoxContainer/ButtonsContainer/SecondContainer/ObstacleContainer/BtnObstacle'},
	{'name': 'trivia', 'button': 'btnQuiz', 'src': 'VBoxContainer/QuizContainer/BtnQuiz'}
]

func check_minigames_locked():
	for game in all_minigames:
		get_node(game['src']).disabled = !game['name'] in mini_games


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.clean_story_game()
	if Global.player_name:
		$TitleContainer/PlayerName.text = Global.player_name
	if Global.player_points:
		$TitleContainer/PlayerPoints.text = "PUNTUACIÓN: " + str(Global.player_points)
	else:
		$TitleContainer/PlayerPoints.text = "PUNTUACIÓN: " + str(0)
	
	if Global.mini_games:
		mini_games = Global.mini_games
	else:
		mini_games = []
	
	#check_minigames_locked()


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
	var actual_checkpoint = Global.read_story_checkpoint()
	if actual_checkpoint:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/MenuPlay/Story/Story.tscn")
	else:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Story/Scene1/Scene1.tscn")
	#get_tree()

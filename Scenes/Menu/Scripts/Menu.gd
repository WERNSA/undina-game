extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationInit.play("Init")
	if Global.player_name:
		$VBoxContainer/PlayerName.text = Global.player_name
	else:
		$VBoxContainer/PlayerName.text = ""
	
	if Global.player_points:
		$VBoxContainer/PlayerPoints.text = "PUNTUACIÓN: " + str(Global.player_points)
	else:
		$VBoxContainer/PlayerPoints.text = "PUNTUACIÓN: " + str(0)

func _on_BtnPlay_pressed():
	$SoundPress.play()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/MenuPlay/MenuPlay.tscn")

func _on_BtnCredits_pressed():
	$SoundPress.play()
	#get_tree().call_deferred("change_scene", "res://Scenes/Credits/Credits.tscn")

func _on_BtnLearn_pressed():
	$SoundPress.play()

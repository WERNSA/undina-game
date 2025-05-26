extends Node2D

func _on_BtnMenu_pressed():
	get_tree().change_scene_to_file("res://Scenes/MenuPlay/MenuPlay.tscn")

func set_score(_score):
	$CenterContainer/LblPuntuacion.text = "PUNTUACIÓN: " + str(_score)

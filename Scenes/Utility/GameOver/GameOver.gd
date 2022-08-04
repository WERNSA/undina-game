extends Node2D
export(PackedScene) var game

func _on_BtnMenu_pressed():
	get_tree().change_scene("res://Scenes/MenuPlay/MenuPlay.tscn")

func set_score(_score):
	$CenterContainer/LblPuntuacion.text = "PUNTUACIÓN: " + str(_score)

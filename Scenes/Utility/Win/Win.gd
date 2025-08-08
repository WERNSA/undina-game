extends Node2D

func _ready():
	if Global.active_story:
		$CenterContainer/HBoxContainer/BtnMenu/Label.text = "CONTINUAR"

func _on_BtnMenu_pressed():
	if Global.active_story:
		get_tree().change_scene_to_file(Global.active_story)
	else:
		get_tree().change_scene_to_file("res://Scenes/MenuPlay/MenuPlay.tscn")

func set_score(_score):
	$CenterContainer/LblPuntuacion.text = "PUNTUACIÓN: " + str(_score)

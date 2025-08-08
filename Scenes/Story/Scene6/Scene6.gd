extends Node2D


func hide_ilea():
	$Environment/IlleaLeyendo.visible = false
	$Environment/Humo.visible = false
	$Environment/Silla.visible = false

func _ready():
	Dialogic.start("Scene6")
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument:String):
	if argument == "finished":
		get_tree().change_scene_to_file("res://Scenes/Games/LimpiandoCosta/Nivel3/LimpiandoCosta.tscn")
	elif argument == "hide_ilea":
		hide_ilea()

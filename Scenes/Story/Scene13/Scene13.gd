extends Node2D

func _ready():
	Dialogic.start("Scene13")
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument:String):
	if argument == "finished":
		get_tree().change_scene_to_file("res://Scenes/Games/Pescando/Nivel1/Pescando.tscn")

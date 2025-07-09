extends Node2D

func show_trash():
	$Basura.visible = true
	$Characters/BoyPitahaya.visible = false
	$Characters/BoyWatermelon.visible = false
	$Characters/GirlWatermelon.visible = false
	$Characters/IleaSide.flip_h = true
	$Characters/IleaSide.position.y += 200

func _ready():
	Dialogic.start("Scene7")
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument:String):
	if argument == "finished":
		get_tree().change_scene_to_file("res://Scenes/Story/Scene8/Scene8.tscn")
	elif argument == "show_trash":
		show_trash()

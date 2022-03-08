extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.player_name:
		$LblName/VBoxContainer/CenterContainer/Label.text = Global.player_name
	else:
		$LblName/VBoxContainer/CenterContainer/Label.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_count(count):
	$LblCount/VBoxContainer/Label.text = count

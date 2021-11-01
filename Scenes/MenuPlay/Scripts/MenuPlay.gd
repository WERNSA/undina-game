extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerName.text = Global.player_name


func _on_BtnBack_pressed():
	get_tree().call_deferred("change_scene", "res://Scenes/Menu/Menu.tscn")

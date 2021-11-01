extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationInit.play("Init")
	$PlayerName.text = Global.player_name

func _on_BtnPlay_pressed():
	get_tree().call_deferred("change_scene", "res://Scenes/MenuPlay/MenuPlay.tscn")

func _on_BtnCredits_pressed():
	get_tree().call_deferred("change_scene", "res://Scenes/Credits/Credits.tscn")

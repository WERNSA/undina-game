extends Area2D

@export var Option1: Texture2D
@export var Option2: Texture2D
@export var Option3: Texture2D
@export var Option4: Texture2D

func _ready():
	spawn_fish()

func spawn_fish():
	var option = Global.random_int(0, 3)
	$Sprite2D.flip_h = false
	match option:
		0:
			$Sprite2D.texture = Option1
		1:
			$Sprite2D.texture = Option2
		2:
			$Sprite2D.texture = Option3
		3:
			$Sprite2D.texture = Option4
			$Sprite2D.flip_h = true

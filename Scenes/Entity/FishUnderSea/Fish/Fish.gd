extends Area2D

export (Texture) var Option1
export (Texture) var Option2
export (Texture) var Option3
export (Texture) var Option4

func _ready():
	spawn_fish()

func spawn_fish():
	var option = Global.random_int(0, 3)
	$Sprite.flip_h = false
	match option:
		0:
			$Sprite.texture = Option1
		1:
			$Sprite.texture = Option2
		2:
			$Sprite.texture = Option3
		3:
			$Sprite.texture = Option4
			$Sprite.flip_h = true

extends Node2D

export (PackedScene) var Island1
export (PackedScene) var Island2

export (PackedScene) var Trash1
export (PackedScene) var Trash2
export (PackedScene) var Trash3
export (PackedScene) var Trash4
onready var island_position = Vector2.ZERO
onready var top_position = 250
onready var bottom_position = 1550
onready var tries = 3
var TRASH_COUNT = 0
var game_over : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Spawn/IslandTimer.start()
	$Spawn/IslandSpeedTimer.start()
	island_position.y = bottom_position
	island_position.x = 3600
	$GameOver/CenterContainer/HBoxContainer/BtnTry.connect("pressed", self, "_on_try_again")
	$Win/CenterContainer/HBoxContainer/BtnTry.connect("pressed", self, "_on_try_again")
	$Contador.set_count(str(TRASH_COUNT))
	randomize()

func _on_IslandTimer_timeout():
	get_node("Spawn/IslandPath/IslandSpawn").set_offset(randi())
	var island_number = Global.random_int(1, 2)
	var island
	if island_number == 1:
		island = Island1.instance()
	else:
		island = Island2.instance()
	add_child(island)
	island.position = island_position
	spawn_trash()
	if island_position.y == top_position:
		island.rotate(90)
		island_position.y = bottom_position
	else:
		island.rotate(-90)
		island_position.y = top_position
	$Spawn/IslandTimer.wait_time = Global.random_float(2, 3)
	$Spawn/IslandTimer.start()

func spawn_trash():
	var is_spawn = Global.random_int(0, 2)
	if is_spawn == 1 or is_spawn == 2:
		var trash_number = Global.random_int(1, 4)
		var trash
		match trash_number:
			1:
				trash = Trash1.instance()
			2:
				trash = Trash2.instance()
			3:
				trash = Trash3.instance()
			4:
				trash = Trash4.instance()
			_:
				trash = Trash1.instance()
		add_child(trash)
		trash.position = island_position
		var position_x = Global.random_int(1, 4)
		match position_x:
			1:
				trash.position.x += 800
			2:
				trash.position.x += 1000
			3:
				trash.position.x += 1200
			4:
				trash.position.x += 1400
			_:
				trash.position.x += 1400

func reduce_distance():
	TRASH_COUNT += 10
	$Contador.set_count(str(TRASH_COUNT))
	tries = 3
	$Sounds/GetSound.play()
	var new_position = $Characters/Turtle.position.x - 400
	$Characters/Tween.interpolate_property(
		$Characters/Turtle, "position",$Characters/Turtle.position,
		Vector2(new_position, $Characters/Turtle.position.y), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Characters/Tween.start()

func add_distance():
	if TRASH_COUNT <= 0:
		TRASH_COUNT = 0
	else:
		TRASH_COUNT -= 10
	$Contador.set_count(str(TRASH_COUNT))
	if $Characters/Turtle.position.x >= 2700:
		tries -= 1
		if tries == 0:
			var new_position = $Characters/Turtle.position.x + 600
			$Characters/Tween.interpolate_property(
				$Characters/Turtle, "position",$Characters/Turtle.position,
				Vector2(new_position, $Characters/Turtle.position.y), 1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
			)
			$Characters/Tween.start()
			_game_over()
	else:
		var new_position = $Characters/Turtle.position.x + 400
		$Characters/Tween.interpolate_property(
			$Characters/Turtle, "position",$Characters/Turtle.position,
			Vector2(new_position, $Characters/Turtle.position.y), 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Characters/Tween.start()

func _on_IslandSpeedTimer_timeout():
	Global.min_enemy_speed += 50
	Global.max_enemy_speed += 50
	if Global.min_enemy_speed > 500:
		$Spawn/IslandSpeedTimer.stop()
		print("Velocidad maxima alcanzada")
	print("Velocidad enemiga aumentada")

func win():
	game_over = true
	$Win.set_score(TRASH_COUNT)
	$Win.visible = true
	$Characters/IleaNadando.can_move = false
	$Spawn/IslandTimer.stop()
	$Spawn/IslandSpeedTimer.stop()
	$Sounds/BGSong.stop()

func _game_over():
	game_over = true
	$GameOver.set_score(TRASH_COUNT)
	$GameOver.visible = true
	$Characters/IleaNadando.can_move = false
	$Spawn/IslandTimer.stop()
	$Spawn/IslandSpeedTimer.stop()
	$Characters/IleaNadando.position = Vector2(250, 900)
	$Sounds/BGSong.stop()

func _on_try_again():
	get_tree().change_scene("res://Scenes/Games/ObstacleRace/Nivel1/ObstacleRace.tscn")

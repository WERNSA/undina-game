extends Node2D

@export var Island1: PackedScene
@export var Island2: PackedScene
@export var Trash1: PackedScene
@export var Trash2: PackedScene
@export var Trash3: PackedScene
@export var Trash4: PackedScene

@onready var island_position = Vector2(3600, 1550)
@onready var top_position = 250
@onready var bottom_position = 1550
@onready var tries = 3
var TRASH_COUNT = 0
var game_over: bool = false

func _ready():
	$Spawn/IslandTimer.start()
	$Spawn/IslandSpeedTimer.start()
	$GameOver/CenterContainer/HBoxContainer/BtnTry.connect("pressed", Callable(self, "_on_try_again"))
	$Win/CenterContainer/HBoxContainer/BtnTry.connect("pressed", Callable(self, "_on_try_again"))
	$Contador.set_count(str(TRASH_COUNT))
	randomize()

func _process(_delta):
	$Timer/VBoxContainer/Timer/Label.text = Global.get_timer($Timer/Timer.time_left)

func _on_IslandTimer_timeout():
	$Spawn/IslandPath/IslandSpawn.progress = randi()
	var island_number = Global.random_int(1, 2)
	var island: Node2D
	if island_number == 1:
		island = Island1.instantiate()
	else:
		island = Island2.instantiate()
	add_child(island)
	island.position = island_position
	spawn_trash()

	if island_position.y == top_position:
		island.rotate_object(90)
		island_position.y = bottom_position
	else:
		island.rotate_object(-90)
		island_position.y = top_position

	$Spawn/IslandTimer.wait_time = Global.random_float(2, 3)
	$Spawn/IslandTimer.start()

func spawn_trash():
	var is_spawn = Global.random_int(0, 2)
	if is_spawn in [1, 2]:
		var trash_number = Global.random_int(1, 4)
		var trash: Node2D
		match trash_number:
			1:
				trash = Trash1.instantiate()
			2:
				trash = Trash2.instantiate()
			3:
				trash = Trash3.instantiate()
			4:
				trash = Trash4.instantiate()
			_:
				trash = Trash1.instantiate()
		add_child(trash)
		trash.position = island_position
		trash.position.x += 800 + (Global.random_int(0, 3) * 200)

func move_turtle_to(target_position: Vector2, duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property($Characters/Turtle, "position", target_position, duration)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)

func reduce_distance():
	TRASH_COUNT += 10
	$Contador.set_count(str(TRASH_COUNT))
	tries = 3
	$Sounds/GetSound.play()
	var new_position = $Characters/Turtle.position.x - 400
	move_turtle_to(Vector2(new_position, $Characters/Turtle.position.y))

func add_distance():
	var current_x = $Characters/Turtle.position.x
	if current_x >= 2700:
		tries -= 1
		if tries == 0:
			move_turtle_to(Vector2(current_x + 600, $Characters/Turtle.position.y))
			_game_over()
	else:
		move_turtle_to(Vector2(current_x + 400, $Characters/Turtle.position.y))

func _on_IslandSpeedTimer_timeout():
	Global.min_enemy_speed += 50
	Global.max_enemy_speed += 50
	if Global.min_enemy_speed > 500:
		$Spawn/IslandSpeedTimer.stop()
		print("Velocidad máxima alcanzada")
	print("Velocidad enemiga aumentada")

func win():
	game_over = true
	var total_points = floor($Timer/Timer.time_left / 20) * 10
	Global.player_points += (TRASH_COUNT + total_points)
	Global.write_points(TRASH_COUNT + total_points)
	$Win.set_score(TRASH_COUNT + total_points)
	$Win.visible = true
	$Characters/IleaNadando.can_move = false
	$Spawn/IslandTimer.stop()
	$Spawn/IslandSpeedTimer.stop()
	$Sounds/BGSong.stop()

func _game_over():
	game_over = true
	Global.player_points += TRASH_COUNT
	Global.write_points(TRASH_COUNT)
	$GameOver.set_score(TRASH_COUNT)
	$GameOver.visible = true
	$Characters/IleaNadando.can_move = false
	$Spawn/IslandTimer.stop()
	$Spawn/IslandSpeedTimer.stop()
	$Characters/IleaNadando.position = Vector2(250, 900)
	$Sounds/BGSong.stop()

func _on_try_again():
	get_tree().change_scene_to_file("res://Scenes/Games/ObstacleRace/Nivel1/ObstacleRace.tscn")

func _on_StepTimer_timeout():
	TRASH_COUNT -= 10
	$Contador.set_count(str(TRASH_COUNT))

func _on_Timer_timeout():
	$Timer/StepTimer.stop()
	tries = 0
	move_turtle_to(Vector2(3400, $Characters/Turtle.position.y), 2.0)
	_game_over()


func _on_delete_area_area_entered(area: Area2D) -> void:
	area.queue_free()

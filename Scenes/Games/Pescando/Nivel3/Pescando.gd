extends Node2D

var TRASH_COUNT = 0

var trash_qty := 0
@export var tries := 3
@export var game_over: bool = false
@export var ilea_position := Vector2(530, 230)
@export var FishBG: PackedScene

var fish_initial_positions = [
	Vector2(1470, 273), Vector2(1470, 357), Vector2(1470, 441),
	Vector2(1470, 525), Vector2(1470, 609), Vector2(1470, 693),
]
var fish_final_positions = [
	Vector2(-300, 273), Vector2(-300, 850), Vector2(-300, 441),
	Vector2(-300, 525), Vector2(-300, 357), Vector2(-300, 693),
]

var barracuda_position = [Vector2(1180, 800), Vector2(1180, 570)]

@onready var turtle_position_idx := 0
@onready var actual_trash_position := Vector2.ZERO

#var turtle_initial_position = [
	#Vector2(1000, 1900), Vector2(2900, 1900), Vector2(1400, 1900)
#]

var turtle_initial_position = [
	Vector2(357, 1000), Vector2(1035, 1000), Vector2(499, 1000)
]

#var turtle_trash_position = [
	#{
		#"turtle": Vector2(725, 1430),
		#"trash": Vector2(850, 1430),
	#},
#]
@onready var turtle_trash_position : Array[Node] = $Trash.get_children()

func _ready():
	trash_qty = $Trash.get_children().size()
	randomize()
	$Contador.set_count(str(TRASH_COUNT))
	$HUD/GameOver/CenterContainer/HBoxContainer/BtnTry.pressed.connect(_on_try_again)
	$HUD/Win/CenterContainer/HBoxContainer/BtnTry.pressed.connect(_on_try_again)
	
	spawn_fish_bg()
	$FishBG/SpawnFishBGTimer.start()
	$Fish/BarracudaTimer.start()
	move_barracuda()
	move_turtle()
	$Timer/MarginContainer/VBoxContainer/LblTries.text = "iNTENTOS: %s" % tries
	$Boat/Claw/AnimatedSprite2D.play("default")


func _physics_process(delta):
	var wave_velocity = 35
	$Background/Wave.scroll_offset += Vector2(1, 0) * wave_velocity * delta
	$Timer/MarginContainer/VBoxContainer/LblTimer.text = Global.get_timer($Timer/Timer.time_left)

func add_trash_count():
	TRASH_COUNT += 10
	trash_qty -= 1
	$Contador.set_count(str(TRASH_COUNT))
	$Songs/GetSound.play()
	if trash_qty <= 0:
		_game_win()

func get_sound():
	$Songs/GetSound.play()

func _on_SpawnFishBGTimer_timeout():
	spawn_fish_bg()

func spawn_fish_bg():
	var start_pos = fish_initial_positions[Global.random_int(0, fish_initial_positions.size() - 1)]
	var end_pos = fish_final_positions[Global.random_int(0, fish_final_positions.size() - 1)]
	var fish_bg = FishBG.instantiate()
	fish_bg.position = start_pos
	fish_bg.z_index = -1
	add_child(fish_bg)

	var tween = create_tween()
	tween.tween_property(fish_bg, "position", end_pos, 5.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func _on_BarracudaTimer_timeout():
	move_barracuda()


func move_barracuda():
	var target_pos = barracuda_position[1] if $Fish/Barracuda.position == barracuda_position[0] else barracuda_position[0]
	var tween = create_tween()
	tween.tween_property($Fish/Barracuda, "position", target_pos, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func get_trash_index():
	turtle_position_idx = Global.random_int(0, turtle_trash_position.size() - 1)
	if is_instance_valid(turtle_trash_position[turtle_position_idx]):
		return
	get_trash_index()

func move_turtle():
	var init_pos = turtle_initial_position[Global.random_int(0, turtle_initial_position.size() - 1)]
	get_trash_index()
	var final_pos : CharacterBody2D = turtle_trash_position[turtle_position_idx]

	$FishBG/Turtle._set_flip_h(init_pos.x > final_pos.position.x)
	$FishBG/Turtle.position = init_pos

	var tween = create_tween()
	tween.tween_property(
		$FishBG/Turtle,
		"position",
		final_pos.position,
		2
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", _on_TurtleTween_tween_completed)

	actual_trash_position = final_pos.position

func _on_TurtleTween_tween_completed():
	if game_over:
		return
	if not turtle_initial_position.has($FishBG/Turtle.position):		
		if $FishBG/Turtle.position == actual_trash_position && is_instance_valid(turtle_trash_position[turtle_position_idx]):
			$Timer/Timer.start()
			show_timer(true)
			var flipped = $FishBG/Turtle.position.x > turtle_trash_position[turtle_position_idx].position.x
			$FishBG/Turtle._set_flip_h(flipped)
			var margin_pos = 50
			$FishBG/Turtle.position.x += margin_pos if flipped else (margin_pos * -1)
			$FishBG/Turtle._set_eating(true)
		else:
			hide_turtle()

func _on_Timer_timeout():
	$Timer/Timer.stop()
	if game_over:
		return

	var found = false
	var trash_group = get_tree().get_nodes_in_group("enemy")
	for p in trash_group:
		if p.position == actual_trash_position:
			found = true
			p.queue_free()
			break

	if found:
		$Songs/GetSound.play()
		trash_qty -= 1
		tries -= 1
		TRASH_COUNT -= 10
		$Contador.set_count(str(TRASH_COUNT))
		$Timer/MarginContainer/VBoxContainer/LblTries.text = "iNTENTOS: %s" % tries

	if tries == 0:
		_game_over()
	elif trash_qty == 0:
		_game_win()
	else:
		hide_turtle()

	if $Timer.position.y != -200:
		show_timer(false)

func show_timer(is_show: bool):
	var start_y = -100 if is_show else 0
	var end_y = 0 if is_show else -100
	var tween = create_tween()
	tween.tween_property(
		$Timer,
		"position",
		Vector2(643, end_y),
		0.5
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func remove_trash_turtle(pos: Vector2):
	var index := -1
	for i in turtle_trash_position.size():
		if is_instance_valid(turtle_trash_position[i]):
			if turtle_trash_position[i].position == pos:
				index = i
				break
		else: index = 0
	if index != -1:
		var removed = turtle_trash_position.pop_at(index)
		if removed.position == actual_trash_position:
			if $Timer.position.y != -200:
				show_timer(false)
			hide_turtle()

func hide_turtle():
	$FishBG/Turtle._set_eating(false)
	var start_pos = $FishBG/Turtle.position
	var end_pos = turtle_initial_position[Global.random_int(0, turtle_initial_position.size() - 1)]
	$FishBG/Turtle._set_flip_h(start_pos.x > end_pos.x)

	var tween = create_tween()
	tween.tween_property(
		$FishBG/Turtle,
		"position",
		end_pos,
		3
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	$FishBG/TurtleTimer.start()

func _on_TurtleTimer_timeout():
	move_turtle()

func _game_win():
	game_over = true
	Global.player_points += TRASH_COUNT
	Global.write_points(TRASH_COUNT)
	$HUD/Win.set_score(TRASH_COUNT)
	$HUD/Win.visible = true
	$Songs/BGSong.stop()
	$IlleaBuceando.can_move = false
	if $Timer.position.y != -200:
		show_timer(false)
	if turtle_initial_position.has($FishBG/Turtle.position):
		hide_turtle()

func _game_over():
	game_over = true
	$Songs/PunchSound.play()
	Global.player_points += TRASH_COUNT
	Global.write_points(TRASH_COUNT)
	$HUD/GameOver.set_score(TRASH_COUNT)
	$HUD/GameOver.visible = true
	$Songs/BGSong.stop()
	$FishBG/Turtle._set_dead(true)
	$FishBG/Turtle/Sprite2D.flip_v = true

	var tween = create_tween()
	tween.tween_property(
		$FishBG/Turtle,
		"position",
		Vector2($FishBG/Turtle.position.x, 180),
		2
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	$IlleaBuceando.can_move = false

func _on_try_again():
	get_tree().reload_current_scene()


func _on_bg_song_finished() -> void:
	$Songs/BGSong.play()

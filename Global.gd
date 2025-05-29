extends Node


# Declare member variables here. Examples:
var player_name
var player_points: int = 0
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
const const_enemy_speed : int = 400
@onready var min_enemy_speed : int = 400
@onready var max_enemy_speed : int = 600
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func read_data():
	var dir = "user://data.txt"
	if not FileAccess.file_exists(dir):
		return null
	
	var file = FileAccess.open(dir, FileAccess.READ)
	if file:
		var data = file.get_as_text()
		return data
	return null

func write_data(text):
	var dir = "user://data.txt"
	var file = FileAccess.open(dir, FileAccess.WRITE)
	if file:
		file.store_string(text)

func read_points():
	var dir = "user://points.txt"
	if not FileAccess.file_exists(dir):
		return 0

	var file = FileAccess.open(dir, FileAccess.READ)
	if file:
		var data = file.get_as_text()
		return int(data)
	return 0

func write_points(text):
	var dir = "user://points.txt"
	var file = FileAccess.open(dir, FileAccess.WRITE)
	if file:
		file.store_string(str(text))

func random_int(min_number, max_number):
	rng.randomize()
	var random = rng.randi_range(min_number, max_number)
	return random

func random_float(min_number, max_number):
	rng.randomize()
	var random = rng.randf_range(min_number, max_number)
	return random

func get_timer(_time_left) -> String:
	var time = floor(_time_left)
	var minutes = 0
	var seconds = 0
	if time >= 60:
		minutes = int(floor(time / 60))
		seconds = int(time - minutes * 60)
	else:
		seconds = int(floor(time))
	return "%02d" % minutes + ":" + "%02d" % seconds

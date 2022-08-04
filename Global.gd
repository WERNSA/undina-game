extends Node


# Declare member variables here. Examples:
var player_name
onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
const const_enemy_speed : int = 400
onready var min_enemy_speed : int = 400
onready var max_enemy_speed : int = 600
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func read_data(): 
	var file = File.new()
	var dir = "user://data.txt"
	if not file.file_exists(dir):
		return null 
	file.open(dir, File.READ)
	var data = file.get_as_text() 
	file.close()
	return data

func write_data(text):
	var file = File.new()
	var dir = "user://data.txt"
	file.open(dir, File.WRITE)
	file.store_string(text)
	file.close()

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

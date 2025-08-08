extends Node


# Declare member variables here. Examples:
var player_name
var player_points
var mini_games = []
var active_story
var story_checkpoint
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
const const_enemy_speed : int = 400
@onready var min_enemy_speed : int = 400
@onready var max_enemy_speed : int = 600
@onready var _mgames = ['cocosta','coralimpio','pescando','carrera_obstaculos','trivia']

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func story_game(game):
	active_story = game

func clean_story_game():
	active_story = null
	
func array_to_string(arr: Array) -> String:
	var s = ""
	var c = 1
	if len(arr) == 1:
		s += String(arr[0])
	for i in arr:
		if c == len(arr):
			s += String(i)
		else:
			s += String(i) + ","
			c += 1
	return s

func read_data(): 
	var dir = "user://data.txt"
	if not FileAccess.file_exists(dir):
		return null
	
	var file = FileAccess.open(dir, FileAccess.READ)
	var data = file.get_as_text() 
	file.close()
	return data

func write_data(text):
	var dir = "user://data.txt"
	var file = FileAccess.open(dir, FileAccess.WRITE)
	file.store_string(text)
	file.close()

func read_points(): 
	var dir = "user://points.txt"
	if not FileAccess.file_exists(dir):
		return 0 
	var file = FileAccess.open(dir, FileAccess.READ)
	var data = file.get_as_text() 
	file.close()
	return int(data)

func write_points(text):
	var dir = "user://points.txt"
	var file = FileAccess.open(dir, FileAccess.WRITE)
	file.store_string(str(text))
	file.close()
	
func read_minigames(): 
	var dir = "user://minigames.txt"
	if not FileAccess.file_exists(dir):
		return null
	var file = FileAccess.open(dir, FileAccess.READ)
	var data = file.get_as_text() 
	file.close()
	return data

func write_minigames(text):
	var dir = "user://minigames.txt"
	if mini_games:
		mini_games.push_back(text)
		text = array_to_string(mini_games)
	var file = FileAccess.open(dir, FileAccess.WRITE)
	file.store_string(str(text))
	file.close()

func read_story_checkpoint(): 
	var dir = "user://checkpoint.txt"
	if not FileAccess.file_exists(dir):
		return 0 
	var file = FileAccess.open(dir, FileAccess.READ)
	var data = file.get_as_text() 
	file.close()
	return data

func write_story_checkpoint(text):
	var dir = "user://checkpoint.txt"
	var file = FileAccess.open(dir, FileAccess.WRITE)
	file.store_string(str(text))
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

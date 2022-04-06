extends Node


# Declare member variables here. Examples:
var player_name
onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()


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

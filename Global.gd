extends Node


# Declare member variables here. Examples:
var player_name


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

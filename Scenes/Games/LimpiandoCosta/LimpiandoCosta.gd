extends Node2D

onready var TRASH_COUNT = 0

func _ready():
	$Background/Contador.set_count(str(TRASH_COUNT))

func add_trash_count():
	TRASH_COUNT += 1
	$Background/Contador.set_count(str(TRASH_COUNT))

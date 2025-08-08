extends Area2D
@export var FishingPositionMin: Vector2
@export var FishingPositionMax: Vector2
@export var speed: int
var is_colliding : bool = false
@onready var level = get_tree().get_nodes_in_group('sea_fish_level')[0]

func _process(delta):
	if is_colliding:
		level.add_fishing_points()

func _on_Fish_body_entered(body):
	is_colliding = true


func _on_Fish_body_exited(body):
	is_colliding = false

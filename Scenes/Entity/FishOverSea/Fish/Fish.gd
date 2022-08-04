extends Area2D
export(Vector2) var FishingPositionMin
export(Vector2) var FishingPositionMax
export(int) var speed
var is_colliding : bool = false
onready var level = get_tree().get_nodes_in_group('sea_fish_level')[0]

func _process(delta):
	if is_colliding:
		level.add_fishing_points()

func _on_Fish_body_entered(body):
	is_colliding = true


func _on_Fish_body_exited(body):
	is_colliding = false

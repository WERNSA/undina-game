extends Area2D
@onready var level = get_tree().get_nodes_in_group("level_obstacle_race")[0]
# Called when the node enters the scene tree for the first time.
func _process(delta):
	$AnimationPlayer.play("Idle")


func _on_Turtle_body_entered(body):
	if body.is_in_group("player"):
		level.win()

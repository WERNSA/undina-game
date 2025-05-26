extends Area2D
@onready var can_move = true

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if can_move:
		$AnimationPlayer.play("Walk")

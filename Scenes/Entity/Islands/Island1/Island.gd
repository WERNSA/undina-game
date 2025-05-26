extends Area2D

var speed
@onready var level = get_tree().get_nodes_in_group("level_obstacle_race")[0]

func _ready():
	speed = Global.min_enemy_speed

func _physics_process(delta):
	position.x -= speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func rotate(_degree):
	rotation_degrees = _degree


func _on_Island_body_entered(body):
	if body.is_in_group("player"):
		body.punch_ctrl()
		$PunchSound.play()
		level.add_distance()

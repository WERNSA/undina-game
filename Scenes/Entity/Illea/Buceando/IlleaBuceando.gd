extends CharacterBody2D

const SPEED = 100
const SPEED_RUN = 150 ## RUN SPEED
const FLOOR = Vector2(0, -1)
const GRAVITY =  1
@onready var motion = Vector2.ZERO
const CAST_ENEMY = 70 # Esta constante es para definir la distancia de colisión con los enemigos.
@onready var level = get_tree().get_nodes_in_group("level_pesca")[0]
@onready var trash = []
var box
var pointing : int = 1
@onready var can_move = true
""" STATE MACHINE """

func _ready():
	$AnimationPlayer.play("Idle") # Iniciamos en el estado Idle.

func _process(_delta):
	if can_move:
		motion_ctrl()
		direction_ctrl()

func get_axis() -> Vector2:
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if Input.is_action_pressed("ui_up"):
		axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	else:
		axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")) + GRAVITY

	if axis.x != 0:
		pointing = axis.x
	return axis

func motion_ctrl():
	if Input.is_action_pressed("run"):
		motion = get_axis() * SPEED_RUN
	else:
		motion = get_axis() * SPEED
#	motion.y += GRAVITY
		
	if get_axis().y == -1:
		$AnimationPlayer.play("Move")
	elif get_axis().x == 0:
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("Move")

	if Input.is_action_pressed("grab"):
		$AnimationPlayer.play("Grab")
	if get_axis().x == 0:
		$Sprite2D.flip_h = pointing == -1
	elif !Input.is_action_pressed("grab"):
		$Sprite2D.flip_h = get_axis().x == -1 ## DIRECCIÓN EN LA QUE EL SPRITE MIRA
	set_velocity(motion)
	set_up_direction(FLOOR)
	move_and_slide()
	motion = velocity
	for t in trash:
		if t != null:
			t.set_velocity(motion)
			t.set_up_direction(FLOOR)
			t.move_and_slide()
			t.velocity
	raycast_ctrl(motion)
	

func raycast_ctrl(mot):
	var col = $RayEnemy.get_collider() # Mismo procedimiento que el Raycast de la pared.
	var col_boat = $RayBoat.get_collider()
	if $RayBoat.is_colliding() and col_boat.is_in_group("boat"):
		free_trash()
	if $RayEnemy.is_colliding():
		if col.is_in_group("enemy"):
			if trash.is_empty():
				level.remove_trash_turtle(col.position)
				level.get_sound()
				trash.append(col)
				col.disable_collider()
		if col.is_in_group("boat"):
			free_trash()
		if Input.is_action_pressed("grab") and col.is_in_group("obstacle"):
			col.apply_central_impulse(mot)

func free_trash():
	for t in trash:
		t.queue_free()
		level.add_trash_count()
	trash = []
	

# Como es probable que se vayan agregando componentes creamos esta función para mantener cierto orden en el código e indicar la dirección de ciertos elementos.
func direction_ctrl(): 
	# MOVER EL RAYCAST EN LA DIRECCIÓN QUE VA EL PLAYER
	$RayEnemy.target_position.x = CAST_ENEMY * get_axis().x

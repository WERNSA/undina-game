extends CharacterBody2D
const FLOOR = Vector2(0, -1)
const SPEED = 85
const SPEED_RUN = 80
const CAST_ENEMY = 70 # Esta constante es para definir la distancia de colisión con los enemigos.
# EL ONREADY ES COMO DECLARARLA EN LA FUNCION READY
@onready var motion = Vector2.ZERO # ESTA PROP DEL VECTOR ES LO MISMO QUE (0,0)
@onready var can_move : bool = true
@onready var screensize = get_viewport_rect().size # tamaño de la ventana
var pointing : int = 1
@onready var level = get_tree().get_nodes_in_group("level_limpia_costa")[0]
@onready var trash = null

func _ready():
	$AnimationPlayer.play("Idle")

func _physics_process(_delta):
	if can_move:
		motion_ctrl()
		direction_ctrl()

""" función para definir el movimiento del player """
func get_axis() -> Vector2:
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis

func motion_ctrl(): # Controlador de Movimiento
	if Input.is_action_pressed("run"):
		motion = get_axis() * SPEED_RUN
	else:
		motion = get_axis() * SPEED
#	motion.y += GRAVITY
		
	if get_axis().y == -1 and get_axis().x == 0:
		$AnimationPlayer.play("Up")
	elif get_axis().x == 0 and get_axis().y == 1:
		$AnimationPlayer.play("Down")
	elif get_axis().x == 0:
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("DownWalk")

	if get_axis().x == 0:
		$Sprite2D.flip_h = pointing == -1
	else:
		$Sprite2D.flip_h = get_axis().x == -1 ## DIRECCIÓN EN LA QUE EL SPRITE MIRA
	set_velocity(motion)
	set_up_direction(FLOOR)
	move_and_slide()
	motion = velocity
	if trash != null:
		trash.set_velocity(motion)
		trash.set_up_direction(FLOOR)
		trash.move_and_slide()
		#trash.velocity
	raycast_ctrl()
	

func raycast_ctrl():
	var col = $RayTrash.get_collider() # Mismo procedimiento que el Raycast de la pared.
	if $RayTrash.is_colliding():
		if col.is_in_group("enemy"):
			if trash == null:
				level.get_trash(col)
				col.disable_collider()
				trash = col

func direction_ctrl(): 
	# MOVER EL RAYCAST EN LA DIRECCIÓN QUE VA EL PLAYER
	$RayTrash.target_position.x = CAST_ENEMY * get_axis().x

func free_trash():
	if trash != null:
		trash.queue_free()
		trash = null
		level.add_trash_count()

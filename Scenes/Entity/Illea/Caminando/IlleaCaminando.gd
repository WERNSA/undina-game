extends KinematicBody2D
const FLOOR = Vector2(0, -1)
const SPEED = 200
const SPEED_RUN = 300
const CAST_ENEMY = 70 # Esta constante es para definir la distancia de colisión con los enemigos.
# EL ONREADY ES COMO DECLARARLA EN LA FUNCION READY
onready var motion = Vector2.ZERO # ESTA PROP DEL VECTOR ES LO MISMO QUE (0,0)
onready var can_shoot : bool = true
onready var screensize = get_viewport_rect().size # tamaño de la ventana
var pointing : int = 1
onready var level = get_tree().get_nodes_in_group("level_limpia_costa")[0]

func _ready():
	$AnimationPlayer.play("Idle")

func _physics_process(delta):
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
		$Sprite.flip_h = pointing == -1
	else:
		$Sprite.flip_h = get_axis().x == -1 ## DIRECCIÓN EN LA QUE EL SPRITE MIRA
	motion = move_and_slide(motion, FLOOR)
	raycast_ctrl(motion)
	

func raycast_ctrl(mot):
	var col = $RayTrash.get_collider() # Mismo procedimiento que el Raycast de la pared.
	if $RayTrash.is_colliding():
		if col.is_in_group("enemy"):
			col.queue_free()
			level.add_trash_count()

func direction_ctrl(): 
	# MOVER EL RAYCAST EN LA DIRECCIÓN QUE VA EL PLAYER
	$RayTrash.cast_to.x = CAST_ENEMY * get_axis().x

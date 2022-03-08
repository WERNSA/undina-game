extends Node2D
var TRASH_COUNT = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Contador.set_count(str(TRASH_COUNT))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta): # SE EJECUTA CADA FRAME A UNA TASA DE FRAMES CONSTANTE
	var wave_velocity = 35
	var sea_velocity = 10
	var lights_velocity = 20
	var clouds_velocity = 50
	""" FORMULA PARA CREAR EFECTO DE MOVMIENTO EN EL FONDO """
	get_node("Background/Wave").scroll_base_offset += Vector2(1, 0) * wave_velocity * delta
#	get_node("Background/Clouds").scroll_base_offset += Vector2(1, 0) * clouds_velocity * delta

func add_trash_count():
	TRASH_COUNT += 1
	$Contador.set_count(str(TRASH_COUNT))

extends VehicleBody

export var turn_speed = 2.0
export var max_turn_angle = 30.0
var cur_turn_angle = 0.0

export var accel_speed = 2.0
export var max_accel = 10
var cur_accel = 0.0

export var brake_force = 200.0

var played_start_sound = false

func _ready():
	var people = get_tree().get_nodes_in_group("person")
	for person in people:
		person.truck = self


func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _physics_process(delta):
	var turn_dir = 0
	if Input.is_action_pressed("turn_left"):
		turn_dir += 1
	if Input.is_action_pressed("turn_right"):
		turn_dir -= 1
	
	if turn_dir == 0:
		turn_dir = sign(cur_turn_angle) * -1
	
	cur_turn_angle += turn_dir * turn_speed * delta
	cur_turn_angle = clamp(cur_turn_angle, -max_turn_angle, max_turn_angle)
	steering = deg2rad(cur_turn_angle)
	
	var move_dir = 0
	if Input.is_action_pressed("move_forward"):
		move_dir += 1
	if Input.is_action_pressed("move_backward"):
		move_dir -= 1
	
	if move_dir == 0:
		cur_accel = 0
	elif !played_start_sound:
		$EngineStartNoise.play()
		$EngineNoise.play()
		played_start_sound = true
	cur_accel += move_dir * accel_speed * delta
	cur_accel = clamp(cur_accel, -max_accel, max_accel)
	engine_force = cur_accel

	
	if move_dir != 0 and linear_velocity.dot(move_dir * global_transform.basis.z) < 0:
		#brake = brake_force # doesn't work, can't figure out why
		cur_accel = 0
		engine_force = move_dir * brake_force
	else:
		pass
		#brake = 0.0
		#print('not breaking')
	$EngineNoise.volume_db = linear2db(clamp(linear_velocity.length() / 20.0, 0.0, 0.9))

func crack():
	$BodyGraphics/CrackedWindow.show()

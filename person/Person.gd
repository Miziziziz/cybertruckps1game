extends KinematicBody

var truck = null

var move_range = 50
var move_speed = 5
var throw_range = 30

onready var anim = $AnimationPlayer

var metal_ball = preload("res://person/MetalBall.tscn")

func _physics_process(delta):
	if !truck:
		return
	
	var our_pos = global_transform.origin
	var truck_pos = truck.global_transform.origin
	var dis = our_pos.distance_to(truck_pos)
	
	if dis < move_range and dis > throw_range - 2.0:
		var dir = (truck_pos - our_pos).normalized()
		var move_vec = dir
		move_and_collide(move_vec * move_speed * delta)
	
	if dis < throw_range:
		play_anim("throw")
	else:
		play_anim("walk")

func play_anim(anim_name):
	if anim.current_animation == anim_name:
		return
	anim.play(anim_name)

func throw_metal_ball():
	var our_pos = global_transform.origin
	our_pos.y = 0
	var truck_pos = truck.global_transform.origin
	truck_pos.y = 0
	
	var mb = metal_ball.instance()
	get_tree().get_root().add_child(mb)
	mb.global_transform.origin = our_pos + Vector3.UP * 2.0
	mb.dir = (truck_pos - our_pos).normalized()
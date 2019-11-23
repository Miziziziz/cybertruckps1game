extends KinematicBody

var speed = 10
var dir = Vector3()

func _physics_process(delta):
	move_and_collide(speed * dir * delta)
	for body in $Area.get_overlapping_bodies():
		if body.name == "TruckBody":
			body.crack()
			queue_free()
	
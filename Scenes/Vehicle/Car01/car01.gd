extends RigidBody3D

#	Input.get_axis(&"Right", &"Left")

var MoveForce : Vector3
var Speed = 100
var MaxSpeed = Vector3(300, 300, 300)

@onready var wheels = $Wheels
@onready var whFrontLeft = $Wheels/RayCast3DfrontLeft
@onready var whFrontRight = $Wheels/RayCast3D2frontRight
@onready var whBackLeft = $Wheels/RayCast3D4backLeft
@onready var whBackRight = $Wheels/RayCast3D3backRight


var drag = 0.99
# Called when the node enters the scene tree for the first time.
func _ready():
	MoveForce = Vector3.ZERO
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	MoveForce += Input.get_axis(&"Backward", &"Forward") * global_transform.basis.z * delta * Speed
	
	var steer = Input.get_axis("Right", "Left")* global_transform.basis.z * 5 
	steer = Vector3(0, 0, steer.z)  
	#var steer = Input.get_axis("Right", "Left") * 5 
	if Input.is_action_just_pressed("Jump"):
		apply_central_impulse(Vector3.UP*30)
	
	#print("steer = ", steer)
	MoveForce *= drag 
	MoveForce = MoveForce.clamp(MoveForce, MaxSpeed)
	#print("moveForce = ", MoveForce)
	#apply_force(MoveForce, whFrontLeft.position)
	#apply_force(MoveForce, whFrontRight.position)
	#apply_force(MoveForce, whBackLeft.position)
	#apply_force(MoveForce, whBackRight.position)
	#rotate(Vector3.UP, steer*delta)
	apply_torque(steer)
	calcSusp(whFrontLeft)
	calcSusp(whFrontRight)
	calcSusp(whBackLeft)
	calcSusp(whBackRight)


func calcDrag():
	pass

func calcAccel():
	pass

func calcSusp(wheel):
	var tireSpringDirection = wheel.get_global_transform().basis.y
	var tireWorldVel = getPointVelocity(wheel.position)
	
	var coliisionPointDistance = getRayCastLength(wheel)
	print("distance ", wheel.name, " = ", coliisionPointDistance)
	var offset = 4 - coliisionPointDistance
	print("offset = ", offset)
	if offset <=5 && offset >=-5 :
		var velocityWheel = tireSpringDirection.dot(tireWorldVel)
		var force = (offset*20) - (velocityWheel*15)
		apply_force(tireSpringDirection*force, wheel.position)
	

func getRayCastLength(raycast):
	var start = raycast.global_transform.origin
	var end = raycast.get_collision_point()
	var distance = start.distance_to(end)
	return distance

func getPointVelocity(point: Vector3):
	#var forces = _integrate_forces(state)
	return linear_velocity + angular_velocity.cross(point - global_transform.origin)
	#	_integrate_forces	instead of 	linear_velocity	???





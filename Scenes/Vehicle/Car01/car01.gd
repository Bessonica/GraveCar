extends RigidBody3D

#	Input.get_axis(&"Right", &"Left")

var MoveForce : Vector3
var Speed = 200
var MaxSpeed = Vector3(150, 150, 150)

var drag = 0.99
# Called when the node enters the scene tree for the first time.
func _ready():
	MoveForce = Vector3.ZERO
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	MoveForce += Input.get_axis(&"Backward", &"Forward") * global_transform.basis.z * delta * Speed
	
	var steer = Input.get_axis("Right", "Left")* global_transform.basis.z * 5 
	steer = Vector3(0, 0, steer.z)  
	#var steer = Input.get_axis("Right", "Left") * 5 

	print("steer = ", steer)
	MoveForce *= drag 
	MoveForce = MoveForce.clamp(MoveForce, MaxSpeed)
	print("moveForce = ", MoveForce)
	apply_force(MoveForce, Vector3.ZERO)
	#rotate(Vector3.UP, steer*delta)
	apply_torque(steer)

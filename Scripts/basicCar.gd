extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


var MoveForce : Vector3
var Speed = 200
var MaxSpeed = Vector3(150, 150, 150)
var drag = 0.99


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#	Input.get_axis(&"Backward", &"Forward")

func _physics_process(delta):
	
	MoveForce += Input.get_axis(&"Backward", &"Forward") * global_transform.basis.z * delta * Speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	
	var gas = Input.get_axis(&"Forward", &"Backward")
	var steering = Input.get_axis(&"Right", &"Left")
	
	var direction = (transform.basis * Vector3(0, 0, gas)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	rotate(Vector3.UP, steering * 5 * delta)
	
	MoveForce *= drag 
	MoveForce = MoveForce.clamp(MoveForce, MaxSpeed)
	
	velocity = MoveForce
	
	move_and_slide()

extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


var MoveForce : Vector3
var Speed = 50
var MaxSpeed 
var MaxSpeedNormal = Vector3(40, 40, 40)
var MaxSpeedDrifting = Vector3(8, 8, 8)

const sensitivity = 0.01
@onready var phantCamera = $PhantomCamera3D

@onready var camera_pivot = $CameraPivot
@onready var camera_3d = $CameraPivot/Camera3D

@export var drag = 0.97
@export var traction = 0.1
@export var steeringAmount = 2.0

var isDrifting = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#	Input.get_axis(&"Backward", &"Forward")

func _ready():
	MaxSpeed = MaxSpeedNormal
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		#head.rotate_y	or	rotate_y	????
		camera_pivot.rotate_y(-event.relative.x * sensitivity)
		camera_3d.rotate_x(-event.relative.y * sensitivity)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	

func _physics_process(delta):
	
	MoveForce += Input.get_axis(&"Forward", &"Backward") * global_transform.basis.z * delta * Speed
	#print("move force = ", Input.get_axis(&"Forward", &"Backward"))
	
	#camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
	#camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
	# Add the gravity.

		
	if not is_on_floor():
		MoveForce.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("Jump"):
			MoveForce.y += 20
		else:
			MoveForce.y = 0
	
	#var gas = Input.get_axis(&"Forward", &"Backward")
	#	TODO drift doesnt work right
	var steering = Input.get_axis(&"Right", &"Left")
	if (steering >= 0.8 || steering <= -0.8) && MoveForce.length() >= 8 && steering != 0 && Input.is_action_pressed("Drift"):
		isDrifting = true
	elif steering:
		isDrifting = false
	#print("steering = ", steering)
	# 1 left, -1 right
	#print("move length = ", MoveForce.length())
	#print("steering = ", steering)
	#print("Move Force = ", MoveForce)
	
	
	if isDrifting:
		if steering > 0 && Input.is_action_pressed("Drift"):
			print("drift")
			#MoveForce += -global_transform.basis.x * 4 * delta
			var steerAllow = lerp(0.0, MoveForce.length(), 0.08)
			#	rotate to the side  and keep it like that	TODO
			rotate(Vector3.UP, steering * steeringAmount * delta * steerAllow)
			#MoveForce += -global_transform.basis.z *1.5 * delta
			#	TODO only works with this side if steering <0 it doesnt work
			MoveForce = MoveForce.clamp(-MaxSpeedDrifting, MaxSpeedDrifting)
		if steering < 0 && Input.is_action_pressed("Drift"):
			print("Drift")
			#MoveForce += global_transform.basis.x * 4 * delta
			var steerAllow = lerp(0.0, MoveForce.length(), 0.08)
			rotate(Vector3.UP, steering * steeringAmount * delta * steerAllow)
			#MoveForce += -global_transform.basis.z *1.5 * delta
			MoveForce = MoveForce.clamp(-MaxSpeedDrifting, MaxSpeedDrifting )
	else:
		#var direction = (transform.basis * Vector3(0, 0, gas)).normalized()
		var steerAllow = lerp(0.0, MoveForce.length(), 0.08)
		#print("steer allow = ", steerAllow)
		rotate(Vector3.UP, steering * steeringAmount * delta * steerAllow )
	
	#print("move force length norm = ", MoveForce.normalized().length())
	#print("move force length = ", MoveForce.length())
	#print("moveForce = ", MoveForce)
	MoveForce *= drag 
	MoveForce = MoveForce.clamp(MoveForce, MaxSpeed)
	#	bezier_interpolate()
	
	MoveForce = MoveForce.lerp(global_transform.basis.z, traction * delta)
	velocity = MoveForce
	#print("MoveForce = ", MoveForce)
	



	#move_and_collide(velocity*5)	
	move_and_slide()

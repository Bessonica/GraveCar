extends VehicleBody3D


const MAX_STEER = 0.8
const enginePower = 300
#####
var isDrifting = false
var driftFactor = 100.0
var driftTrashhold = 0.7

const STEER_SPEED = 10


@onready var backWheelLeft = $VehicleWheel3D
@onready var backWheelRight = $VehicleWheel3D2

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("is drifting = ", isDrifting)
	steering = move_toward(steering, Input.get_axis(&"Right", &"Left") * MAX_STEER, delta * STEER_SPEED)
	print("steering = ", steering)
	engine_force = Input.get_axis("Backward", "Forward") * enginePower
	print("engine force = ", engine_force)
	if Input.is_action_just_pressed("hardStop"):
		brake = 3
	if Input.is_action_just_released("hardStop"):
		brake = 0
	
	var current_speed = linear_velocity.length()
	#print("currentSpeed = ", current_speed)
	if abs(steering) > driftTrashhold and current_speed > 20:
		isDrifting = true
	else:
		isDrifting = false
	
	updateWheelFriction()
	applyLateralForce()

func updateWheelFriction():
	var wheelsArray = get_tree().get_nodes_in_group("Wheel")
	if isDrifting:
		backWheelLeft.wheel_friction_slip = 3
		backWheelRight.wheel_friction_slip = 3
	else:
		backWheelLeft.wheel_friction_slip = 5
		backWheelRight.wheel_friction_slip = 5	
	#for wheel in wheelsArray:
	#	if isDrifting:
	#		wheel.wheel_friction_slip = 5

	#	else:
	#		wheel.wheel_friction_slip = 7
		
		
func applyLateralForce():
	if isDrifting:
		var lateral_velocity = global_transform.basis * (linear_velocity)
		var lateral_force = lateral_velocity.y * driftFactor
		apply_impulse(Vector3.ZERO, -global_transform.basis.x * lateral_force)
		




		

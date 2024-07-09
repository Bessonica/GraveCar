extends RayCast3D

@onready var car: RigidBody3D = $"../.."

var previousSpringLength: float = 0.0

@export var canAccel: bool
@export var canTurn: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	add_exception(car)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_colliding():
		var collPoint = get_collision_point()
		calcSuspenson(collPoint, delta)
		calcAcceleration(collPoint)
		
		addDragOnZAxis(collPoint)


func getPointVelocity(point: Vector3):
	return car.linear_velocity + car.angular_velocity.cross(point - car.global_position)

func addDragOnZAxis(collisionPoint):
	var dir : Vector3 = global_basis.z
	var tireWorldVel : Vector3 = getPointVelocity(collisionPoint)
	var zForce = dir.dot(tireWorldVel)*car.mass / 10
	
	car.apply_force(-dir * zForce, collisionPoint - car.global_position)

func calcAcceleration(collisionPoint):
	if canAccel:
		var accelDir = -global_basis.z
		var torque = car.accelInput * car.enginePower
		var point = Vector3(collisionPoint.x, collisionPoint.y*car.wheelRadius, collisionPoint.z)
	
		car.apply_force(accelDir*torque, point - car.global_position)

func calcSuspenson(collisionPoint, delta):
	var suspDir = global_basis.y
	
	var raycastOrigin = global_position
	var rayDest = collisionPoint
	var distance = raycastOrigin.distance_to(rayDest)
	
	var contact = collisionPoint - car.global_position
		
	var springLength = clamp(distance - car.wheelRadius, 0, car.suspensionRestDistance)
	var springForce = car.springStrength * (car.suspensionRestDistance - springLength)
		
	var springVelocity = (previousSpringLength - springLength)/delta
		
	var dumperForce = car.springDamper * springVelocity
		
	var suspensionForce = basis.y * (springForce+dumperForce)
	previousSpringLength = springLength
		
	var point = Vector3(rayDest.x, rayDest.y+car.wheelRadius, rayDest.z)
	car.apply_force(suspDir * suspensionForce, point - car.global_position)




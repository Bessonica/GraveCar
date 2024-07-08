extends RayCast3D

@onready var car: RigidBody3D = $"../.."

var previousSpringLength: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_exception(car)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_colliding():
		
		var suspDir = global_basis.y
	
		var raycastOrigin = global_position
		var rayDest = get_collision_point()
		var distance = raycastOrigin.distance_to(rayDest)
	
		var contact = get_collision_point() - car.global_position
		
		var springLength = clamp(distance - car.wheelRadius, 0, car.suspensionRestDistance)
		var springForce = car.springStrength * (car.suspensionRestDistance - springLength)
		
		var springVelocity = (previousSpringLength - springLength)/delta
		
		var dumperForce = car.springDamper * springVelocity
		
		var suspensionForce = basis.y * (springForce+dumperForce)
		previousSpringLength = springLength
		
		var point = Vector3(rayDest.x, rayDest.y+car.wheelRadius, rayDest.z)
		car.apply_force(suspDir * suspensionForce, point - car.global_position)

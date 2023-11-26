extends CharacterBody3D

var target
var space_state

var inFOV = false
var inLOS = false
var currentEnemyState
var detectionMeter = 0

var lastKnownPos

@onready var enemy = $"."
@onready var fov = $FoVArea
@onready var fovCone = $FoVArea/FoVColl

enum EnemyState {
	SEARCHING,
	SUSPICIOUS,
	PATROL
	}

func _ready():
	space_state = get_world_3d().direct_space_state

func _physics_process(_delta):

	Global.debug.add_property("detectionMeter", detectionMeter, 2)
	if target:
		# creates object "RayQueryParameters3D" which is a dict. 
		var rayCastQueryParams = PhysicsRayQueryParameters3D.new()
		rayCastQueryParams.from = global_transform.origin
		rayCastQueryParams.to = target.global_transform.origin + Vector3(0,.55,0)
		rayCastQueryParams.exclude = [self]

		#passes new dict to generate intersect_ray
		var result = space_state.intersect_ray(rayCastQueryParams)
		if result: # make sure that the intersect ray has been created in the first place
			if result.collider.is_in_group("Player"): # ensure the object we are hitting is the Player.
				inLOS = true
				currentEnemyState = EnemyState.SEARCHING
				handle_detection_rate(getDistanceToPlayer(result.position), 1, 3, 5, 1)
			else:
				# Player is within FoV cone, but does not have consistent Line of Sight
				inLOS = false
				currentEnemyState = EnemyState.SUSPICIOUS

		if detectionMeter >= 3000:
			pass


func _process(_delta):
	handle_state(currentEnemyState)
	if inFOV && inLOS == true:
		look_at(target.global_transform.origin, Vector3.UP) # Look at the player obj
	

func _on_midrange_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		inFOV = true
		# lastKnownPos = body.global_transform.origin
		# go to last known position
		currentEnemyState = EnemyState.SUSPICIOUS

func _on_midrange_body_exited(body):
	if body.is_in_group("Player"):
		target = null
		inFOV = false
		# get last known position
		# lastKnownPos = body.global_transform
		# go to last known position
		# when you reach last known position
		# turn around/patrol
		currentEnemyState = EnemyState.PATROL

func set_color(col):
	$EnemyBody.get_active_material(0).set_albedo(col)

func handle_state(_state):
	match (_state):
		EnemyState.SUSPICIOUS:
			_suspicious()
		EnemyState.SEARCHING:
			_searching()
		EnemyState.PATROL:
			_patrol()

func _patrol():
	set_color(Color.DARK_BLUE)
func _suspicious():
	set_color(Color.YELLOW)
func _searching():
	set_color(Color.RED)

func getDistanceToPlayer(player):
	return enemy.global_transform.origin.distance_to(player)

func increment_detectionMeter(rate):
	detectionMeter += rate

func decrement_detectionMeter(rate):
	detectionMeter -= rate

func handle_detection_rate(distance, min_dist, mid_dist, max_dist, rate):
	if distance <= min_dist:
		currentEnemyState = EnemyState.SEARCHING
	elif distance >= min_dist and distance <= mid_dist:
		increment_detectionMeter(rate * 2)
	elif distance >= mid_dist and distance <= max_dist:
		increment_detectionMeter(rate)

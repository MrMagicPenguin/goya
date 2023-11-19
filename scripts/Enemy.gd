extends CharacterBody3D

var target
var space_state

var inFOV = false
var inLOS = false
var currentEnemyState

@onready var fov = $FoVArea
@onready var fovCone = $FoVArea/FoVColl

enum EnemyState {
	SPOT_PLAYER,
	LOW_ALERT,
	PATROL
	}

func _ready():
	space_state = get_world_3d().direct_space_state

func _physics_process(delta):
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
				print("Line of Sight of " + str(result.collider))
				inLOS = true
				currentEnemyState = EnemyState.SPOT_PLAYER
			else:
				# Player is within FoV cone, but does not have consistent Line of Sight
				inLOS = false
				currentEnemyState = EnemyState.LOW_ALERT

func _process(delta):
	handle_state(currentEnemyState)
	if inFOV && inLOS == true:
		look_at(target.global_transform.origin, Vector3.UP) # Look at the player obj

func _on_midrange_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		inFOV = true
		adjust_fov_cone(3,3)
		currentEnemyState = EnemyState.LOW_ALERT

func _on_midrange_body_exited(body):
	if body.is_in_group("Player"):
			target = null
			inFOV = false
			currentEnemyState = EnemyState.PATROL

func _on_close_range_area_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("You are already dead.")
	# TODO: Differentiate between being Close behind/Close in front
	if body.is_in_group("Player"):
		target = body
		currentEnemyState = EnemyState.SPOT_PLAYER

func _on_close_range_area_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	print("Nani??")
	if body.is_in_group("Player"):
		target = null
		currentEnemyState = EnemyState.LOW_ALERT

func set_color(col):
	$EnemyBody.get_active_material(0).set_albedo(col)
	
func handle_state(_state):
	match (_state):
		EnemyState.LOW_ALERT:
			low_alert()
		EnemyState.SPOT_PLAYER:
			spot_player()
		EnemyState.PATROL:
			patrol()
			

func patrol():
	set_color(Color.DARK_BLUE)
func low_alert():
	set_color(Color.YELLOW)
func spot_player():
	set_color(Color.RED)
	
func adjust_fov_cone(x,z):
	# Takes in two new X/Z coordinates to increase size of cone. 
	# Default "Mid Range" is 6,3
	# Get current coords. If we did math instead of setting them directly, we would need this.
	var current_fov = fovCone.polygon
	# Sets new FOV Coords.
	# First index is always 0,0 as this is the center of the Enemy.
	# second index is the "Right" coordinate (Positive X/Z)
	# third index is the "Left" coordinate (Positive X/-Z)
	var new_fov = [Vector2(0, 0), Vector2(x, z), Vector2(x, -z)]
	# Set the cone's polygon to use the new coordinates
	fovCone.polygon = new_fov
	


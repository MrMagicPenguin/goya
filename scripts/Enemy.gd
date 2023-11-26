extends CharacterBody3D
#class_name Enemy

var target
var space_state
var detectionMeter = 0
var inFOV = false
var inLOS = false

@export var maxDetectionMeter = 300

var lastKnownPos

@onready var enemy = $"."
@onready var fov = $FoVArea
@onready var fovCone = $FoVArea/FoVColl


func _ready():
	space_state = get_world_3d().direct_space_state

func _physics_process(_delta):
	Global.debug.add_property("detectionMeter", detectionMeter, 1)
	Global.debug.add_property("target?", target, 2)
	handleEnemyVision()
	print(detectionMeter)


func _process(delta):
	if inFOV && inLOS == true:
		look_at(target.global_transform.origin, Vector3.UP) # Look at the player obj
	

func _on_midrange_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		inFOV = true

func _on_midrange_body_exited(body):
	if body.is_in_group("Player"):
			target = null
			inFOV = false

func _on_close_range_area_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("You are already dead.")
	# TODO: Differentiate between being Close behind/Close in front
	if body.is_in_group("Player"):
		target = body

func _on_close_range_area_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	print("Nani??")
	if body.is_in_group("Player"):
		target = null

func set_color(col):
	$EnemyBody.get_active_material(0).set_albedo(col)
	
func increment_detectionMeter(rate):
	if detectionMeter < maxDetectionMeter:
		detectionMeter += rate

func decrement_detectionMeter(rate):
	if detectionMeter > 0:
		detectionMeter -= rate
	
func handle_detection_rate(distance, min_dist, mid_dist, max_dist, rate):
	if distance <= min_dist:
		pass
	elif distance >= min_dist and distance <= mid_dist:
		increment_detectionMeter(rate * 2)
	elif distance >= mid_dist and distance <= max_dist:
		increment_detectionMeter(rate)

func getDistanceToPlayer(player):
	return enemy.global_transform.origin.distance_to(player)

func handleEnemyVision():
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
				increment_detectionMeter(1)
			else:
				# Player is within FoV cone, but does not have consistent Line of Sight
				inLOS = false
				decrement_detectionMeter(1)
	if !target and !inLOS:
		decrement_detectionMeter(1)	


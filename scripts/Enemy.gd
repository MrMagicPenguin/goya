extends CharacterBody3D

var target
var space_state

func _ready():
	space_state = get_world_3d().direct_space_state
	
func _process(delta):
	
	if target:
		# creates object "RayQueryParameters3D" which is a dict. 
		var rayCastQueryParams = PhysicsRayQueryParameters3D.new()
		rayCastQueryParams.from = global_transform.origin
		rayCastQueryParams.to = target.global_transform.origin
		rayCastQueryParams.exclude = [self]
		
		#passes new dict to generate intersect_ray
		var result = space_state.intersect_ray(rayCastQueryParams)
		if result: # make sure that the intersect ray has been created in the first place
			if result.collider.is_in_group("Player"): # ensure the object we are hitting is the Player.
				print("Line of Sight of " + str(result.collider)) # What did we hit?
				set_color(Color(1,0,0))
				look_at(target.global_transform.origin, Vector3.UP) # Look at the player obj
		else:
			#  # Player is within FoV cone, but does not have consistent Line of Sight
			print("Target in area. No Line of Sight.")
			set_color(Color(0,1,0))

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		print("Target in area")
		target = body


func _on_area_3d_body_exited(body):
	print("target left area")
	if body.is_in_group("Player"):
		target = null


func set_color(col):
	$EnemyBody.get_active_material(0).set_albedo(col)


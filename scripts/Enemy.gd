extends CharacterBody3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		print("MINORITY LOCATED")
		set_color(Color(1,0,0))


func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		print("MINORITY NEUTRALIZED")
		set_color(Color(0,1,0))
	

func set_color(col):
	$EnemyBody.get_active_material(0).set_albedo(col)

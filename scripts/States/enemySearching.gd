extends EnemyState
class_name enemySearching


func Enter():
	enemy.set_color(Color.RED)
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	if enemy.detectionMeter <= enemy.maxDetectionMeter / 2:
		Transitioned.emit(self, "stateEnemySuspicious")

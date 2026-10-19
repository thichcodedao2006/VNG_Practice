extends EnemyState

func _enter() -> void:
	obj.change_animation("run")
	obj.stop_move()
	obj.movement_enabled = false
	_set_collision(true)

func _exit() -> void:
	obj.movement_enabled = true
	_set_collision(false)

func _set_collision(disabled: bool) -> void:
	obj.get_node("CollisionShape3D").set_deferred("disabled", disabled)

extends EnemyState

func _enter() -> void:
	_set_thrown_hit(obj.throw_harmful)

func _exit() -> void:
	_set_thrown_hit(false)


func _update(_delta: float) -> void:
	if obj.is_on_floor() and obj.velocity.y <= 0.0:
		obj.stop_horizontal()
		change_state(fsm.default_state)



func _set_thrown_hit(enabled: bool) -> void:
	var path := "Direction/ThrownHitArea3D/CollisionShape3D"
	if obj.has_node(path):
		obj.get_node(path).set_deferred("disabled", not enabled)

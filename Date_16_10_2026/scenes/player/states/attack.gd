extends PlayerState

func _enter() -> void:
	obj.change_animation("attack")
	obj.stop_horizontal()
	timer = obj.anim_player.get_animation("attack_%s" % obj.direction).length
	_hit_shape().disabled = false



func _exit() -> void:
	_hit_shape().disabled = true


func _update(_delta: float) -> void:
	if update_timer(_delta):
		change_state(fsm.previous_state)

func _hit_shape() -> CollisionShape3D:
	return obj.get_node("Direction/HitArea3D/CollisionShape3D")

extends PlayerState

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(_delta: float):
	control_moving_carry_object()
	# In 3D the Y axis points up, so falling means velocity.y is negative
	if obj.velocity.y < 0:
		change_state(fsm.states.carry_fall)

extends PlayerState

func _enter() -> void:
	pass

func _update(delta: float) -> void:
	var is_moving: bool = control_moving_carry_object()
	if obj.is_on_floor():
		if not is_moving and not control_jump_carry_object():
			change_state(fsm.states.carry_idle)

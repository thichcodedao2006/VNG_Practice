extends PlayerState

func _enter() -> void:
	obj.change_animation("carry")

func _update(delta: float):
	if control_jump_carry_object():
		return
	if control_throw():
		return
	if not control_moving_carry_object():
		change_state(fsm.states.carry_idle)

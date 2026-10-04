extends PlayerState

func _enter() -> void:
	obj.change_animation("jump")

func _update(_delta: float) -> void:
	control_moving()

	if can_double_jump() and control_jump():
		obj.restart_animation()
		return

	if can_wall_cling():
		change_state(fsm.states.wallcling)
		return

	if obj.velocity.y < 0:
		change_state(fsm.states.fall)

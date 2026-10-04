extends PlayerState

func _enter() -> void:
	obj.change_animation("fall")

func _update(_delta: float) -> void:
	if can_wall_cling():
		change_state(fsm.states.wallcling)
		return
	var is_moving: bool = control_moving()
	if can_double_jump() or (obj.count ==0 and obj.coyote_time > 0):
		control_jump()
		if obj.is_on_floor():
			obj.coyote_time = 0.2
	if obj.is_on_floor():
		if not is_moving and not control_jump():
			change_state(fsm.states.idle)
			

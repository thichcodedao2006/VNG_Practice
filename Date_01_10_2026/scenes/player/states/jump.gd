extends PlayerState

func _enter() -> void:
	obj.change_animation("jump")

func _update(_delta: float):
	control_moving()
	
	if obj.velocity.y < 0:
		change_state(fsm.states.fall)

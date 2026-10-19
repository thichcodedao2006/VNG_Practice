extends PlayerState

func _enter() -> void:
	obj.change_animation("throw")
	obj.stop_horizontal()
	obj.throw_carried(obj.throw_power)
	timer = obj.anim_player.get_animation("throw_%s" % obj.direction).length

func _update(delta: float) -> void:
	obj.stop_horizontal()
	if update_timer(delta):
		change_state(fsm.states.idle)

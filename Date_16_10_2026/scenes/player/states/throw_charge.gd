extends PlayerState

## Giữ nút bao lâu thì đạt lực tối đa.
@export var max_charge_time: float = 1.0
## Lực tối đa so với lực ném bình thường.
@export var max_power: float = 2.0

var _held: float = 0.0

func _enter() -> void:
	obj.change_animation("carry_idle")
	obj.stop_horizontal()
	_held = 0.0
	obj.throw_power_ratio = 0.0

func _exit() -> void:
	obj.throw_power_ratio = 0.0

func _update(delta: float) -> void:
	obj.stop_horizontal()
	_held += delta
	var t: float = clampf(_held / max_charge_time, 0.0, 1.0)
	obj.throw_power_ratio = t
	if not Input.is_action_pressed("throw"):
		
		obj.throw_power = lerpf(1.0, max_power, t)
		change_state(fsm.states.throw)

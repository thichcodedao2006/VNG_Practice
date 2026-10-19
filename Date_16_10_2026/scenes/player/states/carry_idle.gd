extends PlayerState

const LIFT_TIME := 0.18

var _lifting: bool = false
var _tween: Tween = null

func _enter() -> void:
	obj.change_animation("carry_idle")
	obj.stop_horizontal()
	var held: BaseCharacter = obj.carried_object
	held.be_picked_up(obj.hold_point)
	_tween = obj.create_tween()
	_tween.tween_property(held, "position", Vector3.ZERO, LIFT_TIME)
	_lifting = true
	timer = LIFT_TIME

func _exit() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()

func _update(delta: float) -> void:
	if _lifting:
		obj.stop_horizontal()   # đứng yên, bỏ qua input trong lúc nhấc
		if update_timer(delta):
			_lifting = false
		return
	if control_jump_carry_object():
		return
	if control_throw():
		return
	control_moving_carry_object()

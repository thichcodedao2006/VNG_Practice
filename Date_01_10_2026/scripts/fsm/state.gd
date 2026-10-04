extends Node
class_name FSMState

var fsm: FSM = null
var obj: BaseCharacter = null
var timer: float = 0.0

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update( _delta ):
	pass

# Update timer and return true if timer is finished
func update_timer(delta: float) -> bool:
	if timer <= 0:
		return false
	timer -= delta
	if timer <= 0:
		return true
	return false


func change_state(new_state: FSMState) -> void:
	fsm.change_state(new_state)
	
func can_double_jump()-> bool:
	if obj.count == 1:
		return true
	return false
	
func can_wall_cling() -> bool:
	if obj.is_on_floor() or not obj.is_on_wall():
		return false
	var input: Vector2 = Input.get_vector("left", "right", "up", "down")
	var push := Vector3(input.x, 0.0, input.y)
	return push.dot(obj.get_wall_normal()) <= 0.5

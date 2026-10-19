class_name PlayerState
extends FSMState

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	pass

## Reads input, sets the facing direction and horizontal velocity. Returns true if there's input.
## Split out of control_moving() because Carry needs to follow input WITHOUT being pushed into Run.
func move_by_input(speed_scale: float = 1.0) -> bool:
	var input: Vector2 = Input.get_vector("left", "right", "up", "down")
	if input.length() <= 0.1:
		obj.stop_horizontal()
		return false
	obj.change_direction(BaseCharacter.direction_from_input(input))
	obj.velocity.x = obj.movement_speed * speed_scale * input.x
	obj.velocity.z = obj.movement_speed * speed_scale * input.y
	return true

#Control moving and changing state to run
#Return true if moving
func control_moving() -> bool:
	var is_moving := move_by_input()
	if is_moving and obj.is_on_floor():
		change_state(fsm.states.run)
	return is_moving
	
func control_moving_carry_object() -> bool:
	var is_moving := move_by_input(obj.carried_object.carry_speed_multiplier)
	if is_moving and obj.is_on_floor():
		change_state(fsm.states.carry)
	return is_moving

#Control jumping
#Return true if jumping
func control_jump() -> bool:
	if Input.is_action_just_pressed("jump"):
		obj.jump()
		change_state(fsm.states.jump)
		return true
	return false

func control_jump_carry_object() -> bool:
	if Input.is_action_just_pressed("jump"):
		obj.jump(obj.carried_object.carry_jump_multiplier)
		change_state(fsm.states.carry_jump)
		return true
	return false

#Control attack
#Return true if attacking
func control_attack() -> bool:
	if Input.is_action_just_pressed("attack"):
		change_state(fsm.states.attack)
		return true
	return false

func control_cast() -> bool:
	if Input.is_action_just_pressed("cast"):
		change_state(fsm.states.cast)
		return true
	return false
	
func control_carry() -> bool:
	if Input.is_action_just_pressed("carry"):
		var target: BaseCharacter = obj.grab_area.find_carriable()
		if target != null && target.can_be_carried():
			obj.carried_object = target
			change_state(fsm.states.carry)
			return true
	return false

func control_throw() -> bool:
	if Input.is_action_just_pressed("throw"):
		if obj.carried_object != null:
			## Tac dong luc nem len carried_object
			change_state(fsm.states.throw_charge)
			return true
	return false



func take_damage(_damage: int = 1) -> void:
	obj.take_damage(_damage)
	if obj.health <= 0:
		change_state(fsm.states.dead)
	else:
		change_state(fsm.states.hurt)

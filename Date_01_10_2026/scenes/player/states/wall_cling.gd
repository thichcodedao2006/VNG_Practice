extends PlayerState

@export var slide_speed: float = 2.0       # Tốc độ trượt xuống tối đa khi bám tường
@export var wall_friction: float = 40.0    # Độ "phanh" khi mới bám vào lúc đang rơi nhanh
@export var wall_jump_push: float = 6.0    # Lực bật ra khỏi tường khi nhảy

var wall_normal: Vector3 = Vector3.ZERO

func _enter() -> void:
	obj.change_animation("wall_cling")
	wall_normal = obj.get_wall_normal()
	obj.count = 0

func _update(delta: float) -> void:
	# 1. Chạm đất thì về idle
	if obj.is_on_floor():
		change_state(fsm.states.idle)
		return

	# 2. Nhấn nhảy thì bật ra khỏi tường và chuyển sang jump
	if Input.is_action_just_pressed("jump"):
		_wall_jump()
		return

	# 3. Bấm hướng ra xa tường, hoặc tường đã hết, thì chuyển sang fall
	var input: Vector2 = Input.get_vector("left", "right", "up", "down")
	var push := Vector3(input.x, 0.0, input.y)
	if push.dot(wall_normal) > 0.5 or not obj.is_on_wall():
		obj.coyote_time = 0.2
		change_state(fsm.states.fall)
		return

	wall_normal = obj.get_wall_normal()

	# Giữ một lực nhỏ đẩy vào tường để is_on_wall() không bị false
	obj.velocity.x = -wall_normal.x
	obj.velocity.z = -wall_normal.z

	# Giảm dần tốc độ rơi về mức slide_speed
	if obj.velocity.y < -slide_speed:
		obj.velocity.y = move_toward(obj.velocity.y, -slide_speed, wall_friction * delta)

func _wall_jump() -> void:
	obj.velocity.x = wall_normal.x * wall_jump_push
	obj.velocity.z = wall_normal.z * wall_jump_push
	obj.jump()
	obj.change_direction(BaseCharacter.direction_from_input(Vector2(wall_normal.x, wall_normal.z)))
	change_state(fsm.states.jump)

extends CharacterBody3D

const JUMP_VELOCITY = 4.5
const FRICTION = 15.0
const COMB_TIMER = 0.3

@export var gravity = 80.0
@export var run_speed = 5.0  
@export var jump_speed = 8.0
@export var double_jump_speed = 10.0

@export var smoke_effect: PackedScene

enum {IDLE, WALK, JUMP}
var state = IDLE
var canDoubleJump = false
var finishFirstJump = false

var timer = 0.0

func _ready() -> void:
	change_state(IDLE)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimatedSprite3D.play("idle")
		WALK:
			$AnimatedSprite3D.play("walk")
		JUMP:
			$AnimatedSprite3D.play("jump")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if finishFirstJump:
			finishFirstJump = false
			canDoubleJump = true
			timer = COMB_TIMER
	
	if timer > 0:
		timer -= delta
	else:
		canDoubleJump = false

	get_input(delta)
	move_and_slide()
	update_state()
	
func get_input(delta: float):
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	
	velocity.z = 0.0
	var direction_x = 0.0
	if right:
		direction_x += 1.0
		$AnimatedSprite3D.flip_h = false
	if left:
		direction_x -= 1.0
		$AnimatedSprite3D.flip_h = true
		
	# Nếu có bấm phím -> Tăng tốc mượt mà tới hướng đó
	if direction_x != 0:
		velocity.x = move_toward(velocity.x, direction_x * run_speed, FRICTION * delta)
	# Nếu không bấm phím (hoặc vừa tiếp đất mà không giữ phím) -> Trượt giảm tốc từ từ về 0
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	if jump and is_on_floor():
		if canDoubleJump:
			velocity.y = double_jump_speed
			canDoubleJump = false
			finishFirstJump = false
		else:
			velocity.y = jump_speed
			finishFirstJump = true
		
		var clone_smoke = smoke_effect.instantiate()
		clone_smoke.position = position
		get_parent().add_child(clone_smoke)
		
	
	

func update_state():
	if state == IDLE and velocity.x != 0:
		change_state(WALK)
	if state == WALK and velocity.x == 0:
		change_state(IDLE)
	if state in [IDLE, WALK] and !is_on_floor():
		change_state(JUMP)
		$Jump.play()
	if state == JUMP and is_on_floor():
		change_state(IDLE)

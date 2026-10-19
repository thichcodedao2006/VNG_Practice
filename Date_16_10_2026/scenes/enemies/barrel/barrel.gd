extends EnemyCharacter

enum FirePattern { SINGLE, BURST, SPREAD }

@export var bullet_speed: float = 12.0
@export var fire_pattern: FirePattern = FirePattern.SINGLE

@export_group("Burst")
@export var burst_count: int = 3
@export var burst_interval: float = 0.2

@export_group("Spread")
@export var spread_count: int = 3
## Góc lệch giữa hai viên liền kề, tính bằng độ.
@export var spread_step_degrees: float = 20.0

@onready var bullet_factory: Node3DFactory = $Direction/BulletFactory

var _burst_tween: Tween = null

func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Idle)
	super._ready()

func fire() -> void:
	var pattern: FirePattern = FirePattern.values().pick_random()
	match pattern:
		FirePattern.SINGLE:
			_fire_one(forward())
		FirePattern.BURST:
			_fire_burst()
		FirePattern.SPREAD:
			_fire_spread()

func _fire_one(dir: Vector3) -> void:
	var bullet := bullet_factory.create() as RigidBody3D
	bullet.apply_impulse(dir * bullet_speed)


func _fire_burst() -> void:
	stop_firing()
	_burst_tween = create_tween()
	for i in burst_count:
		if i > 0:
			_burst_tween.tween_interval(burst_interval)
		_burst_tween.tween_callback(func(): _fire_one(forward()))


func _fire_spread() -> void:
	var half: float = (spread_count - 1) / 2.0
	for i in spread_count:
		var angle: float = deg_to_rad((i - half) * spread_step_degrees)
		_fire_one(forward().rotated(Vector3.UP, angle))

func stop_firing() -> void:
	if _burst_tween != null and _burst_tween.is_valid():
		_burst_tween.kill()

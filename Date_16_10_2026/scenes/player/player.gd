class_name Player
extends BaseCharacter

## Turned on throughout the Hurt state so one hit doesn't drain health every single frame in a row.
var is_invulnerable: bool = false
var carried_object: BaseCharacter = null
@onready var grab_area: Area3D = $Direction/GrabArea3D
@onready var hold_point: Marker3D = $HoldPoint
@export var throw_speed: float = 8.0
@export var throw_up: float = 6.0

## use this for maximizing throw power 
var throw_power: float = 1.0 
var throw_power_ratio: float = 0.0

@export var bullet_speed: float = 15.0
@onready var bullet_factory: Node3DFactory = $Direction/BulletFactory

func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Idle)
	super._ready()


## Every state of the fox can take damage, so this calls straight into the current state; whichever
## state doesn't want to lose health (Dead) overrides take_damage().
func _on_hurt_area_3d_hurt(_direction: Vector3, damage: float) -> void:
	if is_invulnerable:
		return
	fsm.current_state.take_damage(int(damage))
	
func drop_carried() -> void:
	if carried_object == null:
		return
	carried_object.be_released(Vector3(0, 2.0, 0) - forward() * 1.5, false)
	carried_object = null
	
func throw_carried(power: float = 1.0) -> void:
	if carried_object == null:
		return
	var launch: Vector3 = forward() * throw_speed * power
	launch.y = throw_up
	carried_object.be_released(launch)
	carried_object = null
	
func fire() -> void:
	var bullet := bullet_factory.create() as RigidBody3D
	bullet.apply_impulse(forward() * bullet_speed)

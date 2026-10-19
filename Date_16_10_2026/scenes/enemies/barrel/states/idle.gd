extends EnemyState

@export var shoot_interval: float = 1.5

func _enter()-> void:
	obj.change_animation("idle")
	timer = shoot_interval

func _update( delta: float ) -> void:
	if update_timer(delta):
		change_state(fsm.states.shoot)
		

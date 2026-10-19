extends ProgressBar

@export var player: Player = null


func _process(_delta: float) -> void:
	var ratio: float = player.throw_power_ratio
	visible = ratio >= 0.0
	if not visible:
		return
	value = ratio

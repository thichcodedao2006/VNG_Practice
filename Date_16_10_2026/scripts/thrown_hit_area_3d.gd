extends HitArea3D
class_name ThrownHitArea3D

@export var min_height: float = 0.2

func _on_area_entered(area: Area3D) -> void:
	if area.owner == owner:
		return
	if owner.velocity.y >= 0.0:   # đang bay lên thì không tính
		return
	if global_position.y - area.global_position.y < min_height:   # không ở phía trên
		return
	hit(area)
	hitted.emit(area)

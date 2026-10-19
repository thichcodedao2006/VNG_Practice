extends Area3D
class_name GrabArea3D

## Trả về vật gần nhất có thể nhấc được, hoặc null nếu không có gì.
func find_carriable() -> BaseCharacter:
	var best: BaseCharacter = null
	var best_dist := INF
	for body in get_overlapping_bodies():
		if body is BaseCharacter and body.can_be_carried():
			var d := global_position.distance_squared_to(body.global_position)
			if d < best_dist:
				best_dist = d
				best = body
	return best

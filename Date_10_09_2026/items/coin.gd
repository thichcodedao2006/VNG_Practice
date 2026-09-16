extends Area3D

@export var coin_effect: PackedScene

func _ready() -> void:
	$AnimatedSprite3D.play("idle")
	print("x: " + str(position.x) +" y: " +  str(position.y) + " z: " +  str(position.z))
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D) -> void:
	print("Player Collision")
	$Coin.play()
	$CollisionShape3D.set_deferred("disabled", true)
	var clone_effect = coin_effect.instantiate()
	clone_effect.position = position
	get_parent().add_child(clone_effect)
	hide()

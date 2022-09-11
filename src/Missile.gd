extends Area2D

const speed = 600

var target_postion_x = 0

onready var ms = preload("res://assets/images/missile_2.png")


func _process(delta):
	if target_postion_x:
		global_position.x = lerp(global_position.x, target_postion_x, 0.1)
	position.y -= speed * delta


func set_target(offset):
	$Sprite.texture = ms
	target_postion_x = global_position.x + offset


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Missile_area_entered(area):
	area.hit()
	queue_free()

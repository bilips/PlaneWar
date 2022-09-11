extends Area2D

enum types {
	Double,
	Bomb
}
export(types) var type

const speed = 200


func _process(delta):
	position.y += speed * delta


func _ready():
	var window_width = OS.window_size.x
	var half_width = $Sprite.texture.get_size().x
	var full_height = $Sprite.texture.get_size().y
	
	position.x = rand_range(half_width, window_width - half_width)
	position.y = -full_height


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Supply_area_entered(area):
	match type:
		types.Double:
			area.get_node("DoubleTime").play("Double")
		types.Bomb:
			area.get_parent().add_bomb()
	queue_free()

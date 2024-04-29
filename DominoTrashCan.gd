extends Area2D


func _draw():
	var shape = find_child("CollisionShape2D")
	draw_rect(Rect2(-shape.shape.size/2, shape.shape.size), Color.RED, false, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = true
	pass # Replace with function body.

func _on_area_entered(area):
	var area_parent = area.get_parent()
	if area_parent is Domino:
		area_parent.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

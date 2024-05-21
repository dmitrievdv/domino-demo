# An area that deletes all dominos that touch it

extends Area2D


func _draw():
	var shape = find_child("CollisionShape2D") # This way we can set the size in the 2d scene editor
	draw_rect(Rect2(-shape.shape.size/2, shape.shape.size), Color.RED, false, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = true # this is neded to enable emission of signals on entering the trash can
	pass # Replace with function body.

# Called when another area is enetering the trash can
func _on_area_entered(area):
	var area_parent = area.get_parent()
	if area_parent is Domino: # we don't want to delete anything else, right?
		area_parent.queue_free() # deleting the domino

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_create_domino_pressed():
	var domino = Domino.new()
	add_child(domino)
	var size = domino.size
	var random_shift = Vector2(randf_range(-size, size), randf_range(-size/2, size/2))
	domino.global_position = find_child("DominoSpawnPoint").global_position + random_shift
	pass # Replace with function body.

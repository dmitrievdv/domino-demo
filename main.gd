extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#Called when "Create Domino" is pressed
func _on_create_domino_pressed():
	var domino = Domino.new()
	var spawn = find_child("DominoSpawnPoint") 
	# all dominos are children of a spawn point 
	# This way it's more organized I believe, but idk
	spawn.add_child(domino)
	
	var size = domino.size # domino width in px
	# a random shift to spawn position
	var random_shift = Vector2(randf_range(-size, size), randf_range(-size/2, size/2))
	domino.global_position = spawn.global_position + random_shift

# This is HUD that displays numbers of the DominoField
# it's positioned in the tree in such a way that it's drawn last^
# the only children of a scene root (Node2D) are another
# Node2D (a root for everything else) and this HUD

extends Node2D

var default_font = ThemeDB.fallback_font

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	# recursive search for a DominoField from the scene root
	var domino_field = get_parent().find_child("DominoField", true)
	var size = domino_field.size
	var n_side = domino_field.n_side
	var field = domino_field.field
	var cell_size = size/n_side
	var half_size = size/2.0
	var font_scale = 4.0/n_side # it's equal to 1 when the DominoField is 4x4
	for i in n_side:
		for j in n_side:
			var string = str(field[i*n_side + j])
			draw_string(default_font, Vector2(cell_size*i - half_size+5*font_scale, cell_size*j+20*font_scale - half_size), 
							string, HORIZONTAL_ALIGNMENT_LEFT, -1, 20*font_scale ,Color.RED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_domino_field_hud_redraw():
	queue_redraw()
	pass # Replace with function body.

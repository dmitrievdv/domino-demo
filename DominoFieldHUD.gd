extends Node2D

var default_font = ThemeDB.fallback_font

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	var domino_field = get_parent().find_child("DominoField", true)
	var size = domino_field.size
	var n_side = domino_field.n_side
	var field = domino_field.field
	var cell_size = size/4
	var half_size = size/2
	for i in n_side:
		for j in n_side:
			var string = str(field[i*n_side + j])
			draw_string(default_font, Vector2(cell_size*i - half_size+5, cell_size*j+20 - half_size), 
							string, HORIZONTAL_ALIGNMENT_LEFT, -1, 20 ,Color.RED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_domino_field_hud_redraw():
	queue_redraw()
	pass # Replace with function body.
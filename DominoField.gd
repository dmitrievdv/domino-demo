class_name DominoField extends Node2D

var n_side: int
var size: float
var field = []
var occupied = []

signal HUD_redraw

func _init():
	n_side = 10
	for i in n_side:
		for j in n_side:
			field.append(0)
			occupied.append(false)
	
func _draw():
	var cell_size = size*1.0/n_side
	var half_size = size*1.0/2
	draw_rect(Rect2(-half_size, -half_size, size, size), Color.GREEN, false, 3)
	for i in range(1,n_side):
		var line_coord = -half_size + i*cell_size
		draw_line(Vector2(line_coord, half_size), Vector2(line_coord, -half_size), Color.GREEN, 1)
		draw_line(Vector2(half_size, line_coord), Vector2(-half_size, line_coord), Color.GREEN, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	var rect = find_child("FieldShape2D", true)
	size = rect.shape.size[1]
	pass # Replace with function body.

#Returns index (in the DominoField.field) of the closest cell to the coordinates coords
func get_closest_cell(coords: Vector2):
	var cell_size = size*1.0/n_side
	var cell_id_float = (coords - Vector2(cell_size/2, cell_size/2) - Vector2(-size/2, -size/2))/cell_size
	var i = roundi(cell_id_float[0])
	if i >= n_side:
		i = n_side - 1
	var j = roundi(cell_id_float[1])
	if j >= n_side:
		j = n_side - 1
	return i*n_side + j

#Returns coordinates of the center of the cell DominoField.field[cell_id]	
func get_cell_coords(cell_id: int):
	var i = cell_id/n_side
	var j = cell_id%n_side
	var cell_size = size*1.0/n_side
	var x = i*cell_size + cell_size/2 - size/2.0
	var y = j*cell_size + cell_size/2 - size/2.0
	return Vector2(x, y)

#True if the point coords is inside the borders of the DominoField 
func coords_in_field(coords: Vector2):
	if abs(coords[0]) <= size/2 and abs(coords[1]) <= size/2:
		return true
	return false

func _on_domino_placed(domino: Domino):
	var cell_size = size*1.0/n_side
	var relative_pos = domino.global_position - global_position
	#coordinates of the "right" half of the domino relative to the center of the DominoField
	var right_coords = Vector2(cell_size/2, 0).rotated(domino.rotation) + relative_pos
	#coordinates of the "left" half of the domino relative to the center of the DominoField
	var left_coords = Vector2(-cell_size/2, 0).rotated(domino.rotation) + relative_pos
	var left_to_right = right_coords - left_coords
	if !coords_in_field(right_coords) or !coords_in_field(left_coords):
		return
	var left_cell = get_closest_cell(left_coords)
	var left_cell_coords = get_cell_coords(left_cell)
	var right_cell_coords = left_cell_coords + left_to_right
	var right_cell = get_closest_cell(right_cell_coords)
	if left_cell == right_cell:
		return
	if occupied[right_cell] or occupied[left_cell]:
		return
	field[right_cell] = domino.right_value # setting the field values according to the domino's values
	field[left_cell] = domino.left_value
	occupied[right_cell] = true # marking the cells as occupied
	occupied[left_cell] = true
	HUD_redraw.emit() # redrawing the HUD
	#Moving the domino to the correct position in the field
	var new_relative_pos = (get_cell_coords(right_cell) + get_cell_coords(left_cell))/2
	domino.global_position = new_relative_pos + global_position
	domino.placed_in_field = true

func _on_domino_picked(domino: Domino):
	var cell_size = size*1.0/n_side
	var relative_pos = domino.global_position - global_position
	var right_coords = Vector2(cell_size/2, 0).rotated(domino.rotation) + relative_pos
	var left_coords = Vector2(-cell_size/2, 0).rotated(domino.rotation) + relative_pos
	var left_to_right = right_coords - left_coords
	if !coords_in_field(right_coords) or !coords_in_field(left_coords) or !domino.placed_in_field:
		return
	var left_cell = get_closest_cell(left_coords)
	var left_cell_coords = get_cell_coords(left_cell)
	var right_cell_coords = left_cell_coords + left_to_right
	var right_cell = get_closest_cell(right_cell_coords)
	field[right_cell] = 0
	field[left_cell] = 0
	occupied[right_cell] = false
	occupied[left_cell] = false
	domino.placed_in_field = false
	HUD_redraw.emit()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

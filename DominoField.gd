class_name DominoField extends Node2D

var n_side: int # number of cells on each of the axes
var size: float # size in px
var field = [] # array that stores the domino numbers
var occupied = [] # array for occupancy checking

signal HUD_redraw

func _init():
	n_side = 4 # default size is 4
	for i in n_side:
		for j in n_side:
			field.append(0) # fill the field with zeros
			occupied.append(false)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var rect = find_child("FieldShape2D", true) # recursive search for a child
	# this way we can control the field size in the editor by changing the FieldArea2D
	size = rect.shape.size[1] # Field size (it needs to be a square, so only the first argument matter)
	pass # Replace with function body.
	

func _draw():
	var cell_size = size*1.0/n_side # size of one cell in px
	var half_size = size*1.0/2 # half of the field size in px
	draw_rect(Rect2(-half_size, -half_size, size, size), Color.GREEN, false, 3)
	for i in range(1,n_side):
		var line_coord = -half_size + i*cell_size
		draw_line(Vector2(line_coord, half_size), Vector2(line_coord, -half_size), Color.GREEN, 1)
		draw_line(Vector2(half_size, line_coord), Vector2(-half_size, line_coord), Color.GREEN, 1)

#Returns index (in the DominoField.field) of the closest cell to the coordinates coords
func get_closest_cell(coords: Vector2):
	var cell_size = size*1.0/n_side # size of one cell in px
	
	# the next line computes the cell row and rank numbers by computing the coordinates of the corner 
	# of the cell relative to the coordinates of the corner of the Field
	var cell_id_float = (coords - Vector2(cell_size/2, cell_size/2) - Vector2(-size/2, -size/2))/cell_size
	
	var i = roundi(cell_id_float[0]) # round to the integer
	
	# if out of bounds it's actually 0 or n-1
	if i >= n_side:
		i = n_side - 1
	if i < 0:
		i = 0
	
	var j = roundi(cell_id_float[1])
	if j >= n_side:
		j = n_side - 1
	if j < 0:
		j = 0
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

# Checks if the cell is either the value or empty
func check_cell(cell_id: int, value: int):
	if occupied[cell_id] and field[cell_id] != value:
			return false
	return true

# Checks if the neighbors are either the value or empty
func check_neighbors(cell_id: int, value: int):
	var cell_i = cell_id / n_side # integer division
	var cell_j = cell_id % n_side
	# the following ifs return false if the neighbor exist, occupied and has a wrong value
	if cell_j > 0 and !check_cell(cell_id - 1, value):
		return false
	if cell_j < n_side-1 and !check_cell(cell_id + 1, value):
		return false
	if cell_i > 0 and !check_cell(cell_id - n_side, value):
		return false
	if cell_i < n_side-1 and !check_cell(cell_id + n_side, value):
		return false
	return true
	
	
func _on_domino_placed(domino: Domino):
	var cell_size = size*1.0/n_side
	var relative_pos = domino.global_position - global_position
	#coordinates of the "right" half of the domino relative to the center of the DominoField
	var right_coords = Vector2(cell_size/2, 0).rotated(domino.rotation) + relative_pos
	#coordinates of the "left" half of the domino relative to the center of the DominoField
	var left_coords = Vector2(-cell_size/2, 0).rotated(domino.rotation) + relative_pos
	var left_to_right = right_coords - left_coords # for easy transition between domino sides
	
	# stop if domino is outside of the field 
	if !coords_in_field(right_coords) or !coords_in_field(left_coords):
		return
	
	var left_cell = get_closest_cell(left_coords)
	var left_cell_coords = get_cell_coords(left_cell)
	var right_cell_coords = left_cell_coords + left_to_right
	var right_cell = get_closest_cell(right_cell_coords)
	
	# weird edge case when the position is super precise
	if left_cell == right_cell:
		return
	
	# check if the neighboring field values are the proper ones
	if !check_neighbors(left_cell, domino.left_value) or !check_neighbors(right_cell, domino.right_value):
		return
	
	# can't place a domino in already occupied cell
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

# this function is almost the same as the previous one, so no commens
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

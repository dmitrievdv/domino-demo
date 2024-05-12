#Testing new origin, ignore this
class_name Domino extends Node2D

var default_font = ThemeDB.fallback_font

var size: float
var mouse_in: bool = false
var picked: bool = false
var mouse_relative: Vector2 = Vector2(0,0)
var rotate: bool = false
var left_value: int
var right_value: int 
var placed_in_field = false
var font_scale = 1

signal domino_picked
signal domino_placed

# Called when the node enters the scene tree for the first time.
func _ready():
	right_value = randi_range(0,6)
	left_value = randi_range(0,6)
	#set_physics_process(false)
	#custom_integrator = true
	var domino_field = get_parent().get_parent().find_child("DominoField")
	var domino_trash_can = get_parent().get_parent().find_child("DominoTrashCan")
	connect("domino_placed", domino_field._on_domino_placed.bind(self))
	connect("domino_picked", domino_field._on_domino_picked.bind(self))
	size = domino_field.size*0.9/domino_field.n_side
	font_scale = 4.0/domino_field.n_side
	var area = Area2D.new()
	var shape = CollisionShape2D.new()
	shape.shape = RectangleShape2D.new()
	shape.shape.size = Vector2(size*2, size)
	area.add_child(shape)
	area.mouse_entered.connect(_on_mouse_entered)
	area.mouse_exited.connect(_on_mouse_exited)
	add_child(area)
	pass # Replace with function body.

func _input(event):
	if mouse_in or picked:
		if event is InputEventMouseButton:
			if event.pressed:
				if event.button_index == MOUSE_BUTTON_LEFT and mouse_in:
					if !picked:
						domino_picked.emit()
					picked = true
					mouse_relative = get_global_mouse_position() - global_position
				if event.button_index == MOUSE_BUTTON_RIGHT and mouse_in:
					if !picked:
						domino_picked.emit()
					rotate = true
			if (!event.pressed and event.button_index == MOUSE_BUTTON_LEFT) and picked:
				if picked:
					domino_placed.emit()
				picked = false 

func _process(delta):
	if picked:
		global_position = get_global_mouse_position() - mouse_relative
	if rotate:
		rotation += PI/2
		domino_placed.emit()
		rotate = false

func increase_scale():
	scale *= 1.05
	
func reduce_scale():
	scale /= 1.05
	

func _draw():
	draw_rect(Rect2(-size, -size/2, size*2, size), Color.YELLOW, 1)
	draw_string(default_font, Vector2(-size/2-20*font_scale, 20*font_scale), str(left_value), 
						HORIZONTAL_ALIGNMENT_LEFT, -1, 60*font_scale, Color.BLUE)
	draw_string(default_font, Vector2(size/2-20*font_scale, 20*font_scale), str(right_value), 
						HORIZONTAL_ALIGNMENT_LEFT, -1, 60*font_scale, Color.BLUE)



func _on_mouse_exited():
	mouse_in = false
	reduce_scale()
	pass # Replace with function body.


func _on_mouse_entered():
	mouse_in = true
	increase_scale()
	pass # Replace with function body.

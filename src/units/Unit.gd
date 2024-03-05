extends Node2D
class_name Unit

@onready var sprites = $Sprites
@onready var player = $AnimationPlayer

var unit_type = "pawn"
var unit_side = "blue"

var is_selected = false
var is_dragged = false
var is_hovered = false

var return_position = Vector2.ZERO
var return_z_index = 0

var has_moved = false
var en_passant = false

signal was_selected(unit)
signal was_unselected(unit)


func _input(event):
	if is_dragged:
		global_position = get_global_mouse_position()

func init(unit_info):
	unit_type = unit_info["unit_type"]
	unit_side = unit_info["unit_side"]

func _ready():
	sprites.update_sprites(
		Constants.UNITS[unit_type]["sprites"],
		Constants.PALETTES[unit_side]
	)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("LeftMouseClick"):
		is_selected = true
		player.play("Idle")
		is_dragged = true
		return_z_index = z_index
		z_index = 10
		return_position = global_position
		emit_signal("was_selected", self)
	elif is_dragged and event.is_action_released("LeftMouseClick"):
		is_dragged = false
		global_position = return_position
		unselect()

func unselect():
	is_selected = false
	player.play("RESET")
	emit_signal("was_unselected", self)

func _on_area_2d_mouse_entered():
	is_hovered = true

func _on_area_2d_mouse_exited():
	is_hovered = false

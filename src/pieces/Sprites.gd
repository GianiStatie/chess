extends Node2D

@onready var head = $Head
@onready var body = $Body
@onready var left_arm = $LeftArm
@onready var right_arm = $RightArm

var color_palette = Constants.DEFAULT_PALETTE


func update_sprites(sprite_info, new_color_palette):
	for key in sprite_info:
		match key:
			"head":
				head.texture = sprite_info[key]
			_:
				print("Idk what %s is"%key)
	
	color_palette = new_color_palette
	update_palettes()

func update_palettes():
	var default_palette = Constants.DEFAULT_PALETTE
	
	material.set_shader_parameter("old_main_color", default_palette["old_main_color"])
	material.set_shader_parameter("old_shadow_color", default_palette["old_shadow_color"])
	material.set_shader_parameter("old_light_color", default_palette["old_light_color"])
	
	material.set_shader_parameter("new_main_color", color_palette["new_main_color"])
	material.set_shader_parameter("new_shadow_color", color_palette["new_shadow_color"])
	material.set_shader_parameter("new_light_color", color_palette["new_light_color"])

class_name FogOfWar extends Node2D



@onready var fog_sprite: Sprite2D = %FogSprite

@onready var world_tiles: TileMapLayer = %WorldTiles

@onready var vision_sprite: Sprite2D = %VisionSprite

@export var fog_pixelation: int = 1
@onready var player: CharacterBody2D = %Player
@onready var save_fog_button: Button = %SaveFog

var vision_image: Image
var fog_image: Image
var world_position: Vector2

var drawing: bool = false
func _ready() ->void:
	save_fog_button.pressed.connect(func() ->void: fog_image.save_png("res://fog.png"))
	generate_fog()
	update_fog()

func generate_fog() ->void:
	# get the size of the tileset in pixels
	var world_dimentions = world_tiles.get_used_rect().size * world_tiles.tile_set.tile_size

	# get the world position coordinates in pixels
	world_position = world_tiles.get_used_rect().position * world_tiles.tile_set.tile_size



	# pixelate it ( fog pixelation makes it so 1pixel is going to correspond to fog_pixelation amount of pixels )
	var scaled_dims = ceil(Vector2(world_dimentions) / fog_pixelation)
	# create fog_image that is going to cover everything
	fog_image = Image.create(scaled_dims.x, scaled_dims.y, false, Image.Format.FORMAT_RGBA8)
	# fill with color
	fog_image.fill(Color.BLACK)
	# make a texture out of this image
	var fog_texture = ImageTexture.create_from_image(fog_image)
	
	# set fog_sprite position to where the tiles begin
	fog_sprite.position = world_position
	# set the texture on the sprite
	fog_sprite.texture = fog_texture
	# scale the sprite to cover the entire thing
	print(fog_texture.get_size())
	fog_sprite.scale *= fog_pixelation
	#fog_sprite.position += Vector2(world_dimentions / 2.0)
	print(fog_sprite.scale)

	
	vision_image = vision_sprite.texture.get_image()
	# figure out what was the original proportions of the vision image 
	var vision_proportions = Vector2(vision_image.get_size()) / fog_pixelation
	# resize the vision image ( basically can be done by hand in the editor, but annoying to do )
	vision_image.resize(vision_proportions.x, vision_proportions.y)
	# convert the image to the same format as the fog image ( maybe neccessary )
	vision_image.convert(Image.Format.FORMAT_RGBA8)





func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drawing = event.is_pressed()

	if event is InputEventMouseMotion:
		if drawing:
			update_fog()

func _process(_delta: float) -> void:
	if player.velocity.length():
		update_fog()

func update_fog() ->void:
	# get the rect of the vision and reset it's position
	var vision_rect = Rect2(Vector2.ZERO, vision_image.get_size())
	# blend vision image with the fog image at the position of the mouse that is converted to account for the pixelation ( also centers the vision at the position )
	fog_image.blend_rect(vision_image, vision_rect, player.global_position / fog_pixelation - (world_position / fog_pixelation) - Vector2(vision_image.get_size() / 2))
	# recreate fog texture with the new image
	var fog_texture = ImageTexture.create_from_image(fog_image)
	# set the texture to the fog sprite
	fog_sprite.texture = fog_texture

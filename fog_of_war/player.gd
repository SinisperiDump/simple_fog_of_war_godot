class_name Player extends CharacterBody2D



@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

var speed: float = 80.0



func _physics_process(_delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	animate(input_vector)
	self.velocity = self.velocity.move_toward((input_vector).normalized() * speed, 10.0)
	move_and_slide()



func animate(direction: Vector2) ->void:
	if direction.x:
		animated_sprite.play("walk_h")
		animated_sprite.flip_h = direction.x < 0
	elif direction.y:
		animated_sprite.play("walk_down" if direction.y > 0 else "walk_up")
	else:
		animated_sprite.play("idle")




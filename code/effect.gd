extends Node2D

var lifetime: float = 1.0
var speed: float = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= speed * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func set_text(text: String) -> void:
	%Label.text = text

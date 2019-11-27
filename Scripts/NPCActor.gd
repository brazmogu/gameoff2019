extends KinematicBody2D

# Bounce factor (for vertical collisions)
export (float) var bounce = 1.0
# Push factor (for horizontal collisions)
export (float) var pushback = 16.0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

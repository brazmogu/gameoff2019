extends "res://Scripts/NPCActor.gd"

export (float) var walkSpeed = 16

export (NodePath) var raycasterNode = "Floor Checker"
var raycaster

enum Direction {RIGHT = 1, LEFT = -1}
export (Direction) var direction = Direction.RIGHT
    
func _ready():
    raycaster = get_node(raycasterNode)
    
func _process(dt):
    move_and_slide(Vector2(direction, 0) * walkSpeed, Vector2.UP)

    # Check if there's still floor forward
    # Otherwise, turn around    
    if not raycaster.is_colliding():
        direction = -direction
        scale.x = -scale.x

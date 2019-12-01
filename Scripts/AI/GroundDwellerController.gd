extends "res://Scripts/NPCActor.gd"

export (float) var walkSpeed = 16

export (NodePath) var raycasterNode = "Floor Checker"
var raycaster

enum Direction {RIGHT = 1, LEFT = -1}
export (Direction) var direction = Direction.RIGHT

var SimplifiedPhysics2D = load("res://Scripts/SimplifiedPhysics2D.gd")

func _ready():
    raycaster = get_node(raycasterNode)
    scale.x = scale.x * direction
    
func _process(dt):
    move_and_slide(Vector2(direction, 0) * walkSpeed, Vector2.UP)
    for i in get_slide_count():
        var collision = get_slide_collision(i)
        if collision.collider is SimplifiedPhysics2D and abs(collision.normal.x) >= 0.6:
            collision.collider.push(pushback, -collision.normal)
            turnAround()
        elif collision.collider is TileMap and abs(collision.normal.x) == 1:
            turnAround()
    # Check if there's still floor forward
    # Otherwise, turn around    
    if not raycaster.is_colliding():
        turnAround()

func turnAround():
    direction = -direction
    scale.x = -scale.x
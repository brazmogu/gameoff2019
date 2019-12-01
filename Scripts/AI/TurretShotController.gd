extends NPCActor

var shotSpeed:Vector2

func _ready():
    pushback = 32

func setSpeed(velocity:Vector2):
    shotSpeed = velocity

var SimplifiedPhysics2D = load("res://Scripts/SimplifiedPhysics2D.gd")

func _process(delta):
    var collision = move_and_collide(delta * shotSpeed, true)
    if collision:
        if collision.collider is TileMap:
            get_parent().remove_child(self)
        elif collision.collider is SimplifiedPhysics2D:
            collision.collider.push(pushback, -collision.normal)
            get_parent().remove_child(self)
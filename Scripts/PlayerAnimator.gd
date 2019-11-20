extends AnimationPlayer

export (NodePath) var physicsNode = ".."
var physics

enum Direction {LEFT = -1, RIGHT = 1}
var facingDirection = Direction.RIGHT

func _ready():
    physics = get_node(physicsNode)
    
    physics.connect("floored", self, "on_land")
    physics.connect("airborne", self, "on_air")

func _process(dt):
    match current_animation:
        "Idle":
            if physics.hspeed != 0:
                play("Walk", 0.1)
                if physics.hspeed * facingDirection < 0:
                    facingDirection = -facingDirection
                    physics.scale.x = -1
        "Walk":
            if physics.hspeed == 0:
                play("Idle", 0.1) 
            if physics.hspeed * facingDirection < 0:
                facingDirection = -facingDirection
                physics.scale.x = -1 

func on_land():
    if current_animation == "Fall":
        play("Idle", 0.1)

func on_air():
    if physics.vspeed < 0:
        play("Leap", 0.1)
    else:
        play("Fall", 0.1)
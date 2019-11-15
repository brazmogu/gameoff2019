extends KinematicBody2D

class_name SimplifiedPhysics2D

# Height of jump
export var jumpHeight:float = 16
# Time of jump (until peak of jump)
export var jumpTime:float = 0.5
# Speed of walking
export var walkSpeed:float = 32
# Time until stopping (on floor)
export var dampTime:float = 0.25

var vspeed:float
var hspeed:float
var friction:float
var gravity:float

var onFloor:bool = false
var onAir:bool = false

signal floored
signal airborne

func _ready():
    friction = walkSpeed / dampTime
    gravity = 2 * jumpHeight / pow(jumpTime, 2)
        
    pass # Replace with function body.

func _process(dt):
    move_and_slide(Vector2(hspeed, vspeed))
   
    check_floor()
    
    if onFloor:
        if hspeed > 0:
            hspeed = clamp(hspeed - friction*dt, 0, hspeed)
        elif hspeed < 0:
            hspeed = clamp(hspeed + friction*dt, hspeed, 0)
        vspeed = 0
    else:
        vspeed += gravity*dt

func jump():
    if onFloor:
        var jumpSpeed:float = sqrt(2 * gravity * jumpHeight)
        vspeed = -jumpSpeed
        onAir = true
        onFloor = false
        emit_signal("airborne")
    
func walk(dir):
    var bump:KinematicCollision2D = move_and_collide(Vector2(dir, 0).normalized(), true, true, true)
    
    if bump == null:
        hspeed = dir * walkSpeed
    
func check_floor():
    var bump:KinematicCollision2D = move_and_collide(Vector2(0, 1), true, true, true)
    
    var touchedDown:bool = bump != null
    
    if not onFloor and vspeed >= 0 and touchedDown:
        emit_signal("floored")
        
        onFloor = true
        onAir = onAir and not touchedDown
    if onFloor and not touchedDown:
        emit_signal("airborne")
        onAir = true
        onFloor = false
    
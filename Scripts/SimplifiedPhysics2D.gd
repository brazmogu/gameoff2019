extends KinematicBody2D

class_name SimplifiedPhysics2D

# Ignore gravity
export var ignoreGravity:float = false
# Height of jump
export var jumpHeight:float = 16
# Time of jump (until peak of jump)
export var jumpTime:float = 0.5
# Speed of walking
export var walkSpeed:float = 32
# Time until stopping (on floor)
export var dampTime:float = 0.25
# Air walking influcence on horizontal speed
export var airWalkDelta:float = 0.5

var vspeed:float = 0
var hspeed:float = 0
var friction:float = 0
var gravity:float = 0

var debug_velocity:Vector2

var onFloor:bool = false
var onAir:bool = false

signal floored
signal airborne
signal bounce
signal pushback

func _ready():
    if not ignoreGravity:
        friction = walkSpeed / dampTime
        gravity = 2 * jumpHeight / pow(jumpTime, 2)

func _process(dt):
    var velocity = move_and_slide(Vector2(hspeed, vspeed), Vector2(0, -1))
    debug_velocity = velocity

    if velocity.y == 0:
        check_floor()
    
    check_bounce()
    
    if onFloor:
        if hspeed > 0:
            hspeed = clamp(hspeed - friction*dt, 0, hspeed)
        elif hspeed < 0:
            hspeed = clamp(hspeed + friction*dt, hspeed, 0)
        vspeed = 0
    else:
        vspeed += gravity*dt

func jump(height := 1.0, force := false):
    if onFloor or force:
        var jumpSpeed:float = sqrt(2 * gravity * height * jumpHeight)
        vspeed = -jumpSpeed
        onAir = true
        onFloor = false
        emit_signal("airborne")

func walk(dir):
    var bump:KinematicCollision2D = move_and_collide(Vector2(dir, 0).normalized(), true, true, true)
    
    if bump == null:
        if onFloor:
            hspeed = dir * walkSpeed
        if onAir:
            hspeed = clamp(hspeed + dir * airWalkDelta, -walkSpeed, walkSpeed)
    
func check_floor():
    var bump:KinematicCollision2D = move_and_collide(Vector2(0, 1), true, true, true)
    
    var touchedDown:bool = bump != null
    
    if not onFloor and touchedDown:
        emit_signal("floored")
        onFloor = true
        onAir = onAir and not touchedDown
    if onFloor and not touchedDown:
        emit_signal("airborne")
        onAir = true
        onFloor = false

func check_bounce():
    for i in get_slide_count():
        var collision:KinematicCollision2D = get_slide_collision(i)
        if collision.normal.y < 0:
            if collision.position.y >= position.y:
                if "bounce" in collision.collider:
                    jump(collision.collider.bounce, true) 
                    emit_signal("bounce", collision.collider)
                    return true
        if abs(collision.normal.x) > 0.8:
            if "pushback" in collision.collider:
                jump(0.25, true)
                hspeed = collision.normal.x * collision.collider.pushback
                return true
            
    return false

func _draw():
    draw_line(position, position + debug_velocity, Color.maroon, 2.0, true)
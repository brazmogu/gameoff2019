tool
extends "res://Scripts/NPCActor.gd"

export (NodePath) var animatorNode = "Animator"
onready var animator = get_node(animatorNode)

# Time to firs shot
export (float) var firstShotDelay = 0.0
# Delay between shots
export (float) var shotInterval = 1.0
# Shooting vector
export (Vector2) var shootDirection = Vector2(16, 0)
# Shooting spawn point
export (Vector2) var gunPosition = Vector2(0, -40)

onready var shotTime = firstShotDelay

# Called when the node enters the scene tree for the first time.
func _ready():
    if shootDirection.x < 0:
        get_node("Sprite").scale.x = -1

func _process(dt):
    if Engine.editor_hint:
        update()
        return
    
    shotTime = shotTime - dt
    if shotTime <= 0:
        shotTime = shotTime + shotInterval
        shoot()

func shoot():
    animator.play("Shoot")
    var shot = load("res://Prefab/TurretShot.tscn").instance()
    shot.setSpeed(shootDirection)
    get_parent().add_child(shot)
    shot.position = position + gunPosition

func _draw():
    if Engine.editor_hint:
        var gunPoint = position + gunPosition
        draw_line(gunPoint, gunPoint + shootDirection, Color.darkgreen, 4.0)
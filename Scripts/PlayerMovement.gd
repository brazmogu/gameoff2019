extends Node2D

export(NodePath) var physicsNode = ".."
export(NodePath) var animatorNode = "AnimationPlayer"

var physicsBody: SimplifiedPhysics2D
var animator: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
    physicsBody = get_node(physicsNode)
    animator = get_node(animatorNode)
    
func _process(dt):
    if Input.is_action_just_pressed("ui_up"):
        physicsBody.jump()
    if Input.is_action_pressed("ui_right"):
        physicsBody.walk(1)
    if Input.is_action_pressed("ui_left"):
        physicsBody.walk(-1)
    

func _onPlayerReady():
    physicsBody.jump(2.5, true)

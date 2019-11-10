extends Node2D

export(NodePath) var physicsNode

var physicsBody: SimplifiedPhysics2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    physicsBody = get_node(physicsNode)
    
func _process(dt):
    if Input.is_action_just_pressed("ui_up"):
        physicsBody.jump()
    if Input.is_action_pressed("ui_right"):
        physicsBody.walk(1)
    if Input.is_action_pressed("ui_left"):
        physicsBody.walk(-1)
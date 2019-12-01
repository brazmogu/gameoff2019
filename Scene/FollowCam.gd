extends Camera2D

export(NodePath) var targetPath
var target:Node2D

export(NodePath) var fadeOutPath

# Follow Threshold
export var followThreshold:Vector2
# Follow time (seconds)
export(float) var followTime = 1.0

# Follow status (true: move towards target)
var following:bool = false
# Next focus point (movement target)
var focusPoint:Vector2
# Follow Velocity (pixels per second)
var focusVelocity:Vector2
# Offset to focus point
export var focusOffset:Vector2

signal off_camera

# Called when the node enters the scene tree for the first time.
func _ready():
    target = get_node(targetPath)
    target.connect("floored", self, "startFollow")

func _process(dt):
    if following:
        var stepSize:float = min((focusPoint - position).length(), focusVelocity.length()*dt)
        position += focusVelocity.normalized() * stepSize
    
    if (focusPoint - position).length_squared() < 1:
        position = focusPoint
        following = false

func startFollow():
    if target.position.y < position.y - followThreshold.y:
        following = true
        focusPoint = target.position + focusOffset
        focusPoint.x = position.x
        focusVelocity = (focusPoint - position) / followTime

func _on_Visible_Area_body_exited(body):
    if body is TileMap:
        var mapRoot = body.get_parent()
        if "_off_camera" in mapRoot:
            body.call("_off_camera")

func _on_Survival_Area_body_exited(body):
    if body == target:
        target.get_parent()
        body.queue_free()
        
        var fadeOut = get_node(fadeOutPath)
        fadeOut.connect("faded", self, "on_fade_out")
        fadeOut.fade_out(2)

func on_fade_out():
    get_tree().change_scene("res://Scene/Title.tscn")

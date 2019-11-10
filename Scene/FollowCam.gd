extends Camera2D

export(NodePath) var targetPath
var target:Node2D

# Follow time (seconds)
export(float) var followTime = 1.0

# Follow status (true: move towards target)
var following:bool = false
# Next focus point (movement target)
var focusPoint:Vector2
# Follow Velocity (pixels per second)
var focusVelocity:Vector2

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
    if target.position.y < position.y:
        following = true
        focusPoint = target.position
        focusPoint.x = position.x
        focusVelocity = (focusPoint - position) / followTime

func _on_Visible_Area_area_exited(area):
    print("Something Left")


func _on_Visible_Area_body_exited(body):
    print("Something Left:", body)

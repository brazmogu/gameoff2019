tool
extends "res://Scripts/NPCActor.gd"

export (Array, Vector2) var waypoints = [Vector2(-16, 0), Vector2(16, 0)]
var point = 0
var next_point = 1
var route_direction = 1

export (float) var flySpeed = 16

func _ready():
    if not Engine.editor_hint:
        for i in range(waypoints.size()):
            waypoints[i] = waypoints[i] + position
        position = waypoints[0]

func _process(dt):
    if Engine.editor_hint:
        update()
        return
    
    var move_vector:Vector2 = waypoints[next_point] - position
    if move_vector.length() < 2 * flySpeed * dt:
        position = waypoints[next_point]
        point = next_point
        next_point = next_point + route_direction
        if next_point >= waypoints.size() or next_point < 0:
            route_direction = -route_direction
            next_point = next_point + 2*route_direction
    else:
        var result = move_and_slide(move_vector.normalized() * flySpeed)
        
func _draw():
    if Engine.editor_hint:
        var prevPoint
        for point in waypoints:
            if prevPoint == null:
                prevPoint = position + point
            else:
                var nextPoint = position + point
                draw_line(prevPoint, nextPoint, Color.purple, 2, true)
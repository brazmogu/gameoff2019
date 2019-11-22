extends Node2D

export(Array, String, FILE, "*.tscn") var nextSegments

var total_rect:Rect2
var cell_size:Vector2

func _ready():
    for child in get_children():
        if not cell_size:
            cell_size = child.cell_size
        if child.has_method("get_used_rect"):
            var this_rect = child.get_used_rect()
            total_rect = total_rect.expand(this_rect.position)
            total_rect = total_rect.expand(this_rect.end)

func get_used_rect():
    return total_rect
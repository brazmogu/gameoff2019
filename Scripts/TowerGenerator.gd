extends Node

const TowerSegment = preload("TowerSegment.gd")

export (String, FILE, "Tower*.tscn") var base

func _ready():
    var BaseSegment = load(base)
    var towerBase = BaseSegment.instance()
    add_child(towerBase)


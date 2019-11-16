extends Node

const TowerSegment = preload("TowerSegment.gd")

export (String, FILE, "Tower*.tscn") var base
export (NodePath) var playerNode
var playerCharacter

export (float) var spawnTreshold = 144
var nextMapPosition = 0
var nextMapSegments = null

func _ready():
    spawnSegment(base)
    
    playerCharacter = get_node(playerNode)
    playerCharacter.connect("floored", self, "check_height")

func spawnSegment(segmentPath):
    var segment:TowerSegment = load(segmentPath).instance()
    segment.position.y = -nextMapPosition
    add_child(segment)
    
    nextMapPosition += segment.get_used_rect().size[1] * segment.cell_size[1]
    nextMapSegments = segment.nextSegments

func check_height():
    if abs(-playerCharacter.position.y - nextMapPosition) < spawnTreshold:
        var lastMapPosition = nextMapPosition
        while (nextMapPosition - lastMapPosition < spawnTreshold):
            spawnSegment(nextMapSegments[0])
extends Node

const TowerSegment = preload("TowerSegment.gd")

export (String, FILE, "Tower*.tscn") var base
export (NodePath) var playerNode
onready var playerCharacter = get_node(playerNode)

export (NodePath) var cameraNode
onready var camera = get_node(cameraNode)

export (float) var spawnTreshold = 144
var nextMapPosition = 0
var nextMapSegments = null
var rng:RandomNumberGenerator

func _ready():
    rng = RandomNumberGenerator.new()
    rng.randomize()
    
    spawnSegment(base)
    
    playerCharacter.connect("floored", self, "check_height")
    camera.connect("off_camera", self, "checkSegmentForRemoval")

func spawnSegment(segmentPath):
    var segment:TowerSegment = load(segmentPath).instance()
    segment.position.y = -nextMapPosition
    add_child(segment)
    
    nextMapPosition += segment.get_used_rect().size[1] * segment.scale[1] * segment.cell_size[1]
    nextMapSegments = segment.nextSegments

func check_height():
    if abs(-playerCharacter.position.y - nextMapPosition) < spawnTreshold:
        var lastMapPosition = nextMapPosition
        while (nextMapPosition - lastMapPosition < spawnTreshold):
            spawnSegment(pickNextSegment())

func pickNextSegment():
    return nextMapSegments[rng.randi_range(0, nextMapSegments.size()-1)]
    
func checkSegmentForRemoval(segment):
    for child in get_children():
        if segment.get_parent() == child:
            remove_child(segment)
            segment.queue_free()
            return
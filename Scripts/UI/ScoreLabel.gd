extends Label

export(NodePath) var scoreKeeperPath

export var format:String = "%05d"
var displayValue = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    var scoreKeeper = get_node(scoreKeeperPath)
    scoreKeeper.connect("score_update", self, "update_value")
    
    update_text()

func update_text():
    text = format % displayValue
    
func update_value(newValue):
    displayValue = newValue
    update_text()
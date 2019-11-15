extends Node

# Who is the player?
export (NodePath) var playerCharacterPath
var playerCharacter

# How many pixels make a meter?
export (float) var pixelsPerMeter = 16

# How far the player has gone this session
var height:float
# The last height the player's height has been tracked
var lastHeight:float = -1

signal score_update

func _ready():
    height = 0
    playerCharacter = get_node(playerCharacterPath)
    playerCharacter.connect("floored", self, "on_player_landed")
    pass # Replace with function body.

func add_to_height(amount):
    if amount > 0:
        height += amount

func on_player_landed():
    var playerHeight = abs(playerCharacter.position.y) / pixelsPerMeter
    if lastHeight < 0:
        lastHeight = playerHeight
    elif lastHeight < playerHeight:
        add_to_height(playerHeight - lastHeight)
        lastHeight = playerHeight
    emit_signal("score_update", height)
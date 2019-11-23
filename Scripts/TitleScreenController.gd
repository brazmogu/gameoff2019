extends Node2D

export (String, FILE) var gameScene

func _ready():
    var fadeIn = get_node("Fade UI")
    fadeIn.fade_in(2.0)

func _process(dt):
    if Input.is_action_just_pressed("ui_accept"):
        var fadeOut = get_node("Fade UI")
        fadeOut.connect("faded", self, "on_fade_out")
        fadeOut.fade_out(2.0)

func on_fade_out():
    get_tree().change_scene(gameScene)
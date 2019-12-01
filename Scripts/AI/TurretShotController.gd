extends KinematicBody2D

var shotSpeed:Vector2

func setSpeed(velocity:Vector2):
    shotSpeed = velocity

func _process(delta):
    move_and_collide(delta * shotSpeed, true)

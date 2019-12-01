extends KinematicBody2D

var shotSpeed:Vector2

func setSpeed(velocity:Vector2):
    shotSpeed = velocity

func _process(delta):
    var collision = move_and_collide(delta * shotSpeed, true)
    if collision:
        if collision.collider is TileMap:
            get_parent().remove_child(self)
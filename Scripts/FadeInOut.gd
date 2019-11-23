extends CanvasLayer

export (NodePath) var solidPath = "Black"
onready var solidColor:ColorRect = get_node(solidPath)

export (bool) var faded = false

# Fading coroutine
var fading

signal faded

func _ready():
    if faded:
        solidColor.color.a = 0

func _process(dt):
    if fading:
        fading = fading.resume(dt)
    
func fade_to(alpha, rate):
    var delta = alpha - solidColor.color.a
    if delta * rate <= 0:
        print("Fade canceled - can't fade from %f to %f with rate %f!" % 
        [solidColor.color.a, alpha, rate])
        return
    
    while sign(rate) * delta > 0.01:
        var dt = yield()
        var d_alpha = rate * dt
        solidColor.color.a += d_alpha
        delta -= d_alpha
    
    solidColor.color.a = alpha
    emit_signal("faded")
    return
    
func fade_in(time := 1.0):
    if not fading:
        fading = fade_to(0, -solidColor.color.a / time)

func fade_out(time := 1.0):
    if not fading:
        fading = fade_to(1, (1 - solidColor.color.a) / time)
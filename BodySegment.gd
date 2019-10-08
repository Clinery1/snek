extends KinematicBody2D


var next_segment:Array=[false,false]
var last_move:Vector2
var head


func _ready():
    head=get_parent().get_node("Head")

func move(amount:Vector2):
    position+=amount
    if next_segment[0]:
        next_segment[1].move(last_move)
    last_move=amount
    if next_segment[0]:
        pass

func spawn():
    if !next_segment[0]:
        next_segment[1]=head.body_segment.instance()
        get_parent().add_child(next_segment[1])
        next_segment[1].position=position-last_move
        next_segment[0]=true
    else:
        next_segment[1].spawn()
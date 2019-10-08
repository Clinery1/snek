extends Node2D


var head
var label
var desktop:bool=true


func _ready():
    head=get_node("Head")
    label=get_node("Label")
    if OS.get_name()=="Android":
        desktop=false

func _on_Head_game_over():
    head.position=Vector2(200,200)
    head.rotation=0
    head.segment[0]=false
    head._ready()
    label.score=0
    label.set_text("Score:0")
    for child in get_children():
        if "Segment" in child.name:
            child.queue_free()
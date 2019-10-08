extends Label


var score:int=0


func _on_Head_score():
    score+=1
    set_text("Score:"+String(score))
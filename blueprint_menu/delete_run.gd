@tool
extends EditorScript

enum  FART{A,B,C}
func _run()->void:
	for t in FART:
		print(','.join(FART.keys()))

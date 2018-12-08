# Godot Scene Tree "philosophy"

The concept is pretty simply. Every scene has a root and you could append more nodes to it.

The nice thing is that scenes trees could be saved and then loaded. That means, that you can add all the sprites,
physics and etc to a Node in a scene instead of progammatically adding them in one by one in a script.
For example in your script you could do something like:

```GDScript
var SomeSceneWithJuicyDeets = load('res://Scenes/Bullet.tscn')
var SceneTree = SomeSceneWithJuicyDeets.instance()
get_node
```
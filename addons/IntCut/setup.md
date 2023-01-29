# Setup

## Setting up your actors

Actors are what we call the nodes which are acting in the cutscene. To work with IntCut, you need to
have them set up with the following:

### Functions

```gdscript
move(duration: float, x: float, y: float, movement_type: String = "absolute", easing: EaseType = 0 (Tween.EASE_IN), transition: TransitionType = 0 (Tween.TRANS_LINEAR), relative_to: Node2D = null)
```
`duration : float` - The duration of the movement in seconds

`x: float` - The x position to be moved to

`y: float` - The y position to be moved to

`movement_type: String = "absolute"` - Sets movement type. Either "absolute" (an absolute position in the world) or "relative" (relative to another actor)

`easing: EaseType (as int) = 0 (Tween.EASE_IN) ` - The easing that will be used in the motion

`transition: TransitionType (as int) = 0 (Tween.TRANS_LINEAR)`

`relative_to: Node2D = null`


```gdscript
play()
```

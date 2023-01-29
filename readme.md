# Intangible Cutscene Engine (IntCut)

This is the cutscene engine that I use for my games. It's somewhat modular, easily(ish) extensible,
and uses a readable language to write the cutscenes. 

## Features

- Readable plain-text cutscene language.
- Dialogue bubbles (can be switched out for boxes by doing some modifications)
- Easy to integrate your other systems into
- Non-blocking cutscenes, so you can easily have people talking while your players moves around

## Caveats

- Made for 2D. Will not work for 3D without some *serious* changes
- Requires the following
	- All cutscene objects to have a state machine and a "normal" (or whatever else you may call it) state (and a `set_state()` function)
	- Translation files
	- Actors to have [these functions](addons/IntCut/setup.md)

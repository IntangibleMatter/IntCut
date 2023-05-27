# Writing Cutscenes

## Making a new cutscene

IntCut cutscenes are implemented with GDScript. To create a new cutscene,
create a new GDscript file that extends `IntCutScene`.

## Writing dialogue

IntCut automatically translates all dialogue from the translations generated in
the engine. As such, when you write dialogue it *must* be done in a translation
file. Please see
[the godot docs page about writing dialogue](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_translations.html)
for more info on creating translations for Godot.

### Formatting

IntCut supports all built in
[BBCode formatting](https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html)
of Godot. 

### Dialogue additional formatting

IntCut has the ability to use variables and the like in dialogue.

#### Variables 

To use variables in dialogue, surround the string used to identify the variable 
in your game's blackboard with two curly braces on each side. As an example,
if you were to access the variable `money` from the blackboard, you might
write this:

`"You have ${{money}}! Wanna buy something?"`

#### Commands

You can execute commands from your dialogue! Or at least, trigger them. In the
function which calls the dialogue, you can add an array of callables. These
will all be triggered at the appropriate moments in the dialogue, denoted by a
pair of braces around the index into the array. As an example, if you wanted
to play a sound and run an animation at a certain point in the dialogue, you
could do the following in your code:

```swift
## PLEASE NOTE THAT THIS IS PSEUDOCODE. THE FUNCTION HAS MORE PARAMETERS
## AND YOU SHOULD REFER TO THE DOCUMENTATION FOR SAY INSTEAD OF THIS SNIPPET!

say("Whoa... that's... {0}{1} really funny, dude!", [Callable(play_sound, "laugh.ogg"), Callale(play_anim, "laugh"])
```

## Basic functions

pass

## Advanced functions

pass


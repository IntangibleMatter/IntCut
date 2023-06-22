
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

#### Special Characters

There are some character that IntCut treats differently for various reasons.
The following is a list of the characters and what they do.

- `\n`
	- the string `\n` (or just a regular newline) will be seen as a newline by 
	IntCut's text parser.
- `|`
	- The pipe character (`|`) is used to represent a pause in the dialogue.
	The pause is 0.1 seconds long, so if you had a dialogue line which was
	written as `"Oh...||| I see."`, there would be a 0.3 second pause after
	the elipsis.
- `` ` ``
	- the backtick character (`` ` ``) is used to separate a single message
	into multiple messages. Primarily aimed at translations, but could make
	writing longwinded monologues that don't get interrupted a bit easier.
- `^`
	- The caret character (`^`) is used to indicate that a message should be
	interrupted at this point. Can be used for autoadvancing dialogue, or
	allowing a character to be interrupted.

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

say("Whoa... that's... {0}{1} really funny, dude!", [Callable(play_sound, "laugh.ogg"), Callable(play_anim, "laugh"])
```

## Functions

### Cutscene actions

#### say

**params**

- actor: String
	- The string used to refer to the actor in the cutscene.
- line: String
	- The translation key for the line
- continues: bool = false
	- Sets whether the dialogue box should stay open after this line. Super
	janky solution to solve the problem of continuing the same dialogue.
- pos: int = 0
	- Sets any position display flags for the dialogue box. 0 is default.
		- 0 -> automatic positioning
		- 1 -> force box to top
		- 2 -> force box to bottom
- callables: Array[Callable]
	- An array of callables. They can be triggered at any point in the 
	dialogue. If you want to bypass this option, set it to an empty array.
- duration: float = -1
	- Sets the dration that the dialogue bubble will be open. Used for dialogue
	which progresses automatically, is interrupted, or is part of a non-player
	controlled cutscene.

#### choice

Gives a choice to the user. Can split in any number of directions.

**params**

- choices: Array[Dictionary]
	- dictionary must have the following format:
		- `{tr_string: string, label: string}`
			- tr_string is the translation string used for the dialogue option
			- label is the label which will be jumped to if the choice is
			selected

### Flow

These functions change the flow of the cutscene in some way or another.

#### jump

Moves control flow to another function in the cutscene.

**params**

- label: String
	- the name of the function to jump to



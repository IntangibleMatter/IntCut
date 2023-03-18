# Writing Cutscenes

IntCut uses plain text files with the extension `.cut.txt` for its cutscenes.

## Cutscene Files

Cutscene files are a collection of [labels](#cutscene-labels),
[commands](#cutscene-commands), and the

## Cutscene Labels

IntCut uses labels to organize the cutscene flow. Labels are groups of commands started with a
single line which begins with a tilde (`~`) followed by a label name. Here's an example label:

```txt
~john-talk-0
command argument argument argument
command argument argument argument argument argument
command argument argument
command argument
command argument argument argument 
...
```

If a label doesn't have any other labels that it jumps to (via jump, choice, if, etc), the cutscene will end.

### Special Labels

There are some labels which are used specially in IntCut.

`~start`

Every cutscene file has to include a `~start` label. This is the label which is always played when
the cutscene file is loaded. It makes it easy to branch out from this one label.

`~end`

This label will always be played when the cutscene ends. Makes it easy to initialize other states
and the like, or makes it easy to have a goodbye interaction when you're done talking to a certain
character.

**Note:** Cutscene interrupts are handled with `~end`. Interrupts are when a cutscene is
interrupted by another event, such as a character being killed or another cutscene pulling the
actors away from the current one. Interrupts must be done manually.

`~skipped`

This label is included because I couldn't figure out a good way to deal with cutscenes being
skipped automatically, so it's on the person making these cutscenes to actually deal with the event
that a cutscene is skipped so everyone's in the right place afterwards and no data is missing.
**Note:** `~end` will also be skipped, so make sure to handle that too.

## Cutscene Commands

IntCut commands are written in plain text with a command followed by options
for that command, all separated by spaces.

Example:

`command first_option second_option third_option etc...`

### Command list

A little note about how these commands are formatted before we begin:\
In this list all command parameters are formatted as such: `parameter: < usage note > : description`.
The usage notes will only show up for some commands. If the parameter has a specific set of options
it can be set to, they will be noted in a sublist.

#### Usage notes

- **optional**: notes that this parameter is optional.
- **dependant**: notes that this parameter should only be used if the parameter before it is
specified
- **default**: notes the default value of this parameter. States explicitly what will be used, but
is in practice optional.

Now onto the actual commands list!

#### Commands

`choice`

The choice command allows the user to make a choice from a certain number of options. The maximum
is (4? tbd)

Options:

- `first_choice`: A translation key for the first choice displayed to the player.
- `label_to_jump_to_on_first_choice`: The name for the label that will be jumped to if the first
choice is chosen.
- `second_choice`: **optional** : A translation key for the second choice displayed to the player.
- `label_to_jump_to_on_second_choice`: **dependant** : The name for the label that will be jumped
to if the second choice is chosen.
- `third_choice`: **optional** : A translation key for the third choice displayed to the player.
- `label_to_jump_to_on_third_choice`: **dependant** : The name for the label that will be jumped
to if the third choice is chosen.
- `fourth_choice`: **optional** : A translation key for the fourth choice displayed to the player.
- `label_to_jump_to_on_fourth_choice`: **dependant** : The name for the label that will be jumped
to if the fourth choice is chosen.

`cinebars`

The cinebars command toggles the cinematic bars that appear at the top and bottom of the screen to
make it appear more cinematic.

Options:

- `enabled`: States whether they should be turned on or off.
    - `on`: Turns them on
    - `off`: Turns them off

`if`

The if command jumps to a different label based on a conditional statement.
//TODO: WRITE THE WHOLE DOCUMENTATION FOR THIS COMMAND!

Options:

- `value_name`: The name of the global variable which is going to be compared.
- `comparison_type`: The type of comparison used.
    - `==`: Checks if the two are equal.
    - `<`: Checks if the value is less than the comparison value.
    - `<=`: Checks if the value is less than or equal to the comparison value.
    - `>`: Checks if the value is greater than the comparison value.
    - `>=`: Checks if the value is greater than or equal to the comparison value.
    - `!=`: Checks if the value is not equal to the comparison value.
- `comparison_value`: Will either be used as the name of a blackboard variable to be compared to
or an absolute value to be compared to, depending on comparison_value_type.
- `label`: The label to jump to if the comparison evaluates to true.
- `comparison_value_type`: **default: abs** : The way comparison_value will be treated.
    - `abs`: The command will treat comparison_value as an absolute value
    - `var`: The command will treat comparison_value as a blackboard variable name

`jump`

The jump command jumps to another label in the cutscene file.

Options:

- `label`: The name of the label to be jumped to.

`move`

Moves an actor from one point to another. Essentially a wrapper for Tween.

Options:

- `actor`: The name of the actor that will be moving.
- `duration`: The duration of the movement in seconds.
- `x`: The x position that will be moved to.
- `y`: The y position that will be moved to.
- `position_type`: **default: abs** : The type of position specified in x and y.
    - `abs`: The position specified is an absolute world position.
    - `rel`: The position specified is relative to another object (by default it will be relative
to actor.)
- `easing`: **default: 0** : The easing type used. Default is ease_in. For the options see
[Godot's easing docs](https://docs.godotengine.org/en/stable/classes/class_tween.html#enum-tween-easetype).
- `transition`: **default: 0** : The transition type used. Default is linear. For the options see
[Godot's transition docs](https://docs.godotengine.org/en/stable/classes/class_tween.html#enum-tween-transitiontype).
- `relative_to`: **optional** : The actor that the movement will be relative to. Only works if movement is rel!

`move_camera`

Specifies a camera movement. Note: If the target position is outside of the camera's bounds, the
camera will not move past the bounds and instead move to the closest location within the bounds.

Options:

- `duration`: The duration of the movement in seconds.
- `x`: The x position that will be moved to.
- `y`: The y position that will be moved to.
- `scale`: The scaling of the camera.
- `position_type`: **default: abs** : The type of position specified in x and y.
    - `abs`: The position specified is an absolute world position.
    - `rel`: The position specified is relative to another object (by default it will be relative
to actor.)
- `easing`: **default: 0** : The easing type used. Default is ease_in. For the options see
[Godot's easing docs](https://docs.godotengine.org/en/stable/classes/class_tween.html#enum-tween-easetype).
- `transition`: **default: 0** : The transition type used. Default is linear. For the options see
[Godot's transition docs](https://docs.godotengine.org/en/stable/classes/class_tween.html#enum-tween-transitiontype).
- `relative_to`: **optional** : The actor that the movement will be relative to. Only works if movement is rel!

`music`

Music is essentially a wrapper for IntAud's Music Singleton. There are so many commands that this
has been moved to its own section, [Music](#music-commands)

`play`

Plays an animation of an actor.

Options:

- `actor`: The actor who will be animated.
- `animation`: The name of the animation.
- `speed`: **default: 1** : The animation's playback speed

`say`

This displays dialogue from a character. By default IntCut uses dialogue bubbles, but you can
modify it as need be.

Options:

- `actor`: The actor who will say this line.
- `line`: The translation key for the line of dialogue.
- `duration`: **default: -1** : How long the line will be displayed for. Intended for use in
non-blocking cutscenes and for interrupted dialogue.

`screenshake`

Causes the screen to shake.

- `x`: The total amount of pixels to either side that the screen will shake at most.
- `y`: The total amount of pixels to the top or bottom that the screen will shake at most.
- `duration`: How long the screen will shake for (seconds).

`set`

Sets a variable in the blackboard.

- `value_name`: The name of the value.
- `value`: The value that the variable will be set to.
- `type`: **default: str** : The type that the value will be converted to to be saved.
    - `str`: String
    - `int`: Integer
    - `float`: Floating Point Value
    - `bool`: Boolean

```swift
"set": # [set, value_name, value]
    pass
"setpos": # [setpos, actor, x, y, position_type, relative_to]
    pass
"sound":
    pass
"tween":
    pass
"wait": # [wait, wait_time]
    await get_tree().create_timer(float(action[1]))
```

#### Music Commands

pass

## Writing Dialogue

IntCut expects dialogue to be in a translation file. You can use any form
of Godot translation file, such as .csv or .po to create translations.

### Special formatting

IntCut uses certain characters and pieces of formatting to make its dialogue
be able to do cool things. The following is a comprehensive list of included
commands.

`|` - Pauses text by set amount of time. Default is 0.2 seconds

`{{<variable name>}}` - Whatever text is contained between the two pairs of
curly braces will be accessed as a variable from the game's blackboard. Set how
the blackboard is accessed in the `deal_with_vars` function in
`cutscene_player.gd`.

`{<command and variables>}` - runs an IntCut command at the point embedded into the dialogue. It is
intended to allow you to do stuff like move the camera, play animations, and
other such things. **PLEASE DO NOT USE ANY COMMANDS WHICH INTERRUPT OR CHANGE
CUTSCENE FLOW SUCH AS `wait`, `jump`, `if`, or `say` IN THESE AS THEY WILL
CAUSE THE CUTSCENE TO BREAK!!!**

![jTools](addons/jean28518.jTools/Heading.png)
***
Useful toolset for creating games with Godot Engine.
It is intended to expand and modify the toolset on your needs.
It is high customizable and offers a simple, but efficient basis.

You can use this in your own project, even a commercial one.

## Features
- Simple Save Manager
- Basic Settings Manager - Highly customizable and easy to use
- Table - Adds powerful tables to Godot
- Simple Audio Manager for playing music or game sounds

## How to use jTools in your own project
Just copy in the addons folder in to your Godot Project.
Then head to the projectsettings -> addons, and activate jTools!

For quick start just look at the provided example.tscn and example.gd how to use them.

**Attention:**
*At game start jAudioManager loads in it's own audio bus layout located in
`res://addons/jean28518.jTools/jAudioManager/jAudoManager_bus_layout.tres`.
You are welcome to expand this layout for your own needs.
If you don't want to use this audio bus layout, set `jAudioManagerBus` in `JAudioManager.gd:3` to `false`.*

## Modules

### jSaveManager
With it you can very easy save values of your game persistently.
In code it can be accessed very easy over `jSaveManager`.
It stores all saved data at `res://jSaveManager.save`. It can be changed in the jSaveManager Script.

#### How to use
- **jSaveManager.save_value(key : String, value):** Stores a value with a specific key.

- **jSaveManager.get_value(key : String)** Gets the value which is stored under that key.
If this value doesn't exist, null is returned.

#### Example
```
    jSaveManager.save_value("level", 3)

    var level = jSaveManager.get_value("level")
```
### jSettings
Basic Settings Window. When you call the function `jSettings.open_window()`. The Settings window opens.

You can easily add settings. Just add some nodes to the GridContainer in `JSettings.tscn`. Then add some code in the `JSettings.gd` at `_ready()`, `saveSettings()`, `applySettings()` `updateSettingsWindows()`. Also add your own setter/getter functions in the end of the script.

### jTable
Powerful table for godot. Usable ingame but also for editor plugins.

#### How to use
- Add `res://addons/jean28518.jTools/jTable/jTable.tscn` to your scene.
- Add child nodes to it. These depend on what fields you want to add to the table. If you want to have 3 columns, add 3 child nodes to the table. These could be e.g. Line Edit, Spin Box, Option Button or Check Box.
- In the inspector you have to define the `headings` array. If you want to have 3 columns, then the size of it has to be 3.
- Also you have to define the `keys` array in the inspector. It should be the same size as the headings array. In keys these keys are specified, with wich you can access the values in the retrieved data later.
- You can also specify some more settings in the inspector. In the end press the checkbox "Update Table". If the console don't throw an error, everything worked fine.
- In the end you have to connect the signal "saved_pressed" to a script of you. With that data you can do everything.

If you have problems at any time, check out the `example.tscn` with `example.gd`.

#### Data Structure
You can get the current data of the table by calling `get_data()`. With `set_data(tableData : Dictionary)` you can load data to the table.

In the end it is a Dictionary containing for each value a specific array. If you want to get e.g. the age of the 5th line you have to call `var age = dataTable["age"][4]`

**Example:**
```
var dataTable = {
    "Street": [ "Gubener Straße", "Büsingstrasse", "Karl-Liebknecht-Strasse" ],
    "city": [ "Bad Tölz", "Gilching", "Kaltenkirchen" ],
    "firstName": [ "Laura", "Kevin", "Monika" ],
    "gender": [ 1, 0, 0 ],
    "housenumber": [ "51", "94", "21" ],
    "lastName": [ "Hoch", "Egger", "Schweitzer" ],
    "postalCode": [ 83633.0, 82205.0, 24560.0 ]
}
```

### jAudioManager
Play easy sounds by calling just one function from anywhere. Music even keeps playing while switching to another scene.

#### How to use
- **play_music(soundPath : String, loop : bool = true, volume_db : float = 0.0)** Plays music from a given path. By default it is looped.

- **play_game_sound(soundPath : String, volume_db : float = 0.0)** Plays simple game sound (no 3D/2D Effects) from a given path. By default it is not looped.

- **play(soundPath : String, loop : bool = false, pausable : bool = true, volume_db : float = 0.0 , bus : String = "Game")** You wanna get advanced? Just use this function.

- **clear_all_sounds():** That's very helpful if you want to change the level for example. That clears the music too.

- **set_main_volume_db(volume : float)** This function is usually called by jSettings. But you can change the volumes too. If you want.

- **set_game_volume_db(volume : float)** This function is usually called by jSettings. But you can change the volumes too. If you want.

- **set_music_volume_db(volume : float)** This function is usually called by jSettings. But you can change the volumes too. If you want.

#### Examples
```
    jAudioManager.play_music("res://addons/jean28518.jTools/example/SampleMusic.ogg")

    jAudioManager.play_game_sound("res://addons/jean28518.jTools/example/SampleSound.ogg")
```

#### Attention
At game start jAudioManager loads in it's own audio bus layout located in
`res://addons/jean28518.jTools/jAudioManager/jAudoManager_bus_layout.tres`.
You are welcome to expand this layout for your own needs.
If you don't want to use this audio bus layout, set `jAudioManagerBus` in `JAudioManager.gd:3` to `false`.



## Feedback? Found Bugs? Suggestions?:
-> Open an issue at https://github.com/Jean28518/Godot-jTools

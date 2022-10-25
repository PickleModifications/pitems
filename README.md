<div align='center'><img src='https://user-images.githubusercontent.com/111543470/197658458-2f9c919e-0785-4bbb-a0e8-5b353c299065.png'/></div>
<div align='center'><h3><a href='https://pickle-mods.tebex.io/'>More Information & Scripts can be found here!</a></h3></div>

## What is this?

Basically, this serves as a free resource for servers that need usable items that have effects & event animations.

With this resource, you will be able to use the following:

- Re-usable items.
- Props & Animations while idling, performing, or exiting usage.
- Add effects that are reusable & modular.

## What do I need?

You will need the following for this script to work.

- ESX Legacy (1.5+)
- Ox Inventory

If you want to make a fork that adds support to other frameworks (which should be easy), feel free as long as you credit me.

## What are some examples of items that need this?

Some items that would for sure need a system like this are the following:

- Food (Burger, Pizza, Tacos, etc.)
- Drinks (Water, Beer, Soda, etc.)
- Drugs (Weed, Meth, Heroin, etc.)

## Item Configuration Example

```lua
["big_burger"] = {
    Consume = 20, -- 0-100, How much to remove per use.
    Prop = { -- Prop spawn data for idle & usage.
        Model = `prop_cs_burger_01`,
        BoneID = 18905,
        Offset = vector3(0.1, 0.0, 0.05),
        Rotation = vector3(-180.0, 0.0, 0.0),
    },
    Animations = {
        Takeout = nil, -- Anim to play when taking out the item & after effects. (nil = no anim)
        Used = {
            dictionary = "mp_player_inteat@burger", 
            animation = "mp_player_int_eat_burger_fp", 
            time = 1200, 
            params = {nil, nil, nil, 49} -- rest of TaskPlayAnim after dict, anim, time.
        },
        Removed = nil, -- Anim to play when item is fully consumed or returned. (nil = no anim)
    },
    Effect = { -- Only required value is Type = "EFFECT_HERE", excess data is used for vars.
        Type = "EAT", 
        Duration = 10,
        Value = 200000
    }
},
```

## Need Support?

<a href='https://pickle-mods.tebex.io/contact'>Click here!</a>

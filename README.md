## Lusty94_Xmas


## Support

- Script support via Discord: https://discord.gg/BJGFrThmA8



## Features

- Find presents around the map and collect them
- Visit a snowman to exchange your presents and be in with a chance to get useful items, cash or lumps of coal!
- Presents spawn once per server restart
- Configurable buffs from eating sweet treats
- Custom sounds played when exchanged tokens
- Easily add more present locations and exchange points via the config file
- Language section for custom translations
- Built in consumables with configurable animations, props and more


## DEPENDENCIES

- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-target](https://github.com/qbcore-framework/qb-target)
- [qb-inventory](https://github.com/qbcore-framework/qb-inventory)
- [interact-sound](https://github.com/plunkettscott/interact-sound)
- [ox_lib](https://github.com/overextended/ox_lib/releases/)





## INSTALLATION

- Add the ##ITEMS snippet below into your items.lua file
- Add all .png images inside [IMAGES] folder into your inventory/images folder
- Add all .ogg files inside [INTERACT-SOUND] into your interact-sound/client/html/sounds folder
- Ensure all dependencies are started BEFORE this resource


## QB-CORE ITEMS

```

    --xmas 
	xmaspresent           = {name = 'xmaspresent',          label = 'Xmas Token',      weight = 100,   type = 'item',  image = 'xmaspresent.png',           unique = false, useable = false, shouldClose = true, combinable = nil, description = 'An unopened present!'},
    xmascookie          = {name = 'xmascookie',         label = 'Cookie',          weight = 100,   type = 'item',  image = 'xmascookie.png',          unique = false, useable = true,  shouldClose = true, combinable = nil, description = 'A Christmas Cookie!'},
    xmascandycane       = {name = 'xmascandycane',      label = 'Candy Cane',      weight = 100,   type = 'item',  image = 'xmascandycane.png',       unique = false, useable = true,  shouldClose = true, combinable = nil, description = 'A Candy Cane Full Of Sugar!'},
    xmaschocolate       = {name = 'xmaschocolate',      label = 'Chocolate',       weight = 100,   type = 'item',  image = 'xmaschocolate.png',       unique = false, useable = true, shouldClose = true, combinable = nil, description = 'A Christmas Chocolate!'},
    xmasmincepie        = {name = 'xmasmincepie',       label = 'Mince Pie',       weight = 100,   type = 'item',  image = 'xmasmincepie.png',        unique = false, useable = true, shouldClose = true, combinable = nil, description = 'A Christmas Mince Pie!'},
    xmasgingerbread     = {name = 'xmasgingerbread',    label = 'Ginger Bread',    weight = 100,   type = 'item',  image = 'xmasgingerbread.png',     unique = false, useable = true, shouldClose = true, combinable = nil, description = 'A Christmas Ginger Bread!'},
    xmasteddy           = {name = 'xmasteddy',          label = 'Teddy Bear',      weight = 100,   type = 'item',  image = 'xmasteddy.png',           unique = false, useable = false, shouldClose = true, combinable = nil, description = 'A Christmas Teddy Bear!'},
    coal                = {name = 'coal',               label = 'Coal',            weight = 100,   type = 'item',  image = 'coal.png',                unique = false, useable = false, shouldClose = true, combinable = nil, description = 'A Lump of Coal!'},


```

## OX_INVENTORY ITEMS

```


	["xmasteddy"] = {
		label = "Teddy Bear",
		weight = 100,
		stack = true,
		close = true,
		description = "A Christmas Teddy Bear!",
		client = {
			image = "xmasteddy.png",
		}
	},

	["xmasmincepie"] = {
		label = "Mince Pie",
		weight = 100,
		stack = true,
		close = true,
		description = "A Christmas Mince Pie!",
		client = {
			image = "xmasmincepie.png",
		}
	},

	["xmasgingerbread"] = {
		label = "Ginger Bread",
		weight = 100,
		stack = true,
		close = true,
		description = "A Christmas Ginger Bread!",
		client = {
			image = "xmasgingerbread.png",
		}
	},

	["coal"] = {
		label = "Coal",
		weight = 100,
		stack = true,
		close = true,
		description = "A Lump of Coal!",
		client = {
			image = "coal.png",
		}
	},

	["xmaspresent"] = {
		label = "Christmas Present",
		weight = 100,
		stack = true,
		close = true,
		description = "An unopened present!",
		client = {
			image = "xmaspresent.png",
		}
	},

	["xmaschocolate"] = {
		label = "Chocolate",
		weight = 100,
		stack = true,
		close = true,
		description = "A Christmas Chocolate!",
		client = {
			image = "xmaschocolate.png",
		}
	},

	["xmascandycane"] = {
		label = "Candy Cane",
		weight = 100,
		stack = true,
		close = true,
		description = "A Candy Cane Full Of Sugar!",
		client = {
			image = "xmascandycane.png",
		}
	},

	["xmascookie"] = {
		label = "Cookie",
		weight = 100,
		stack = true,
		close = true,
		description = "A Christmas Cookie!",
		client = {
			image = "xmascookie.png",
		}
	},


```
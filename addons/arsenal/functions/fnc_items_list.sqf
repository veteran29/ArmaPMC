#include "script_component.hpp"

/*
 * Takes a getUnitLoadout array
 * returns a CBA namespace containing all the items and the quantity of each
 */

private _loadout = _this;

private _items = call CBA_fnc_createNamespace;

_fnc_addItem = {
	params ["_item", ["_count", 1]];
	if !(_item isEqualTo "") then {
		private _base = [_item] call FUNC(item_listing);
		private _existing = _items getVariable [_base, 0];
		_items setVariable [_base, _existing + _count];
	};
};

_fnc_addWeapon = {
	params ["_weaponArray"];
	if !(_weaponArray isEqualTo []) then {
		// weapon and attachements
		{
			private _item = _weaponArray select _x;
			[_item] call _fnc_addItem;
		} forEach [0, 1, 2, 3, 6];
		// magazines
		{
			private _mag = _weaponArray select _x;
			if !(_mag isEqualTo []) then {
				private _item = _mag select 0;
				[_item] call _fnc_addItem;
			};
		} forEach [4, 5];
	};
};

_fnc_addContainer = {
	params ["_containerArray"];
	if (_containerArray isEqualTo []) exitWith {}; 
	[_containerArray select 0] call _fnc_addItem;
	{
		switch (count _x) do {
			case 2: {
				if (IS_STRING(_x select 0)) then {
					[_x select 0, _x select 1] call _fnc_addItem;
				} else {
					for "_i" from 1 to (_x select 1) do {
						[_x select 0] call _fnc_addWeapon;
					};
				};
			};
			case 3: {
				[_x select 0, _x select 1] call _fnc_addItem;
			};
		};
	} forEach (_containerArray select 1);
};

// Primary 
[_loadout select 0] call _fnc_addWeapon;

// Secondary
[_loadout select 1] call _fnc_addWeapon;

// Pistol
[_loadout select 2] call _fnc_addWeapon;

// Uniform
[_loadout select 3] call _fnc_addContainer;

// Vest
[_loadout select 4] call _fnc_addContainer;

// Backpack
[_loadout select 5] call _fnc_addContainer;

// Helmet, Facewear
{
	private _item = _loadout select _x;
	[_item] call _fnc_addItem;
} forEach [6, 7];

// Binocular
private _item = _loadout select 8 select 0;
[_item] call _fnc_addItem;

// Linked Items
{
	private _item = _loadout select 9 select _x;
	[_item] call _fnc_additem;
} forEach [0, 1, 2, 3, 4, 5];

_items

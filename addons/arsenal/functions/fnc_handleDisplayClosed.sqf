#include "script_component.hpp"

[GVAR(balanceHandle)] call CBA_fnc_removePerFrameHandler;
[GVAR(rightPanelColor)] call CBA_fnc_removePerFrameHandler;

private _items = (getUnitLoadout player) call FUNC(items_list);
private _cost = [_items] call FUNC(items_cost);

// Player did not pay for their items
if !(_cost == 0) then {
	// Take carried items
	player setUnitLoadout [GVAR(preLoadout), false];
	[_items] call CBA_fnc_deleteNamespace;
	_items = (getUnitLoadout player) call FUNC(items_list);
};

[_items] call FUNC(locker_take);
[_items] call CBA_fnc_deleteNamespace;

player setVariable [QGVAR(inArsenal), false, true];

// TODO
[player, getPlayerUID player] call FUNC(db_savePlayer);
[player, getPlayerUID player] call FUNC(db_push);

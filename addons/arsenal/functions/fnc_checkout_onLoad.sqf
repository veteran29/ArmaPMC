#include "script_component.hpp"

params ["_display"];

_display displayAddEventHandler ["Unload", {
    [findDisplay 1127001] call ace_arsenal_fnc_buttonHide;
}];

[findDisplay 1127001] call ace_arsenal_fnc_buttonHide;

private _header = _display displayCtrl IDC_RSCDISPLAYCHECKOUT_HEADER;
_header lnbAddRow ["","Item","#","Price","Total"];
_header ctrlEnable false;

private _list = _display displayCtrl IDC_RSCDISPLAYCHECKOUT_ITEMS;

private _items = (getUnitLoadout player) call FUNC(items_list);
{
	_x params ["_item", "_price", "_need", "_total"];
	if (_price != 0) then {
		private _config = (_item call CBA_fnc_getItemConfig);
		private _name = getText (_config >> "displayName");
		private _index = _list lnbAddRow [
			"",
			_name,
			format ["%1", _need],
			format ["%1", _price],
			format ["%1", _total]
		];
		_list lnbSetPicture [[_index, 0], getText (_config >> "picture")];
	};
} forEach ([_items] call FUNC(items_difference));

private _fnc_onConfirm = {
    params [["_ctrlButtonOK", controlNull, [controlNull]]];
    private _display = ctrlparent _ctrlButtonOK;
    if (isNull _display) exitWith {};

	private _items = (getUnitLoadout player) call FUNC(items_list);
	[_items] call FUNC(items_buy);
	[_items] call CBA_fnc_deleteNamespace;
	// Trigger events manually to color owned items
	["ace_arsenal_leftPanelFilled", [findDisplay 1127001]] call CBA_fnc_localEvent;
	["ace_arsenal_rightPanelFilled", [findDisplay 1127001]] call CBA_fnc_localEvent;
};
(_display displayCtrl 1) ctrlAddEventHandler ["buttonclick", _fnc_onConfirm];

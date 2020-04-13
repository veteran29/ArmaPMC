#include "\x\cba\addons\main\script_macros_common.hpp"

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)

#ifdef DISABLE_COMPILE_CACHE
  #undef PREP
  #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
  #undef PREP
  #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#define BLANK_LOADOUT [[],[],[],[],[],[],"","",[],["","","","","",""]]

// remoteExec
#define REMOTE_GLOBAL   0
#define REMOTE_SERVER   ([player,2] select isDedicated)
#define REMOTE_CLIENTS  ([0,-2] select isDedicated)

// functions
#define REQUIRE_PMC if !(EGVAR(main,enabled)) exitWith {};
#define NO_HC if !(hasInterface) exitWith { player setVariable [QEGVAR(main,ignore), true, true]; };

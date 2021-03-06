// ROAMING TRADER by JohnO
// http://www.exilemod.com/profile/38-john/
// http://www.exilemod.com/topic/7664-roaming-trader-script

// Trader vehicle handling added by second_coming 
// http://www.exilemod.com/profile/60-second_coming/

// Modified, fixed and added to by [GADD]Monkeynutz

diag_log format['[travellingtrader] Started'];

if (!isServer) exitWith {};

/*
	Feel free to edit all these variables to set up your trader how you want him to be.
*/

_mindist 			= 20; 						// minimum distance from the nearest object (Number) in meters, ie. create waypoint this distance away from anything within x meters..
_water 				= 0; 						// water mode 0: cannot be in water , 1: can either be in water or not , 2: must be in water
_shoremode 			= 0; 						// 0: does not have to be at a shore , 1: must be at a shore
_tradertype			= "Exile_Trader_SpecialOperations";		// Set what kind of trader you want to be roaming the lands.
_vehicletype			= "B_LSV_01_armed_F";			// Set what vehicle you want him to be in.
_traderuniform 			= "U_O_T_Soldier_F";				// Set the uniform for the trader
_tradervest 			= "V_LegStrapBag_olive_F";			// Set the vest that the trader will wear
_traderbackpack 		= "CUP_B_AlicePack_Khaki";				// Set the backpack the trader will wear
_traderheadgear			= "H_Beret_Colonel";					// Set the Headgear/Hat that the trader will wear
_traderdistance			= 40;						// Set the distance in meters that players have to be to make the trader stop and talk to them
_tradermarkertype		= "ExileSpecOpsTraderIcon";			// Set the Marker type.
_mapmarkername			= "Spec Ops Trader";				// Set the text for the marker to be displayed on the map.
_markercolor			= "ColorRed";					// Set the color of the marker here.

/*
	DO NOT EDIT BELOW THIS LINE
*/

_middle = worldSize/2;				//DO NOT EDIT
_spawnCenter = [_middle,_middle,0];		//DO NOT EDIT
_maxDistance = _middle;				//DO NOT EDIT

_startPosition 	= [_spawnCenter,100,1500,_mindist,_water,20,_shoremode] call BIS_fnc_findSafePos;
_wayPoints		= [];
{
	_markerName = _x;
	_markerPos = getMarkerPos _markerName;
	if (markerType _markerName == "ExileTraderZone" OR markerType _markerName == "o_unknown") then 
	{
		_wp = [_markerPos,"MOVE"];
		_wayPoints pushBack _wp;
	};
} forEach allMapMarkers;

// Add a final CYCLE
_wp = [_startPosition,"CYCLE"];
_wayPoints pushBack _wp;

// Create the trader and ensure he doest react to gunfire or being shot at.

_group2 = createGroup resistance;
_group2 setCombatMode "BLUE";

_possiblePosStart = _startPosition;

_tradertype createUnit [_possiblePosStart, _group2, "trader2 = this; this disableAI 'AUTOTARGET'; this disableAI 'TARGET'; this disableAI 'SUPPRESSION'; "];
trader2 setVariable ["ExileTraderType", _tradertype,true];
trader2 allowDamage false; 
removeGoggles trader2;
trader2 addGoggles "G_Bandanna_aviator";
trader2 forceAddUniform _traderuniform;
trader2 addVest _tradervest;
trader2 addBackpack _traderbackpack;
trader2 AddWeapon "srifle_DMR_05_hex_F";
trader2 addPrimaryWeaponItem "muzzle_snds_93mmg";
trader2 addPrimaryWeaponItem "optic_AMS";
trader2 addPrimaryWeaponItem "bipod_01_F_blk";
trader2 AddWeapon "CUP_launch_M72A6_Special";
trader2 addHeadgear _traderheadgear;
trader2 setCaptive true;

// Spawn Traders Vehicle
_vehicleObject = createVehicle [_vehicletype, _possiblePosStart, [], 0, "CAN_COLLIDE"];
clearBackpackCargoGlobal _vehicleObject;
clearItemCargoGlobal _vehicleObject;
clearMagazineCargoGlobal _vehicleObject;
clearWeaponCargoGlobal _vehicleObject;
_vehicleObject setVariable ["ExileIsPersistent", false];
_vehicleObject setFuel 1;
_vehicleObject forceFlagTexture "textures\logo.paa";
	
    Locker = createVehicle ["Exile_Locker", _possiblePosStart, [], 0, "can_collide"]; 
    Locker attachTo [_vehicleObject, [0.00683594,-1.80609,-1.31031]];  
  
diag_log format['[travellingtrader] Vehicle spawned @ %1',_possiblePosStart];

_vehicleObject addEventHandler ["HandleDamage", {
_amountOfDamage = 0;
_amountOfDamage
}];

trader2 assignasdriver _vehicleObject;
[trader2] orderGetin true;
 
{
	_wpName = _x select 0;
	_wpType = _x select 1;
	_wp = _group2 addWaypoint [_x select 0, 0];
	_wp setWaypointType _wpType;
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointspeed "LIMITED"; 
	diag_log format['[travellingtrader] Waypoint %1 Type: %2',_wpName,_wpType];
} forEach _wayPoints; 
 
_traderPos2 = position trader2;
_mk = createMarker ["TraderLocation2",_traderPos2];
"TraderLocation2" setMarkerType _tradermarkertype;
"TraderLocation2" setMarkerText _mapmarkername;
"TraderLocation2" setMarkerColor _markercolor;

// Make trader will stand still when players near him.
	while {true} do
	{
		_pos = position _vehicleObject;
		_mk setMarkerPos _pos;
		_requiredMin = 2;
		_nearPlayers = (count (_pos nearEntities [["Exile_Unit_Player"],_traderdistance]));
		
		if(trader2 in _vehicleObject) then
		{			 
			_requiredMin = 1;
		};
		
		if (_nearPlayers >= _requiredMin) then
		{
			[trader2] orderGetin false;
			uiSleep 0.5;
			_vehicleObject setVehicleLock "LOCKED";
			_vehicleObject setFuel 0;
			trader2 action ["LightOff", trader2];	
			trader2 action ["salute", trader2];		
			trader2 disableAI "MOVE";
			uiSleep 60;
		}
		else
		{	
			trader2 assignasdriver _vehicleObject;
			[trader2] orderGetin true;
			_vehicleObject setFuel 1;
			_vehicleObject setVehicleLock "UNLOCKED";
			uiSleep 0.5;
			trader2 moveInDriver _vehicleObject;
			trader2 action ["LightOn", trader2];	
			trader2 enableAI "MOVE";
		};
		_vehicleObject setFuel 1;
		uiSleep 5;
		if(!Alive trader2)exitWith {};
	}; 


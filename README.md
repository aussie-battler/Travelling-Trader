## ROAMING TRADER by JohnO 

Credits to:

ROAMING TRADER 

by **JohnO**
http://www.exilemod.com/profile/38-john/
http://www.exilemod.com/topic/7664-roaming-trader-script

Trader vehicle handling added by **second_coming** 
http://www.exilemod.com/profile/60-second_coming/

Modified, fixed and added to by **[GADD]Monkeynutz** 
http://www.exilemod.com/profile/61794-monkeynutz/

**Customise the Traders:**

+ I have set both traders to be Spec Ops traders. You can customise both traders in the files:

a3_travelling_Trader\serverside\travellingTrader.sqf 

and in 

a3_travelling_Trader\serverside\travellingTrader2.sqf 

+ If you only want one trader comment line 3 found in a3_travelling_Trader\init\fn_init.sqf

change it to:
```
//execvm "\x\addons\a3_travellingTrader\serverside\travellingTrader2.sqf";
```

Here are the lines (line 21 to line 30) to customise your trader:
```
_tradertype			= "Exile_Trader_SpecialOperations";		// Set what kind of trader you want to be roaming the lands.
_vehicletype			= "B_LSV_01_armed_F";			// Set what vehicle you want him to be in.
_traderuniform 			= "U_O_GhillieSuit";				// Set the uniform for the trader
_tradervest 			= "V_PlateCarrier2_rgr_noflag_F";			// Set the vest that the trader will wear
_traderbackpack 		= "CUP_B_Kord_Tripod_Bag";				// Set the backpack the trader will wear
_traderheadgear			= "H_Beret_gen_F";					// Set the Headgear/Hat that the trader will wear
_traderdistance			= 40;						// Set the distance in meters that players have to be to make the trader stop and talk to them
_tradermarkertype		= "ExileSpecOpsTraderIcon";			// Set the Marker type.
_mapmarkername			= "Spec Ops Trader";				// Set the text for the marker to be displayed on the map.
_markercolor			= "ColorRed";					// Set the color of the marker here.
```
line 67:
```
trader addGoggles "G_Bandanna_blk";
```
Line 71 to line 73:
```
trader AddWeapon "CUP_srifle_AS50";
trader addPrimaryWeaponItem "optic_AMS";
trader AddWeapon "launch_O_Titan_short_ghex_F";
```
**Add a flag to the vehicle:**

Line 85, uncomment this so it looks like:
```
_vehicleObject forceFlagTexture "textures\logo.paa"; 
```
and change the directory to your server logo in your mission.pbo

**Remove the locker on the vehicle:**

Change line 87 & 88 to:

   // Locker = createVehicle ["Exile_Locker", _possiblePosStart, [], 0, "can_collide"]; 
  //  Locker attachTo [_vehicleObject, [0.00683594,-1.80609,-1.31031]];  

![Travelling-Trader](https://github.com/aussie-battler/Travelling-Trader/blob/master/20171228140954_1.jpg)

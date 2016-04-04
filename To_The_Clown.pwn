 //Map by: Sasuke_Uchiha. 
#include <a_samp>
#include <crashdetect>

new Animations= 1;
new Shop= 0; 
new ShopWeapons= 0; 
new ShopVehicles= 0; 
new SafeSpawn= 0; 
new Fix= 0; 
new Flip= 0; 

#define MapName "ROOFTOP: To The Clown"
#define ROOFTOP_COLOR 0x00ff83FF //Different color for each maps!

#undef MAX_OBJECTS
#define MAX_OBJECTS (0)

main() {}

new RoofTop_Pickup[3];

new Object[MAX_OBJECTS];

#define MAX_CPs (13)
enum rooftop_cp_enum
{
	Float:rooftop_cp_x,
	Float:rooftop_cp_y,
	Float:rooftop_cp_z,
	rooftop_cp_type,
	Float:rooftop_cp_size
};

forward Float:map_RooftopCPs(CP_ID,DATA);
forward map_GetCPType(CP_ID,DATA);
forward map_GetMaxCPs();
forward Float:map_GetSpawn(id,coord);
forward map_CommandsInfo(data);
forward map_ChangeCommandsInfo(ToChange,NewValue);
forward map_GetRooftopColor();

new rooftop_cp[MAX_CPs][rooftop_cp_enum] =
{
	{2058.5693,2404.3555,150.4766,0,10.0},
	{2106.4421,2414.9407,74.1152, 0,10.0},
	{2177.9473,2416.8486,73.0339, 0,10.0},
	{2269.6685,2444.1853,46.9766, 0,10.0},
	{2415.9585,2455.2231,69.4657, 0,10.0},
	{2460.7585,2385.5886,71.0496, 0,10.0},
	{2461.6670,2313.8154,91.6300, 0,10.0},
	{2449.3049,2183.4509,80.3984, 0,10.0},
	{2426.2900,2100.8364,62.3410, 0,10.0},
	{2379.1057,2086.6143,58.7220, 0,10.0},
	{2322.7612,2047.2236,32.8287, 0,10.0},
	{2292.4824,1916.8781,71.8893, 0,10.0},
	{2319.0845,1846.2510,61.6916, 1,10.0}
};

new Float:spawns[][4] =
{
	{2057.2288,2440.0007,165.6172,180.8223}
};
   

public Float:map_GetSpawn(id,coord)
{
	if(coord < 0 || coord > 3) return -1.0; 
	return spawns[id][coord];
}
   
public OnFilterScriptInit()
{
	print(""MapName" initialized");
	RoofTop_Pickup[0] = CreatePickup(1318, 1, 2314.5198,2035.4996,32.8287);
	RoofTop_Pickup[1] = CreatePickup(1318, 1, 2299.0518,2432.7400,46.9775);
	RoofTop_Pickup[2] = CreatePickup(1318, 1, 2447.7754,2352.4285,71.0496);
	AddPlayerClassEx(0,264,-2431.9709,-1619.5594,526.4762,297.8344,0,0,0,0,0,0); // 
	SetGravity(0.001);
	UsePlayerPedAnims();
	return 1;
}

public OnPlayerRequestClass(playerid,classid)
{
	TogglePlayerControllable(playerid,false);
	GameTextForPlayer(playerid,"~b~Jumper",1000,3);
	SetPlayerColor(playerid,ROOFTOP_COLOR);
	SetPlayerPos(playerid,2288.0686,1845.8005,39.2713);
	SetPlayerFacingAngle(playerid,89.3955);
	SetPlayerCameraPos(playerid,2285.0686,1845.8005,39.2713);
	SetPlayerCameraLookAt(playerid,2288.0686,1845.8005,39.2713);
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(RoofTop_Pickup[0] == pickupid)
	{
		SetPlayerPos(playerid,2289.1101,1927.4602,71.8893);
		SetPlayerFacingAngle(playerid,197.1861);
	}
	else if(RoofTop_Pickup[1] == pickupid)
	{
		SetPlayerPos(playerid,2393.0798,2446.3135,69.4657);
		SetPlayerFacingAngle(playerid,268.1656);
	}
	else
	{
		SetPlayerPos(playerid,2444.6655,2330.3118,91.6300);
		SetPlayerFacingAngle(playerid,182.4127);
	}
	return 1;
}

public OnFilterScriptExit()
{
    for(new i=0;i<MAX_OBJECTS;i++) DestroyObject(i);
	return 1;
}

public map_GetCPType(CP_ID,DATA) return rooftop_cp[CP_ID][rooftop_cp_type];
public map_GetMaxCPs() return MAX_CPs;
public map_GetRooftopColor() return ROOFTOP_COLOR;

public Float:map_RooftopCPs(CP_ID,DATA)
{
	if(CP_ID < 0 || CP_ID > MAX_CPs) return -1.0;
	switch(DATA)
	{
		case 0: return Float:rooftop_cp[CP_ID][rooftop_cp_x];
		case 1: return rooftop_cp[CP_ID][rooftop_cp_y];
		case 2: return rooftop_cp[CP_ID][rooftop_cp_z];
		case 4: return rooftop_cp[CP_ID][rooftop_cp_size];
	}
	return -1.0;
}

public map_CommandsInfo(data)
{
	switch(data)
	{
		case 0: return SafeSpawn;
		case 1: return Animations;
		case 2: return Fix;
		case 3: return Flip;
		case 4: return Shop;
		case 5: return ShopWeapons;
		case 6: return ShopVehicles;
	}
	return 1;
}

public map_ChangeCommandsInfo(ToChange,NewValue)
{
	switch(ToChange)
	{
		case 0: SafeSpawn=NewValue;
		case 1: Animations=NewValue;
		case 2: Fix=NewValue;
		case 3: Flip=NewValue;
		case 4: Shop=NewValue;
		case 5: ShopWeapons=NewValue;
		case 6: ShopVehicles=NewValue;
	}
	return 1;
}

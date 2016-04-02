 //Idea by: Erza. Remade by: Louay
#include <a_samp>
#include <crashdetect>

new Animations= 0;
new Shop= 0; 
new ShopWeapons= 0; 
new ShopVehicles= 0; 
new SafeSpawn= 0; 
new Fix= 1; 
new Flip= 1; 

#define RACE_VEH 539

#define MapName "RACE:Trevortex"
#define RACE_COLOR 0xadff00FF //Different color for each maps!

#undef MAX_OBJECTS
#define MAX_OBJECTS (7)

main() {}

new Object[MAX_OBJECTS];

#define MAX_CPs (16)
enum race_cp_enum
{
	Float:race_cp_x,
	Float:race_cp_y,
	Float:race_cp_z,
	race_cp_type,
	Float:race_cp_size
};

forward Float:map_RaceCPs(CP_ID,DATA);
forward map_GetCPType(CP_ID,DATA);
forward map_GetMaxCPs();
forward Float:map_GetSpawn(id,coord);
forward map_CommandsInfo(data);
forward map_ChangeCommandsInfo(ToChange,NewValue);
forward map_GetRaceVehicle();
forward map_GetRaceColor();

new race_cp[MAX_CPs][race_cp_enum] =
{
	{-2246.5850,-1723.5297,479.6232,0,10.0},
	{-1766.2,-2088.3999,47.2,0,10.0},
	{-1510.6,-2153.8999,2.4,0,10.0},	
	{-1230.6,-2332.7,17.6,0,10.0},	
	{-954.20001,-2350.3,60.7,0,10.0},
	{-934.00,-2185.3,34.8,0,10.0},
	{-789.29999,-2098.1001,24.6,0,10.0},
	{-686.40002,-1898.6,2.0,0,10.0},
	{-493.70001,-1894.5,1.0,0,10.0},
	{-295.60001,-1865.6,1.0,0,10.0},
	{109.7,-1813.4,1.0,0,10.0},
	{306.5,-1779.9,4.5,0,10.0},
	{458.60001,-1744.4,7.1,0,10.0},
	{570.70001,-1727.1,13.3,0,10.0},
	{820.29999,-1790.2,13.9,0,10.0},
	{836.90002,-2053.8,12.0,1,10.0}
};

new Float:spawns[][4] =
{
	{-2334.9429,-1654.8835,483.0631,227.0151},
	{-2332.2859,-1652.6868,483.0632,223.2315},
	{-2327.8792,-1648.7964,483.0631,223.1289},
	{-2329.9089,-1650.7490,483.0632,219.5695},
	{-2325.0867,-1646.5348,483.0632,224.5933},
	{-2322.1396,-1644.2516,483.0632,223.7894},
	{-2319.1626,-1641.6565,483.0632,224.2300},
	{-2316.5017,-1639.1384,483.0636,225.3492},
	{-2313.8640,-1636.7585,483.0633,226.9909},
	{-2311.1643,-1634.4366,483.0632,226.1512},
	{-2308.6497,-1631.7881,483.0682,229.3826},
	{-2306.1396,-1629.5035,483.0940,235.4026}
};
   

public Float:map_GetSpawn(id,coord)
{
	if(coord < 0 || coord > 3) return -1.0; 
	return spawns[id][coord];
}
   
public OnFilterScriptInit()
{
	print(""MapName" initialized");
	Object[0] = CreateObject(13593,-2247.8000000,-1729.9000000,479.7000100,0.0000000,0.0000000,226.0000000); //object(kickramp03)(1)
	Object[1] = CreateObject(13593,-2246.1001000,-1727.7000000,479.7000100,0.0000000,0.0000000,226.0000000); //object(kickramp03)(2)
	Object[2] = CreateObject(13593,-2244.3999000,-1725.5000000,479.7000100,0.0000000,0.0000000,226.0000000); //object(kickramp03)(3)
	Object[3] = CreateObject(13593,-2242.6001000,-1723.5000000,479.7000100,0.0000000,0.0000000,226.0000000); //object(kickramp03)(4)
	Object[4] = CreateObject(13593,-2240.8000000,-1721.5000000,479.7000100,0.0000000,0.0000000,226.0000000); //object(kickramp03)(5)
	Object[5] = CreateObject(1655,144.3000000,-1815.2000000,0.9000000,0.0000000,0.0000000,270.0000000); //object(waterjumpx2)(2)
	Object[6] = CreateObject(1655,144.3999900,-1806.5000000,0.9000000,0.0000000,0.0000000,270.0000000); //object(waterjumpx2)(3)
	for(new i=0; i < 5; i++) AddPlayerClassEx(1,random(312),-2431.9709,-1619.5594,526.4762,297.8344,0,0,0,0,0,0); // 
	return 1;
}

public OnPlayerRequestClass(playerid,classid)
{
	TogglePlayerControllable(playerid,false);
	GameTextForPlayer(playerid,"~g~~h~RACER",1000,3);
	SetPlayerColor(playerid,RACE_COLOR);
	SetPlayerPos(playerid,-2431.9709,-1619.5594,526.4762);
	SetPlayerFacingAngle(playerid,297.8344);
	SetPlayerCameraPos(playerid,-2427.104736 , -1616.853515 , 528.444702);
	SetPlayerCameraLookAt(playerid,-2431.9709,-1619.5594,526.4762);
	return 1;
}

public OnFilterScriptExit()
{
    for(new i=0;i<MAX_OBJECTS;i++) DestroyObject(i);
	return 1;
}

public map_GetCPType(CP_ID,DATA) return race_cp[CP_ID][race_cp_type];
public map_GetMaxCPs() return MAX_CPs;
public map_GetRaceVehicle() return RACE_VEH;
public map_GetRaceColor() return RACE_COLOR;

public Float:map_RaceCPs(CP_ID,DATA)
{
	if(CP_ID < 0 || CP_ID > MAX_CPs) return -1.0;
	switch(DATA)
	{
		case 0: return Float:race_cp[CP_ID][race_cp_x];
		case 1: return race_cp[CP_ID][race_cp_y];
		case 2: return race_cp[CP_ID][race_cp_z];
		case 4: return race_cp[CP_ID][race_cp_size];
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
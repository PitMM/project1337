 //Idea by: JimmySpaceTravel1337. Remade by: - ///Just so we keep who made it or who gave the idea
#include <a_samp>
#include <crashdetect>
#include <stuff\defines>
//#include <streamer>

new Animations= 1; // for animations
new Shop= 1; //for shop
new ShopWeapons= 1; //for shop weapon section
new ShopVehicles= 1; //for shop veh section
new SafeSpawn= 0; //for safe spawn
new Fix= 0; // for fix command
new Flip= 0; //for flip command

#define MapName "Grand Theft Shamal" 

#define Health 99

#define OBJ_X 1477.4000200
#define OBJ_Y 1815.5000000
#define OBJ_Z 11.8000000
#define OBJ_A 180.0000000
#define OBJ_ID 519
#define OBJ_NAME "Shamal"

#define CP_X 36.8
#define CP_Y 2501.8
#define CP_Z 15.0

#define TEAM_1_NAME "Guards"
#define TEAM_2_NAME "Terrorists"

#define TEAM_1_SKIN 286	
#define TEAM_2_SKIN 184 
#define TEAM_3_SKIN 0	
#define TEAM_4_SKIN 0 
#define TEAM_5_SKIN 0	
#define TEAM_6_SKIN 0   
#define TEAM_7_SKIN 0	
#define TEAM_8_SKIN 0   

#define TEAM_1_WEAPON_1 24
#define TEAM_1_WEAPON_1_AMMO 210
#define TEAM_1_WEAPON_2 31
#define TEAM_1_WEAPON_2_AMMO 300
#define TEAM_1_WEAPON_3 25
#define TEAM_1_WEAPON_3_AMMO 500

#define TEAM_2_WEAPON_1 24
#define TEAM_2_WEAPON_1_AMMO 210
#define TEAM_2_WEAPON_2 31
#define TEAM_2_WEAPON_2_AMMO 500
#define TEAM_2_WEAPON_3 25
#define TEAM_2_WEAPON_3_AMMO 300

#define TEAM_3_WEAPON_1 30
#define TEAM_3_WEAPON_1_AMMO 500
#define TEAM_3_WEAPON_2 28
#define TEAM_3_WEAPON_2_AMMO 300
#define TEAM_3_WEAPON_3 27
#define TEAM_3_WEAPON_3_AMMO 400

#define TEAM_4_WEAPON_1 31
#define TEAM_4_WEAPON_1_AMMO 500
#define TEAM_4_WEAPON_2 24
#define TEAM_4_WEAPON_2_AMMO 300
#define TEAM_4_WEAPON_3 32
#define TEAM_4_WEAPON_3_AMMO 300

#define TEAM_5_WEAPON_1 0
#define TEAM_5_WEAPON_1_AMMO 0
#define TEAM_5_WEAPON_2 0
#define TEAM_5_WEAPON_2_AMMO 0
#define TEAM_5_WEAPON_3 0
#define TEAM_5_WEAPON_3_AMMO 0

#define TEAM_6_WEAPON_1 0
#define TEAM_6_WEAPON_1_AMMO 0
#define TEAM_6_WEAPON_2 0
#define TEAM_6_WEAPON_2_AMMO 0
#define TEAM_6_WEAPON_3 0
#define TEAM_6_WEAPON_3_AMMO 0

#define TEAM_7_WEAPON_1 0
#define TEAM_7_WEAPON_1_AMMO 0
#define TEAM_7_WEAPON_2 0
#define TEAM_7_WEAPON_2_AMMO 0
#define TEAM_7_WEAPON_3 0
#define TEAM_7_WEAPON_3_AMMO 0

#define TEAM_8_WEAPON_1 0
#define TEAM_8_WEAPON_1_AMMO 0
#define TEAM_8_WEAPON_2 0
#define TEAM_8_WEAPON_2_AMMO 0
#define TEAM_8_WEAPON_3 0
#define TEAM_8_WEAPON_3_AMMO 0

#define MAP_INTERIOR 0

#define MAX_MAP_VEHICLES 80

new Object[0];
new Class[8];
new TeamColor[] = { 
	0xFFC0CBFF,
	0x00FF00FF 
};

forward Float:map_GetSpawn(id,coord);
forward map_CommandsInfo(data);
forward map_ChangeCommandsInfo(ToChange,NewValue);
forward map_Load();
forward map_GetHealth();

new Float:spawns[][] =
{
	{1317.8292,1590.4163,10.8125,267.7797},//class 0
	{414.1389,2535.3748,19.1484,175.9721}, //class 1
	{0.0,	0.0,	0.0}, //class 2
	{0.0,	0.0,	0.0}, //class 3 
	{0.0,	0.0,	0.0}, //class 4
	{0.0,	0.0,	0.0}, //class 5
	{0.0,	0.0,	0.0}, //class 6
	{0.0,	0.0,	0.0} //class 7
};

public OnFilterScriptInit()
{
	print(" -- "MapName" - INITIALIZED --");

	AddStaticVehicleEx(476,290.5000000,2539.1001000,18.0000000,180.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,324.7000100,2538.8000500,18.0000000,180.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,274.7999900,2522.1001000,17.9000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,274.7000100,2509.0000000,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,263.5000000,2522.1001000,17.9000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,274.8999900,2482.3000500,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,274.7998000,2495.2998000,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,252.7000000,2522.1999500,17.9000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,242.3999900,2522.1999500,17.9000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,231.3999900,2522.1999500,17.9000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,263.6000100,2509.3999000,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,252.6000100,2509.6999500,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,242.3000000,2510.1001000,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,231.3000000,2510.3000500,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,231.3999900,2496.8000500,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,231.6000100,2483.3999000,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,242.0000000,2483.8000500,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,252.2000000,2483.8000500,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,263.2999900,2483.6999500,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,263.3999900,2495.8999000,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,252.5000000,2496.1001000,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(476,242.0000000,2496.5000000,17.7000000,270.0000000,170,157,15); //Rustler
	AddStaticVehicleEx(405,341.0000000,2530.1999500,16.8000000,270.0000000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,340.8999900,2533.3000500,16.8000000,270.0000000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,340.8999900,2536.6001000,16.8000000,270.0000000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,341.0000000,2540.0000000,16.8000000,270.0000000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,340.8999900,2543.5000000,16.8000000,270.0000000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,342.0000000,2547.3999000,16.8000000,230.0000000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,347.3999900,2547.0000000,16.7000000,179.9990000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,350.8999900,2546.8000500,16.7000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,354.1000100,2546.8000500,16.6000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,357.5000000,2546.6999500,16.6000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,360.7999900,2546.6001000,16.6000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,364.5000000,2546.6001000,16.5000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,368.2000100,2546.8000500,16.5000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,371.6000100,2546.8000500,16.5000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,375.3999900,2546.6001000,16.5000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,379.0000000,2546.6999500,16.5000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,383.0000000,2546.8000500,16.5000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,387.1000100,2546.8999000,16.5000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,387.1000100,2534.6001000,16.5000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,383.7999900,2534.5000000,16.5000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,379.3999900,2534.8000500,16.6000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,375.1000100,2534.8999000,16.6000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,371.3999900,2535.1001000,16.6000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,367.8999900,2535.1999500,16.7000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,364.5000000,2535.1001000,16.7000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,361.1000100,2535.3000500,16.7000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,357.3999900,2535.1001000,16.7000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,353.7000100,2535.1999500,16.7000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(405,350.7000100,2535.1999500,16.7000000,179.9950000,34,25,15); //Sentinel
	AddStaticVehicleEx(574,1339.0000000,1550.6999500,10.6000000,0.0000000,255,255,15); //Sweeper
	AddStaticVehicleEx(574,1336.5000000,1550.6999500,10.6000000,0.0000000,255,255,15); //Sweeper
	AddStaticVehicleEx(552,1346.5000000,1632.1999500,10.6000000,270.0000000,255,255,15); //Utility
	AddStaticVehicleEx(552,1346.5000000,1628.1999500,10.6000000,270.0000000,255,255,15); //Utility
	AddStaticVehicleEx(552,1346.5000000,1624.3000500,10.6000000,270.0000000,255,255,15); //Utility
	AddStaticVehicleEx(407,1292.6999500,1565.5000000,11.2000000,270.0000000,185,-1,15); //Firetruck
	AddStaticVehicleEx(416,1294.0000000,1560.3000500,11.1000000,270.0000000,255,255,15); //Ambulance
	AddStaticVehicleEx(417,1326.5999800,1406.6999500,11.0000000,0.0000000,-1,-1,15); //Leviathan
	AddStaticVehicleEx(487,1328.0999800,1505.3000500,11.1000000,270.0000000,93,126,15); //Maverick
	AddStaticVehicleEx(487,1334.5000000,1692.1999500,11.1000000,270.0000000,93,126,15); //Maverick
	AddStaticVehicleEx(563,1341.9000200,1407.3000500,11.7000000,0.0000000,255,255,15); //Raindance
	AddStaticVehicleEx(511,1285.0999800,1323.9000200,12.3000000,270.0000000,189,190,15); //Beagle
	AddStaticVehicleEx(553,1521.5000000,1171.8000500,13.0000000,0.0000000,147,163,15); //Nevada
	AddStaticVehicleEx(593,1398.1999500,1768.1999500,11.4000000,180.0000000,48,79,15); //Dodo
	AddStaticVehicleEx(593,1380.5999800,1768.1999500,11.4000000,180.0000000,48,79,15); //Dodo
	AddStaticVehicleEx(577,1601.1999500,1264.0000000,9.8000000,40.0000000,189,190,15); //AT-400

    Class[0] = AddPlayerClassEx(0,TEAM_1_SKIN,-2431.9709,-1619.5594,526.4762,297.8344,0,0,0,0,0,0); //TEAM 1
	Class[1] = AddPlayerClassEx(1,TEAM_2_SKIN,-2431.9709,-1619.5594,526.4762,297.8344,0,0,0,0,0,0); //TEAM 2 
	//..
	
	SetWorldTime(10);
	return 1;
}

public OnPlayerRequestClass(playerid,classid)
{
	TogglePlayerControllable(playerid,false);
	if(classid == Class[0] || classid == Class[2] || classid == Class[4] || classid == Class[6]) GameTextForPlayer(playerid,TEAM_1_NAME,1000,3);
	else GameTextForPlayer(playerid,TEAM_2_NAME,1000,3);
	SetPlayerInterior(playerid,MAP_INTERIOR);
	SetPlayerPos(playerid,414.1389,2535.3748,19.1484);
	SetPlayerFacingAngle(playerid, 175.9721);
	SetPlayerCameraPos(playerid,416.1389,2537.3748,19.1484);
	SetPlayerCameraLookAt(playerid,414.1389,2535.3748,19.148);

	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerInterior(playerid,MAP_INTERIOR);
	return 1;
}

public OnFilterScriptExit()
{
    for(new i=0;i<MAX_OBJECTS;i++) DestroyObject(i);
	for(new i=0; i<MAX_MAP_VEHICLES; i++)
	{
		DestroyVehicle(i);
	}
	return 1;
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
public Float:map_GetSpawn(id,coord)
{
	if(coord < 0 || coord > 3) return -1.0;
	if(id < 0 || id > sizeof(spawns)) return -1.0;
	
	return spawns[id][coord];
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
public map_Load()
{
	CallRemoteFunction("STEAL_getTeamNames","ss",TEAM_1_NAME,TEAM_2_NAME);
	CallRemoteFunction("STEAL_getClassIDs","iiiiiiii",Class[0],Class[1],Class[2],Class[3],Class[4],Class[5],Class[6],Class[7]); // ADD here more if you have
	CallRemoteFunction("STEAL_getWeaponData","iiiiiii",0,TEAM_1_WEAPON_1,TEAM_1_WEAPON_1_AMMO,TEAM_1_WEAPON_2,TEAM_1_WEAPON_2_AMMO,TEAM_1_WEAPON_3,TEAM_1_WEAPON_3_AMMO);
	CallRemoteFunction("STEAL_getWeaponData","iiiiiii",1,TEAM_2_WEAPON_1,TEAM_2_WEAPON_1_AMMO,TEAM_2_WEAPON_2,TEAM_2_WEAPON_2_AMMO,TEAM_2_WEAPON_3,TEAM_2_WEAPON_3_AMMO);
	CallRemoteFunction("STEAL_getWeaponData","iiiiiii",2,TEAM_3_WEAPON_1,TEAM_3_WEAPON_1_AMMO,TEAM_3_WEAPON_2,TEAM_3_WEAPON_2_AMMO,TEAM_3_WEAPON_3,TEAM_3_WEAPON_3_AMMO);
	CallRemoteFunction("STEAL_getWeaponData","iiiiiii",3,TEAM_4_WEAPON_1,TEAM_4_WEAPON_1_AMMO,TEAM_4_WEAPON_2,TEAM_4_WEAPON_2_AMMO,TEAM_4_WEAPON_3,TEAM_4_WEAPON_3_AMMO);
	CallRemoteFunction("STEAL_getWeaponData","iiiiiii",4,TEAM_5_WEAPON_1,TEAM_5_WEAPON_1_AMMO,TEAM_5_WEAPON_2,TEAM_5_WEAPON_2_AMMO,TEAM_5_WEAPON_3,TEAM_5_WEAPON_3_AMMO);
	CallRemoteFunction("STEAL_getWeaponData","iiiiiii",5,TEAM_6_WEAPON_1,TEAM_6_WEAPON_1_AMMO,TEAM_6_WEAPON_2,TEAM_6_WEAPON_2_AMMO,TEAM_6_WEAPON_3,TEAM_6_WEAPON_3_AMMO);
	CallRemoteFunction("STEAL_getWeaponData","iiiiiii",6,TEAM_7_WEAPON_1,TEAM_7_WEAPON_1_AMMO,TEAM_7_WEAPON_2,TEAM_7_WEAPON_2_AMMO,TEAM_7_WEAPON_3,TEAM_7_WEAPON_3_AMMO);
	CallRemoteFunction("STEAL_getWeaponData","iiiiiii",7,TEAM_8_WEAPON_1,TEAM_8_WEAPON_1_AMMO,TEAM_8_WEAPON_2,TEAM_8_WEAPON_2_AMMO,TEAM_8_WEAPON_3,TEAM_8_WEAPON_3_AMMO);
	CallRemoteFunction("STEAL_getColors","dd",TeamColor[0],TeamColor[1]);
	CallRemoteFunction("STEAL_getObjectiveInfo","dsfffffff",OBJ_ID,OBJ_NAME,OBJ_X,OBJ_Y,OBJ_Z,OBJ_A,CP_X,CP_Y,CP_Z);
	return 1;
}

public map_GetHealth() return Health;
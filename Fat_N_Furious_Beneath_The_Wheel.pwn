 //Idea by: JimmySpaceTravel1337.  Remade by: Original98
#include <a_samp>
#include <crashdetect>

new Animations= 0;
new Shop= 0; 
new ShopWeapons= 0; 
new ShopVehicles= 0; 
new SafeSpawn= 0; 
new Fix= 1; 
new Flip= 1; 

#define RACE_VEH 557

#define MapName "RACE:Fat N Furious Beneath The Wheel"
#define RACE_COLOR 0x882544FF //Different color for each maps!

#define GHOST_MODE 40

#undef MAX_OBJECTS
#define MAX_OBJECTS (88)

main() {}

new Object[MAX_OBJECTS];

#define MAX_CPs (56)
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
forward map_GetGhostModeTime();

new race_cp[MAX_CPs][race_cp_enum] =
{
	{ 2725.3999, -1253.3, 58.6 ,0,10.0},
 	{ 2724.2 , -1491.2, 29.3 ,0,10.0},
 	{ 2709.7 , -1636.9, 11.8 ,0,10.0},
    { 2653.7 , -1656.7, 9.7 ,0,10.0},
    { 2587.1001 , -1671.2, 0.8 ,0,10.0},
    { 2554.0 , -1847.8, 2.9 ,0,10.0},
    { 2385.7 , -1851.1, 0.7 ,0,10.0},
    { 2162.1001 , -1846.5, 3.0 ,0,10.0},
    { 2086.8 , -1834.6, 12.6 ,0,10.0},
    { 2091.1001 , -1761.9, 12.4 ,0,10.0},
    { 2111.8 , -1679.4, 12.4 ,0,10.0},
    { 2112.8 , -1578.6, 25.1 ,0,10.0},
    { 2108.6001 , -1395.8, 22.9 ,0,10.0},
    { 2057.8999 , -1342.3, 22.9 ,0,10.0},
    { 1980.8 , -1340.9, 22.9 ,0,10.0},
    { 1889.1 , -1347.9, 12.6 ,0,10.0},
    { 1850.5 , -1390.2, 12.4 ,0,10.0},
    { 1848.2 , -1461.9, 12.4 ,0,10.0},
    { 1833.0 , -1545.1, 12.4 ,0,10.0},
    { 1854.1 , -1545.2, 11.5 ,0,10.0},
    { 1905.8 , -1523.0, 2.3 ,0,10.0},
    { 1985.0 , -1518.2, 2.4 ,0,10.0},
    { 2096.3 , -1528.0, 1.5 ,0,10.0},
    { 2185.6001 , -1562.4, 1.2 ,0,10.0},
    { 2277.3 , -1566.8, 4.7 ,0,10.0},
    { 2345.3 , -1565.0, 22.9 ,0,10.0},
    { 2449.8 , -1596.0, 12.6 ,0,10.0},
    { 2633.0 , -1609.2, 18.6 ,0,10.0},
    { 2643.1001 , -1552.8, 19.6 ,0,10.0},
    { 2644.0 , -1482.3, 29.3 ,0,10.0},
    { 2638.7 , -1446.4, 29.3 ,0,10.0},
    { 2577.8999 , -1444.8, 33.9 ,0,10.0},
    { 2504.7 , -1444.9, 27.4 ,0,10.0},
    { 2439.8 , -1443.3, 22.9 ,0,10.0},
    { 2396.0 , -1438.2, 22.9 ,0,10.0},
    { 2385.3 , -1388.2, 22.9 ,0,10.0},
    { 2370.7 , -1330.7, 22.9 ,0,10.0},
    { 2368.0 , -1276.7, 22.9 ,0,10.0},
    { 2340.3999 , -1257.1, 21.5 ,0,10.0},
    { 2318.3999 , -1218.2, 22.4 ,0,10.0},
    { 2288.5 , -1234.3, 23.0 ,0,10.0},
    { 2287.3 , -1355.0, 23.0 ,0,10.0},
    { 2278.0 , -1477.4, 21.8 ,0,10.0},
    { 2328.1001 , -1481.2, 22.8 ,0,10.0},
    { 2422.3999 , -1472.7, 22.9 ,0,10.0},
    { 2444.5 , -1461.5, 23.0 ,0,10.0},
    { 2522.3 , -1462.7, 23.0 ,0,10.0},
    { 2550.3 , -1476.3, 22.9 ,0,10.0},
    { 2544.5 , -1502.4, 22.9 ,0,10.0},
    { 2437.8 , -1504.5, 22.9 ,0,10.0},
    { 2431.3 , -1573.1, 22.9 ,0,10.0},
    { 2430.8999 , -1633.5, 26.5 ,0,10.0},
    { 2432.1001 , -1726.8, 12.6 ,0,10.0},
    { 2480.2 , -1723.0, 12.6 ,0,10.0},
    { 2482.6001 , -1690.9, 12.6 ,0,10.0},
    { 2495.3999 , -1668.2, 12.4 ,1,10.0}
};

new Float:spawns[][4] =
{
	{2720.9128,-1172.4069,69.6018,179.1697},
	{2724.8289,-1172.5621,69.6287,178.4525},
	{2729.4021,-1172.3175,69.7953,177.2521},
	{2734.2678,-1172.4580,69.6721,178.8253},
	{2738.6328,-1172.4248,69.6316,179.2400},
	{2743.1069,-1172.5349,69.6765,180.7971},
	{2716.6560,-1172.4954,69.7211,177.2914},
	{2718.5022,-1179.6235,69.5905,178.5862},
	{2722.8599,-1179.7572,69.6311,180.5248},
	{2727.2803,-1179.8635,69.6667,178.8414},
	{2734.5388,-1179.8732,69.5896,177.9013},
	{2739.3691,-1179.9122,69.6720,178.4474},
	{2743.5359,-1180.0861,69.6999,182.0197},
	{2721.2485,-1187.0511,69.5860,179.4049},
	{2725.7227,-1187.0386,69.6172,180.4653},
	{2733.8040,-1186.9458,69.6736,180.2813},
	{2738.0635,-1186.8767,69.6148,178.0392},
	{2743.1829,-1186.9039,69.6945,180.5997}
};
   

public Float:map_GetSpawn(id,coord)
{
	if(coord < 0 || coord > 3) return -1.0; 
	return spawns[id][coord];
}
   
public OnFilterScriptInit()
{
	print(""MapName" initialized");
	Object[0] = CreateObject(1655,2632.1001000,-1663.9000000,10.8000000,359.5000000,0.0000000,102.0000000); //object(waterjumpx2)(1)
	Object[1] = CreateObject(1655,2630.2000000,-1655.5000000,10.8000000,359.4950000,0.0000000,102.7470000); //object(waterjumpx2)(2)
	Object[2] = CreateObject(647,2607.3999000,-1711.4000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(1)
	Object[3] = CreateObject(647,2605.1001000,-1711.6000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(2)
	Object[4] = CreateObject(647,2602.8999000,-1711.8000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(3)
	Object[5] = CreateObject(647,2600.7000000,-1711.8000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(4)
	Object[6] = CreateObject(647,2598.3000000,-1711.7000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(5)
	Object[7] = CreateObject(647,2596.0000000,-1711.9000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(6)
	Object[8] = CreateObject(647,2599.1001000,-1710.2000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(7)
	Object[9] = CreateObject(647,2595.2000000,-1709.1000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(8)
	Object[10] = CreateObject(647,2601.8999000,-1708.9000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(9)
	Object[11] = CreateObject(647,2605.3999000,-1707.8000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(10)
	Object[12] = CreateObject(647,2592.6001000,-1708.6000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(11)
	Object[13] = CreateObject(647,2592.3999000,-1712.7000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(12)
	Object[14] = CreateObject(647,2599.3000000,-1723.7000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(13)
	Object[15] = CreateObject(647,2603.5000000,-1726.2000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(14)
	Object[16] = CreateObject(647,2607.3999000,-1730.5000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(15)
	Object[17] = CreateObject(647,2607.1001000,-1727.8000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(16)
	Object[18] = CreateObject(647,2602.3999000,-1729.8000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(17)
	Object[19] = CreateObject(647,2605.0000000,-1732.9000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(18)
	Object[20] = CreateObject(647,2598.5000000,-1732.0000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(19)
	Object[21] = CreateObject(647,2594.7000000,-1731.0000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(20)
	Object[22] = CreateObject(647,2591.6001000,-1729.6000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(21)
	Object[23] = CreateObject(647,2595.8999000,-1728.7000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(22)
	Object[24] = CreateObject(647,2593.5000000,-1725.6000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(23)
	Object[25] = CreateObject(647,2591.2000000,-1725.8000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(24)
	Object[26] = CreateObject(647,2595.8000000,-1723.9000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(25)
	Object[27] = CreateObject(647,2598.8000000,-1719.8000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(26)
	Object[28] = CreateObject(647,2610.5000000,-1699.5000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(27)
	Object[29] = CreateObject(759,2602.3999000,-1708.1000000,0.6000000,0.0000000,0.0000000,0.0000000); //object(sm_bush_large_1)(1)
	Object[30] = CreateObject(759,2597.8999000,-1709.0000000,0.6000000,0.0000000,0.0000000,0.0000000); //object(sm_bush_large_1)(2)
	Object[31] = CreateObject(759,2593.6001000,-1708.2000000,0.6000000,0.0000000,0.0000000,0.0000000); //object(sm_bush_large_1)(3)
	Object[32] = CreateObject(759,2608.3000000,-1708.2000000,0.7000000,0.0000000,0.0000000,0.0000000); //object(sm_bush_large_1)(4)
	Object[33] = CreateObject(759,2607.8999000,-1720.1000000,0.6000000,0.0000000,0.0000000,0.0000000); //object(sm_bush_large_1)(5)
	Object[34] = CreateObject(759,2604.5000000,-1723.5000000,0.6000000,0.0000000,0.0000000,0.0000000); //object(sm_bush_large_1)(6)
	Object[35] = CreateObject(759,2573.8000000,-1711.6000000,0.6000000,0.0000000,0.0000000,0.0000000); //object(sm_bush_large_1)(7)
	Object[36] = CreateObject(759,2568.0000000,-1719.6000000,0.6000000,0.0000000,0.0000000,0.0000000); //object(sm_bush_large_1)(8)
	Object[37] = CreateObject(759,2560.8999000,-1732.8000000,0.6000000,0.0000000,0.0000000,0.0000000); //object(sm_bush_large_1)(9)
	Object[38] = CreateObject(759,2573.1001000,-1735.5000000,0.6000000,0.0000000,0.0000000,0.0000000); //object(sm_bush_large_1)(10)
	Object[39] = CreateObject(759,2561.7000000,-1706.6000000,0.6000000,0.0000000,0.0000000,0.0000000); //object(sm_bush_large_1)(11)
	Object[40] = CreateObject(759,2573.2000000,-1720.6000000,0.6000000,0.0000000,0.0000000,0.0000000); //object(sm_bush_large_1)(12)
	Object[41] = CreateObject(759,2560.8999000,-1720.2000000,0.6000000,0.0000000,0.0000000,0.0000000); //object(sm_bush_large_1)(13)
	Object[42] = CreateObject(803,2572.3000000,-1714.9000000,2.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(1)
	Object[43] = CreateObject(803,2564.7000000,-1714.6000000,2.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(2)
	Object[44] = CreateObject(803,2573.1001000,-1709.6000000,2.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(3)
	Object[45] = CreateObject(803,2559.2000000,-1714.6000000,2.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(4)
	Object[46] = CreateObject(803,2568.7000000,-1721.6000000,2.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(5)
	Object[47] = CreateObject(803,2572.8999000,-1727.5000000,2.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(6)
	Object[48] = CreateObject(803,2561.3000000,-1727.6000000,2.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(7)
	Object[49] = CreateObject(803,2566.3000000,-1730.3000000,2.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(8)
	Object[50] = CreateObject(803,2564.3999000,-1722.0000000,2.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(9)
	Object[51] = CreateObject(803,2568.7000000,-1715.5000000,2.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(10)
	Object[52] = CreateObject(1225,2608.7000000,-1710.8000000,1.1000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(1)
	Object[53] = CreateObject(1225,2606.3000000,-1710.7000000,1.1000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(2)
	Object[54] = CreateObject(1225,2603.7000000,-1710.7000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(3)
	Object[55] = CreateObject(1225,2600.8000000,-1711.1000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(4)
	Object[56] = CreateObject(1225,2598.8000000,-1711.2000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(5)
	Object[57] = CreateObject(1225,2595.6001000,-1711.3000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(6)
	Object[58] = CreateObject(1225,2592.8000000,-1711.3000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(7)
	Object[59] = CreateObject(1225,2591.0000000,-1711.2000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(8)
	Object[60] = CreateObject(1225,2591.7000000,-1717.5000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(9)
	Object[61] = CreateObject(1225,2594.8000000,-1716.8000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(10)
	Object[62] = CreateObject(1225,2597.3999000,-1716.9000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(11)
	Object[63] = CreateObject(1225,2600.8000000,-1717.0000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(12)
	Object[64] = CreateObject(1225,2605.2000000,-1716.7000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(13)
	Object[65] = CreateObject(1225,2607.7000000,-1721.0000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(14)
	Object[66] = CreateObject(1225,2599.6001000,-1720.9000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(15)
	Object[67] = CreateObject(1225,2593.5000000,-1721.2000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(16)
	Object[68] = CreateObject(1225,2607.6001000,-1727.3000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(17)
	Object[69] = CreateObject(1225,2604.0000000,-1727.4000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(18)
	Object[70] = CreateObject(1225,2600.6001000,-1727.5000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(19)
	Object[71] = CreateObject(1225,2597.2000000,-1727.6000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(20)
	Object[72] = CreateObject(1225,2593.7000000,-1728.9000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(21)
	Object[73] = CreateObject(1225,2590.7000000,-1726.2000000,1.0000000,0.0000000,0.0000000,0.0000000); //object(barrel4)(22)
	Object[74] = CreateObject(647,2574.8000000,-1713.3000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(28)
	Object[75] = CreateObject(647,2568.0000000,-1713.0000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(29)
	Object[76] = CreateObject(647,2561.6001000,-1715.1000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(30)
	Object[77] = CreateObject(647,2560.0000000,-1719.7000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(31)
	Object[78] = CreateObject(647,2572.6001000,-1722.1000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(32)
	Object[79] = CreateObject(647,2569.5000000,-1729.5000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(33)
	Object[80] = CreateObject(647,2593.8000000,-1720.8000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(34)
	Object[81] = CreateObject(647,2594.5000000,-1714.7000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(35)
	Object[82] = CreateObject(647,2598.0000000,-1717.0000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(36)
	Object[83] = CreateObject(647,2604.6001000,-1716.7000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(37)
	Object[84] = CreateObject(647,2591.6001000,-1717.3000000,2.8000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(38)
	Object[85] = CreateObject(647,2591.8000000,-1710.6000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(39)
	Object[86] = CreateObject(4522,1894.5996000,-1366.9004000,14.9000000,0.0000000,0.0000000,136.0000000); //object(ce_flintintld)(1)
	Object[87] = CreateObject(4521,2431.3999000,-1474.3000000,24.4000000,358.5050000,355.4980000,267.8820000); //object(ce_flintwat01ld)(1)
	for(new i=0; i < 5; i++) AddPlayerClassEx(1,random(312),-2431.9709,-1619.5594,526.4762,297.8344,0,0,0,0,0,0); // 
	return 1;
}

public OnPlayerRequestClass(playerid,classid)
{
	TogglePlayerControllable(playerid,false);
	GameTextForPlayer(playerid,"~g~~h~RACER",1000,3);
	SetPlayerColor(playerid,RACE_COLOR);
	SetPlayerPos(playerid,2581.4878,-1717.5092,8.0347);
	SetPlayerFacingAngle(playerid,7.0751);
	SetPlayerCameraPos(playerid,2581.024902 , -1714.221191 , 8.701100);
	SetPlayerCameraLookAt(playerid,2581.4878,-1717.5092,8.0347);
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

public map_GetGhostModeTime() return GHOST_MODE;
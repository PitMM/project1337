 //Idea by: Louay. 
#include <a_samp>
#include <crashdetect>
#include <streamer>

new Animations= 0;
new Shop= 0; 
new ShopWeapons= 0; 
new ShopVehicles= 0; 
new SafeSpawn= 0; 
new Fix= 1; 
new Flip= 1; 

#define RACE_VEH 522

#define MapName "RACE:Reckless Bikers"
#define RACE_COLOR 0xffd700FF //Different color for each maps!

#define GHOST_MODE 15

#undef MAX_OBJECTS
#define MAX_OBJECTS (158)

main() {}

new Object[MAX_OBJECTS];

#define MAX_CPs (37)
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
	{-1747.5,-580.5,16.3       ,0,10.0},
	{-1657.2,-542.20001,11.4   ,0,10.0},
	{-1543.3,-428.79999,5.9    ,0,10.0},
	{-1486.4,-455.0,5.9        ,0,10.0},
	{-1405.0,-396.20001,5.9    ,0,10.0},
	{-1321.7,-399.10001,14.1   ,0,10.0},
	{-1335.7,-221.39999,14.1   ,0,10.0},
	{-1545.5,-71.1,14.1        ,0,10.0},
	{-1550.3,-257.70001,14.1   ,0,10.0},
	{-1662.4,-364.60001,14.1   ,0,10.0},
	{-1740.6,-363.60001,22.0   ,3,10.0},
	{-1800.2,-337.0,22.7       ,0,10.0},
	{-1870.2,-288.79999,40.0   ,0,10.0},
	{-1897.5,-251.0,38.2       ,0,10.0},
	{-1885.8,-127.8,38.2       ,0,10.0},
	{-1866.0,-201.39999,43.6   ,0,10.0},
	{-1873.2,-286.89999,50.7   ,0,10.0},
	{-2015.5,-351.20001,36.00  ,0,10.0},
	{-2095.8,-336.20001,35.3   ,0,10.0},
	{-2157.1001,-327.60001,35.2,0,10.0},
	{-2217.1001,-326.29999,47.5,3,10.0},
	{-2235.3,-326.70001,42.2   ,0,10.0},
	{-2287.2,-340.39999,50.9   ,0,10.0},
	{-2219.6001,-355.70001,47.5,3,10.0},
	{-2155.3999,-357.70001,35.3,0,10.0},
	{-2123.6001,-433.60001,35.5,0,10.0},
	{-2074.3,-524.0,35.3       ,0,10.0},
	{-1997.4,-543.09998,35.3   ,0,10.0},
	{-1952.9,-543.90002,44.0   ,3,10.0},
	{-1910.9,-583.90002,38.2   ,0,10.0},
	{-1911.1,-803.29999,45.0   ,0,10.0},
	{-1910.9,-1098.0,38.2      ,0,10.0},
	{-1908.1,-1276.4,39.5      ,0,10.0},
	{-1907.0,-1371.2,40.4      ,0,10.0},
	{-1903.6,-1525.3,21.8      ,0,10.0},
	{-1901.1,-1645.2,21.8      ,0,10.0},
	{-1852.2,-1699.2,40.9      ,1,10.0}
};

new Float:spawns[][4] =
{
	{-1787.1000000,-586.9000200,16.0000000,270.0000000},
	{-1787.0996000,-585.2002000,16.0000000,270.0000000},
	{-1787.0996000,-583.5000000,16.0000000,270.0000000},
	{-1787.2000000,-581.2999900,16.0000000,270.0000000},
	{-1787.3000000,-579.0999800,16.0000000,270.0000000},
	{-1787.4000000,-576.9000200,16.0000000,270.0000000},
	{-1787.5000000,-574.4000200,16.0000000,270.0000000},
	{-1792.9000000,-586.7999900,16.0000000,270.0000000},
	{-1793.0000000,-584.7999900,16.0000000,270.0000000},
	{-1793.0996000,-582.2998000,16.0000000,270.0000000},
	{-1793.2002000,-580.0996100,16.0000000,270.0000000},
	{-1793.2002000,-578.5996100,16.0000000,270.0000000},
	{-1793.3000000,-576.5999800,16.0000000,270.0000000},
	{-1793.4004000,-574.5996100,16.0000000,270.0000000}
};
   

public Float:map_GetSpawn(id,coord)
{
	if(coord < 0 || coord > 3) return -1.0; 
	return spawns[id][coord];
}
   
public OnFilterScriptInit()
{
	print(""MapName" initialized");
	Object[0] = CreateDynamicObject(7956,-1698.4000000,-361.7000100,14.6000000,0.0000000,0.0000000,296.0000000); //object(vgwcuntwall1)(1)
	Object[1] = CreateDynamicObject(7956,-1698.2000000,-367.2999900,14.6000000,0.0000000,0.0000000,295.9990000); //object(vgwcuntwall1)(2)
	Object[2] = CreateDynamicObject(978,-1899.2000000,-120.8000000,38.1000000,0.0000000,0.0000000,226.0000000); //object(sub_roadright)(1)
	Object[3] = CreateDynamicObject(978,-1883.8000000,-119.3000000,38.1000000,0.0000000,0.0000000,149.9990000); //object(sub_roadright)(3)
	Object[4] = CreateDynamicObject(978,-1892.4000000,-117.5000000,38.1000000,0.0000000,0.0000000,187.9960000); //object(sub_roadright)(4)
	Object[5] = CreateDynamicObject(979,-1570.7000000,-60.3000000,14.0000000,0.0000000,0.0000000,244.0000000); //object(sub_roadleft)(1)
	Object[6] = CreateDynamicObject(979,-1573.8000000,-68.2000000,14.0000000,0.0000000,0.0000000,253.9950000); //object(sub_roadleft)(2)
	Object[7] = CreateDynamicObject(979,-1573.9000000,-77.0000000,14.0000000,0.0000000,0.0000000,281.9930000); //object(sub_roadleft)(3)
	Object[8] = CreateDynamicObject(979,-1571.8000000,-86.2000000,14.0000000,0.0000000,0.0000000,283.9920000); //object(sub_roadleft)(4)
	Object[9] = CreateDynamicObject(978,-1631.7000000,-367.8999900,14.0000000,0.0000000,0.0000000,0.0000000); //object(sub_roadright)(5)
	Object[10] = CreateDynamicObject(978,-1650.5000000,-367.8999900,14.0000000,0.0000000,0.0000000,0.0000000); //object(sub_roadright)(7)
	Object[11] = CreateDynamicObject(978,-1641.1000000,-367.8999900,14.0000000,0.0000000,0.0000000,0.0000000); //object(sub_roadright)(8)
	Object[12] = CreateDynamicObject(978,-1659.9000000,-367.8999900,14.0000000,0.0000000,0.0000000,0.0000000); //object(sub_roadright)(9)
	Object[13] = CreateDynamicObject(1422,-1625.5000000,-368.1000100,13.6000000,0.0000000,0.0000000,10.0000000); //object(dyn_roadbarrier_5)(1)
	Object[14] = CreateDynamicObject(981,-2144.2000000,-342.2000100,34.1000000,0.0000000,0.0000000,178.0000000); //object(helix_barrier)(1)
	Object[15] = CreateDynamicObject(1422,-2127.5000000,-342.6000100,34.4000000,0.0000000,0.0000000,0.0000000); //object(dyn_roadbarrier_5)(3)
	Object[16] = CreateDynamicObject(1422,-2148.0000000,-342.0000000,34.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_roadbarrier_5)(4)
	Object[17] = CreateDynamicObject(1422,-2140.5000000,-342.4003900,34.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_roadbarrier_5)(5)
	Object[18] = CreateDynamicObject(1422,-2161.3000000,-341.7999900,34.6000000,0.0000000,0.0000000,0.0000000); //object(dyn_roadbarrier_5)(6)
	Object[19] = CreateDynamicObject(979,-2091.0000000,-329.2999900,35.1000000,0.0000000,0.0000000,180.0000000); //object(sub_roadleft)(6)
	Object[20] = CreateDynamicObject(979,-2100.3000000,-329.2999900,35.1000000,0.0000000,0.0000000,179.9950000); //object(sub_roadleft)(7)
	Object[21] = CreateDynamicObject(979,-2109.6001000,-329.2999900,35.1000000,0.0000000,0.0000000,179.9950000); //object(sub_roadleft)(8)
	Object[22] = CreateDynamicObject(979,-2118.8999000,-329.2999900,35.1000000,0.0000000,0.0000000,179.9950000); //object(sub_roadleft)(9)
	Object[23] = CreateDynamicObject(979,-2128.2000000,-329.2999900,35.1000000,0.0000000,0.0000000,179.9950000); //object(sub_roadleft)(10)
	Object[24] = CreateDynamicObject(979,-2134.2000000,-328.8999900,35.1000000,0.0000000,0.0000000,175.9950000); //object(sub_roadleft)(12)
	Object[25] = CreateDynamicObject(979,-2143.2000000,-327.6000100,36.0000000,0.0000000,0.0000000,169.9900000); //object(sub_roadleft)(13)
	Object[26] = CreateDynamicObject(979,-2152.3999000,-326.0000000,36.0000000,0.0000000,0.0000000,169.9860000); //object(sub_roadleft)(14)
	Object[27] = CreateDynamicObject(979,-2160.0000000,-324.7999900,36.0000000,0.0000000,0.0000000,169.9860000); //object(sub_roadleft)(15)
	Object[28] = CreateDynamicObject(979,-2169.0000000,-324.1000100,36.0000000,0.0000000,356.0000000,179.9860000); //object(sub_roadleft)(16)
	Object[29] = CreateDynamicObject(979,-2174.2000000,-324.1000100,37.0000000,0.0000000,350.0000000,179.9840000); //object(sub_roadleft)(17)
	Object[30] = CreateDynamicObject(979,-2182.8000000,-324.1000100,38.7000000,0.0000000,347.9970000,179.9840000); //object(sub_roadleft)(18)
	Object[31] = CreateDynamicObject(979,-2191.8000000,-324.1000100,40.0000000,0.0000000,353.9920000,179.9840000); //object(sub_roadleft)(19)
	Object[32] = CreateDynamicObject(979,-2200.7000000,-324.1000100,40.5000000,0.0000000,357.9900000,179.9840000); //object(sub_roadleft)(20)
	Object[33] = CreateDynamicObject(979,-2200.7002000,-324.0996100,40.5000000,0.0000000,357.9900000,179.9840000); //object(sub_roadleft)(21)
	Object[34] = CreateDynamicObject(979,-2210.0000000,-324.1000100,40.9000000,0.0000000,357.9900000,179.9840000); //object(sub_roadleft)(22)
	Object[35] = CreateDynamicObject(979,-2218.8999000,-324.1000100,41.2000000,0.0000000,357.9900000,179.9840000); //object(sub_roadleft)(23)
	Object[36] = CreateDynamicObject(979,-2228.1001000,-324.1000100,41.5000000,0.0000000,357.9900000,179.9840000); //object(sub_roadleft)(24)
	Object[37] = CreateDynamicObject(979,-2233.8000000,-324.1000100,41.7000000,0.0000000,357.9900000,179.9840000); //object(sub_roadleft)(25)
	Object[38] = CreateDynamicObject(979,-2022.4000000,-336.5000000,35.3000000,0.0000000,0.0000000,116.0000000); //object(sub_roadleft)(26)
	Object[39] = CreateDynamicObject(979,-2027.9000000,-329.2999900,35.3000000,0.0000000,0.0000000,139.9990000); //object(sub_roadleft)(27)
	Object[40] = CreateDynamicObject(979,-2035.0000000,-324.2999900,35.3000000,0.0000000,0.0000000,151.9990000); //object(sub_roadleft)(28)
	Object[41] = CreateDynamicObject(979,-2290.6001000,-328.7000100,50.7000000,0.0000000,0.0000000,270.0000000); //object(sub_roadleft)(29)
	Object[42] = CreateDynamicObject(979,-2290.6001000,-337.7999900,50.7000000,0.0000000,0.0000000,270.0000000); //object(sub_roadleft)(30)
	Object[43] = CreateDynamicObject(979,-2290.5000000,-346.7999900,50.7000000,0.0000000,0.0000000,270.0000000); //object(sub_roadleft)(31)
	Object[44] = CreateDynamicObject(979,-2290.5000000,-353.0000000,50.7000000,0.0000000,0.0000000,270.0000000); //object(sub_roadleft)(32)
	Object[45] = CreateDynamicObject(979,-2286.6001000,-323.8999900,50.7000000,0.0000000,0.0000000,180.0000000); //object(sub_roadleft)(33)
	Object[46] = CreateDynamicObject(979,-2276.8000000,-324.0000000,50.7000000,0.0000000,0.0000000,179.9950000); //object(sub_roadleft)(34)
	Object[47] = CreateDynamicObject(979,-2286.2000000,-357.3999900,50.7000000,0.0000000,0.0000000,0.0000000); //object(sub_roadleft)(35)
	Object[48] = CreateDynamicObject(979,-2276.8999000,-357.3999900,50.7000000,0.0000000,0.0000000,0.0000000); //object(sub_roadleft)(36)
	Object[49] = CreateDynamicObject(979,-2235.0000000,-357.3999900,41.9000000,0.0000000,0.0000000,0.0000000); //object(sub_roadleft)(37)
	Object[50] = CreateDynamicObject(979,-2225.8000000,-357.3999900,41.5000000,0.0000000,6.0000000,0.0000000); //object(sub_roadleft)(38)
	Object[51] = CreateDynamicObject(979,-2217.8999000,-357.3999900,41.0000000,0.0000000,0.0000000,0.0000000); //object(sub_roadleft)(39)
	Object[52] = CreateDynamicObject(979,-2209.3999000,-357.3999900,41.0000000,0.0000000,0.0000000,0.0000000); //object(sub_roadleft)(40)
	Object[53] = CreateDynamicObject(979,-2200.7000000,-357.3999900,40.7000000,0.0000000,4.0000000,0.0000000); //object(sub_roadleft)(41)
	Object[54] = CreateDynamicObject(979,-2191.8999000,-357.2999900,40.3000000,0.0000000,1.9990000,0.0000000); //object(sub_roadleft)(42)
	Object[55] = CreateDynamicObject(979,-2183.3999000,-357.3999900,39.0000000,0.0000000,11.9990000,0.0000000); //object(sub_roadleft)(43)
	Object[56] = CreateDynamicObject(2931,-2235.6001000,-356.3999900,41.7000000,0.0000000,0.0000000,270.0000000); //object(kmb_jump1)(1)
	Object[57] = CreateDynamicObject(2931,-2235.3000000,-355.3999900,41.7000000,0.0000000,0.0000000,270.0000000); //object(kmb_jump1)(2)
	Object[58] = CreateDynamicObject(978,-2160.1001000,-354.8999900,35.1000000,0.0000000,0.0000000,178.0000000); //object(sub_roadright)(10)
	Object[59] = CreateDynamicObject(978,-2150.8999000,-355.2000100,35.1000000,0.0000000,0.0000000,177.9950000); //object(sub_roadright)(11)
	Object[60] = CreateDynamicObject(978,-2141.6001000,-355.5000000,35.1000000,0.0000000,0.0000000,177.9950000); //object(sub_roadright)(12)
	Object[61] = CreateDynamicObject(978,-2132.3000000,-355.7999900,35.1000000,0.0000000,0.0000000,177.9950000); //object(sub_roadright)(13)
	Object[62] = CreateDynamicObject(1282,-2127.0000000,-355.3999900,34.8000000,0.0000000,0.0000000,86.0000000); //object(barrierm)(3)
	Object[63] = CreateDynamicObject(1282,-2126.0000000,-355.5000000,34.8000000,0.0000000,0.0000000,85.9950000); //object(barrierm)(4)
	Object[64] = CreateDynamicObject(978,-2025.1000000,-356.0000000,35.3000000,0.0000000,0.0000000,355.9950000); //object(sub_roadright)(15)
	Object[65] = CreateDynamicObject(978,-2122.0000000,-370.5000000,35.1000000,0.0000000,0.0000000,91.9940000); //object(sub_roadright)(16)
	Object[66] = CreateDynamicObject(979,-2128.8000000,-440.2000100,35.2000000,0.0000000,0.0000000,270.0000000); //object(sub_roadleft)(44)
	Object[67] = CreateDynamicObject(979,-2128.8000000,-446.5000000,35.2000000,0.0000000,0.0000000,270.0000000); //object(sub_roadleft)(45)
	Object[68] = CreateDynamicObject(979,-2126.6001000,-463.0000000,35.2000000,0.0000000,0.0000000,286.0000000); //object(sub_roadleft)(46)
	Object[69] = CreateDynamicObject(979,-2124.1001000,-472.0000000,35.2000000,0.0000000,0.0000000,285.9960000); //object(sub_roadleft)(47)
	Object[70] = CreateDynamicObject(979,-2121.3000000,-480.5000000,35.2000000,0.0000000,0.0000000,291.9960000); //object(sub_roadleft)(48)
	Object[71] = CreateDynamicObject(979,-2117.8000000,-488.0000000,35.2000000,0.0000000,0.0000000,297.9950000); //object(sub_roadleft)(49)
	Object[72] = CreateDynamicObject(978,-2101.7000000,-494.2000100,35.4000000,0.0000000,0.0000000,146.0000000); //object(sub_roadright)(18)
	Object[73] = CreateDynamicObject(978,-1904.9000000,-521.5000000,38.1000000,0.0000000,0.0000000,90.0000000); //object(sub_roadright)(19)
	Object[74] = CreateDynamicObject(978,-1904.9000000,-530.5000000,38.1000000,0.0000000,0.0000000,90.0000000); //object(sub_roadright)(20)
	Object[75] = CreateDynamicObject(978,-1904.9000000,-539.5000000,38.1000000,0.0000000,0.0000000,90.0000000); //object(sub_roadright)(21)
	Object[76] = CreateDynamicObject(978,-1904.9000000,-548.7999900,38.1000000,0.0000000,0.0000000,90.0000000); //object(sub_roadright)(22)
	Object[77] = CreateDynamicObject(978,-1904.9000000,-557.7999900,38.1000000,0.0000000,0.0000000,90.0000000); //object(sub_roadright)(23)
	Object[78] = CreateDynamicObject(978,-1904.8000000,-561.7999900,38.1000000,0.0000000,0.0000000,90.0000000); //object(sub_roadright)(24)
	Object[79] = CreateDynamicObject(979,-1917.1000000,-671.2999900,40.8000000,0.0000000,358.0000000,270.0000000); //object(sub_roadleft)(50)
	Object[80] = CreateDynamicObject(979,-1917.1000000,-680.5999800,41.0000000,0.0000000,358.0000000,269.9950000); //object(sub_roadleft)(51)
	Object[81] = CreateDynamicObject(979,-1917.1000000,-690.0999800,41.5000000,0.0000000,358.0000000,269.9950000); //object(sub_roadleft)(52)
	Object[82] = CreateDynamicObject(979,-1917.1000000,-699.4000200,42.0000000,0.0000000,357.9950000,269.9950000); //object(sub_roadleft)(53)
	Object[83] = CreateDynamicObject(979,-1917.1000000,-708.5999800,42.5000000,0.0000000,357.9950000,269.9950000); //object(sub_roadleft)(54)
	Object[84] = CreateDynamicObject(979,-1917.1000000,-717.7999900,43.0000000,0.0000000,357.9950000,269.9950000); //object(sub_roadleft)(55)
	Object[85] = CreateDynamicObject(979,-1917.1000000,-727.2000100,43.2000000,0.0000000,357.9950000,269.9950000); //object(sub_roadleft)(56)
	Object[86] = CreateDynamicObject(979,-1917.1000000,-736.7000100,43.6000000,0.0000000,357.9950000,269.9950000); //object(sub_roadleft)(57)
	Object[87] = CreateDynamicObject(978,-1904.7000000,-797.5000000,44.8000000,0.0000000,0.0000000,90.0000000); //object(sub_roadright)(25)
	Object[88] = CreateDynamicObject(978,-1904.8000000,-806.7999900,44.8000000,0.0000000,0.0000000,90.0000000); //object(sub_roadright)(26)
	Object[89] = CreateDynamicObject(978,-1904.8000000,-816.0999800,44.8000000,0.0000000,0.0000000,90.0000000); //object(sub_roadright)(27)
	Object[90] = CreateDynamicObject(978,-1904.8000000,-825.2999900,44.8000000,0.0000000,0.0000000,90.0000000); //object(sub_roadright)(28)
	Object[91] = CreateDynamicObject(978,-1904.8000000,-834.4000200,44.8000000,0.0000000,0.0000000,90.0000000); //object(sub_roadright)(29)
	Object[92] = CreateDynamicObject(978,-1904.8000000,-838.2000100,44.8000000,0.0000000,0.0000000,90.0000000); //object(sub_roadright)(30)
	Object[93] = CreateDynamicObject(979,-1913.8000000,-1186.0000000,39.1000000,0.0000000,0.0000000,308.0000000); //object(sub_roadleft)(58)
	Object[94] = CreateDynamicObject(979,-1911.1000000,-1256.6000000,39.3000000,0.0000000,0.0000000,270.0000000); //object(sub_roadleft)(59)
	Object[95] = CreateDynamicObject(979,-1911.1000000,-1265.8000000,39.3000000,0.0000000,0.0000000,270.0000000); //object(sub_roadleft)(60)
	Object[96] = CreateDynamicObject(979,-1914.6000000,-1357.2000000,40.2000000,0.0000000,0.0000000,280.0000000); //object(sub_roadleft)(61)
	Object[97] = CreateDynamicObject(979,-1913.1000000,-1366.3000000,40.2000000,0.0000000,0.0000000,279.9970000); //object(sub_roadleft)(62)
	Object[98] = CreateDynamicObject(979,-1911.4000000,-1375.4000000,40.2000000,0.0000000,0.0000000,279.9920000); //object(sub_roadleft)(63)
	Object[99] = CreateDynamicObject(978,-1899.6000000,-1383.7000000,39.8000000,0.0000000,0.0000000,102.0000000); //object(sub_roadright)(31)
	Object[100] = CreateDynamicObject(978,-1901.5000000,-1374.8000000,39.8000000,0.0000000,0.0000000,101.9970000); //object(sub_roadright)(32)
	Object[101] = CreateDynamicObject(978,-1903.2000000,-1366.7000000,39.8000000,0.0000000,0.0000000,101.9970000); //object(sub_roadright)(33)
	Object[102] = CreateDynamicObject(978,-1902.3000000,-1358.6000000,39.8000000,0.0000000,0.0000000,63.9970000); //object(sub_roadright)(34)
	Object[103] = CreateDynamicObject(979,-1907.0000000,-1638.6000000,21.6000000,0.0000000,0.0000000,272.0000000); //object(sub_roadleft)(64)
	Object[104] = CreateDynamicObject(979,-1902.8000000,-1650.0000000,21.6000000,0.0000000,0.0000000,322.0000000); //object(sub_roadleft)(65)
	Object[105] = CreateDynamicObject(978,-1884.5000000,-1642.9000000,21.6000000,0.0000000,0.0000000,112.0000000); //object(sub_roadright)(35)
	Object[106] = CreateDynamicObject(978,-1881.3000000,-1651.0000000,21.6000000,0.0000000,0.0000000,111.9950000); //object(sub_roadright)(36)
	Object[107] = CreateDynamicObject(979,-1885.6000000,-1656.2000000,21.6000000,0.0000000,0.0000000,310.0000000); //object(sub_roadleft)(66)
	Object[108] = CreateDynamicObject(978,-1896.4000000,-1616.4000000,21.6000000,0.0000000,0.0000000,60.0000000); //object(sub_roadright)(37)
	Object[109] = CreateDynamicObject(979,-1649.5000000,-548.7999900,11.2000000,0.0000000,0.0000000,44.0000000); //object(sub_roadleft)(67)
	Object[110] = CreateDynamicObject(979,-1643.1000000,-542.5000000,11.2000000,0.0000000,0.0000000,45.9950000); //object(sub_roadleft)(68)
	Object[111] = CreateDynamicObject(979,-1636.9000000,-536.0000000,11.2000000,0.0000000,0.0000000,45.9940000); //object(sub_roadleft)(69)
	Object[112] = CreateDynamicObject(978,-1664.3000000,-535.2999900,11.2000000,0.0000000,0.0000000,224.0000000); //object(sub_roadright)(38)
	Object[113] = CreateDynamicObject(978,-1657.8000000,-529.0000000,11.2000000,0.0000000,0.0000000,223.9950000); //object(sub_roadright)(39)
	Object[114] = CreateDynamicObject(978,-1651.3000000,-522.7000100,11.2000000,0.0000000,0.0000000,223.9950000); //object(sub_roadright)(40)
	Object[115] = CreateDynamicObject(978,-1563.7000000,-441.1000100,6.0000000,0.0000000,0.0000000,224.0000000); //object(sub_roadright)(41)
	Object[116] = CreateDynamicObject(979,-1556.2000000,-448.7000100,5.8000000,0.0000000,0.0000000,44.0000000); //object(sub_roadleft)(70)
	Object[117] = CreateDynamicObject(979,-1560.5000000,-456.2000100,5.8000000,0.0000000,0.0000000,77.9950000); //object(sub_roadleft)(71)
	Object[118] = CreateDynamicObject(978,-1571.3000000,-444.5000000,6.0000000,0.0000000,0.0000000,183.9950000); //object(sub_roadright)(42)
	Object[119] = CreateDynamicObject(978,-1537.7000000,-418.2999900,5.7000000,0.0000000,0.0000000,132.0000000); //object(sub_roadright)(43)
	Object[120] = CreateDynamicObject(978,-1531.6000000,-424.8999900,5.7000000,0.0000000,0.0000000,131.9950000); //object(sub_roadright)(44)
	Object[121] = CreateDynamicObject(2931,-2201.6001000,-325.5000000,39.7000000,0.0000000,0.0000000,90.0000000); //object(kmb_jump1)(3)
	Object[122] = CreateDynamicObject(2931,-2201.6001000,-326.3999900,39.7000000,0.0000000,0.0000000,90.0000000); //object(kmb_jump1)(4)
	Object[123] = CreateDynamicObject(978,-2163.3000000,-335.2999900,35.0000000,0.0000000,0.0000000,273.9950000); //object(sub_roadright)(45)
	Object[124] = CreateDynamicObject(978,-2122.3994000,-361.4003900,35.1000000,0.0000000,0.0000000,91.9940000); //object(sub_roadright)(46)
	Object[125] = CreateDynamicObject(978,-2034.2000000,-354.5000000,35.3000000,0.0000000,0.0000000,345.9900000); //object(sub_roadright)(47)
	Object[126] = CreateDynamicObject(978,-2043.1000000,-351.7000100,35.3000000,0.0000000,0.0000000,337.9870000); //object(sub_roadright)(48)
	Object[127] = CreateDynamicObject(978,-2051.3999000,-347.8999900,35.3000000,0.0000000,0.0000000,331.9830000); //object(sub_roadright)(49)
	Object[128] = CreateDynamicObject(978,-2056.7000000,-344.6000100,35.3000000,0.0000000,0.0000000,327.9790000); //object(sub_roadright)(50)
	Object[129] = CreateDynamicObject(978,-1399.8000000,-390.7999900,5.7000000,0.0000000,0.0000000,172.0000000); //object(sub_roadright)(51)
	Object[130] = CreateDynamicObject(978,-1408.3000000,-390.7999900,5.7000000,0.0000000,0.0000000,187.9960000); //object(sub_roadright)(52)
	Object[131] = CreateDynamicObject(979,-1300.6000000,-406.2000100,14.0000000,0.0000000,0.0000000,72.0000000); //object(sub_roadleft)(72)
	Object[132] = CreateDynamicObject(979,-1297.8000000,-397.6000100,14.0000000,0.0000000,0.0000000,71.9990000); //object(sub_roadleft)(73)
	Object[133] = CreateDynamicObject(979,-1295.1000000,-388.8999900,14.0000000,0.0000000,0.0000000,71.9990000); //object(sub_roadleft)(74)
	Object[134] = CreateDynamicObject(979,-1242.0000000,-310.8999900,14.0000000,0.0000000,0.0000000,120.0000000); //object(sub_roadleft)(75)
	Object[135] = CreateDynamicObject(979,-1246.7000000,-302.7999900,14.0000000,0.0000000,0.0000000,119.9980000); //object(sub_roadleft)(76)
	Object[136] = CreateDynamicObject(979,-1251.3000000,-294.7999900,14.0000000,0.0000000,0.0000000,119.9980000); //object(sub_roadleft)(77)
	Object[137] = CreateDynamicObject(979,-1361.2000000,-167.8000000,14.0000000,0.0000000,0.0000000,150.0000000); //object(sub_roadleft)(78)
	Object[138] = CreateDynamicObject(979,-1368.9000000,-163.2000000,14.0000000,0.0000000,0.0000000,149.9990000); //object(sub_roadleft)(79)
	Object[139] = CreateDynamicObject(979,-1376.8000000,-158.8999900,14.0000000,0.0000000,0.0000000,151.9990000); //object(sub_roadleft)(80)
	Object[140] = CreateDynamicObject(978,-1669.7000000,-366.8999900,14.0000000,0.0000000,0.0000000,0.0000000); //object(sub_roadright)(53)
	Object[141] = CreateDynamicObject(978,-1679.0000000,-367.0000000,14.0000000,0.0000000,0.0000000,0.0000000); //object(sub_roadright)(54)
	Object[142] = CreateDynamicObject(978,-1687.3000000,-366.7999900,14.0000000,0.0000000,0.0000000,0.0000000); //object(sub_roadright)(55)
	Object[143] = CreateDynamicObject(978,-1696.3000000,-366.6000100,14.0000000,0.0000000,0.0000000,0.0000000); //object(sub_roadright)(56)
	Object[144] = CreateDynamicObject(978,-1704.8000000,-366.6000100,14.0000000,0.0000000,0.0000000,0.0000000); //object(sub_roadright)(57)
	Object[145] = CreateDynamicObject(978,-1714.1000000,-366.5000000,14.0000000,0.0000000,0.0000000,2.0000000); //object(sub_roadright)(58)
	Object[146] = CreateDynamicObject(978,-1718.8000000,-366.2999900,14.0000000,0.0000000,0.0000000,0.0000000); //object(sub_roadright)(59)
	Object[147] = CreateDynamicObject(979,-1303.6000000,-414.2000100,14.0000000,0.0000000,0.0000000,65.9990000); //object(sub_roadleft)(81)
	Object[148] = CreateDynamicObject(979,-1307.5000000,-422.2000100,14.0000000,0.0000000,0.0000000,61.9950000); //object(sub_roadleft)(82)
	Object[149] = CreateDynamicObject(978,-1811.9000000,-371.2000100,19.0000000,0.0000000,0.0000000,280.0000000); //object(sub_roadright)(60)
	Object[150] = CreateDynamicObject(978,-1812.9000000,-363.1000100,19.0000000,0.0000000,2.0000000,273.9980000); //object(sub_roadright)(61)
	Object[151] = CreateDynamicObject(978,-1903.6000000,-235.6000100,38.1000000,0.0000000,0.0000000,270.0000000); //object(sub_roadright)(62)
	Object[152] = CreateDynamicObject(978,-1903.5000000,-226.6000100,38.1000000,0.0000000,0.0000000,270.0000000); //object(sub_roadright)(63)
	Object[153] = CreateDynamicObject(978,-1903.4000000,-217.6000100,38.1000000,0.0000000,0.0000000,270.0000000); //object(sub_roadright)(64)
	Object[154] = CreateDynamicObject(978,-1903.3000000,-208.6000100,38.1000000,0.0000000,0.0000000,270.0000000); //object(sub_roadright)(65)
	Object[155] = CreateDynamicObject(978,-1903.2000000,-199.6000100,38.1000000,0.0000000,0.0000000,270.0000000); //object(sub_roadright)(66)
	Object[156] = CreateDynamicObject(978,-1903.2000000,-194.6000100,38.1000000,0.0000000,0.0000000,270.0000000); //object(sub_roadright)(67)
	Object[157] = CreateDynamicObject(978,-2184.6001000,-354.6000100,38.7000000,0.0000000,348.0000000,180.0000000); //object(sub_roadright)(68)
	for(new i=0; i < 5; i++) AddPlayerClassEx(1,random(312),-2431.9709,-1619.5594,526.4762,297.8344,0,0,0,0,0,0); // 
	return 1;
}

public OnPlayerRequestClass(playerid,classid)
{
	TogglePlayerControllable(playerid,false);
	GameTextForPlayer(playerid,"~g~~h~RACER",1000,3);
	SetPlayerColor(playerid,RACE_COLOR);
	SetPlayerPos(playerid,-1272.0562,52.3756,71.3209);
	SetPlayerFacingAngle(playerid,333.3537);
	SetPlayerCameraPos(playerid,-1270.605957 , 55.265899 , 72.574501);
	SetPlayerCameraLookAt(playerid,-1272.0562,52.3756,71.3209);
	return 1;
}

public OnFilterScriptExit()
{
    for(new i=0;i<MAX_OBJECTS;i++) DestroyDynamicObject(i);
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
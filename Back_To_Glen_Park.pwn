 //Map by: iJumbo. 
#include <a_samp>
#include <crashdetect>

new Animations= 0;
new Shop= 0; 
new ShopWeapons= 0; 
new ShopVehicles= 0; 
new SafeSpawn= 0; 
new Fix= 0; 
new Flip= 0; 

#define MapName "PARKOUR: Back To Geln Park"
#define PARKOUR_COLOR 0xf0f1ffFF //Different color for each maps!

#undef MAX_OBJECTS
#define MAX_OBJECTS (60)

main() {}

#define Z_LIMIT (173.7551)

new Object[MAX_OBJECTS];

#define MAX_CPs (12)
enum parkour_cp_enum
{
	Float:parkour_cp_x,
	Float:parkour_cp_y,
	Float:parkour_cp_z,
	parkour_cp_type,
	Float:parkour_cp_size
};

forward Float:map_ParkourCPs(CP_ID,DATA);
forward map_GetCPType(CP_ID,DATA);
forward map_GetMaxCPs();
forward Float:map_GetSpawn(id,coord);
forward map_CommandsInfo(data);
forward map_ChangeCommandsInfo(ToChange,NewValue);
forward map_GetParkourColor();
forward Float:map_Z_AxisLimit();

new parkour_cp[MAX_CPs][parkour_cp_enum] =
{
	{1544.3330,-1308.4529,327.3722,0,10.0},
    {1561.3280,-1301.9381,329.8169,0,10.0},
    {1561.6622,-1287.6759,325.4560,0,10.0},
    {1541.5375,-1254.8204,299.7534,0,10.0},
    {1571.9928,-1256.2688,290.9978,0,10.0},
    {1636.3940,-1255.5253,288.8595,0,10.0},
    {1696.4355,-1236.9637,287.2714,0,10.0},
    {1693.7725,-1195.0225,278.3278,0,10.0},
    {1696.5178,-1128.5612,275.5778,0,10.0},
    {1801.8140,-1189.0740,276.6653,0,10.0},
    {1857.3494,-1259.7222,196.2282,0,10.0},
    {1941.6742,-1195.7701,173.8897,1,10.0}
};

new Float:spawns[][4] =
{
	{1544.9849,-1353.7681,329.4735,0.0}
};
   

public Float:map_GetSpawn(id,coord)
{
	if(coord < 0 || coord > 3) return -1.0; 
	return spawns[id][coord];
}
   
public OnFilterScriptInit()
{
	print(""MapName" initialized");
	Object[0] = CreateObject(972,1531.4797360,-1359.2265630,328.4503480,0.0000000,0.0000000,0.0000000); //object
	Object[1] = CreateObject(972,1550.9912110,-1359.2368160,328.4558110,0.0000000,0.0000000,0.0000000); //object(1)
	Object[2] = CreateObject(972,1542.7086180,-1365.2862550,328.1538090,0.0000000,0.0000000,-89.3814160); //object(2)
	Object[3] = CreateObject(974,1551.0570070,-1345.1020510,331.2362370,0.0000000,0.0000000,0.0000000); //object(3)
	Object[4] = CreateObject(974,1538.1917720,-1345.0731200,331.2412110,0.0000000,0.0000000,0.0000000); //object(4)
	Object[5] = CreateObject(978,1544.5068360,-1337.0280760,329.0475770,94.5380935,0.0000000,-88.5219793); //object(5)
	Object[6] = CreateObject(978,1544.7089840,-1345.8870850,327.3465270,-245.7988368,256.9715138,14.6104238); //object(6)
	Object[7] = CreateObject(978,1544.2374270,-1324.6140140,329.0477600,94.5380935,0.0000000,-88.5219793); //object(7)
	Object[8] = CreateObject(974,1544.2946780,-1316.1751710,328.0178830,91.9597261,0.0000000,0.0000000); //object(9)
	Object[9] = CreateObject(974,1544.0888670,-1307.9543460,326.0746770,91.9597261,0.0000000,0.0000000); //object(10)
	Object[10] = CreateObject(974,1544.8612060,-1299.6843260,328.9242250,91.9597261,0.0000000,0.0000000); //object(11)
	Object[11] = CreateObject(974,1553.2598880,-1299.9008790,330.8077090,91.9597261,0.0000000,0.0000000); //object(12)
	Object[12] = CreateObject(974,1560.9429930,-1300.6954350,328.5448610,91.9597261,0.0000000,0.0000000); //object(13)
	Object[13] = CreateObject(974,1564.0394290,-1299.9224850,331.3226620,183.9195095,0.0000000,-89.3814160); //object(14)
	Object[14] = CreateObject(974,1561.3298340,-1292.1364750,326.9522400,91.9597261,0.0000000,0.0000000); //object(15)
	Object[15] = CreateObject(974,1562.1833500,-1287.3046880,324.1541140,91.9597261,0.0000000,0.0000000); //object(16)
	Object[16] = CreateObject(3258,1559.6967770,-1287.8344730,322.7366330,118.6023209,0.0000000,-88.5219793); //object(17)
	Object[17] = CreateObject(3257,1555.8541260,-1255.2099610,276.3557130,0.0000000,0.0000000,0.0000000); //object(18)
	Object[18] = CreateObject(3287,1565.3041990,-1254.0991210,288.8939210,0.0000000,0.0000000,0.0000000); //object(19)
	Object[19] = CreateObject(3287,1571.8582760,-1254.1746830,288.9353030,0.0000000,0.0000000,0.0000000); //object(20)
	Object[20] = CreateObject(3502,1537.4625240,-1282.5633540,314.2812810,0.0000000,0.0000000,0.0000000); //object(22)
	Object[21] = CreateObject(3502,1538.0643310,-1274.2580570,313.8345030,-6.0160569,0.0000000,-7.7349302); //object(23)
	Object[22] = CreateObject(3502,1539.6464840,-1267.3537600,312.5872800,-12.0321137,0.0000000,-16.3292972); //object(24)
	Object[23] = CreateObject(3502,1541.5817870,-1256.7816160,307.0541380,-85.0842326,0.0000000,-16.3292972); //object(25)
	Object[24] = CreateObject(974,1541.1547850,-1254.3846440,311.6583860,91.9597261,0.0000000,0.0000000); //object(26)
	Object[25] = CreateObject(974,1541.2364500,-1262.0153810,310.1498110,91.9597261,0.0000000,0.0000000); //object(28)
	Object[26] = CreateObject(974,1546.3331300,-1258.0347900,310.4131470,91.9597261,0.0000000,0.0000000); //object(29)
	Object[27] = CreateObject(974,1536.3911130,-1257.4553220,310.3058780,91.9597261,0.0000000,11.1726770); //object(30)
	Object[28] = CreateObject(974,1540.4655760,-1255.2178960,298.4084470,91.9597261,0.0000000,3.4377468); //object(31)
	Object[29] = CreateObject(974,1544.4476320,-1255.2996830,298.4299620,91.9597261,0.0000000,-4.2971835); //object(32)
	Object[30] = CreateObject(3257,1585.7303470,-1253.0253910,272.1297610,0.0000000,0.0000000,-88.5219793); //object(33)
	Object[31] = CreateObject(3257,1585.9868160,-1261.2940670,272.1331480,0.0000000,0.0000000,-268.1441908); //object(34)
	Object[32] = CreateObject(3631,1594.1416020,-1257.0864260,286.8688350,0.0000000,0.0000000,1.7188734); //object(35)
	Object[33] = CreateObject(3631,1604.5616460,-1256.7723390,286.8517460,0.0000000,0.0000000,1.7188734); //object(36)
	Object[34] = CreateObject(3631,1615.5517580,-1256.5833740,286.8595890,0.0000000,0.0000000,1.7188734); //object(37)
	Object[35] = CreateObject(3636,1633.9842530,-1255.8483890,276.3659970,82.5059225,0.0000000,-1.7188734); //object(38)
	Object[36] = CreateObject(3636,1650.9996340,-1256.6353760,274.6045230,82.5059225,0.0000000,-1.7188734); //object(39)
	Object[37] = CreateObject(3636,1666.3859860,-1255.2049560,272.6148680,82.5059225,0.0000000,17.1887338); //object(40)
	Object[38] = CreateObject(3636,1681.0902100,-1248.7812500,273.7092900,82.5059225,0.0000000,27.5019742); //object(41)
	Object[39] = CreateObject(3636,1694.7730710,-1239.3874510,274.8478090,82.5059225,0.0000000,39.5340879); //object(42)
	Object[40] = CreateObject(6867,1714.9548340,-1178.6704100,297.1539920,0.0000000,0.0000000,-51.5662016); //object(43)
	Object[41] = CreateObject(974,1706.9841310,-1211.4726560,277.0307620,90.2408527,0.0000000,-49.8473282); //object(44)
	Object[42] = CreateObject(974,1701.0375980,-1204.8764650,276.8173830,90.2408527,0.0000000,-49.8473282); //object(45)
	Object[43] = CreateObject(974,1693.7663570,-1197.6145020,276.8290100,90.2408527,0.0000000,-49.8473282); //object(46)
	Object[44] = CreateObject(974,1702.9202880,-1178.1762700,279.1806030,90.2408527,0.0000000,-49.8473282); //object(47)
	Object[45] = CreateObject(974,1697.3150630,-1182.8781740,279.6194760,90.2408527,0.0000000,-49.8473282); //object(48)
	Object[46] = CreateObject(974,1690.9849850,-1185.7086180,280.6578370,90.2408527,0.0000000,-49.8473282); //object(49)
	Object[47] = CreateObject(974,1707.2357180,-1118.8055420,273.8806150,90.2408527,0.0000000,-49.8473282); //object(50)
	Object[48] = CreateObject(974,1711.8013920,-1115.3616940,276.6735530,90.2408527,0.0000000,-49.8473282); //object(51)
	Object[49] = CreateObject(974,1716.7010500,-1121.0378420,278.0981140,90.2408527,0.0000000,-49.8473282); //object(52)
	Object[50] = CreateObject(974,1722.6903080,-1124.6551510,279.0846250,90.2408527,0.0000000,-49.8473282); //object(53)
	Object[51] = CreateObject(974,1727.6313480,-1129.9774170,280.6449280,90.2408527,0.0000000,-49.8473282); //object(54)
	Object[52] = CreateObject(974,1732.6157230,-1125.5532230,282.7793270,90.2408527,0.0000000,-49.8473282); //object(55)
	Object[53] = CreateObject(974,1740.9943850,-1120.9561770,280.2221370,90.2408527,0.0000000,-49.8473282); //object(56)
	Object[54] = CreateObject(974,1744.0837400,-1121.6605220,281.8569340,183.0600728,0.0000000,39.5340879); //object(57)
	Object[55] = CreateObject(974,1779.2250980,-1161.0411380,280.8306270,268.1441908,0.0000000,39.5340879); //object(58)
	Object[56] = CreateObject(3330,1804.4113770,-1187.4750980,270.0340270,-31.7991576,0.0000000,37.8152145); //object(59)
	Object[57] = CreateObject(3330,1820.6331790,-1210.1910400,233.5100100,-55.0039483,0.0000000,37.8152145); //object(60)
	Object[58] = CreateObject(3411,1879.0327150,-1241.6793210,183.4462590,0.0000000,0.0000000,-53.2850177); //object(61)
	Object[59] = CreateObject(4550,1957.4041750,-1183.4034420,126.3055040,124.6183204,0.0000000,126.3373084); //object(62)
	for(new i=0; i < 5; i++) AddPlayerClassEx(1,random(312),-2431.9709,-1619.5594,526.4762,297.8344,0,0,0,0,0,0); // 
	return 1;
}

public OnPlayerRequestClass(playerid,classid)
{
	TogglePlayerControllable(playerid,false);
	GameTextForPlayer(playerid,"~g~RUNNER!",1000,3);
	SetPlayerColor(playerid,PARKOUR_COLOR);
	SetPlayerPos(playerid,1769.8267,-1193.5482,306.3337);
	SetPlayerFacingAngle(playerid,295.2095);
	SetPlayerCameraPos(playerid,1772.8267,-1193.5482,307.3337);
	SetPlayerCameraLookAt(playerid,1769.8267,-1193.5482,306.3337);
	return 1;
}

public OnFilterScriptExit()
{
    for(new i=0;i<MAX_OBJECTS;i++) DestroyObject(i);
	return 1;
}

public map_GetCPType(CP_ID,DATA) return parkour_cp[CP_ID][parkour_cp_type];
public map_GetMaxCPs() return MAX_CPs;
public map_GetParkourColor() return PARKOUR_COLOR;

public Float:map_ParkourCPs(CP_ID,DATA)
{
	if(CP_ID < 0 || CP_ID > MAX_CPs) return -1.0;
	switch(DATA)
	{
		case 0: return Float:parkour_cp[CP_ID][parkour_cp_x];
		case 1: return parkour_cp[CP_ID][parkour_cp_y];
		case 2: return parkour_cp[CP_ID][parkour_cp_z];
		case 4: return parkour_cp[CP_ID][parkour_cp_size];
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

public Float:map_Z_AxisLimit()
{
	return Z_LIMIT;
}
 //by: JimmySpaceTravel1337.
#include <a_samp>
#include <crashdetect>
#include <stuff\defines>
//#include <streamer>

new Animations= 1; 
new Shop= 1; 
new ShopWeapons= 1;
new ShopVehicles= 1; 
new SafeSpawn= 0; 
new Fix= 0; 
new Flip= 0;

#define MapName "DEATHMATCH: Desert Storm"
#define DM_COLOR 0x8b0000FF

#define Health 99

#define WEAPON_1 30
#define WEAPON_1_AMMO 500
#define WEAPON_2 24
#define WEAPON_2_AMMO 300
#define WEAPON_3 27
#define WEAPON_3_AMMO 400

#define MAP_INTERIOR 0

#define MAX_MAP_VEHICLES 0

new Object[275];

forward Float:map_GetSpawn(id,coord);
forward map_CommandsInfo(data);
forward map_ChangeCommandsInfo(ToChange,NewValue);
forward map_Load();
forward map_GetHealth();
forward map_MaxSpawns();

new Float:spawns[][] =
{
	{-1841.8931,3231.2529,12.1563,186.6232},
    {-1832.2225,3217.8235,12.1524,78.85900},
    {-1825.9655,3195.6301,12.1528,70.71240},
    {-1828.9807,3177.4817,11.8399,122.7262},
    {-1843.5814,3169.3506,11.3407,19.95190},
    {-1852.2909,3192.4851,12.1563,12.11850},
    {-1868.8318,3169.0732,13.5203,302.2446},
    {-1878.3323,3219.9314,12.1563,266.5242},
    {-1860.7588,3233.5923,12.1563,126.4629},
    {-1878.9805,3233.7097,12.1563,254.6175},
    {-1901.6425,3209.3289,17.2985,288.4579},
    {-1887.8243,3207.7126,17.0773,352.0653},
    {-1882.1626,3204.1719,17.2733,231.4308},
    {-1882.5983,3196.4119,17.8203,274.0447},
    {-1884.4833,3190.1487,17.8203,267.1515},
    {-1883.3821,3179.9722,17.8203,269.9717},
    {-1881.6074,3165.8315,17.7773,264.0184},
    {-1893.1973,3175.5195,17.6563,345.1725}
};

public OnFilterScriptInit()
{
	print(" -- "MapName" - INITIALIZED --");

	Object[0] = CreateObject(16165,-1851.1999500,3230.1999500,0.0000000,30.0000000,0.0000000,0.0000000); //object(n_bit_10) (1)
	Object[1] = CreateObject(16165,-1842.0996100,3201.1992200,0.0000000,29.9930000,0.0000000,303.9970000); //object(n_bit_10) (2)
	Object[2] = CreateObject(16165,-1843.2998000,3198.3994100,0.0000000,29.9930000,0.0000000,267.9950000); //object(n_bit_10) (3)
	Object[3] = CreateObject(16165,-1837.4000200,3191.0000000,0.0000000,29.9870000,0.0000000,217.9950000); //object(n_bit_10) (4)
	Object[4] = CreateObject(16165,-1836.0999800,3177.6999500,0.0000000,29.9620000,2.3090000,158.8370000); //object(n_bit_10) (5)
	Object[5] = CreateObject(16165,-1886.4000200,3231.6999500,0.0000000,29.9600000,2.3070000,102.8350000); //object(n_bit_10) (6)
	Object[6] = CreateObject(16165,-1872.3000500,3213.8999000,0.0000000,29.9600000,2.3020000,48.8320000); //object(n_bit_10) (7)
	Object[7] = CreateObject(16170,-1856.0996100,3202.3994100,-5.0000000,0.0000000,0.0000000,0.0000000); //object(n_bit_15) (1)
	Object[8] = CreateObject(6980,-1872.5000000,3240.0000000,14.6000000,0.0000000,0.0000000,190.0000000); //object(trainstuff07_sfs02) (1)
	Object[9] = CreateObject(16120,-1874.5000000,3251.1001000,5.0000000,0.0000000,0.0000000,64.0000000); //object(des_rockgp2_07) (1)
	Object[10] = CreateObject(16120,-1865.8000500,3247.8999000,5.0000000,0.0000000,358.0000000,45.9980000); //object(des_rockgp2_07) (2)
	Object[11] = CreateObject(16120,-1891.5000000,3247.3000500,5.0000000,0.0000000,357.9950000,65.9970000); //object(des_rockgp2_07) (3)
	Object[12] = CreateObject(16120,-1889.5999800,3240.8999000,5.0000000,0.0000000,357.9900000,95.9950000); //object(des_rockgp2_07) (4)
	Object[13] = CreateObject(10985,-1873.5999800,3239.0000000,11.0000000,0.0000000,0.0000000,0.0000000); //object(rubbled02_sfs) (1)
	Object[14] = CreateObject(10985,-1873.3000500,3238.6001000,10.0000000,70.0000000,0.0000000,0.0000000); //object(rubbled02_sfs) (2)
	Object[15] = CreateObject(16120,-1880.0999800,3249.8000500,5.0000000,0.0000000,0.0000000,63.9950000); //object(des_rockgp2_07) (5)
	Object[16] = CreateObject(16120,-1876.6999500,3249.8999000,5.0000000,0.0000000,0.0000000,63.9950000); //object(des_rockgp2_07) (6)
	Object[17] = CreateObject(11426,-1857.5999800,3228.1999500,11.0000000,0.0000000,0.0000000,250.0000000); //object(des_adobe03) (1)
	Object[18] = CreateObject(11440,-1863.9000200,3187.6999500,10.5500000,0.0000000,0.0000000,0.0000000); //object(des_pueblo1) (1)
	Object[19] = CreateObject(11441,-1872.5999800,3209.3000500,11.1000000,0.0000000,0.0000000,0.0000000); //object(des_pueblo5) (1)
	Object[20] = CreateObject(11443,-1837.9000200,3210.3999000,11.5000000,0.0000000,0.0000000,0.0000000); //object(des_pueblo4) (1)
	Object[21] = CreateObject(11444,-1847.4000200,3227.3000500,11.0000000,0.0000000,0.0000000,0.0000000); //object(des_pueblo2) (1)
	Object[22] = CreateObject(11445,-1845.5000000,3174.1001000,10.8000000,0.0000000,0.0000000,0.0000000); //object(des_pueblo06) (1)
	Object[23] = CreateObject(3887,-1889.4000200,3185.6999500,18.0000000,0.0000000,0.0000000,180.0000000); //object(demolish4_sfxrf) (1)
	Object[24] = CreateObject(16170,-1941.8994100,3165.7998000,0.5000000,0.0000000,0.0000000,347.9970000); //object(n_bit_15) (2)
	Object[25] = CreateObject(11426,-1856.5999800,3211.5000000,11.0000000,0.0000000,0.0000000,63.9950000); //object(des_adobe03) (2)
	Object[26] = CreateObject(11426,-1833.5000000,3182.1001000,11.0000000,0.0000000,0.0000000,137.9950000); //object(des_adobe03) (3)
	Object[27] = CreateObject(11426,-1828.9000200,3204.1999500,11.0000000,0.0000000,0.0000000,201.9940000); //object(des_adobe03) (4)
	Object[28] = CreateObject(11444,-1862.0999800,3173.3000500,11.0000000,0.0000000,0.0000000,84.0000000); //object(des_pueblo2) (2)
	Object[29] = CreateObject(11426,-1878.3000500,3227.0000000,11.0000000,0.0000000,358.0000000,21.9950000); //object(des_adobe03) (5)
	Object[30] = CreateObject(11426,-1873.6999500,3180.5000000,11.0000000,0.0000000,357.9950000,21.9950000); //object(des_adobe03) (6)
	Object[31] = CreateObject(11441,-1869.1999500,3215.6999500,11.1000000,0.0000000,0.0000000,232.0000000); //object(des_pueblo5) (2)
	Object[32] = CreateObject(11441,-1841.0000000,3217.0000000,11.1000000,0.0000000,0.0000000,189.9980000); //object(des_pueblo5) (3)
	Object[33] = CreateObject(11441,-1850.0000000,3204.3999000,11.1000000,0.0000000,0.0000000,71.9980000); //object(des_pueblo5) (4)
	Object[34] = CreateObject(11444,-1845.0000000,3160.3994100,10.2000000,0.0000000,0.0000000,171.9910000); //object(des_pueblo2) (5)
	Object[35] = CreateObject(971,-1886.0000000,3213.8000500,11.6000000,0.0000000,0.0000000,18.0000000); //object(subwaygate) (1)
	Object[36] = CreateObject(11440,-1833.0999800,3192.3999000,10.6000000,0.0000000,0.0000000,88.0000000); //object(des_pueblo1) (2)
	Object[37] = CreateObject(1413,-1848.1999500,3185.8000500,12.4000000,0.0000000,0.0000000,0.0000000); //object(dyn_mesh_3) (1)
	Object[38] = CreateObject(1413,-1867.9000200,3176.8000500,13.0000000,0.0000000,0.0000000,160.0000000); //object(dyn_mesh_3) (2)
	Object[39] = CreateObject(1413,-1849.4000200,3164.6999500,11.8000000,0.0000000,0.0000000,179.9990000); //object(dyn_mesh_3) (3)
	Object[40] = CreateObject(1447,-1845.0999800,3234.1999500,12.4000000,0.0000000,0.0000000,90.0000000); //object(dyn_mesh_4) (1)
	Object[41] = CreateObject(1447,-1868.5000000,3210.3000500,12.4000000,0.0000000,0.0000000,184.0000000); //object(dyn_mesh_4) (2)
	Object[42] = CreateObject(1447,-1863.4000200,3210.6999500,12.4000000,0.0000000,0.0000000,183.9990000); //object(dyn_mesh_4) (3)
	Object[43] = CreateObject(3275,-1856.0999800,3175.1999500,11.8000000,0.0000000,0.0000000,188.0000000); //object(cxreffence) (1)
	Object[44] = CreateObject(922,-1883.0000000,3212.0996100,16.8000000,0.0000000,0.0000000,0.0000000); //object(packing_carates1) (1)
	Object[45] = CreateObject(922,-1881.5000000,3209.1999500,16.9000000,0.0000000,0.0000000,90.0000000); //object(packing_carates1) (2)
	Object[46] = CreateObject(922,-1830.6999500,3204.8999000,14.8000000,0.0000000,0.0000000,112.0000000); //object(packing_carates1) (3)
	Object[47] = CreateObject(922,-1859.4000200,3227.1999500,14.8000000,0.0000000,0.0000000,159.9950000); //object(packing_carates1) (4)
	Object[48] = CreateObject(922,-1860.5999800,3174.6999500,14.7000000,0.0000000,0.0000000,173.9940000); //object(packing_carates1) (5)
	Object[49] = CreateObject(923,-1862.6999500,3200.3000500,17.5000000,0.0000000,0.0000000,0.0000000); //object(packing_carates2) (1)
	Object[50] = CreateObject(923,-1845.3994100,3194.1992200,17.6000000,0.0000000,0.0000000,51.9980000); //object(packing_carates2) (2)
	Object[51] = CreateObject(923,-1848.4000200,3224.0000000,14.7000000,0.0000000,0.0000000,359.9980000); //object(packing_carates2) (3)
	Object[52] = CreateObject(923,-1865.6999500,3183.8999000,14.5000000,0.0000000,0.0000000,359.9950000); //object(packing_carates2) (4)
	Object[53] = CreateObject(923,-1876.0000000,3224.8000500,14.9000000,0.0000000,0.0000000,59.9950000); //object(packing_carates2) (5)
	Object[54] = CreateObject(923,-1889.0999800,3178.8000500,17.3000000,0.0000000,0.0000000,359.9950000); //object(packing_carates2) (6)
	Object[55] = CreateObject(2991,-1853.1999500,3213.8999000,11.8000000,0.0000000,0.0000000,331.9960000); //object(imy_bbox) (1)
	Object[56] = CreateObject(2991,-1836.5999800,3178.1001000,11.5000000,0.0000000,0.0000000,317.9960000); //object(imy_bbox) (2)
	Object[57] = CreateObject(2991,-1878.1999500,3200.3000500,11.8000000,0.0000000,0.0000000,327.9940000); //object(imy_bbox) (3)
	Object[58] = CreateObject(923,-1895.0000000,3194.5000000,17.2000000,0.0000000,0.0000000,359.9950000); //object(packing_carates2) (7)
	Object[59] = CreateObject(18257,-1890.6999500,3182.5000000,16.3000000,0.0000000,0.0000000,0.0000000); //object(crates) (1)
	Object[60] = CreateObject(925,-1888.4000200,3169.1999500,22.1000000,0.0000000,0.0000000,6.0000000); //object(rack2) (1)
	Object[61] = CreateObject(1348,-1887.6999500,3185.1999500,21.8000000,0.0000000,0.0000000,90.0000000); //object(cj_o2tanks) (1)
	Object[62] = CreateObject(1348,-1887.6999500,3183.6001000,21.8000000,0.0000000,0.0000000,90.0000000); //object(cj_o2tanks) (2)
	Object[63] = CreateObject(1348,-1884.5000000,3175.3000500,21.8000000,0.0000000,0.0000000,40.0000000); //object(cj_o2tanks) (3)
	Object[64] = CreateObject(11433,-1835.5000000,3229.3999000,13.1000000,0.0000000,0.0000000,302.0000000); //object(adobe_hoose2) (1)
	Object[65] = CreateObject(11427,-1857.4000200,3164.3000500,17.8000000,0.0000000,0.0000000,252.0000000); //object(des_adobech) (1)
	Object[66] = CreateObject(13367,-1836.4000200,3166.6001000,22.0000000,0.0000000,14.0000000,122.0000000); //object(sw_watertower01) (1)
	Object[67] = CreateObject(3260,-1846.3000500,3187.0000000,13.9000000,270.0000000,0.0000000,90.0000000); //object(oldwoodpanel) (1)
	Object[68] = CreateObject(3260,-1849.3000500,3187.0000000,13.9000000,270.0000000,0.0000000,90.0000000); //object(oldwoodpanel) (2)
	Object[69] = CreateObject(3260,-1852.3000500,3187.0000000,13.9000000,270.0000000,0.0000000,90.0000000); //object(oldwoodpanel) (3)
	Object[70] = CreateObject(3260,-1855.3000500,3187.0000000,13.9000000,270.0000000,0.0000000,90.0000000); //object(oldwoodpanel) (4)
	Object[71] = CreateObject(923,-1836.4000200,3198.1999500,14.6000000,0.0000000,0.0000000,11.9980000); //object(packing_carates2) (2)
	Object[72] = CreateObject(923,-1882.4000200,3203.3000500,12.6000000,0.0000000,18.0000000,1.9970000); //object(packing_carates2) (2)
	Object[73] = CreateObject(16170,-1936.5999800,3165.5000000,0.5000000,0.0000000,0.0000000,347.9970000); //object(n_bit_15) (2)
	Object[74] = CreateObject(922,-1899.0999800,3212.1999500,15.8000000,0.0000000,0.0000000,0.0000000); //object(packing_carates1) (1)
	Object[75] = CreateObject(3593,-1857.3000500,3236.1999500,11.9000000,0.0000000,0.0000000,90.0000000); //object(la_fuckcar2) (1)
	Object[76] = CreateObject(3593,-1892.3000500,3204.6999500,16.4000000,0.0000000,0.0000000,70.0000000); //object(la_fuckcar2) (2)
	Object[77] = CreateObject(3594,-1855.8000500,3193.5000000,11.8000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (1)
	Object[78] = CreateObject(3594,-1872.3000500,3169.5000000,14.1000000,0.0000000,338.0000000,218.0000000); //object(la_fuckcar1) (2)
	Object[79] = CreateObject(933,-1853.5999800,3224.8999000,11.2000000,0.0000000,0.0000000,0.0000000); //object(cj_cableroll) (1)
	Object[80] = CreateObject(933,-1837.4000200,3203.1001000,11.2000000,0.0000000,0.0000000,0.0000000); //object(cj_cableroll) (2)
	Object[81] = CreateObject(933,-1837.4000200,3203.1001000,12.2000000,0.0000000,0.0000000,0.0000000); //object(cj_cableroll) (3)
	Object[82] = CreateObject(933,-1829.6999500,3190.3000500,13.7000000,0.0000000,0.0000000,0.0000000); //object(cj_cableroll) (4)
	Object[83] = CreateObject(854,-1835.1999500,3187.5000000,11.4000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (1)
	Object[84] = CreateObject(854,-1880.8000500,3212.5000000,11.7000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (2)
	Object[85] = CreateObject(854,-1865.3000500,3176.5000000,11.7000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (3)
	Object[86] = CreateObject(854,-1841.6999500,3164.6999500,10.3000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (4)
	Object[87] = CreateObject(854,-1845.6999500,3236.3999000,11.4000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (5)
	Object[88] = CreateObject(853,-1847.4000200,3195.0000000,11.6000000,0.0000000,0.0000000,50.0000000); //object(cj_urb_rub_5) (2)
	Object[89] = CreateObject(853,-1867.9000200,3200.6001000,11.6000000,0.0000000,0.0000000,359.9990000); //object(cj_urb_rub_5) (3)
	Object[90] = CreateObject(853,-1833.3000500,3220.8000500,11.6000000,0.0000000,0.0000000,289.9950000); //object(cj_urb_rub_5) (4)
	Object[91] = CreateObject(853,-1862.8000500,3167.1999500,11.7000000,0.0000000,0.0000000,135.9900000); //object(cj_urb_rub_5) (5)
	Object[92] = CreateObject(853,-1827.5000000,3182.3999000,11.5000000,0.0000000,0.0000000,95.9890000); //object(cj_urb_rub_5) (6)
	Object[93] = CreateObject(852,-1860.3000500,3193.1999500,11.2000000,0.0000000,0.0000000,140.0000000); //object(cj_urb_rub_4) (1)
	Object[94] = CreateObject(852,-1862.3000500,3227.1999500,11.2000000,0.0000000,0.0000000,279.9990000); //object(cj_urb_rub_4) (2)
	Object[95] = CreateObject(852,-1855.9000200,3214.6999500,11.2000000,0.0000000,0.0000000,199.9980000); //object(cj_urb_rub_4) (3)
	Object[96] = CreateObject(852,-1837.0999800,3227.1001000,11.2000000,0.0000000,0.0000000,299.9950000); //object(cj_urb_rub_4) (4)
	Object[97] = CreateObject(851,-1841.5000000,3229.1999500,11.5000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_2) (1)
	Object[98] = CreateObject(851,-1848.5000000,3214.8000500,11.5000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_2) (2)
	Object[99] = CreateObject(851,-1859.1999500,3203.6999500,11.5000000,0.0000000,0.0000000,60.0000000); //object(cj_urb_rub_2) (3)
	Object[100] = CreateObject(851,-1851.0999800,3180.1999500,11.3000000,0.0000000,0.0000000,139.9960000); //object(cj_urb_rub_2) (4)
	Object[101] = CreateObject(850,-1859.0999800,3180.5000000,11.1000000,0.0000000,0.0000000,60.0000000); //object(cj_urb_rub_1) (2)
	Object[102] = CreateObject(850,-1844.1999500,3203.3000500,11.3000000,0.0000000,0.0000000,139.9960000); //object(cj_urb_rub_1) (3)
	Object[103] = CreateObject(850,-1863.6999500,3215.3000500,11.3000000,0.0000000,0.0000000,139.9930000); //object(cj_urb_rub_1) (4)
	Object[104] = CreateObject(850,-1882.5999800,3222.6001000,11.9000000,0.0000000,0.0000000,59.9930000); //object(cj_urb_rub_1) (5)
	Object[105] = CreateObject(2971,-1881.8000500,3163.8000500,26.2000000,0.0000000,0.0000000,0.0000000); //object(k_smashboxes) (1)
	Object[106] = CreateObject(2971,-1883.9000200,3163.8000500,26.2000000,0.0000000,0.0000000,0.0000000); //object(k_smashboxes) (2)
	Object[107] = CreateObject(1462,-1859.3000500,3170.1999500,11.1000000,0.0000000,0.0000000,0.0000000); //object(dyn_woodpile) (1)
	Object[108] = CreateObject(1462,-1846.5999800,3222.8999000,11.2000000,0.0000000,0.0000000,0.0000000); //object(dyn_woodpile) (2)
	Object[109] = CreateObject(1450,-1855.8597400,3224.5097700,11.0161000,0.0000000,0.0000000,340.0000000); //object(dyn_crate_3) (1)
	Object[110] = CreateObject(1450,-1855.9000200,3224.3000500,11.8000000,0.0000000,0.0000000,339.9990000); //object(dyn_crate_3) (2)
	Object[111] = CreateObject(1450,-1854.9000200,3207.1999500,11.8000000,0.0000000,0.0000000,339.9990000); //object(dyn_crate_3) (3)
	Object[112] = CreateObject(1449,-1861.0999800,3200.0000000,11.7000000,0.0000000,0.0000000,92.0000000); //object(dyn_crate_2) (1)
	Object[113] = CreateObject(1449,-1881.3000500,3162.8000500,17.6000000,0.0000000,0.0000000,92.0000000); //object(dyn_crate_2) (2)
	Object[114] = CreateObject(1449,-1881.4000200,3162.8999000,18.7000000,0.0000000,0.0000000,92.0000000); //object(dyn_crate_2) (3)
	Object[115] = CreateObject(1449,-1881.5000000,3163.0000000,19.8000000,0.0000000,0.0000000,92.0000000); //object(dyn_crate_2) (4)
	Object[116] = CreateObject(1449,-1881.1999500,3169.1001000,17.6000000,0.0000000,0.0000000,92.0000000); //object(dyn_crate_2) (5)
	Object[117] = CreateObject(1442,-1884.5999800,3164.8999000,16.9000000,0.0000000,0.0000000,0.0000000); //object(dyn_firebin0) (1)
	Object[118] = CreateObject(1442,-1894.9000200,3178.8000500,17.3000000,0.0000000,0.0000000,0.0000000); //object(dyn_firebin0) (2)
	Object[119] = CreateObject(1442,-1867.0999800,3182.3000500,12.3000000,0.0000000,0.0000000,0.0000000); //object(dyn_firebin0) (3)
	Object[120] = CreateObject(1442,-1851.5000000,3210.8000500,11.8000000,0.0000000,0.0000000,0.0000000); //object(dyn_firebin0) (4)
	Object[121] = CreateObject(1442,-1841.6999500,3185.1001000,11.8000000,0.0000000,0.0000000,0.0000000); //object(dyn_firebin0) (5)
	Object[122] = CreateObject(1441,-1830.0999800,3188.8999000,11.8000000,0.0000000,0.0000000,0.0000000); //object(dyn_box_pile_4) (1)
	Object[123] = CreateObject(1441,-1875.8000500,3223.6001000,11.8000000,0.0000000,0.0000000,18.0000000); //object(dyn_box_pile_4) (2)
	Object[124] = CreateObject(1441,-1865.5999800,3201.6001000,11.8000000,0.0000000,0.0000000,179.9960000); //object(dyn_box_pile_4) (3)
	Object[125] = CreateObject(1440,-1869.1999500,3209.5000000,11.7000000,0.0000000,0.0000000,2.0000000); //object(dyn_box_pile_3) (1)
	Object[126] = CreateObject(1440,-1827.0000000,3199.8999000,11.7000000,0.0000000,0.0000000,22.0000000); //object(dyn_box_pile_3) (2)
	Object[127] = CreateObject(1440,-1841.5000000,3162.6001000,10.9000000,0.0000000,0.0000000,81.9950000); //object(dyn_box_pile_3) (3)
	Object[128] = CreateObject(1438,-1846.6999500,3175.0000000,10.7000000,0.0000000,0.0000000,0.0000000); //object(dyn_box_pile_2) (1)
	Object[129] = CreateObject(1438,-1879.9000200,3210.0000000,11.3000000,0.0000000,0.0000000,90.0000000); //object(dyn_box_pile_2) (2)
	Object[130] = CreateObject(1438,-1871.4000200,3184.3000500,11.8000000,0.0000000,0.0000000,112.0000000); //object(dyn_box_pile_2) (3)
	Object[131] = CreateObject(1338,-1828.6999500,3209.3999000,11.9000000,0.0000000,0.0000000,0.0000000); //object(binnt08_la) (1)
	Object[132] = CreateObject(1338,-1844.1999500,3223.5000000,11.9000000,0.0000000,0.0000000,0.0000000); //object(binnt08_la) (2)
	Object[133] = CreateObject(1338,-1873.9000200,3183.8999000,14.7000000,0.0000000,0.0000000,0.0000000); //object(binnt08_la) (3)
	Object[134] = CreateObject(12957,-1849.3000500,3219.8999000,12.0000000,0.0000000,0.0000000,110.0000000); //object(sw_pickupwreck01) (1)
	Object[135] = CreateObject(1327,-1842.0000000,3195.3000500,12.1000000,0.0000000,0.0000000,270.0000000); //object(junk_tyre) (2)
	Object[136] = CreateObject(942,-1884.5999800,3198.6001000,19.0000000,0.0000000,0.0000000,0.0000000); //object(cj_df_unit_2) (1)

    for(new i=0; i<5; i++) AddPlayerClass(random(312),-2431.9709,-1619.5594,526.4762,297.8344,0,0,0,0,0,0);
	//..
	SetWorldTime(6);
	return 1;
}

public OnPlayerRequestClass(playerid,classid)
{
	TogglePlayerControllable(playerid,false);

	SetPlayerInterior(playerid,MAP_INTERIOR);
	SetPlayerPos(playerid,-1856.6136,3167.3013,11.9009);
	SetPlayerFacingAngle(playerid, 343.7741);
	SetPlayerCameraPos(playerid,-1856.6136,3170.3013,11.9009);
	SetPlayerCameraLookAt(playerid,-1856.6136,3167.3013,11.9009);

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
	return Float:spawns[id][coord];
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
	CallRemoteFunction("DM_getWeaponData","iiiiii",WEAPON_1,WEAPON_1_AMMO,WEAPON_2,WEAPON_2_AMMO,WEAPON_3,WEAPON_3_AMMO);
	CallRemoteFunction("DM_getColor","d",DM_COLOR);
	return 1;
}
public map_GetHealth() return Health;
public map_MaxSpawns() return sizeof(spawns);
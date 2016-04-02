//GAMEMODE
#include <a_samp>
#include <crashdetect>
#include <stuff\defines>
#include <ZCMD>

main() {}

new mapid,maptype,mMin,mSec,mTimer;

forward GM_StartTimer();
forward TimerFunc();
forward GM_Restart();

public OnGameModeInit()
{
	mapid = CallRemoteFunction("cycle_getcurrentid",""); //Get's map id from CycleHandler
	maptype = CallRemoteFunction("cycle_getcurrentmode",""); //Get's map type from CycleHandler
	CallRemoteFunction("maphandler_init","i",mapid); //initialize the map handler	
	CallRemoteFunction("Textdraw_SetUp","");
	switch(maptype)
	{
		case MAP_TYPE_BOMBING: SendRconCommand("loadfs /MissionType/bombing");
		case MAP_TYPE_DM: SendRconCommand("loadfs /MissionType/deathmatch");
		case MAP_TYPE_STEALING: SendRconCommand("loadfs /MissionType/stealing");
		case MAP_TYPE_NO_RESPAWN_DM: SendRconCommand("loadfs /MissionType/lms");
		case MAP_TYPE_NO_RESPAWN_TDM: SendRconCommand("loadfs /MissionType/lts");
		case MAP_TYPE_TDM: SendRconCommand("loadfs /MissionType/tdm");
		case MAP_TYPE_PARKOUR: SendRconCommand("loadfs /MissionType/parkour");
		case MAP_TYPE_JUMPERS: SendRconCommand("loadfs /MissionType/jumper");
		default: SendRconCommand("loadfs /MissionType/race");
	}	
	//CallRemoteFunction("cycle_sendmissionname",""); We just don't need it.
}

public GM_StartTimer() //maphandler
{
	mMin = CallRemoteFunction("cycle_getcurrentmaptime","i",0);
	mSec = CallRemoteFunction("cycle_getcurrentmaptime","i",1);
	mTimer = SetTimer("TimerFunc",1000,true);
	return 1;
}

public TimerFunc()
{
	new string[10];
	mSec--;
	if(mSec < 1 && mMin > 0) 
	{ 
		mSec = 59;
		mMin--;
	}
	else if(mSec == 0 && mMin == 0)
	{
		switch(maptype)
		{
			case MAP_TYPE_TDM: CallRemoteFunction("TDM_giveRewards","");
			case MAP_TYPE_PARKOUR: CallRemoteFunction("PARKOUR_giveRewards","");
			default: CallRemoteFunction("RACE_EndMission","");
		}
		KillTimer(mTimer);
		CallRemoteFunction("cycle_nextMission","");
		SetTimer("GM_Restart",3000,false); //3 sec
	}
	if(mMin < 10) format(string,sizeof(string),"0%d",mMin);
	else format(string,sizeof(string),"%d",mMin);
	if(mSec < 10) format(string,sizeof(string),"%s:0%d",string,mSec);
	else format(string,sizeof(string),"%s:%d",string,mSec);
	CallRemoteFunction("textdraw_Clock","s",string);//Clock Textdraw update should be added here.
}

public GM_Restart() 
{ 
	CallRemoteFunction("maphandler_reset","i" ,mapid);
	switch(maptype)
	{
		case MAP_TYPE_BOMBING: SendRconCommand("unloadfs /MissionType/bombing");
		case MAP_TYPE_DM: SendRconCommand("unloadfs /MissionType/deathmatch");
		case MAP_TYPE_STEALING: SendRconCommand("unloadfs /MissionType/stealing");
		case MAP_TYPE_NO_RESPAWN_DM: SendRconCommand("unloadfs /MissionType/lms");
		case MAP_TYPE_NO_RESPAWN_TDM: SendRconCommand("unloadfs /MissionType/lts");
		case MAP_TYPE_TDM: SendRconCommand("unloadfs /MissionType/tdm");
		case MAP_TYPE_PARKOUR: SendRconCommand("unloadfs /MissionType/parkour");
		case MAP_TYPE_JUMPERS: SendRconCommand("unloadfs /MissionType/jumper");
		default: SendRconCommand("unloadfs /MissionType/race");
	}
	return SendRconCommand("gmx"); 
}

CMD:kill(playerid)
{
	SetPlayerHealth(playerid,0);
	return 1;
}
CMD:next(playerid)
{
	mMin=0;
	mSec=3;
	return 1;
}
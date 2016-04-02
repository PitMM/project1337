//Race (FS)
#include <a_samp>
#include <crashdetect>
#include <stuff\defines>

new bool:RaceStarted= false;
new CurrentSpawn=-1;
new RaceVeh;
new RaceGMTimer;
new RaceGMSec;
new TotalRacers;
new CurrentRacePos;
new SafeSpawn;
new MAX_CPs;

new PlayerRaceTimer[MAX_PLAYERS];
new pSec[MAX_PLAYERS];
new pMin[MAX_PLAYERS];
new pMili[MAX_PLAYERS];
new pCurrentCP[MAX_PLAYERS];
new SpawnID[MAX_PLAYERS]=-1;
new bool:pAlive[MAX_PLAYERS];
new Veh[MAX_PLAYERS];
new bool:pRaceFinished[MAX_PLAYERS]= false;

Float: GetSpawn(id,coord) return Float: CallRemoteFunction("map_GetSpawn", "ii",id,coord); 
Float: GetCP(cp_id,coord) return Float: CallRemoteFunction("map_RaceCPs", "ii", cp_id,coord);
native IsValidVehicle(vehicleid);

forward RaceGMClock();
forward PlayerRaceClock(playerid);
forward SafeSpawnFun(playerid);


new COLOR_RACE;

public OnFilterScriptInit() 
{
	RaceVeh=CallRemoteFunction("map_GetRaceVehicle",""); // To get race vehicle.
	RaceGMTimer = SetTimer("RaceGMClock",1000,true);
	SafeSpawn = CallRemoteFunction("map_CommandsInfo","i",0); // to check if mission has safe spawn
	MAX_CPs = CallRemoteFunction("map_GetMaxCPs",""); // to check max checkpoints
	COLOR_RACE = CallRemoteFunction("map_GetRaceColor",""); //to get race color
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(RaceGMTimer);
	for(new i=0; i < 100; i++)
	{
		if(IsValidVehicle(i))
		{
			DestroyVehicle(i);
		}
	}
	return 1;
}

public RaceGMClock()
{
	RaceGMSec++;
	switch(RaceStarted)
	{
		case false:
		{
			switch(RaceGMSec)
			{
				case 1: SendClientMessageToAll(COLOR_RACE,"<!> The race will start in 20 seconds.");
				case 18: GameTextForAll("~r~~h~~h~ON YOUR MARKS!",1000,3);
				case 19: GameTextForAll("~y~GET SET!",1000,3);
				case 20: 
				{
					GameTextForAll("~g~~h~~h~GO!",1000,3);
					RaceStarted= true;
					for(new i=0; i < MAX_PLAYERS; i++) if(pAlive[i]) TogglePlayerControllable(i,true);
					SendClientMessageToAll(COLOR_RACE,"<!> KA BOOM! The race has started. Good luck.");
					KillTimer(RaceGMTimer);
				}
			}
		}
	}	
}

public PlayerRaceClock(playerid)
{
	if(!RaceStarted) return 1;
	pMili[playerid]+=100;
	if(pMili[playerid] == 1000)
	{
		pSec[playerid]++;
		pMili[playerid]=0;
		if(pSec[playerid] == 60)
		{
			pSec[playerid]=0;
			pMin[playerid]++;
		}
		CallRemoteFunction("textdraw_UpdatePlayerRaceTime","iiii",playerid,pMin[playerid],pSec[playerid],pMili[playerid]);
		CallRemoteFunction("textdraw_UpdatePlayerPostion","iii",playerid,GetPlayerPosition(playerid),TotalRacers);
	}
	return 1;
}

GetPlayerPosition(playerid)
{
	new PlayerPositon=CurrentRacePos+1;
	new Float:PlayerDistance=GetPlayerDistanceFromPoint(playerid,GetCP(pCurrentCP[playerid],0),GetCP(pCurrentCP[playerid],1),GetCP(pCurrentCP[playerid],2));
	new Float:OtherPlayerDistance;
	for(new i=0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i) || !pAlive[i] || !RaceStarted) continue;
		if(pCurrentCP[playerid] < pCurrentCP[i])
		{
			PlayerPositon++;
			continue;
		}
		else if(pCurrentCP[playerid] == pCurrentCP[i])
		{
			OtherPlayerDistance=GetPlayerDistanceFromPoint(i,GetCP(pCurrentCP[i],0),GetCP(pCurrentCP[i],1),GetCP(pCurrentCP[i],2));
			if(PlayerDistance > OtherPlayerDistance)
			{
				PlayerPositon++;
				continue;
			}
		}
	}
	SetPlayerScore(playerid,PlayerPositon);
	return PlayerPositon;
}

public OnPlayerSpawn(playerid)
{
	new string[124];
	switch(RaceStarted)
	{
		case false: 
		{	
			TogglePlayerControllable(playerid,false);
			format(string,sizeof(string),"<!> The race will start in %d seconds. Get ready.",(RaceGMSec-20)*-1);
			SendClientMessage(playerid,COLOR_RACE,string);
		}
		case true: 
		{
			TogglePlayerControllable(playerid,true);
			SendClientMessage(playerid,COLOR_RACE,"<!> HURRY UP! The race has already started.");
		}	
	}
	if(SpawnID[playerid] == -1) CurrentSpawn++;
	SpawnID[playerid]=CurrentSpawn;
	pCurrentCP[playerid]=0;
	if(!pAlive[playerid]) TotalRacers++;
	if(SafeSpawn != 1)
	{
		Veh[playerid]=CreateVehicle(RaceVeh,GetSpawn(SpawnID[playerid],0),GetSpawn(SpawnID[playerid],1),GetSpawn(SpawnID[playerid],2),GetSpawn(SpawnID[playerid],3),random(255),random(255),15);
		PutPlayerInVehicle(playerid,Veh[playerid],0);
		if(!pRaceFinished[playerid])
		{
			pMili[playerid]=0,pMin[playerid]=0,pSec[playerid]=0;
			PlayerRaceTimer[playerid] = SetTimerEx("PlayerRaceClock",100,true,"i",playerid);
			SetVehicleVirtualWorld(Veh[playerid], 0);
			SetPlayerVirtualWorld(playerid,0);
			SetPlayerRaceCheckpoint(playerid,CallRemoteFunction("map_GetCPType","ii",pCurrentCP[playerid],3),GetCP(pCurrentCP[playerid],0),GetCP(pCurrentCP[playerid],1),GetCP(pCurrentCP[playerid],2),GetCP(pCurrentCP[playerid]+1,0),GetCP(pCurrentCP[playerid]+1,1),GetCP(pCurrentCP[playerid]+1,2),10.0);
		}
		else
		{
			SetVehicleVirtualWorld(Veh[playerid], 2);
			SetPlayerVirtualWorld(playerid,2);
		}
		pAlive[playerid]= true;
	}
	else
	{
		SetPlayerPos(playerid,GetSpawn(100,0),GetSpawn(100,1),GetSpawn(100,2));
		SetPlayerFacingAngle(playerid,GetSpawn(100,3));
		if(!pRaceFinished[playerid])
		{
			pMili[playerid]=0,pMin[playerid]=0,pSec[playerid]=0;
			PlayerRaceTimer[playerid] = SetTimerEx("PlayerRaceClock",1,true,"i",playerid);
		}
	}
	EnableVehicleFriendlyFire();
	return 1;
}

public SafeSpawnFun(playerid)
{
	Veh[playerid]=CreateVehicle(RaceVeh,GetSpawn(SpawnID[playerid],0),GetSpawn(SpawnID[playerid],1),GetSpawn(SpawnID[playerid],2),GetSpawn(SpawnID[playerid],3),random(255),random(255),15);
	PutPlayerInVehicle(playerid,Veh[playerid],0);
	PlayerRaceTimer[playerid] = SetTimerEx("PlayerRaceClock",1,true,"i",playerid);
	pAlive= true;
	if(!pRaceFinished[playerid])
	{
		SetVehicleVirtualWorld(Veh[playerid], 0);
		SetPlayerVirtualWorld(playerid,0);
		SetPlayerRaceCheckpoint(playerid,CallRemoteFunction("map_GetCPType","ii",pCurrentCP[playerid],3),GetCP(pCurrentCP[playerid],0),GetCP(pCurrentCP[playerid],1),GetCP(pCurrentCP[playerid],2),GetCP(pCurrentCP[playerid]+1,0),GetCP(pCurrentCP[playerid]+1,1),GetCP(pCurrentCP[playerid]+1,2),10.0);
	}
	else
	{
		SetVehicleVirtualWorld(Veh[playerid], 2);
		SetPlayerVirtualWorld(playerid,2);
	}
	return 1;
}

public OnPlayerDisconnect(playerid,reason)
{
	DestroyVehicle(Veh[playerid]);
	KillTimer(PlayerRaceTimer[playerid]);
	if(!pRaceFinished[playerid]) TotalRacers--;
	else pRaceFinished[playerid] = false;
	pAlive[playerid]= false;
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(ispassenger == 0)
	{
		for(new i=0; i<MAX_PLAYERS; i++)
		{
			if(Veh[i] == vehicleid && i != playerid && GetPlayerTeam(playerid) == GetPlayerTeam(i))
			{
				new Float:x,Float:y,Float:z;
				GetPlayerPos(playerid,x,y,z);
				SetPlayerPos(playerid,x,y,z+3);
				break;
			}
		}
	}
    return 1;
}

public OnPlayerDeath(playerid,killerid,reason)
{
	DestroyVehicle(Veh[playerid]);
	KillTimer(PlayerRaceTimer[playerid]);
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	new string[124],type;
	PlayerPlaySound(playerid,1139,0,0,0);
	if(pCurrentCP[playerid] != MAX_CPs-1)
	{
		type=CallRemoteFunction("map_GetCPType","ii",pCurrentCP[playerid]+1,3);
	}	
	if(pCurrentCP[playerid] == MAX_CPs-2)
		SetPlayerRaceCheckpoint(playerid,type,GetCP(pCurrentCP[playerid]+1,0),GetCP(pCurrentCP[playerid]+1,1),GetCP(pCurrentCP[playerid]+1,2),0.0,0.0,0.0,GetCP(pCurrentCP[playerid],4));
	else if(pCurrentCP[playerid] == MAX_CPs-1)
	{
		pRaceFinished[playerid]= true;
		KillTimer(PlayerRaceTimer[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		new Pos=GetPlayerPosition(playerid);
		CurrentRacePos++;
		new Prize=floatround(20000/Pos, floatround_round);
		//CallRemoteFunction("textdraw_UpdatePlayerRaceTime","iiii",playerid,pMin[playerid],pSec[playerid],pMili[playerid]);
		//CallRemoteFunction("account_givemoney","ii",playerid,Prize);
		GetPlayerName(playerid,string,sizeof(string));
		switch(Pos)
		{
			case 1: format(string,sizeof(string),"<!> %s (%d) Has finished 1st in the race. Time Taken: %d:%d:%d | Prize: ($%d).",string,playerid,pMin,pSec,pMili,Prize);
			case 2: format(string,sizeof(string),"<!> %s (%d) Has finished 2nd in the race. Time Taken: %d:%d:%d | Prize: ($%d).",string,playerid,pMin,pSec,pMili,Prize);
			case 3: format(string,sizeof(string),"<!> %s (%d) Has finished 3rd in the race. Time Taken: %d:%d:%d | Prize: ($%d).",string,playerid,pMin,pSec,pMili,Prize);
			default: format(string,sizeof(string),"<!> %s (%d) Has finished %d out of %d. Time Taken: %d:%d:%d | Prize: ($%d).",string,playerid,Pos,TotalRacers,pMin,pSec,pMili,Prize);
		}
		
		SetVehicleVirtualWorld(Veh[playerid], 2);
		SetPlayerVirtualWorld(playerid,2);
		SendClientMessageToAll(COLOR_RACE,string);
	}
	else if(pCurrentCP[playerid] < MAX_CPs) SetPlayerRaceCheckpoint(playerid,type,GetCP(pCurrentCP[playerid]+1,0),GetCP(pCurrentCP[playerid]+1,1),GetCP(pCurrentCP[playerid]+1,2),GetCP(pCurrentCP[playerid]+2,0),GetCP(pCurrentCP[playerid]+2,1),GetCP(pCurrentCP[playerid]+2,2),GetCP(pCurrentCP[playerid],4));
	pCurrentCP[playerid]++;
	return 1;
}
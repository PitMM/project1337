//Race (FS)
#include <a_samp>
#include <stuff\defines>

new bool:RaceStarted= false;
new CurrentSpawn=-1;
new RaceVeh;
new RaceGMTimer;
new RaceGMSec;
new TotalRacers;
new CurrentRacePos;
new SafeSpawn;

new PlayerRaceTimer[MAX_PLAYERS];
new pSec[MAX_PLAYERS];
new pMin[MAX_PLAYERS];
new pMili[MAX_PLAYERS];
new pCurrentCP[MAX_PLAYERS];
new SpawnID[MAX_PLAYERS]=-1;
new bool:pAlive[MAX_PLAYERS];
new Veh[MAX_PLAYERS];
new bool:pRaceFinished[MAX_PLAYERS]= false;

Float: GetSpawn(id,coord) return Float: CallRemoteFunction("GetSpawn", "ii",id,coord); 
Float: GetCP(cp_id,coord) return Float: CallRemoteFunction("RaceCPs", "ii", cp_id,coord);

forward RaceGMClock();
forward PlayerRaceClock(playerid);
forward SafeSpawnFun(playerid);

public OnFilterScriptInit() 
{
	RaceVeh=CallRemoteFunction("map_GetRaceVehicle",""); // To get race vehicle.
	RaceGMTimer = SetTimer("RaceGMClock",1000,true);
	SafeSpawn = CallRemoteFunction("map_CheckSafeSpawn","");
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(RaceGMTimer);
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
				case 1: SendClientMessageToAll(COLOR_RACE,"<!> The race will start in 30 seconds.");
				case 28: GameTextForAll("~r~~h~~h~ON YOUR MARKS!",1000,3);
				case 29: GameTextForAll("~y~GET SET!",1000,3);
				case 30: 
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
	pMili[playerid]++;
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
			format(string,sizeof(string),"<!> The race will start in %d seconds. Get ready.",(RaceGMSec-30)*-1);
			SendClientMessage(playerid,COLOR_RACE,string);
		}
		case true: TogglePlayerControllable(playerid,true);
	}
	if(SpawnID[playerid] == -1) CurrentSpawn++;
	SpawnID[playerid]=CurrentSpawn;
	if(!pAlive[playerid]) TotalRacers++;
	if(SafeSpawn != 1)
	{
		Veh[playerid]=CreateVehicle(RaceVeh,GetSpawn(SpawnID[playerid],0),GetSpawn(SpawnID[playerid],1),GetSpawn(SpawnID[playerid],2),GetSpawn(SpawnID[playerid],3),random(255),random(255),15);
		PutPlayerInVehicle(playerid,Veh[playerid],0);
		PlayerRaceTimer[playerid] = SetTimerEx("PlayerRaceClock",1,true,"i",playerid);
		pAlive[playerid]= true;
	}
	else
	{
		SetPlayerPos(playerid,GetSpawn(100,0),GetSpawn(100,1),GetSpawn(100,2));
		SetPlayerFacingAngle(playerid,GetSpawn(100,3));
		SetTimerEx("SafeSpawnFun",1000,false,"i",playerid);
	}
	return 1;
}

public SafeSpawnFun(playerid)
{
	Veh[playerid]=CreateVehicle(RaceVeh,GetSpawn(SpawnID[playerid],0),GetSpawn(SpawnID[playerid],1),GetSpawn(SpawnID[playerid],2),GetSpawn(SpawnID[playerid],3),random(255),random(255),15);
	PutPlayerInVehicle(playerid,Veh[playerid],0);
	PlayerRaceTimer[playerid] = SetTimerEx("PlayerRaceClock",1,true,"i",playerid);
	pAlive= true;
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

//Race (FS)
#include <a_samp>
#include <stuff\defines>

new bool:RaceStarted= false;
new CurrentSpawn=0;
new SpawnID[MAX_PLAYERS]=-1;
new RaceVeh;
new RaceGMTimer;
new RaceGMSec;
new TotalRacers;
new CurrentRacePos;

new PlayerRaceTimer[MAX_PLAYERS];
new pSec[MAX_PLAYERS];
new pMin[MAX_PLAYERS];
new pMili[MAX_PLAYERS];
new pCurrentCP[MAX_PLAYERS];

new bool:pAlive[MAX_PLAYERS];

forward RaceGMClock();
forward PlayerRaceClock(playerid);

public OnFilterScriptInit() 
{
	RaceVeh=CallRemoteFunction("map_GetRaceVehicle"); // To get race vehicle.
	RaceGMTimer = SetTimer("RaceGMClock",1000,true);
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
				case 1: SendClientMessageToAll(COLOR_RACE,"<!> The race will start in 30 seconds.")
				case 28: GameTextForAll("~r~~h~~h~ON YOUR MARKS!",1000,3);
				case 29: GameTextForAll("~y~GET SET!",1000,3);
				case 30: 
				{
					GameTextForAll("~g~~h~~h~GO!",1000,3);
					RaceStarted= true;
					for(new i=0; i < MAX_PLAYERS; i++) if(pAlive[i]) TogglePlayerControllable(i,true);
					KillTimer(RaceGMTimer);
				}
			}
		}
	}	
}

public PlayerRaceClock(playerid)
{
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
		CallRemoteFunction("textdraw_UpdatePlayerPostion","iii",playerid,GetPlayerPostion(playerid),TotalRacers);
	}
	return 1;
}

GetPlayerPosition(playerid)
{
	new PlayerPositon=ServerInfo[sCurrentRacePos]+1;
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
		else if(pCurrentCP[playerid] == pCurrentCP[i]])
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

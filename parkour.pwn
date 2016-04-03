//Parkour (FS)
#include <a_samp>
#include <crashdetect>
#include <stuff\defines>

new bool:ParkourStarted= false;
new ParkourGMTimer;
new ParkourGMSec;
new TotalParkourPlayers;
new CurrentParkourPos;
new MAX_CPs;
new Float:Z_LIMIT;

new PlayerParkourTimer[MAX_PLAYERS];
new pSec[MAX_PLAYERS];
new pMin[MAX_PLAYERS];
new pMili[MAX_PLAYERS];
new pCurrentCP[MAX_PLAYERS];
new bool:pAlive[MAX_PLAYERS];
new bool:pParkourFinished[MAX_PLAYERS]= false;

Float: GetSpawn(id,coord) return Float: CallRemoteFunction("map_GetSpawn", "ii",id,coord); 
Float: GetCP(cp_id,coord) return Float: CallRemoteFunction("map_ParkourCPs", "ii", cp_id,coord);

forward ParkourGMClock();
forward PlayerParkourClock(playerid);
forward SafeSpawnFun(playerid);
forward PARKOUR_EndMission();

new COLOR_PARKOUR;

public OnFilterScriptInit() 
{
	ParkourGMTimer = SetTimer("ParkourGMClock",1000,true);
	MAX_CPs = CallRemoteFunction("map_GetMaxCPs",""); // to check max checkpoints
	COLOR_PARKOUR = CallRemoteFunction("map_GetParkourColor",""); //to get parkour color
	Z_LIMIT = Float:CallRemoteFunction("map_Z_AxisLimit","");
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(ParkourGMTimer);
	return 1;
}

public ParkourGMClock()
{
	ParkourGMSec++;
	switch(ParkourStarted)
	{
		case false:
		{
			switch(ParkourGMSec)
			{
				case 1: SendClientMessageToAll(COLOR_PARKOUR,"<!> The parkour will start in 20 seconds.");
				case 16: GameTextForAll("~r~~h~GET READY!",1000,3);
				case 17: GameTextForAll("~r~~h~~h~3",1000,3);
				case 18: GameTextForAll("~r~~h~~h~~h~2",1000,3);
				case 19: GameTextForAll("~y~1",1000,3);
				case 20: 
				{
					GameTextForAll("~g~~h~~h~RUN!",1000,3);
					ParkourStarted= true;
					for(new i=0; i < MAX_PLAYERS; i++) if(pAlive[i]) TogglePlayerControllable(i,true);
					SendClientMessageToAll(COLOR_PARKOUR,"<!> DAZZZ! The parkour has started. Good luck.");
					KillTimer(ParkourGMTimer);
				}
			}
		}
	}	
}

public PlayerParkourClock(playerid)
{
	if(!ParkourStarted) return 1;
	pSec[playerid]++;
	if(pMili[playerid] == 0) pMili[playerid]=GetTickCount();
	if(pSec[playerid] == 60)
	{
		pSec[playerid]=0;
		pMin[playerid]++;
	}
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	if(z <= Z_LIMIT)
	{
		SpawnPlayer(playerid);
		pAlive[playerid]= false;
		KillTimer(PlayerParkourTimer[playerid]);
	}
	GetPlayerPosition(playerid);
	//CallRemoteFunction("textdraw_UpdatePlayerMisTime","iiii",playerid,pMin[playerid],pSec[playerid],pMili[playerid]);
	//CallRemoteFunction("textdraw_UpdatePlayerPostion","iii",playerid,GetPlayerPosition(playerid),TotalRacers);
	return 1;
}

GetPlayerPosition(playerid)
{
	new PlayerPositon=CurrentParkourPos+1;
	new Float:PlayerDistance=GetPlayerDistanceFromPoint(playerid,GetCP(pCurrentCP[playerid],0),GetCP(pCurrentCP[playerid],1),GetCP(pCurrentCP[playerid],2));
	new Float:OtherPlayerDistance;
	for(new i=0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i) || !pAlive[i] || !ParkourStarted || !pParkourFinished[i]) continue;
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
	SetPlayerHealth(playerid,10000000);
	switch(ParkourStarted)
	{
		case false: 
		{	
			TogglePlayerControllable(playerid,false);
			format(string,sizeof(string),"<!> The parkour will start in %d seconds. Get ready.",(ParkourGMSec-20)*-1);
			SendClientMessage(playerid,COLOR_PARKOUR,string);
		}
		case true: 
		{
			TogglePlayerControllable(playerid,true);
			SendClientMessage(playerid,COLOR_PARKOUR,"<!> HURRY UP! The parkour has already started.");
		}	
	}
	pCurrentCP[playerid]=0;
	if(!pAlive[playerid]) TotalParkourPlayers++;
	SetPlayerPos(playerid,GetSpawn(0,0),GetSpawn(0,1),GetSpawn(0,2)+5);
	SetPlayerFacingAngle(playerid,GetSpawn(0,3));
	SetCameraBehindPlayer(playerid);	
	if(!pParkourFinished[playerid])
	{
		pMili[playerid]=0,pMin[playerid]=0,pSec[playerid]=0;
		SetPlayerRaceCheckpoint(playerid,CallRemoteFunction("map_GetCPType","ii",pCurrentCP[playerid],3),GetCP(pCurrentCP[playerid],0),GetCP(pCurrentCP[playerid],1),GetCP(pCurrentCP[playerid],2),GetCP(pCurrentCP[playerid]+1,0),GetCP(pCurrentCP[playerid]+1,1),GetCP(pCurrentCP[playerid]+1,2),10.0);
		PlayerParkourTimer[playerid] = SetTimerEx("PlayerParkourClock",1000,true,"i",playerid);
		SetPlayerVirtualWorld(playerid,0);
	}
	else
	{
		SetPlayerVirtualWorld(playerid,2);
	}
	pAlive[playerid]= true;
	return 1;
}

public OnPlayerDisconnect(playerid,reason)
{
	KillTimer(PlayerParkourTimer[playerid]);
	if(!pParkourFinished[playerid]) TotalParkourPlayers--;
	else pParkourFinished[playerid] = false;
	pAlive[playerid]= false;
	return 1;
}

public OnPlayerDeath(playerid,killerid,reason)
{
	KillTimer(PlayerParkourTimer[playerid]);
	pAlive[playerid]= false;
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
		pParkourFinished[playerid]= true;
		KillTimer(PlayerParkourTimer[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		new Pos=GetPlayerPosition(playerid);
		CurrentParkourPos++;
		new Prize=floatround(20000/Pos, floatround_round);
		pMili[playerid]=(((GetTickCount()-pMili[playerid])-(1000*pSec[playerid]))-((1000*60)*pMin[playerid]));
		//CallRemoteFunction("textdraw_UpdatePlayerParkourTime","iiii",playerid,pMin[playerid],pSec[playerid],pMili[playerid]);
		//CallRemoteFunction("account_givemoney","ii",playerid,Prize);
		GetPlayerName(playerid,string,sizeof(string));
		switch(Pos)
		{
			case 1: format(string,sizeof(string),"<!> %s (%d) Has finished 1st in the parkour. Time Taken: %02d:%02d:%03d | Prize: ($%d).",string,playerid,pMin,pSec,pMili,Prize);
			case 2: format(string,sizeof(string),"<!> %s (%d) Has finished 2nd in the parkour. Time Taken: %02d:%02d:%03d | Prize: ($%d).",string,playerid,pMin,pSec,pMili,Prize);
			case 3: format(string,sizeof(string),"<!> %s (%d) Has finished 3rd in the parkour. Time Taken: %02d:%02d:%03d | Prize: ($%d).",string,playerid,pMin,pSec,pMili,Prize);
			default: format(string,sizeof(string),"<!> %s (%d) Has finished %d out of %d. Time Taken: %02d:%02d:%03d | Prize: ($%d).",string,playerid,Pos,TotalParkourPlayers,pMin,pSec,pMili,Prize);
		}
		
		SetPlayerVirtualWorld(playerid,2);
		SendClientMessageToAll(COLOR_PARKOUR,string);
	}
	else if(pCurrentCP[playerid] < MAX_CPs) SetPlayerRaceCheckpoint(playerid,type,GetCP(pCurrentCP[playerid]+1,0),GetCP(pCurrentCP[playerid]+1,1),GetCP(pCurrentCP[playerid]+1,2),GetCP(pCurrentCP[playerid]+2,0),GetCP(pCurrentCP[playerid]+2,1),GetCP(pCurrentCP[playerid]+2,2),GetCP(pCurrentCP[playerid],4));
	pCurrentCP[playerid]++;
	return 1;
}

public PARKOUR_EndMission()
{
	SendClientMessageToAll(COLOR_PARKOUR,"<!> The parkour has ended.");
	for(new i=0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && !pParkourFinished[i])
		{
			GameTextForPlayer(i,"~R~MISSION FAILED~w~!",3000,3);
			DisablePlayerCheckpoint(i);
		}
	}
	return 1;
}
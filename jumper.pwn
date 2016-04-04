//Rooftop (FS)
#include <a_samp>
#include <crashdetect>
#include <stuff\defines>

new bool:RooftopStarted= false;
new RooftopGMTimer;
new RooftopGMSec;
new TotalRooftopPlayers;
new CurrentRooftopPos;
new MAX_CPs;

new pSec[MAX_PLAYERS];
new pMin[MAX_PLAYERS];
new pMili[MAX_PLAYERS];
new pCurrentCP[MAX_PLAYERS];
new bool:pAlive[MAX_PLAYERS];
new bool:pRooftopFinished[MAX_PLAYERS]= false;

Float: GetSpawn(id,coord) return Float: CallRemoteFunction("map_GetSpawn", "ii",id,coord); 
Float: GetCP(cp_id,coord) return Float: CallRemoteFunction("map_RooftopCPs", "ii", cp_id,coord);

forward RooftopGMClock();
forward SafeSpawnFun(playerid);
forward ROOFTOP_EndMission();

new COLOR_ROOFTOP;

public OnFilterScriptInit() 
{
	RooftopGMTimer = SetTimer("RooftopGMClock",1000,true);
	MAX_CPs = CallRemoteFunction("map_GetMaxCPs",""); // to check max checkpoints
	COLOR_ROOFTOP = CallRemoteFunction("map_GetRooftopColor",""); //to get rooftop jumper color
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(RooftopGMTimer);
	return 1;
}

public RooftopGMClock()
{
	RooftopGMSec++;
	switch(RooftopStarted)
	{
		case false:
		{
			switch(RooftopGMSec)
			{
				case 1: SendClientMessageToAll(COLOR_ROOFTOP,"<!> The rooftop jumper will start in 20 seconds.");
				case 17: GameTextForAll("~r~~h~~h~Ready",1000,3);
				case 18: GameTextForAll("~r~~h~~h~~h~Steady",1000,3);
				case 19: GameTextForAll("~y~Apple",1000,3);
				case 20: 
				{
					GameTextForAll("~g~~h~GO!",1000,3);
					RooftopStarted= true;
					for(new i=0; i < MAX_PLAYERS; i++) if(pAlive[i]) TogglePlayerControllable(i,true);
					SendClientMessageToAll(COLOR_ROOFTOP,"<!> AAAAAAHHH! The rooftop jumper has started. Good luck.");
				}
			}
		}
		case true:
		{
			for(new i=0; i<MAX_PLAYERS; i++)
			{
				if(i != INVALID_PLAYER_ID && pAlive[i] && !pRooftopFinished[i])
				{
					pSec[i]++;
					if(pMili[i] == 0) pMili[i]=GetTickCount();
					if(pSec[i] == 60)
					{
						pSec[i]=0;
						pMin[i]++;
					}
					GetPlayerPosition(i);
					//CallRemoteFunction("textdraw_UpdatePlayerMisTime","iiii",playerid,pMin[playerid],pSec[playerid],pMili[playerid]);
					//CallRemoteFunction("textdraw_UpdatePlayerPostion","iii",playerid,GetPlayerPosition(playerid),TotalRooftopPlayers);
				}
			}
		}
	}	
}

GetPlayerPosition(playerid)
{
	new PlayerPositon=CurrentRooftopPos+1;
	new Float:PlayerDistance=GetPlayerDistanceFromPoint(playerid,GetCP(pCurrentCP[playerid],0),GetCP(pCurrentCP[playerid],1),GetCP(pCurrentCP[playerid],2));
	new Float:OtherPlayerDistance;
	for(new i=0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i) || !pAlive[i] || !RooftopStarted || pRooftopFinished[i]) continue;
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
	switch(RooftopStarted)
	{
		case false: 
		{	
			TogglePlayerControllable(playerid,false);
			format(string,sizeof(string),"<!> The rooftop jumper will start in %d seconds. Get ready.",(RooftopGMSec-20)*-1);
			SendClientMessage(playerid,COLOR_ROOFTOP,string);
		}
		case true: 
		{
			TogglePlayerControllable(playerid,true);
			SendClientMessage(playerid,COLOR_ROOFTOP,"<!> HURRY UP! The rooftop jumper has already started.");
		}	
	}
	pCurrentCP[playerid]=0;
	if(!pAlive[playerid]) TotalRooftopPlayers++;
	SetPlayerPos(playerid,GetSpawn(0,0),GetSpawn(0,1),GetSpawn(0,2)+5);
	SetPlayerFacingAngle(playerid,GetSpawn(0,3));
	SetCameraBehindPlayer(playerid);	
	if(!pRooftopFinished[playerid])
	{
		pMili[playerid]=0,pMin[playerid]=0,pSec[playerid]=0;
		SetPlayerRaceCheckpoint(playerid,CallRemoteFunction("map_GetCPType","ii",pCurrentCP[playerid],3),GetCP(pCurrentCP[playerid],0),GetCP(pCurrentCP[playerid],1),GetCP(pCurrentCP[playerid],2),GetCP(pCurrentCP[playerid]+1,0),GetCP(pCurrentCP[playerid]+1,1),GetCP(pCurrentCP[playerid]+1,2),10.0);
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
	if(!pRooftopFinished[playerid]) TotalRooftopPlayers--;
	else pRooftopFinished[playerid] = false;
	pAlive[playerid]= false;
	return 1;
}

public OnPlayerDeath(playerid,killerid,reason)
{
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
		pRooftopFinished[playerid]= true;
		DisablePlayerRaceCheckpoint(playerid);
		new Pos=GetPlayerPosition(playerid);
		CurrentRooftopPos++;
		new Prize=floatround(20000/Pos, floatround_round)+(100*TotalRooftopPlayers);
		pMili[playerid]=(((GetTickCount()-pMili[playerid])-(1000*pSec[playerid]))-((1000*60)*pMin[playerid]));
		//CallRemoteFunction("textdraw_UpdatePlayerRooftopTime","iiii",playerid,pMin[playerid],pSec[playerid],pMili[playerid]);
		//CallRemoteFunction("account_givemoney","ii",playerid,Prize);
		GetPlayerName(playerid,string,sizeof(string));
		switch(Pos)
		{
			case 1: format(string,sizeof(string),"<!> %s (%d) Has finished 1st in the rooftop jumper. Time Taken: %02d:%02d:%03d | Prize: ($%d).",string,playerid,pMin[playerid],pSec[playerid],pMili[playerid],Prize);
			case 2: format(string,sizeof(string),"<!> %s (%d) Has finished 2nd in the rooftop jumper. Time Taken: %02d:%02d:%03d | Prize: ($%d).",string,playerid,pMin[playerid],pSec[playerid],pMili[playerid],Prize);
			case 3: format(string,sizeof(string),"<!> %s (%d) Has finished 3rd in the rooftop jumper. Time Taken: %02d:%02d:%03d | Prize: ($%d).",string,playerid,pMin[playerid],pSec[playerid],pMili[playerid],Prize);
			default: format(string,sizeof(string),"<!> %s (%d) Has finished (%02d/%02d). Time Taken: %02d:%02d:%03d | Prize: ($%d).",string,playerid,Pos,TotalRooftopPlayers,pMin[playerid],pSec[playerid],pMili[playerid],Prize);
		}
		
		SetPlayerVirtualWorld(playerid,2);
		SendClientMessageToAll(COLOR_ROOFTOP,string);
	}
	else if(pCurrentCP[playerid] < MAX_CPs) SetPlayerRaceCheckpoint(playerid,type,GetCP(pCurrentCP[playerid]+1,0),GetCP(pCurrentCP[playerid]+1,1),GetCP(pCurrentCP[playerid]+1,2),GetCP(pCurrentCP[playerid]+2,0),GetCP(pCurrentCP[playerid]+2,1),GetCP(pCurrentCP[playerid]+2,2),GetCP(pCurrentCP[playerid],4));
	pCurrentCP[playerid]++;
	return 1;
}

public ROOFTOP_EndMission()
{
	KillTimer(RooftopGMTimer);
	SendClientMessageToAll(COLOR_ROOFTOP,"<!> The rooftop jumper has ended.");
	for(new i=0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && !pRooftopFinished[i])
		{
			GameTextForPlayer(i,"~R~MISSION FAILED~w~!",3000,3);
			DisablePlayerCheckpoint(i);
		}
	}
	return 1;
}
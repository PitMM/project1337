#include <a_samp>
#include <crashdetect>
#include <float>
#include <stuff\defines>

new Kills[MAX_PLAYERS];
new bool:Counted[MAX_PLAYERS];

new DM_COLOR;
new TopKiller= INVALID_PLAYER_ID;
new TopKills;
new DMers;
new DmGMTimer;
new DmGMSec;
new bool:DmStarted;


enum spawninfo
{
	Float:SpawnX,
	Float:SpawnY,
	Float:SpawnZ,
	Float:SpawnAngle
};

enum weaponinfo
{
	Weapon1,
	Ammo1,
	Weapon2,
	Ammo2,
	Weapon3,
	Ammo3,
};

new WeaponInfo[weaponinfo];
new Spawn[30][spawninfo];

new Health;
new MaxSpawns;

forward DM_giveRewards();
forward DM_getWeaponData(weapon1,weapon1ammo,weapon2,weapon2ammo,weapon3,weapon3ammo);
forward DM_getColor(color);
forward DmGMClock();

public OnFilterScriptInit()
{
	MaxSpawns=CallRemoteFunction("map_MaxSpawns","");
	for(new i=0;i < MaxSpawns;i++)
	{
		Spawn[i][SpawnX] = Float:CallRemoteFunction("map_GetSpawn","ii",i,0);
		Spawn[i][SpawnY] = Float:CallRemoteFunction("map_GetSpawn","ii",i,1);
		Spawn[i][SpawnZ] = Float:CallRemoteFunction("map_GetSpawn","ii",i,2);
		Spawn[i][SpawnAngle] = Float:CallRemoteFunction("map_GetSpawn","ii",i,3);
	}
	CallRemoteFunction("map_Load","");
	Health = CallRemoteFunction("map_GetHealth","");
	DmGMTimer = SetTimer("DmGMClock",1000,true);
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(DmGMTimer);
	return 1;
}

public DmGMClock()
{
	DmGMSec++;
	switch(DmStarted)
	{
		case false:
		{
			switch(DmGMSec)
			{
				case 1: SendClientMessageToAll(DM_COLOR,"<!> The Deathmatch will start in 20 seconds.");
				case 17: GameTextForAll("~r~~h~3",1000,3);
				case 18: GameTextForAll("~r~~h~~h~2",1000,3);
				case 19: GameTextForAll("~y~1",1000,3);
				case 20: 
				{
					GameTextForAll("~r~Fight!",1000,3);
					DmStarted= true;
					for(new i=0; i < MAX_PLAYERS; i++) if(GetPlayerState(i) != 	PLAYER_STATE_WASTED) TogglePlayerControllable(i,true);
					SendClientMessageToAll(DM_COLOR,"<!> The Deathmatch has started. Happy Killing!");
					if(DMers <= 1) CallRemoteFunction("EndMission","");
					KillTimer(DmGMTimer);
				}
			}
		}
	}	
}

public OnPlayerSpawn(playerid)
{
	new string[124];
	new rand=random(MaxSpawns);
	SetPlayerPos(playerid,Spawn[rand][SpawnX],Spawn[rand][SpawnY],Spawn[rand][SpawnZ]);
	SetPlayerFacingAngle(playerid,Spawn[rand][SpawnAngle]);
	SetPlayerTeam(playerid,NO_TEAM);
	SetPlayerColor(playerid,DM_COLOR);
	GivePlayerWeapon(playerid,WeaponInfo[Weapon1],WeaponInfo[Ammo1]);
	GivePlayerWeapon(playerid,WeaponInfo[Weapon2],WeaponInfo[Ammo2]);
	GivePlayerWeapon(playerid,WeaponInfo[Weapon3],WeaponInfo[Ammo3]);
	if(!Counted[playerid])
	{
		Counted[playerid]= true;
		SendClientMessage(playerid,DM_COLOR,"<!> You are Deathmatcher your mission is to kill other players.");
		if(DmStarted)
		{
			SendClientMessage(playerid,DM_COLOR,"<!> You are late, The blood war has already started.");
		}
		else 
		{
			format(string,sizeof(string),"<!> The Deathmatch will start in %d seconds.",(DmGMSec-20)*-1);
			SendClientMessage(playerid,DM_COLOR,string);
		}
		
	}
	if(DmStarted)TogglePlayerControllable(playerid,true);
	else TogglePlayerControllable(playerid,false);
	SetPlayerHealth(playerid,Health);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if(!Counted[playerid])
	{
		DMers++;
		//CallRemoteFunction("textdraw_updateDM","iii",DMers,TopKiller,TopKills);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID)
	{
		Kills[killerid]++;
		new bool:TopKill;
		for(new i=0; i<MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(Kills[killerid] > Kills[i])
				{
					TopKill= true;
				}
				else
				{
					TopKill= false;
					break;
				}
			}
		}
		if(TopKill)
		{
			TopKills=TopKill;
			TopKiller=killerid;
		}
	    //CallRemoteFunction("textdraw_updateDM","iii",DMers,TopKiller,TopKills);
		SetPlayerScore(killerid,Kills[killerid]);
	}
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	if(Counted[playerid])
	{
	    DMers --;
		Counted[playerid]=false;
	}
	return 1;
}

/* -- CROSS SCRIPTING -- */

public DM_getWeaponData(weapon1,weapon1ammo,weapon2,weapon2ammo,weapon3,weapon3ammo)
{
	WeaponInfo[Weapon1] = weapon1;
	WeaponInfo[Ammo1] = weapon1ammo;
	WeaponInfo[Weapon2] = weapon2;
	WeaponInfo[Ammo2] = weapon2ammo;
	WeaponInfo[Weapon3] = weapon3;
	WeaponInfo[Ammo3] = weapon3ammo;
	return 1;
}

public DM_getColor(color)
{
	DM_COLOR = color;
	return 1;
}

public DM_giveRewards()
{
	new string[128];
	new bool:MoreThan1;
	if(!IsPlayerConnected(TopKiller))
	{
		new TopKill;
		for(new i=0; i<MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(Kills[i] > TopKill)
				{
					TopKiller=i;
					TopKills=Kills[i];
					MoreThan1= false;
				}
				else if(Kills[i] == TopKill && Kills[i] != 0)
				{
					MoreThan1= true;
					break;
				}
			}
		}
	}
	
	if(!IsPlayerConnected(TopKiller) || TopKiller == INVALID_PLAYER_ID) return SendClientMessageToAll(DM_COLOR,"<!> The Deathmatch has ended as a draw.");
	
	if(MoreThan1)
	{
		SendClientMessageToAll(DM_COLOR,"<!> The Deathmatch has ended as a draw.");
	}
	else
	{
		new amount= (TopKills*100)+(350*DMers);
		GetPlayerName(TopKiller,string,MAX_PLAYER_NAME);
		format(string,sizeof(string),"<!> %s (%d) has won the Deathmatch, with %d kills. Reward: $%d.",string,TopKiller,TopKills,amount);
		SendClientMessageToAll(DM_COLOR,string);
		for(new i=0;i<MAX_PLAYERS;i++)
		{
			if(i != INVALID_PLAYER_ID && i != TopKiller) GameTextForPlayer(i,"~R~MISSION FAILED~w~!",3000,3);
		}
	}
	
	return 1;
}
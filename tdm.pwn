#include <a_samp>
#include <crashdetect>
#include <float>
#include <stuff\defines>

enum teamdata 
{ 
	Kills,
	Name[32],
	Members,
	ClassID,
	Float:SpawnX,
	Float:SpawnY,
	Float:SpawnZ,
	Float:SpawnAngle,
	Color
};

enum playerdata 
{ 
	bool:TeamChosen, 
	TeamSelection 
};

enum weapondata 
{ 
	WeaponID, 
	Ammo
};

new Team[2][teamdata];
new pInfo[MAX_PLAYERS][playerdata];
new Weapon[3][weapondata];

forward TDM_getTeamNames(team1[32],team2[32]);
forward TDM_getClassIDs(class1,class2);
forward TDM_giveRewards();
forward TDM_getWeaponData(weapon1,weapon1ammo,weapon2,weapon2ammo,weapon3,weapon3ammo);
forward TDM_getColors(color1,color2);

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" TDM Script -- INITIALIZED!");
	print("--------------------------------------\n");
	
	for(new i = 0;i<2;i++)
	{
		Team[i][SpawnX] = Float:CallRemoteFunction("map_GetSpawn","ii",i,0);
		Team[i][SpawnY] = Float:CallRemoteFunction("map_GetSpawn","ii",i,1);
		Team[i][SpawnZ] = Float:CallRemoteFunction("map_GetSpawn","ii",i,2);
		Team[i][SpawnAngle] = Float:CallRemoteFunction("map_GetSpawn","ii",i,3);
	}
	CallRemoteFunction("map_Load","");
	return 1;
}

public OnFilterScriptExit()
{
	print("\n--------------------------------------");
	print(" TDM Script -- UNLOADED!");
	print("--------------------------------------\n");
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerPos(playerid,Team[GetPlayerTeam(playerid)][SpawnX],Team[GetPlayerTeam(playerid)][SpawnY],Team[GetPlayerTeam(playerid)][SpawnZ]);
	SetPlayerFacingAngle(playerid,Team[GetPlayerTeam(playerid)][SpawnAngle]);
	SetPlayerColor(playerid,Team[GetPlayerTeam(playerid)][Color]);

	if(!pInfo[playerid][TeamChosen])
	{
		Team[GetPlayerTeam(playerid)][Members]++;
		pInfo[playerid][TeamChosen] = true;
	}

	for(new i=0;i<3;i++) { GivePlayerWeapon(playerid,Weapon[i][WeaponID],Weapon[i][Ammo]); }

    TogglePlayerControllable(playerid,true);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	new opp_team = (pInfo[playerid][TeamSelection] == 1)? 0:1;
	if(Team[pInfo[playerid][TeamSelection]][Members] > Team[opp_team][Members])
	{
	    SendClientMessage(playerid,COLOR_RED,"[TEAM BALANCER] This Team is full, choose another!");
	    return 0;
	}
	
	return 1;
}

public OnPlayerRequestClass(playerid,classid)
{
	if(pInfo[playerid][TeamChosen])
	{
	    pInfo[playerid][TeamChosen] = false;
	    Team[GetPlayerTeam(playerid)][Members]--;
	}

	if(classid == Team[0][ClassID]) pInfo[playerid][TeamSelection] = 0;
	else pInfo[playerid][TeamSelection] = 1;

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID && GetPlayerTeam(playerid) != NO_TEAM)
	{
	    Team[GetPlayerTeam(killerid)][Kills]++;
	    //CallRemoteFunction("textdraw_updateTDM","sisi",TeamName[0],Kills[0],TeamName[1],Kills[1]);
	}
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	if(GetPlayerTeam(playerid) != NO_TEAM)
	{
	    Team[GetPlayerTeam(playerid)][Members] --;
	}
	return 1;
}

/* -- CROSS SCRIPTING -- */
public TDM_getTeamNames(team1[32],team2[32])
{
	format(Team[0][Name],32,"%s",team1);
	format(Team[1][Name],32,"%s",team2);
	return 1;
}

public TDM_getClassIDs(class1,class2)
{
	Team[0][ClassID] = class1;
	Team[1][ClassID] = class2;
	return 1;
}

public TDM_getWeaponData(weapon1,weapon1ammo,weapon2,weapon2ammo,weapon3,weapon3ammo)
{
	Weapon[0][WeaponID] = weapon1;
	Weapon[0][Ammo] = weapon1ammo;
	Weapon[1][WeaponID] = weapon2;
	Weapon[1][Ammo] = weapon2ammo;
	Weapon[2][WeaponID] = weapon3;
	Weapon[2][Ammo] = weapon3ammo;
	return 1;
}

public TDM_getColors(color1,color2)
{
	Team[0][Color] = color1;
	Team[1][Color] = color2;
	return 1;
}

public TDM_giveRewards()
{
	new str[128];
	new amount =20000;
	new winning_team;
	if(Team[0][Kills] == Team[1][Kills]) { winning_team = 2; } //-1 can't be used here
	else if(Team[0][Kills] > Team[1][Kills]) { winning_team = 0; }
	else { winning_team = 1; }
	if(winning_team != 2)
	{
		format(str,sizeof(str),"<!> Team: %s has won the Team-Deathmatch! Reward: $%d",Team[winning_team][Name],amount);
		SendClientMessageToAll(Team[winning_team][Color],str);
		format(str,sizeof(str),"<!> You have received $%i because your team has won the Team-Deathmatch!",amount);
		for(new i=0;i<MAX_PLAYERS;i++)
		{
			//only people who're spawned in the winning team are getting rewarded
			if(GetPlayerTeam(i) == winning_team && pInfo[i][TeamChosen])
			{
				SendClientMessage(i,Team[winning_team][Color],str);
				//CallRemoteFunction("account_givemoney","ii",i,amount);
			}
		}
	}	
	else
	{
		format(str,sizeof(str),"<!> IT'S A DRAW! No team has won the Team-Deathmatch.",amount);
		SendClientMessageToAll(Team[random(2)][Color],str);
	}
	
	return 1;
}
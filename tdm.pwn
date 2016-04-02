#include <a_samp>
#include <crashdetect>
#include <float>
#include <stuff\defines>

enum teamdata 
{ 
	Kills,
	Name[32],
	Members,
	ClassID1,
	ClassID2,
	ClassID3,
	ClassID4,
	Color
};

enum playerdata 
{ 
	bool:TeamChosen, 
	TeamSelection,
	pClassID
};

enum skindata
{
	Float:SpawnX,
	Float:SpawnY,
	Float:SpawnZ,
	Float:SpawnAngle,
	Weapon1,
	Ammo1,
	Weapon2,
	Ammo2,
	Weapon3,
	Ammo3,
};	

new SkinData[8][skindata];
new Team[2][teamdata];
new pInfo[MAX_PLAYERS][playerdata];

forward TDM_getTeamNames(team1[32],team2[32]);
forward TDM_getClassIDs(class0,class1,class2,class3,class4,class5,class6,class7);
forward TDM_giveRewards();
forward TDM_getWeaponData(classid,weapon1,weapon1ammo,weapon2,weapon2ammo,weapon3,weapon3ammo);
forward TDM_getColors(color1,color2);

public OnFilterScriptInit()
{
	for(new i = 0;i<8;i++)
	{
		SkinData[i][SpawnX] = Float:CallRemoteFunction("map_GetSpawn","ii",i,0);
		SkinData[i][SpawnY] = Float:CallRemoteFunction("map_GetSpawn","ii",i,1);
		SkinData[i][SpawnZ] = Float:CallRemoteFunction("map_GetSpawn","ii",i,2);
		SkinData[i][SpawnAngle] = Float:CallRemoteFunction("map_GetSpawn","ii",i,3);
	}
	CallRemoteFunction("map_Load","");
	return 1;
}

public OnPlayerSpawn(playerid)
{
	new string[124];
	SetPlayerPos(playerid,SkinData[pInfo[playerid][pClassID]][SpawnX],SkinData[pInfo[playerid][pClassID]][SpawnY],SkinData[pInfo[playerid][pClassID]][SpawnZ]);
	SetPlayerFacingAngle(playerid,SkinData[pInfo[playerid][pClassID]][SpawnAngle]);
	SetPlayerTeam(playerid,pInfo[playerid][TeamSelection]);
	SetPlayerColor(playerid,Team[GetPlayerTeam(playerid)][Color]);
	if(!pInfo[playerid][TeamChosen])
	{
		Team[GetPlayerTeam(playerid)][Members]++;
		pInfo[playerid][TeamChosen] = true;
		if(GetPlayerTeam(playerid) == 1) format(string,sizeof(string),"<!> You have chosen team %s, Your mission is to kill %s.",Team[1][Name],Team[0][Name]);
		else format(string,sizeof(string),"<!> You have chosen team %s, Your mission is to kill %s.",Team[0][Name],Team[1][Name]);
		SendClientMessage(playerid,Team[GetPlayerTeam(playerid)][Color],string);
	}
	printf("%d : %d",SkinData[pInfo[playerid][pClassID]][Weapon1],SkinData[pInfo[playerid][pClassID]][Ammo1]);
	GivePlayerWeapon(playerid,SkinData[pInfo[playerid][pClassID]][Weapon1],SkinData[pInfo[playerid][pClassID]][Ammo1]);
	GivePlayerWeapon(playerid,SkinData[pInfo[playerid][pClassID]][Weapon2],SkinData[pInfo[playerid][pClassID]][Ammo2]);
	GivePlayerWeapon(playerid,SkinData[pInfo[playerid][pClassID]][Weapon3],SkinData[pInfo[playerid][pClassID]][Ammo3]);
    TogglePlayerControllable(playerid,true);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	new opp_team = (pInfo[playerid][TeamSelection] == 1)? 0:1;
	if(Team[pInfo[playerid][TeamSelection]][Members] > Team[opp_team][Members])
	{
	    SendClientMessage(playerid,COLOR_RED,"<!> [TEAM BALANCER] This Team is full, choose another!");
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

	if(classid == Team[0][ClassID1] || classid == Team[0][ClassID2] || classid == Team[0][ClassID3] || classid == Team[0][ClassID4]) pInfo[playerid][TeamSelection] = 0;
	else pInfo[playerid][TeamSelection] = 1;
	pInfo[playerid][pClassID]=classid;

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

public TDM_getClassIDs(class0,class1,class2,class3,class4,class5,class6,class7)
{
	Team[0][ClassID1] = class0;
	Team[1][ClassID1] = class1;
	Team[0][ClassID2] = class2;
	Team[1][ClassID2] = class3;
	Team[0][ClassID3] = class4;
	Team[1][ClassID3] = class5;
	Team[0][ClassID4] = class6;
	Team[1][ClassID4] = class7;
	return 1;
}

public TDM_getWeaponData(classid,weapon1,weapon1ammo,weapon2,weapon2ammo,weapon3,weapon3ammo)
{
	printf("%d : %d : %d : %d : %d : %d : %d",classid,weapon1,weapon1ammo,weapon2,weapon2ammo,weapon3,weapon3ammo);
	SkinData[classid][Weapon1] = weapon1;
	SkinData[classid][Ammo1] = weapon1ammo;
	SkinData[classid][Weapon2] = weapon2;
	SkinData[classid][Ammo2] = weapon2ammo;
	SkinData[classid][Weapon3] = weapon3;
	SkinData[classid][Ammo3] = weapon3ammo;
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
			if(GetPlayerTeam(i) != winning_team && pInfo[i][TeamChosen])
			{
				GameTextForPlayer(i,"~R~MISSION FAILED~w~!",3000,3);
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
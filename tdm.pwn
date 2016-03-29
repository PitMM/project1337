#include <a_samp>
#include <stuff\defines>

enum teamdata { Kills,Name[32],Members,ClassID }
enum playerdata { bool:TeamChosen, TeamSelection }

new Team[2][teamdata];
new pInfo[MAX_PLAYERS][playerdata];


forward TDM_getTeamNames(team1[32],team2[32]);
forward TDM_getClassIDs(class1,class2);
forward TDM_giveRewards(amount);


public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" TDM Script -- INITIALIZED!");
	print("--------------------------------------\n");
	
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
	if(!pInfo[playerid][TeamChosen]) { Team[GetPlayerTeam(playerid)][Members]++; pInfo[playerid][TeamChosen] = true; }
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
	Team[0][Name] = team1;
	Team[1][Name] = team2;
	return 1;
}

public TDM_getClassIDs(class1,class2)
{
	Team[0][ClassID] = class1;
	Team[1][ClassID] = class2;
	return 1;
}

public TDM_giveRewards(amount)
{
	new str[128];
	format(str,sizeof(str),"You have received $%i because your team has won the Team-Deathmatch!",amount);
	
	new winning_team;
	if(Team[0][Kills] == Team[1][Kills]) { winning_team = 2; } //-1 can't be used here
	else if(Team[0][Kills] > Team[1][Kills]) { winning_team = 0; }
	else { winning_team = 1; }
	
	for(new i=0;i<MAX_PLAYERS;i++)
	{
	    if(GetPlayerTeam(i) == winning_team)
	    {
	        SendClientMessage(i,COLOR_GREEN,str);
	        CallRemoteFunction("account_givemoney","ii",i,amount);
	    }
	}
	
	return 1;
}

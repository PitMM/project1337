#include <a_samp>
#include <stuff\defines>

new Kills[2];
new TeamName[2][32];

forward TDM_getTeamNames(team1[32],team2[32]);
forward TDM_giveRewards(amount);

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" TDM Script -- INITIALIZED!");
	print("--------------------------------------\n");
	
	Kills[0] = 0, Kills[1] = 0;
	
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
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID)
	{
	    Kills[GetPlayerTeam(killerid)]++;
	    //CallRemoteFunction("textdraw_updateTDM","sisi",TeamName[0],Kills[0],TeamName[1],Kills[1]);
	}
	return 1;
}

/* -- CROSS SCRIPTING -- */
public TDM_getTeamNames(team1[32],team2[32])
{
	TeamName[0] = team1;
	TeamName[1] = team2;
	return 1;
}

public TDM_giveRewards(amount)
{
	new str[128];
	format(str,sizeof(str),"You have received $%i because your team has won the Team-Deathmatch!",amount);
	
	new winning_team;
	if(Kills[0] == Kills[1]) { winning_team = 2; } //-1 can't be used here
	else if(Kills[0] > Kills[1]) { winning_team = 0; }
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

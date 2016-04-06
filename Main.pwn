//main (FS)
#include <a_samp>
#include <stuff/defines>

enum pInfo {
	pUserName[MAX_PLAYER_NAME]
};

new PlayerInfo[MAX_PLAYERS][pInfo];

public OnPlayerConnect(playerid)
{
	GetPlayerName(playerid,PlayerInfo[playerid][pUserName],MAX_PLAYER_NAME);
	return 1;
}

public OnPlayerDeath(playerid,killerid,reason)
{
	SendDeathMessage(killerid,playerid,reason);
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new string[124];
	//if(!PlayerInfo[playerid][pLogin]) return SendClientMessage(playerid,COLOR_RED,"You need to login before using the chatbox.");
	if(GetPlayerColor(playerid) == 0)
		format(string,sizeof(string),""COL_BLUE"%s (%d):"COL_WHITE" %s",PlayerInfo[playerid][pUserName],playerid,text);
	else
		format(string,sizeof(string),"{%06x}%s (%d):"COL_WHITE" %s",GetPlayerColor(playerid) >>> 8,PlayerInfo[playerid][pUserName],playerid,text);
	SendClientMessageToAll(-1,string);
	return 0;
}
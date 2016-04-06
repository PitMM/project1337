#include <a_samp>
#include <crashdetect>
#include <float>
#include <stuff\defines>

new bool:ObjectiveStolen;
enum obj
{
	ObjectiveVeh,
	ObjectiveName[30],
	Float:ObjectiveX,
	Float:ObjectiveY,
	Float:ObjectiveZ,
	Float:ObjectiveA,
	ObjectiveMarker,
	Float:ObjectiveEndX,
	Float:ObjectiveEndY,
	Float:ObjectiveEndZ
};

enum teamdata 
{ 
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
new ObjectiveInfo[obj];

new Health;

forward STEAL_getTeamNames(team1[32],team2[32]);
forward STEAL_getClassIDs(class0,class1,class2,class3,class4,class5,class6,class7);
forward STEAL_giveRewards();
forward STEAL_getWeaponData(classid,weapon1,weapon1ammo,weapon2,weapon2ammo,weapon3,weapon3ammo);
forward STEAL_getColors(color1,color2);
forward STEAL_getObjectiveInfo(vehid,name[],Float:x,Float:y,Float:z,Float:a,Float:ex,Float:ey,Float:ez);

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
	Health = CallRemoteFunction("map_GetHealth","");
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
		if(GetPlayerTeam(playerid) == 1) format(string,sizeof(string),"<!> You have chosen team %s, Your mission is to steal %s from %s.",Team[1][Name],ObjectiveInfo[ObjectiveName],Team[0][Name]);
		else format(string,sizeof(string),"<!> You have chosen team %s, Your mission is to defend %s from %s.",Team[0][Name],ObjectiveInfo[ObjectiveName],Team[1][Name]);
		SendClientMessage(playerid,Team[GetPlayerTeam(playerid)][Color],string);
	}
	if(GetPlayerTeam(playerid) == 0) SetVehicleParamsForPlayer(ObjectiveInfo[ObjectiveVeh],playerid,1,1);
	else SetVehicleParamsForPlayer(ObjectiveInfo[ObjectiveVeh],playerid,1,0);
	GivePlayerWeapon(playerid,SkinData[pInfo[playerid][pClassID]][Weapon1],SkinData[pInfo[playerid][pClassID]][Ammo1]);
	GivePlayerWeapon(playerid,SkinData[pInfo[playerid][pClassID]][Weapon2],SkinData[pInfo[playerid][pClassID]][Ammo2]);
	GivePlayerWeapon(playerid,SkinData[pInfo[playerid][pClassID]][Weapon3],SkinData[pInfo[playerid][pClassID]][Ammo3]);
    TogglePlayerControllable(playerid,true);
	SetPlayerHealth(playerid,Health);
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
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(GetPlayerTeam(playerid) == 1)
	{
		if(vehicleid == ObjectiveInfo[ObjectiveVeh])
		{
			new string[124];
			GetPlayerName(playerid,string,30);
			format(string,sizeof(string),"<!> %s (%d) is stealing the %s's %s.",string,playerid,Team[0][Name],ObjectiveInfo[ObjectiveName]);
			SendClientMessageToAll(Team[0][Color],string);
			SetPlayerRaceCheckpoint(playerid,1,ObjectiveInfo[ObjectiveEndX] ,ObjectiveInfo[ObjectiveEndY],ObjectiveInfo[ObjectiveEndZ],0.0,0.0,0.0,10.0);
		}
	}
	else 
	{
		if(vehicleid == ObjectiveInfo[ObjectiveVeh])
		{
			new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid,x,y,z);
			SetPlayerPos(playerid,x,y,z+3);
		}
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(GetPlayerTeam(playerid) == 1)
	{
		if(vehicleid == ObjectiveInfo[ObjectiveVeh])
		{
			new string[124];
			GetPlayerName(playerid,string,30);
			format(string,sizeof(string),"<!> %s (%d) has left the %s's %s.",string,playerid,Team[0][Name],ObjectiveInfo[ObjectiveName]);
			SendClientMessageToAll(Team[0][Color],string);
			DisablePlayerRaceCheckpoint(playerid);
		}
	}
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(GetPlayerTeam(playerid) == 1)
	{
		if(GetPlayerVehicleID(playerid) == ObjectiveInfo[ObjectiveVeh])
		{
			new string[124];
			GetPlayerName(playerid,string,30);
			format(string,sizeof(string),"<!> %s (%d) has stolen the %s's %s.",string,playerid,Team[0][Name],ObjectiveInfo[ObjectiveName]);
			SendClientMessageToAll(Team[0][Color],string);
			DisablePlayerRaceCheckpoint(playerid);
			DestroyVehicle(ObjectiveInfo[ObjectiveVeh]);
			ObjectiveStolen= true;
			CallRemoteFunction("EndMission","");
		}
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID)
	{
		new score= GetPlayerScore(killerid);
		SetPlayerScore(killerid,score+1);
	}
	if(GetPlayerTeam(playerid) == 1)
	{
		if(GetPlayerVehicleID(playerid) == ObjectiveInfo[ObjectiveVeh])
		{
			new string[124];
			GetPlayerName(playerid,string,30);
			format(string,sizeof(string),"<!> %s (%d) has died and left the %s's %s.",string,playerid,Team[0][Name],ObjectiveInfo[ObjectiveName]);
			SendClientMessageToAll(Team[0][Color],string);
			DisablePlayerRaceCheckpoint(playerid);
		}
	}
	return 1;
}
public OnVehicleSpawn(vehicleid)
{
	if(vehicleid == ObjectiveInfo[ObjectiveVeh])
	{
		new
		iEngine, iLights, iAlarm,
		iDoors, iBonnet, iBoot,
		iObjective;
		GetVehicleParamsEx(ObjectiveInfo[ObjectiveVeh], iEngine, iLights, iAlarm, iDoors, iBonnet, iBoot, iObjective);
		SetVehicleParamsEx(ObjectiveInfo[ObjectiveVeh], iEngine, iLights, iAlarm, iDoors, iBonnet, iBoot, 1);
		for(new i=0; i<MAX_PLAYERS; i++)
		{
			if(i != INVALID_PLAYER_ID)
			{
				if(GetPlayerTeam(i) == 0) SetVehicleParamsForPlayer(ObjectiveInfo[ObjectiveVeh],i,1,1);
				else SetVehicleParamsForPlayer(ObjectiveInfo[ObjectiveVeh],i,1,0);
			}
		}
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
public STEAL_getTeamNames(team1[32],team2[32])
{
	format(Team[0][Name],32,"%s",team1);
	format(Team[1][Name],32,"%s",team2);
	return 1;
}

public STEAL_getClassIDs(class0,class1,class2,class3,class4,class5,class6,class7)
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

public STEAL_getWeaponData(classid,weapon1,weapon1ammo,weapon2,weapon2ammo,weapon3,weapon3ammo)
{
	SkinData[classid][Weapon1] = weapon1;
	SkinData[classid][Ammo1] = weapon1ammo;
	SkinData[classid][Weapon2] = weapon2;
	SkinData[classid][Ammo2] = weapon2ammo;
	SkinData[classid][Weapon3] = weapon3;
	SkinData[classid][Ammo3] = weapon3ammo;
	return 1;
}

public STEAL_getColors(color1,color2)
{
	Team[0][Color] = color1;
	Team[1][Color] = color2;
	return 1;
}

public STEAL_getObjectiveInfo(vehid,name[],Float:x,Float:y,Float:z,Float:a,Float:ex,Float:ey,Float:ez)
{
	format(ObjectiveInfo[ObjectiveName],sizeof(ObjectiveInfo[ObjectiveName]),"%s",name);
	ObjectiveInfo[ObjectiveVeh] = CreateVehicle(vehid,x,y,z,a,random(225),random(225),3);
	//SetVehicleParamsEx(ObjectiveInfo[ObjectiveVeh], 0, 0, 0, 0, 0, 0, 1);
	new
	iEngine, iLights, iAlarm,
	iDoors, iBonnet, iBoot,
	iObjective;
	GetVehicleParamsEx(ObjectiveInfo[ObjectiveVeh], iEngine, iLights, iAlarm, iDoors, iBonnet, iBoot, iObjective);
	SetVehicleParamsEx(ObjectiveInfo[ObjectiveVeh], iEngine, iLights, iAlarm, iDoors, iBonnet, iBoot, 1);
	ObjectiveInfo[ObjectiveEndX] = ex;
	ObjectiveInfo[ObjectiveEndY] = ey;
	ObjectiveInfo[ObjectiveEndZ] = ez;
	return 1;
}

public STEAL_giveRewards()
{
	new str[128];
	new amount =20000;
	if(!ObjectiveStolen)
	{
		format(str,sizeof(str),"<!> Team: %s has won the mission, by sucessfully defending the %s. Reward: $%d",Team[0][Name],ObjectiveInfo[ObjectiveName],amount);
		SendClientMessageToAll(Team[0][Color],str);
		format(str,sizeof(str),"<!> You have received $%i because your team has won the Team-Deathmatch!",amount);
		for(new i=0;i<MAX_PLAYERS;i++)
		{
			if(GetPlayerTeam(i) == 0 && pInfo[i][TeamChosen])
			{
				SendClientMessage(i,Team[0][Color],str);
				//CallRemoteFunction("account_givemoney","ii",i,amount);
			}
			if(GetPlayerTeam(i) != 0 && pInfo[i][TeamChosen])
			{
				GameTextForPlayer(i,"~R~MISSION FAILED~w~!",3000,3);
			}
		}
	}	
	else
	{
		format(str,sizeof(str),"<!> Team: %s has won the mission, by sucessfully stealing the %s. Reward: $%d",Team[1][Name],ObjectiveInfo[ObjectiveName],amount);
		SendClientMessageToAll(Team[1][Color],str);
		format(str,sizeof(str),"<!> You have received $%i because your team has won the Team-Deathmatch!",amount);
		for(new i=0;i<MAX_PLAYERS;i++)
		{
			if(GetPlayerTeam(i) == 1 && pInfo[i][TeamChosen])
			{
				SendClientMessage(i,Team[1][Color],str);
				//CallRemoteFunction("account_givemoney","ii",i,amount);
			}
			if(GetPlayerTeam(i) != 1 && pInfo[i][TeamChosen])
			{
				GameTextForPlayer(i,"~R~MISSION FAILED~w~!",3000,3);
			}
		}
	}
	
	return 1;
}
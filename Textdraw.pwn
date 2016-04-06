//Textdraw (FS)
#include <a_samp>
#include <crashdetect>

new Text:Clock;
new Text:MissionName[2];

forward textdraw_Clock(string[]);
forward Textdraw_SetUp();
forward textdraw_UpdateMissionName(name[],by[]);

public Textdraw_SetUp()
{
	Clock = TextDrawCreate(549.0, 24.0, "00:00");
	TextDrawLetterSize(Clock, 0.55, 2.0);
	TextDrawFont(Clock, 3);
	TextDrawBackgroundColor(Clock, 0x000000AA);
	TextDrawSetOutline(Clock, 2);
	
	MissionName[0] = TextDrawCreate(86.000000, 316.933380, "xxxx");
	TextDrawLetterSize(MissionName[0], 0.175499, 1.114667);
	TextDrawAlignment(MissionName[0], 2);
	TextDrawColor(MissionName[0], -5963521);
	TextDrawSetShadow(MissionName[0], 0);
	TextDrawSetOutline(MissionName[0], 1);
	TextDrawBackgroundColor(MissionName[0], 255);
	TextDrawFont(MissionName[0], 1);
	TextDrawSetProportional(MissionName[0], 1);
	TextDrawSetShadow(MissionName[0], 0);

	MissionName[1] = TextDrawCreate(86.500000, 326.266723, "xxx");
	TextDrawLetterSize(MissionName[1], 0.132499, 1.127111);
	TextDrawAlignment(MissionName[1], 2);
	TextDrawColor(MissionName[1], -65281);
	TextDrawSetShadow(MissionName[1], 0);
	TextDrawSetOutline(MissionName[1], 1);
	TextDrawBackgroundColor(MissionName[1], 255);
	TextDrawFont(MissionName[1], 1);
	TextDrawSetProportional(MissionName[1], 1);
	TextDrawSetShadow(MissionName[1], 0);
	return 1;
}

public textdraw_Clock(string[])
{
	TextDrawSetString(Clock,string);
	return 1;
}
public textdraw_UpdateMissionName(name[],by[])
{
	TextDrawSetString(MissionName[0],name);
	TextDrawSetString(MissionName[1],by);
	printf("%s,%s",name,by);
	return 1;
}

public OnPlayerConnect(playerid)
{
	TextDrawShowForPlayer(playerid,Clock);
	TextDrawShowForPlayer(playerid,MissionName[0]);
	TextDrawShowForPlayer(playerid,MissionName[1]);
	return 1;
}

public OnPlayerDisconnect(playerid,reason)
{
	TextDrawHideForPlayer(playerid,Clock);
	TextDrawHideForPlayer(playerid,MissionName[0]);
	TextDrawHideForPlayer(playerid,MissionName[1]);
	return 1;
}

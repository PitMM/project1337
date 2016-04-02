//Textdraw (FS)
#include <a_samp>
#include <crashdetect>

new Text:Clock;

forward textdraw_Clock(string[]);
forward Textdraw_SetUp();

public Textdraw_SetUp()
{
	Clock = TextDrawCreate(549.0, 24.0, "00:00");
	TextDrawLetterSize(Clock, 0.55, 2.0);
	TextDrawFont(Clock, 3);
	TextDrawBackgroundColor(Clock, 0x000000AA);
	TextDrawSetOutline(Clock, 2);
	return 1;
}

public textdraw_Clock(string[])
{
	TextDrawSetString(Clock,string);
	return 1;
}

public OnPlayerConnect(playerid)
{
	TextDrawShowForPlayer(playerid,Clock);
	return 1;
}

public OnPlayerDisconnect(playerid,reason)
{
	TextDrawHideForPlayer(playerid,Clock);
	return 1;
}

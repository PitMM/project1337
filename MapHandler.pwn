//MAP HANDLER (FS)
#include <a_samp>
#include <stuff\defines>

forward maphandler_reset();
forward maphandler_init(mapid);

public maphandler_init(mapid)
{
	new string[70];
	format(string,sizeof(string),"loadfs %s",MapName[mapid]);
	return SendRconCommand(string);
}

public maphandler_reset()
{
	new string[70];
	format(string,sizeof(string),"unloadfs %s",MapName[CallRemoteFunction("cycle_getcurrentid","")]);
	return SendRconCommand(string);
}
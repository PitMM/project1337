//MAP HANDLER (FS)
#include <a_samp>
#include <stuff\MapName>

forward maphandler_reset();
forward maphandler_init(mapid);

public maphandler_init(mapid)
{
	new string[70];
	format(string,sizeof(string),"loadfs /Maps/%s",MapName[mapid]);
	return SendRconCommand(string);
}

public maphandler_reset()
{
	new string[70];
	format(string,sizeof(string),"unloadfs /Maps/%s",MapName[CallRemoteFunction("cycle_getcurrentid","")]);
	return SendRconCommand(string);
}

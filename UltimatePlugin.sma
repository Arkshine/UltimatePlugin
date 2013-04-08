/*
	Tested:
	
	amx_heal
	amx_hp
	amx_armor
	amx_ap
	amx_unammobp
	amx_unammo
	amx_score
	amx_revive
	amx_noclip
	amx_godmode
	amx_speed
	amx_userorigin
	amx_teleport
	amx_drug
	amx_ip
	amx_transfer
	amx_swapteams
	amx_swap
*/

/*
	AMX Mod X script.

	This plugin is free software; you can redistribute it and/or modify it
	under the terms of the GNU General Public License as published by the
	Free Software Foundation; either version 2 of the License, or (at
	your option) any later version.
	
	This plugin is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
	General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this plugin; if not, write to the Free Software Foundation,
	Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
*/

/*
	UltimatePlugin
	by tonykaram1993
	
	
	We all know the famous amx_super plugin. Most servers use it as a wonderful
	administrative tool to let admins take control over their servers and manage
	it in a better and more efficient way. At first I started by editing that
	plugin to make it use less resources and do things in a better way (AFAIK).
	But later, I ended up rewriting the whole thing from scratch (ofc it is based
	on amx_super so a lot of resemblance can be found). I hope I succeeded in
	my mition. I am not the best coder there is, but I think I have some good
	knowledge in scripting (I hope).
	
	
	Plugins Included:
	PLUGIN_NAME				PLUGIN_AUTHOR
	
	Admin Check				(by OneEyed)
	Admin Restart/Shutdown			(by Hawk552)
	Admin Heal				(by F117Bomb)
	Admin Armor				(by F117Bomb)
	Admin Bury/Unbury			(by v3x)
	Admin Ammo				(by AssKicR)
	Admin Revive				(by anakin_cstrike)
	Admin Disarm				(by mike_cao)
	Admin Noclip				(by watch)
	Admin Godmode				(by watch)
	Admin Blanks				(by EKS)
	Admin NoBuy				(by AssKicR)
	Admin Score				(by Freecode)
	Admin Listen				(by sMaxim)
	Admin Rocket				(by F117Bomb)
	Admin Extend				(by JSauce)
	Admin Speed				(by X-olent)
	Admin Badaim				(by Twistedeuphoria)
	Admin Drug				(by X-Olent)
	Admin Lock				(by Bmann_420)
	Admin Gravity				(by JustinHoMi)
	Admin PersonalGravity			(by GHW_Chronic)
	Admin Auto-Slay				(by fezh)
	Admin Password				(by Sparky911)
	Admin Transfer				(by Deviance)
	Admin Swap				(by Deviance)
	Admin Team Swap				(by Deviance)
	
	Reset Score				(by silentt)
	Command Search				(by GHW_Chronic)
	Advanced Bullet Damage			(by Sn!ff3r)
	Spawn Refund				(by tonykaram1993)
	Auto Restart				(by vato loco [GE-S])
	Aim Practice				(by rompom7)
	Dead Listen				(by sMaxim)
	Standard Admin Color Chat		(by vandercal)
	AFK Bomb Transfer			(by VEN)
	Join/Leave Announcments			(by BigBaller)
	Shown Dead Spectator Fix		(by Vantage)
	C4 Timer				(by Cheap_Suit)
	No More Rcon				(by ??)
	AFK Manager				(by hoboman)
	Player IP				(by tonykaram1993)
	
	REMOVED: Prevent armoury_entity pushing	(by xPaw)
	
	
	Plugin that cannot be added: (due to the 2013 HLDS update)
	Admin Exec		: requires client_cmd( )
	Admin Quit		: requires client_cmd( )
	Loading Songs		: requires client_cmd( )
*/

/*
	Change Log:
	
	v0.0.1	beta:	plugin written
*/


/* Inlcludes */
#include < amxmodx >
#include < amxmisc >
#include < cstrike >
#include < engine >
#include < fakemeta >
#include < hamsandwich >
#include < fun >

#pragma semicolon 1	

/* Defines */
#define SetBit(%1,%2)		(%1 |= (1<<(%2&31)))
#define ClearBit(%1,%2)		(%1 &= ~(1 <<(%2&31)))
#define CheckBit(%1,%2)		(%1 & (1<<(%2&31)))

/*
	Below is the section where normal people can safely edit
	its values.
	Please if you don't know how to code, refrain from editing
	anything outside the safety zone.
	
	Experienced coders are free to edit what they want, but I
	will not reply to any private messages nor emails about hel-
	ping you with it.
	
	SAFETY ZONE STARTS HERE
*/

/*
	Set this to your maximum number of players your server can
	hold.
*/
#define MAX_PLAYERS		32

/*
	This is the prefix that is displayed before every chat me-
	ssage print by the server to the players. You can put this
	whatever you want, but it is not recommended to put a large
	text, because it will lead to cutting some messages.
*/
#define PLUGIN_PREFIX		"[UP]"

/*
	If you wish not to have green message on your server, you
	should comment line 133. Else keep it as it is.
	
	Commenting a line is when you add '//' at the beginning of
	the line.
	
	NOTE: if GREEN_CHAT is defined, then the plugin must be 
	above the admin_chat.amxx plugin in the plugins.ini file.
	Else the std admin color chat, will not function.
*/
#define GREEN_CHAT		1

/*
	ADMIN_LISTEN is the access the admin must have in order to
	see all the players' messages. For the full list of admin
	rights, please check the following file:
	c:\...\scripting\includes\amxconst.txt.
*/
#define ADMIN_LISTEN		ADMIN_BAN

/*
	Below are the limits that admins can use to set the health/armor 
	of a player. The reason that this exists is to prevent admin
	from giving players 200,000 health/armor and risk crash the 
	server.
*/
#define MIN_HEALTH		1  
#define MAX_HEALTH		20000
#define MIN_ARMOR		0
#define MAX_ARMOR		1000

/*
	Below are the default values of each the health and armor
	whitch are used when the admin who revives a player does
	not specify an exact ammount of health and/or armor.
	
	Note: MIN_/MAX_ HEALTH/ARMOR values still apply.
*/
#define SPAWN_DEF_HEALTH	100
#define SPAWN_DEF_ARMOR		0

/*
	Below is to specify whether the revive function include
	already alive players or skips them. If you want that alive
	players gets counted, then leave it as it is, else comment
	line 173.
	
	Commenting a line is when you add '//' at the beginning of
	the line.
*/
#define REVIVE_ALIVE		1

/*
	Below are the default, minimun and maximum values that the
	restart/shutdown timer take. Default timer is when the admin
	who wants to restart/shutdown the server does not specify it.
	
	Note: 0 means instant restart/shutdown
*/
#define DEF_TIMER		0
#define MIN_TIMER		0
#define MAX_TIMER		60

/*
	Below is the delay that it takes to auto slay a player after 
	he has spawned.
	
	Note: this value must be a float (float means that its a deci-
	mel number even if the first number after the '.' is a 0)
	ex: 2.5, 0.1, 5.0 (5.0 and not 5).
*/
#define DELAY_AUTOSLAY		Float:2.5

/*
	After a player is revived by an admin, he normally doesn't
	get any weapons, but I am giving them their default spawn
	weapons (CT:USP | T:GLOCK18). And here you can specify how
	much back pack ammo they get with the weapon.
*/
#define BPAMMO_USP		24
#define BPAMMO_GLOCK18		40

/*
	Here you can specify how much damage a player gets per 2
	seconds when he is set on fire by an admin.
	
	Note: even if the damage is set to a negative number, it 
	will automatically take the absolute value if it
	ex: setting it to -10 is like setting it to 10
*/
#define FIRE_DAMAGE		10

/*
	In here you can define what are the limits that an admin 
	can extend the map by step. So that the admin cannot ext-
	end more than 15 minutes at one time for example.
*/
#define MIN_EXTEND		1
#define MAX_EXTEND		15

/*
    Here you can specify what access the admin has to have in
    order to see the IP and STEAM ID of the joining/leaving 
    player, else do not display IP nor STEAM ID.
*/
#define ADMIN_DISCONNECT	ADMIN_BAN
#define ADMIN_AUTHORIZED	ADMIN_BAN

/*
	AFK specific settings are below here.
	+ Frequency: each what number of seconds, the plugin checks 
	for afk players
	+ Immunity: what flag the admin must to be immune
	+ Warning: when he has that many seconds left, he is warned
*/
#define AFK_FREQUENCY		1
#define AFK_IMMUNITY		ADMIN_IMMUNITY
#define AFK_WARNING		10

/*
	The following will specify whether or not to print the port
	with the IP when the admin is using the amx_ip command.
*/
#define IP_PORT			0

/*
	In the following, you can specify the model that the players
	would get if they have been transfered by an admin.
*/
#define CS_T_MODEL		CS_T_LEET
#define CS_CT_MODEL		CS_CT_URBAN

/*
	This is where you stop. Editing anything below this point
	might lead to some serious errors, and you will not get any
	support if you do.
	
	SAFETY ZONE ENDS HERE
*/

/* Enumerations */
enum ( ) {
	CVAR_RESETSCORE,
	CVAR_RESETSCORE_DISPLAY,
	CVAR_ADMINCHECK,
	CVAR_ABD,
	CVAR_ABD_WALL,
	CVAR_REFUND,
	CVAR_AUTORR,
	CVAR_ADMINLISTEN,
	CVAR_ADMINLISTEN_TEAM,
	CVAR_DEADLISTEN,
	CVAR_DEADLISTEN_TEAM,
	CVAR_AFK_BOMBTRANSFER,
	CVAR_C4_TIMER,
	CVAR_AFK,
	CVAR_AFK_TIME,
	CVAR_AFK_PUNISHMENT
};

enum ( += 100 ) {
	TASK_COUNTDOWN_RESTART 	= 100,
	TASK_COUNTDOWN_SHUTDOWN,
	TASK_COUNTDOWN_RESTARTROUND,
	TASK_REVIVE,
	TASK_UBERSLAP,
	TASK_AUTOSLAY,
	TASK_AFK_BOMBCHECK,
	TASK_UPDATETIMER,
	TASK_ROCKETLIFTOFF,
	TASK_ROCKETEFFECTS,
	TASK_BADAIM,
	TASK_AFK_CHECK
};

enum _:SPRITE_MAX( ) {
	SPRITE_MUZZLEFALSH 	= 0,
	SPRITE_SMOKE,
	SPRITE_BLUEFLARE,
	SPRITE_WHITE,
	SPRITE_LIGHTNING
};

enum _:SOUND_MAX( ) {
	SOUND_FLAMEBURST 	= 0,
	SOUND_SCREAM21,
	SOUND_SCREAM7,
	SOUND_ROCKETFIRE,
	SOUND_ROCKET,
	SOUND_THUNDERCLAP,
	SOUND_HEADSHOT
};

enum _:TEAMS_MAX( ) {
	TERRORIST 		= 0,
	COUNTER 		= 1,
	AUTO 			= 4,
	SPECTATOR 		= 5
};

enum ( ) {
	GREY 			= 0,
	RED,
	BLUE,
	NORMAL
};

enum ( ) {
	SLAY_LIGHTINING 	= 0,
	SLAY_BLOOD,
	SLAY_EXPLODE
};

enum ( ) {
	T 			= 0,
	CT			= 1,
	AUTO			= 4,
	SPEC			= 5
};

/* Constantes */
new const g_strPluginName[ ]		= "UltimatePlugin";
new const g_strPluginVersion[ ]		= "0.0.1b";
new const g_strPluginAuthor[ ]		= "n0br41ner";
new const g_strPluginPrefix[ ]		= PLUGIN_PREFIX;

#if defined GREEN_CHAT
new const g_strTeamName[ ][ ] = {
	"",
	"TERRORIST",
	"CT",
	"SPECTATOR"
};
#endif

new const g_strLockerTeamNames[ ][ ] = {
	"Terrorists",
	"Counter-Terrorists",
	"",
	"",
	"Auto",
	"Spectator"
};

new const g_strSprites[ SPRITE_MAX ][ ] = {
	"sprites/muzzleflash.spr",
	"sprites/steam1.spr",
	"sprites/blueflare2.spr",
	"sprites/white.spr",
	"sprites/lgtning.spr"
};

new const g_strSounds[ SOUND_MAX ][ ] = {
	"ambience/flameburst1.wav",
	"scientist/scream21.wav",
	"scientist/scream07.wav",
	"weapons/rocketfire1.wav",
	"weapons/rocket1.wav",
	"ambience/thunder_clap.wav",
	"weapons/headshot2.wav"
};

new const g_strWeapons[ 31 ][ ] = {
	"",			// 0
	"weapon_p228",		// 1
	"weapon_shield",	// 2
	"weapon_scout",		// 3
	"weapon_hegrenade",	// 4
	"weapon_xm1014",	// 5
	"weapon_c4",		// 6
	"weapon_mac10",		// 7
	"weapon_aug",		// 8
	"weapon_smokegrenade",	// 9
	"weapon_elite",		// 10
	"weapon_fiveseven",	// 11
	"weapon_ump45",		// 12
	"weapon_sg550",		// 13
	"weapon_galil",		// 14
	"weapon_famas",		// 15
	"weapon_usp",		// 16
	"weapon_glock18",	// 17
	"weapon_awp",		// 18
	"weapon_mp5navy",	// 19
	"weapon_m249",		// 20
	"weapon_m3",		// 21
	"weapon_m4a1",		// 22
	"weapon_tmp",		// 23
	"weapon_g3sg1",		// 24
	"weapon_flashbang",	// 25
	"weapon_deagle",	// 26
	"weapon_sg552",		// 27
	"weapon_ak47",		// 28
	"weapon_knife",		// 29
	"weapon_p90"		// 30
};

new const g_iWeaponClip[ 31 ] = {
	0, 13, 0, 10, 0, 7, 0, 30, 30, 0, 30, 20, 25, 30, 35, 25, 
	12, 20, 10, 30, 100, 8, 30, 30, 20, 0, 7, 30, 30, 0, 50
};

new const g_iWeaponBackpack[ 31 ] = {
	0, 52, 0, 90, 1, 32, 1, 100, 90, 1, 120, 100, 100, 90, 90, 90, 
	100, 120, 30, 120, 200, 32, 90, 120, 90, 2, 35, 90, 90, 0, 100
};

new const g_iWeaponLayout[ 31 ] = {
	0, 14, 88, 45, 84, 22, 4, 34, 44, 85, 15, 16, 35, 47, 49, 40, 
	11, 12, 46, 31, 51, 21, 43, 32, 47, 83, 13, 41, 42, 1, 33
};

/* Variables */
new g_iPlayerOrigin[ MAX_PLAYERS + 1 ][ 3 ];
new g_iPlayerTime[ MAX_PLAYERS + 1 ];
new g_iRocket[ MAX_PLAYERS + 1 ];
new g_iSprites[ SPRITE_MAX ];
new g_iSavedOrigin[ 3 ];
new g_iTimeLeft;
new g_iSpawnHealth;
new g_iSpawnArmor;
new g_iSpawnMoney;
new g_iAFKTime;
new g_iAFKTime_Bomb;
new g_iAFKPunishment;
new g_iBombCarrier;
new g_iC4Timer;
new g_iTotalExtendTime;

/* Booleans */
new bool:g_bBlockTeamJoin[ TEAMS_MAX ];
new bool:g_bRestartedRound;
new bool:g_bFreezeTime;
new bool:g_bSpawn;
new bool:g_bPlanting;

/* Bitsums */
new g_bitIsConnected;
new g_bitIsAlive;
new g_bitIsOnFire;
new g_bitHasUnAmmo;
new g_bitHasUnBPAmmo;
new g_bitHasGodmode;
new g_bitHasNoClip;
new g_bitHasNoBuy;
new g_bitHasAutoSlay;
new g_bitHasBadaim;
new g_bitHasSpeed;
new g_bitCvarStatus;

/* Pcvars */
new g_pcvarResetScore;
new g_pcvarResetScoreDisplay;
new g_pcvarAdminCheck;
new g_pcvarBulletDamage;
new g_pcvarBulletDamageWall;
new g_pcvarRefund;
new g_pcvarRefundValue;
new g_pcvarAutoRestart;
new g_pcvarAutoRestartTime;
new g_pcvarAdminListen;
new g_pcvarAdminListenTeam;
new g_pcvarDeadListen;
new g_pcvarDeadListenTeam;
new g_pcvarAFKBombTransfer;
new g_pcvarAFKBombTransfer_Time;
new g_pcvarC4Timer;
new g_pcvarMaxExtendTime;
new g_pcvarAFKTime;
new g_pcvarAFKPunishment;
new g_pcvarAFK;

/* Cvar Pointers */
new g_cvarShowActivity;
new g_cvarC4Timer;
new g_cvarTimeLimit;
new g_cvarGravity;
new g_cvarPassword;

/* Hud Sync */
new g_hudSync1;
new g_hudSync2;
new g_hudSync3;
new g_hudSync4;

/* Message IDs */
new g_msgScoreInfo;
new g_msgDamage;
new g_msgShowTimer;
new g_msgRoundTime;
new g_msgScenario;
new g_msgSetFOV;
new g_msgTeamInfo;
new g_msgSayText;

/* Plugin Natives */
public plugin_init( ) {
	/* Plugin Registration */
	register_plugin( g_strPluginName, g_strPluginVersion, g_strPluginAuthor );
	register_cvar( g_strPluginName, g_strPluginVersion, FCVAR_SPONLY );
	
	/* Pcvars */ 
	g_pcvarResetScore		= register_cvar( "up_resetscore",		"1" );
	g_pcvarResetScoreDisplay	= register_cvar( "up_resetscore_display",	"1" );
	g_pcvarAdminCheck		= register_cvar( "up_admincheck",		"1" );
	g_pcvarBulletDamage		= register_cvar( "up_abd",			"1" );
	g_pcvarBulletDamageWall		= register_cvar( "up_abd_walls",		"1" );
	g_pcvarRefund			= register_cvar( "up_money",			"1" );
	g_pcvarRefundValue		= register_cvar( "up_money_ammount",		"16000" );
	g_pcvarAutoRestart		= register_cvar( "up_autorr",			"0" );
	g_pcvarAutoRestartTime		= register_cvar( "up_autorr_delay",		"45" );
	g_pcvarAdminListen		= register_cvar( "up_adminlisten",		"1" );
	g_pcvarAdminListenTeam		= register_cvar( "up_adminlisten_team",		"1" );
	g_pcvarDeadListen		= register_cvar( "up_deadlisten",		"1" );
	g_pcvarDeadListenTeam		= register_cvar( "up_deadlisten_team",		"0" );
	g_pcvarAFK			= register_cvar( "up_afk",			"1" );
	g_pcvarAFKTime			= register_cvar( "up_afk_time",			"60" );
	g_pcvarAFKPunishment		= register_cvar( "up_afk_punishment",		"1" );
	g_pcvarAFKBombTransfer		= register_cvar( "up_afk_bombtransfer",		"1" );
	g_pcvarAFKBombTransfer_Time	= register_cvar( "up_afk_bombtransfer_time",	"7" );
	g_pcvarC4Timer			= register_cvar( "up_c4timer",			"1" );
	g_pcvarMaxExtendTime		= register_cvar( "up_extend_max",		"15" );
	
	/* Cvar Pointers */
	g_cvarShowActivity		= get_cvar_pointer( "amx_show_activity" );
	g_cvarC4Timer			= get_cvar_pointer( "mp_c4timer" );
	g_cvarTimeLimit			= get_cvar_pointer( "mp_timelimit" );
	g_cvarGravity			= get_cvar_pointer( "sv_gravity" );
	g_cvarPassword			= get_cvar_pointer( "sv_password" );
	
	/* Hud Sync */
	g_hudSync1			= CreateHudSyncObj( );
	g_hudSync2			= CreateHudSyncObj( );
	g_hudSync3			= CreateHudSyncObj( );
	g_hudSync4			= CreateHudSyncObj( );
	
	/* Message IDs */
	g_msgScoreInfo			= get_user_msgid( "ScoreInfo" );
	g_msgDamage			= get_user_msgid( "Damage" );
	g_msgShowTimer			= get_user_msgid( "ShowTimer" );
	g_msgRoundTime			= get_user_msgid( "RoundTime" );
	g_msgScenario			= get_user_msgid( "Scenario" );
	g_msgSetFOV			= get_user_msgid( "SetFOV" );
	g_msgTeamInfo			= get_user_msgid( "TeamInfo" );
	g_msgSayText			= get_user_msgid( "SayText" );
	
	
	/* Client Commands */ 
	#if defined GREEN_CHAT
	register_clcmd( "say",			"ClCmd_SayHandler" );
	register_clcmd( "say_team",		"ClCmd_SayTeamHandler" );
	#endif
	
	register_clcmd( "say /rs",		"ClCmd_ResetScore" );
	register_clcmd( "say /resetscore",	"ClCmd_ResetScore" );
	register_clcmd( "say /admin",		"ClCmd_AdminCheck" );
	register_clcmd( "say /admins",		"ClCmd_AdminCheck" );
	
	register_clcmd( "say_team /rs",		"ClCmd_ResetScore" );
	register_clcmd( "say_team /resetscore",	"ClCmd_ResetScore" );
	register_clcmd( "say_team /admin",	"ClCmd_AdminCheck" );
	register_clcmd( "say_team /admins",	"ClCmd_AdminCheck" );
	
	register_clcmd( "jointeam",		"ClCmd_JoinTeam" );
	
	register_clcmd( "say /test",	"nowfunction" );
	
	/* Console Commands */ 
	/* ADMIN_LEVEL_A (fun) */
	register_concmd( "amx_heal",		"ConCmd_Health",		ADMIN_LEVEL_A,		"<nick | #userid | authid | @> <#hp>" );
	register_concmd( "amx_hp",		"ConCmd_Health",		ADMIN_LEVEL_A,		"<nick | #userid | authid | @> <#hp>" );
	register_concmd( "amx_armor",		"ConCmd_Armor",			ADMIN_LEVEL_A,		"<nick | #userid | authid | @> <#ap" );
	register_concmd( "amx_ap",		"ConCmd_Armor",			ADMIN_LEVEL_A,		"<nick | #userid | authid | @> <#ap" );
	register_concmd( "amx_unammo",		"ConCmd_Ammo",			ADMIN_LEVEL_A,		"<nick | #userid | authid | @> [0 | 1] - 0:Off | 1:On" );
	register_concmd( "amx_unammobp",	"ConCmd_Ammo",			ADMIN_LEVEL_A,		"<nick | #userid | authid | @> [0 | 1] - 0:Off | 1:On" );
	register_concmd( "amx_score",		"ConCmd_Score",			ADMIN_LEVEL_A,		"<nick | #userid | authid | @> <#frags> <#deaths>" );
	register_concmd( "amx_revive",		"ConCmd_Revive",		ADMIN_LEVEL_A,		"<nick | #userid | authid | @>" );
	register_concmd( "amx_noclip",		"ConCmd_NoclipGodmode",		ADMIN_LEVEL_A,		"<nick | #userid | authid | @> [0 | 1 | 2] - 0:Off | 1:On | 2:On + Every Round" );
	register_concmd( "amx_godmode",		"ConCmd_NoclipGodmode",		ADMIN_LEVEL_A,		"<nick | #userid | authid | @> [0 | 1 | 2] - 0:Off | 1:On | 2:On + Every Round" );
	register_concmd( "amx_teleport",	"ConCmd_Teleport",		ADMIN_LEVEL_A,		"<nick | #userid | authid | @> [x] [y] [z]" );
	register_concmd( "amx_useroirigin",	"ConCmd_UserOrigin",		ADMIN_LEVEL_A,		"<nick | #userid | authid | @>" );
	register_concmd( "amx_speed",		"ConCmd_Speed",			ADMIN_LEVEL_A,		"<nick | #userid | authid | @> [0 | 1] - 0:Off | 1:On" );
	register_concmd( "amx_drug",		"ConCmd_Drug",			ADMIN_LEVEL_A,		"<nick | #userid | authid | @>" );
	register_concmd( "amx_weapon",		"ConCmd_Weapon",		ADMIN_LEVEL_A,		"<nick | #userid | authid | @> <weaponname | weaponid> [ammo]" );
	/* ADMIN_LEVEL_B (punishements) */
	register_concmd( "amx_blanks",		"ConCmd_BlanksNobuy",		ADMIN_LEVEL_B,		"<nick | #userid | authid | @> [0 | 1] - 0:Off | 1:On" );
	register_concmd( "amx_nobuy",		"ConCmd_BlanksNobuy",		ADMIN_LEVEL_B,		"<nick | #userid | authid | @> [0 | 1] - 0:Off | 1:On" );
	register_concmd( "amx_bury",		"ConCmd_Un_Bury",		ADMIN_LEVEL_B,		"<nick | #userid | authid | @>" );
	register_concmd( "amx_unbury",		"ConCmd_Un_Bury",		ADMIN_LEVEL_B,		"<nick | #userid | authid | @>" );
	register_concmd( "amx_disarm",		"ConCmd_Disarm",		ADMIN_LEVEL_B,		"<nick | #userid | authid | @>" );
	register_concmd( "amx_uberslap",	"ConCmd_UberslapFire",		ADMIN_LEVEL_B,		"<nick | #userid | authid | @>" );
	register_concmd( "amx_fire",		"ConCmd_UberslapFire",		ADMIN_LEVEL_B,		"<nick | #userid | authid | @>" );
	register_concmd( "amx_autoslay",	"ConCmd_AutoSlay",		ADMIN_LEVEL_B,		"<nick | #userid | authid | @> [0 | 1] - 0:Off | 1:On" );
	register_concmd( "amx_rocket",		"ConCmd_Rocket",		ADMIN_LEVEL_B,		"<nick | #userid | authid | @>" );
	register_concmd( "amx_badaim",		"ConCmd_BadAim",		ADMIN_LEVEL_B,		"<nick | #userid | authid | @> [0 | 1 | #seconds]" );
	register_concmd( "amx_slay2",		"ConCmd_Slay2",			ADMIN_LEVEL_B,		"<nick | #userid | authid | @> [0 | 1 | 2] - 0:Lightning | 1:Blood | 2:Explode" );
	/* ADMIN_LEVEL_C (others) */
	register_concmd( "amx_pgravity",	"ConCmd_PGravity",		ADMIN_LEVEL_C,		"<nick | #userid | authid | @> [#gravity]" );
	register_concmd( "amx_pass",		"ConCmd_Pass",			ADMIN_LEVEL_C,		"<password>" );
	register_concmd( "amx_nopass",		"ConCmd_NoPass",		ADMIN_LEVEL_C,		" - Removes the password" );
	register_concmd( "amx_ip",		"ConCmd_IP",			ADMIN_LEVEL_C,		"[nick | #userid | authid | @>" );
	register_concmd( "amx_transfer",	"ConCmd_Transfer",		ADMIN_LEVEL_C,		"<nick | #userid | authid | @> [t | ct | spec]" );
	register_concmd( "amx_swap",		"ConCmd_Swap",			ADMIN_LEVEL_C,		"<nick | #userid | authid> <nick | #userid | authid>" );
	register_concmd( "amx_swapteams",	"ConCmd_SwapTeams",		ADMIN_LEVEL_C,		"- Swaps the two teams together." );
	/* ADMIN_LEVEL_D (affects everybody) */
	register_concmd( "amx_hsonly",		"ConCmd_HSOnly",		ADMIN_LEVEL_D,		"[0 | 1] - 0:Off | 1:On" );
	register_concmd( "amx_extend",		"ConCmd_Extend",		ADMIN_LEVEL_D,		"<#minutes>" );
	register_concmd( "amx_lock",		"ConCmd_Un_Lock",		ADMIN_LEVEL_D,		"<CT | T | AUTO | SPEC>" );
	register_concmd( "amx_unlock",		"ConCmd_Un_Lock",		ADMIN_LEVEL_D,		"<CT | T | AUTO | SPEC>" );
	register_concmd( "amx_gravity",		"ConCmd_Gravity",		ADMIN_LEVEL_D,		"[#gravity]" );
	
	/* Server Rcon Commands */
	register_concmd( "sv_restart",		"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<#seconds>" );
	register_concmd( "sv_restartround",	"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<#seconds>" ); 
	register_concmd( "sv_alltalk",		"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<0 | 1> - 0:Off | 1:On" );
	register_concmd( "sv_gravity",		"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<#gravity>" );
	register_concmd( "mp_timelimit",	"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<#minutes>" );
	register_concmd( "mp_roundtime",	"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<#minutes>" );
	register_concmd( "mp_buytime",		"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<#minutes>" );
	register_concmd( "mp_freezetime",	"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<#seconds>" );
	register_concmd( "mp_c4timer",		"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<#seconds>" );
	register_concmd( "mp_maxrounds",	"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<#rounds>" );
	register_concmd( "mp_forcecamera",	"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<0 | 1 | 2> - 0:Off | 1:All Players | 2:Team-mates only" );
	register_concmd( "mp_forcechasecam",	"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<0 | 1 | 2> - 0:Off | 1:All Players | 2:Team-mates only" );
	register_concmd( "mp_fadetoblack",	"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<0 | 1> - 0:Off | 1:On" );
	register_concmd( "mp_friendlyfire",	"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<0 | 1> - 0:Off | 1:On" );
	register_concmd( "mp_limitteams",	"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<#players>" );
	register_concmd( "mp_tkpunish",		"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<0 | 1> - 0:Off | 1:On" );
	register_concmd( "mp_hostagepenalty",	"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<#hostages>" );
	register_concmd( "hostname",		"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<name>" );
	register_concmd( "allow_spectators",	"ConCmd_NoMoreRcon",		ADMIN_CVAR,		"<#specs>" );
	
	/* Other Console Commands */
	register_concmd( "amx_reloadcvars",	"ConCmd_ReloadCvars",		ADMIN_CVAR,		" - Reloads all the cvars of the UltimatePlugin" );
	register_concmd( "amx_restart",		"ConCmd_RestartServer",		ADMIN_RCON,		"<timer> - Min:0 | Max:60 | Cancel:-1" );
	register_concmd( "amx_shutdown",	"ConCmd_ShutdownServer",	ADMIN_RCON,		"<timer> - Min:0 | Max:60 | Cancel:-1" );
	register_concmd( "amx_search",		"ConCmd_SearchCommands",	ADMIN_ADMIN,		"<command>" );
	
	#if defined GREEN_CHAT
	register_concmd( "amx_say",		"ConCmd_Say",			ADMIN_CHAT,		"<message>" );
	register_concmd( "amx_psay",		"ConCmd_Psay",			ADMIN_CHAT,		"# <name | #userid | authid> <message>" );
	register_concmd( "amx_chat",		"ConCmd_Chat",			ADMIN_CHAT,		"<message>" );
	#endif
	
	/* Ham Hooks */ 
	RegisterHam( Ham_Spawn,		"player",		"Ham_Spawn_Player_Post",		true );
	RegisterHam( Ham_Killed,	"player",		"Ham_Killed_Player_Post",		true );
	RegisterHam( Ham_Touch,		"func_buyzone",		"Ham_Touch_BuyZone_Pre",		false );
	// RegisterHam( Ham_Spawn,		"armoury_entity",	"Ham_Spawn_ArmouryEntity_Post",		true );

	/* Events */ 
	register_event( "CurWeapon",		"Event_CurWeapon",		"be", "1=1" );
	register_event( "Damage",		"Event_Damage",			"b", "2!0", "3=0", "4!0" );
	register_event( "SayText",		"Event_SayText",		"b", "2&#Cstrike_Chat_" );
	register_event( "WeapPickup",		"Event_WeapPickup",		"be", "1=6" );
	register_event( "BarTime",		"Event_BarTime",		"be" );
	register_event( "TextMsg",		"Event_TextMsg",		"bc", "2=#Game_bomb_drop" );
	register_event( "TextMsg",		"Event_TextMsg",		"a", "2=#Bomb_Planted" );
	register_event( "HLTV",			"Event_HLTV",			"a", "1=0", "2=0" );
	
	
	/* LogEvents */ 
	register_logevent( "LogEvent_RoundStart",	2,	"1=Round_Start" );
	register_logevent( "LogEvent_BombPlanted",	3,	"2=Planted_The_Bomb" );
	
	
	/* Menus */
	register_menucmd( register_menuid( "Team_Select", 1 ), MENU_KEY_1 | MENU_KEY_2 | MENU_KEY_5 | MENU_KEY_6, "Menu_TeamSelect" );
	
	/* Tasks */
	set_task( float( AFK_FREQUENCY ), "Task_AFK_Check",	TASK_AFK_CHECK,		_, _, "b" );
	set_task( float( AFK_FREQUENCY ), "Task_AFK_BombCheck",	TASK_AFK_BOMBCHECK,	_, _, "b" );
}

public nowfunction( id ) {
	client_print( 0, print_chat, "nowfunction" );
	log_amx( "testing" );
	cs_set_user_team( id, CS_TEAM_CT );
}

public plugin_precache( ) {
	/* Sounds */
	for( new iLoop = 0; iLoop < SOUND_MAX; iLoop++ ) {
		precache_sound( g_strSounds[ iLoop ] );
	}
	
	/* Sprites */
	for( new iLoop = 0; iLoop < SPRITE_MAX; iLoop++ ) {
		g_iSprites[ iLoop ] = precache_model( g_strSprites[ iLoop ] );
	}
}

public plugin_cfg( ) {
	/* Reload Cvars for the first time */
	ReloadCvars( );
}

/* Client Natives */
public client_connect( iPlayerID ) {
	SetBit( g_bitIsConnected,	iPlayerID );
	
	ClearBit( g_bitHasUnAmmo,	iPlayerID );
	ClearBit( g_bitHasUnBPAmmo,	iPlayerID );
	ClearBit( g_bitIsOnFire,	iPlayerID );
	ClearBit( g_bitHasGodmode,	iPlayerID );
	ClearBit( g_bitHasNoClip,	iPlayerID );
	ClearBit( g_bitHasNoBuy,	iPlayerID );
	ClearBit( g_bitHasAutoSlay,	iPlayerID );
	ClearBit( g_bitHasBadaim,	iPlayerID );
	ClearBit( g_bitHasSpeed,	iPlayerID );
	
	message_begin( MSG_ALL, g_msgTeamInfo );
	write_byte( iPlayerID );
	write_string( "SPECTATOR" );
	message_end( );
}

public client_disconnect( iPlayerID ) {
	ClearBit( g_bitIsConnected,     iPlayerID );
	ClearBit( g_bitIsAlive,         iPlayerID );
	
	static strPlayerAuthID[ 36 ], strPlayerName[ 32 ], strPlayerIP[ 16 ];
	static iPlayers[ 32 ], iNum, iTempID, iLoop;
	get_players( iPlayers, iNum );
	
	if( !iNum ) {
		return PLUGIN_CONTINUE;
	}
	
	get_user_name( iPlayerID, strPlayerName, 31 );
	get_user_ip( iPlayerID, strPlayerIP, 15, 1 );
	get_user_authid( iPlayerID, strPlayerAuthID, 35 );
	
	for( iLoop = 0; iLoop < iNum; iLoop++ ) {
		iTempID = iPlayers[ iLoop ];
		
		if( Access( iTempID, ADMIN_DISCONNECT ) ) {
			#if defined GREEN_CHAT
			ColorChat( iTempID, NORMAL, "!g%s !n%s (%s) (%s) has !gdisconnected!n.", g_strPluginPrefix, strPlayerName, strPlayerAuthID, strPlayerIP );
			#else
			client_print( iTempID, print_chat, "%s %s (%s) (%s) has disconnected.", g_strPluginPrefix, strPlayerName, strPlayerAuthID, strPlayerIP );
			#endif
		} else {
			#if defined GREEN_CHAT
			ColorChat( iTempID, NORMAL, "!g%s !n%s has !gdisconnected!n.", g_strPluginPrefix, strPlayerName );
			#else
			client_print( iTempID, print_chat, "%s %s has disconnected.", g_strPluginPrefix, strPlayerName );
			#endif
		}
	}
	
	return PLUGIN_CONTINUE;
}

public client_authorized( iPlayerID ) {
	static iPlayers[ 32 ], iNum, iTempID, iLoop;
	get_players( iPlayers, iNum );
	
	if( !iNum ) {
		return PLUGIN_CONTINUE;
	}
	
	static strPlayerAuthID[ 36 ], strPlayerName[ 32 ], strPlayerIP[ 16 ];
	get_user_name( iPlayerID, strPlayerName, 31 );
	get_user_authid( iPlayerID, strPlayerAuthID, 35 );
	get_user_ip( iPlayerID, strPlayerIP, 15, 1 );
	
	for( iLoop = 0; iLoop < iNum; iLoop++ ) {
		iTempID = iPlayers[ iLoop ];
		
		if( Access( iPlayerID, ADMIN_AUTHORIZED ) ) {
			#if defined GREEN_CHAT
			ColorChat( iTempID, NORMAL, "!g%s !n%s (%s) (%s) has !gconnected!n.", g_strPluginPrefix, strPlayerName, strPlayerAuthID, strPlayerIP );
			#else
			client_print( iTempID, print_chat, "%s %s (%s) (%s) has connected.", g_strPluginPrefix, strPlayerName, strPlayerAuthID, strPlayerIP );
			#endif
		} else {
			#if defined GREEN_CHAT
			ColorChat( iTempID, NORMAL, "!g%s !n%s has !gconnected!n.", g_strPluginPrefix, strPlayerName );
			#else
			client_print( iTempID, print_chat, "%s %s has connected.", g_strPluginPrefix, strPlayerName );
			#endif
		}
	}
	
	return PLUGIN_CONTINUE;
}

public client_PreThink( iPlayerID ) {
	if( CheckBit( g_bitHasBadaim, iPlayerID ) ) {
		static Float:fVector[ 3 ] = { 100.0, 100.0, 100.0 };
		static iLoop;
		
		for( iLoop = 0; iLoop < 6; iLoop++ ) {
			entity_set_vector( iPlayerID, EV_VEC_punchangle, fVector );
			entity_set_vector( iPlayerID, EV_VEC_punchangle, fVector );
			entity_set_vector( iPlayerID, EV_VEC_punchangle, fVector );
		}
	}
}

/* Server Natives */
public server_changelevel( strMap[ ] ) {
	/*
	This is so that after the map change, the timelimit returns
	to what it was before the admin extended the map.
	*/
	set_pcvar_float( g_cvarTimeLimit, get_pcvar_float( g_cvarTimeLimit ) - g_iTotalExtendTime );
}

/* Client Commands */
public ClCmd_ResetScore( iPlayerID ) {
	if( !CheckBit( g_bitCvarStatus, CVAR_RESETSCORE ) ) {
		#if defined GREEN_CHAT
		ColorChat( iPlayerID, NORMAL, "!g%s !nThis option has been disabled on this server.", g_strPluginPrefix );
		#else
		client_print( iPlayerID, print_chat, "%s This option has been disabled on this server.", g_strPluginPrefix );
		#endif
		
		return PLUGIN_HANDLED;
	}
	
	if( !get_user_deaths( iPlayerID ) && !get_user_frags( iPlayerID ) ) {
		#if defined GREEN_CHAT
		ColorChat( iPlayerID, NORMAL, "!g%s !nYour score is already reset.", g_strPluginPrefix );
		#else
		client_print( iPlayerID, print_chat, "%s Your score is already reset.", g_strPluginPrefix );
		#endif
		
		return PLUGIN_HANDLED;
	}
	
	set_user_frags( iPlayerID, 0 );
	cs_set_user_deaths( iPlayerID, 0 );
	
	UpdateScore( iPlayerID, 0, 0 );
	
	new strPlayerName[ 32 ];
	get_user_name( iPlayerID, strPlayerName, 31 );
	
	if( !CheckBit( g_bitCvarStatus, CVAR_RESETSCORE_DISPLAY ) ) {
		new iPlayers[ 32 ], iNum, iTempID;
		get_players( iPlayers, iNum );
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( iTempID != iPlayerID && is_user_admin( iTempID ) ) {
				#if defined GREEN_CHAT
				ColorChat( iTempID, NORMAL, "!g%s (ADMINS) !n%s has just reset his score.", g_strPluginPrefix, strPlayerName );
				#else
				client_print( iTempID, print_chat, "%s (ADMINS) %s has just reset his score.", g_strPluginPrefix, strPlayerName );
				#endif
			}
		}
		
		#if defined GREEN_CHAT
		ColorChat( iPlayerID, NORMAL, "!g%s !nYou have just reset your score.", g_strPluginPrefix );
		#else
		client_print( iPlayerID, print_chat, "%s You have just reset your score.", g_strPluginPrefix );
		#endif
	} else {
		#if defined GREEN_CHAT
		ColorChat( 0, NORMAL, "!g%s !n%s has just reset his score.", g_strPluginPrefix, strPlayerName );
		#else
		client_print( 0, print_chat, "%s %s has just reset his score.", g_strPluginPrefix, strPlayerName );
		#endif
	}
	
	return PLUGIN_HANDLED;
}

public ClCmd_AdminCheck( iPlayerID ) {
	if( !CheckBit( g_bitCvarStatus, CVAR_ADMINCHECK ) && !is_user_admin( iPlayerID ) ) {
		#if defined GREEN_CHAT
		ColorChat( iPlayerID, NORMAL, "!g%s !nThis option has been disabled on this server.", g_strPluginPrefix );
		#else
		client_print( iPlayerID, print_chat, "%s This option has been disabled on this server.", g_strPluginPrefix );
		#endif
		
		return PLUGIN_HANDLED;
	}
	
	new strAdminName[ 32 ], strAllAdmins[ 256 ], iLen;
	new iPlayers[ 32 ], iNum, iTempID;
	get_players( iPlayers, iNum );
	
	#if defined GREEN_CHAT
	iLen = formatex( strAllAdmins, 255, "!g%s Online admins: !n", g_strPluginPrefix );
	#else
	iLen = formatex( strAllAdmins, 255, "%s Online admins: ", g_strPluginPrefix );
	#endif
	
	/*
		Adding the names of all online admins to the message,
		whitch after we are done adding, is gonna be printed to
		the player.
	*/
	for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
		iTempID = iPlayers[ iLoop ];
		
		if( is_user_admin( iTempID ) ) {
			get_user_name( iTempID, strAdminName, 31 );
			
			iLen += formatex( strAllAdmins[ iLen ], 255 - iLen, "%s, ", strAdminName );
		}
	}
	
	/*
		Here I am removing the nasty looking comma at the end
		of the names and replacing it with a dot. Witch is better.
	*/
	strAllAdmins[ iLen - 2 ] = '.';
	
	#if defined GREEN_CHAT
	ColorChat( iPlayerID, NORMAL, "%s", strAllAdmins );
	#else
	client_print( iPlayerID, print_chat, "%s", strAllAdmins );
	#endif
	
	return PLUGIN_HANDLED;
}

public ClCmd_JoinTeam( iPlayerID ) {
	static iTeam[ 2 ];
	read_argv( 1, iTeam, 1 );
	
	if( g_bBlockTeamJoin[ str_to_num( iTeam ) - 1 ] ) {
		engclient_cmd( iPlayerID, "chooseteam" );
		
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

#if defined GREEN_CHAT
public ClCmd_SayHandler( iPlayerID ) {
	static strTemp[ 256 ];
	read_argv( 1, strTemp, 255 );
	
	/*
		Checking if the player has the correct access and that he
		is trying to send a private message
	*/
	if( Access( iPlayerID, ADMIN_CHAT ) ) {
		if( strTemp[ 0 ] == '#' ) {
			static strMessage[ 256 ], strCommand[ 10 ];
			
			if( strTemp[ 1 ] == ' ' ) {
				strbreak( strTemp, strCommand, 9, strMessage, 255 );
			} else {
				strTemp[ 0 ] = ' ';
				trim( strTemp );
				copy( strMessage, 255, strTemp );
			}
			
			BaseSendPM( strMessage, iPlayerID );
			
			return PLUGIN_HANDLED;
		}
	}
	
	return PLUGIN_CONTINUE;
}

public ClCmd_SayTeamHandler( iPlayerID ) {
	static strTemp[ 256 ], strCommand[ 10 ], strMessage[ 256 ];
	read_argv( 1, strTemp, 255 );
	
	/*
		Checking if the player wants to send a message to all online
		admins. If not then check if he wants to send a private message 
		instead. Of course he must have the correct access.
	*/
	if( strTemp[ 0 ] == '@' ) {
		if( strTemp[ 1 ] == ' ' ) {
			strbreak( strTemp, strCommand, 9, strMessage, 255 );
		} else {
			strTemp[ 0 ] = ' ';
			trim( strTemp );
			copy( strMessage, 255, strTemp );
		}
		
		remove_quotes( strMessage );
		SendAdminMessage( strMessage, iPlayerID );
		
		return PLUGIN_HANDLED;
	} else if( Access( iPlayerID, ADMIN_CHAT ) ) {
		if( strTemp[ 0 ] == '#' ) {
			if( strTemp[ 1 ] == ' ' ) {
				strbreak( strTemp, strCommand, 9, strMessage, 255 );
			} else {
				strTemp[ 0 ] = ' ';
				trim( strTemp );
				copy( strMessage, 255, strTemp );
			}
			
			BaseSendPM( strMessage, iPlayerID );
			
			return PLUGIN_HANDLED;
		}
	}
	
	return PLUGIN_CONTINUE;
}

/* Console Commands */
public ConCmd_Say( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 1 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strMessage[ 256 ];
	read_args( strMessage, 255 );
	remove_quotes( strMessage );
	
	new strSenderName[ 32 ];
	get_user_name( iPlayerID, strSenderName, 31 );
	
	new strRealMessage[ 256 ] = "^x04(ALL) ";
	add( strRealMessage, 255, strSenderName );
	add( strRealMessage, 255, ": ^x01" );
	add( strRealMessage, 255, strMessage, 256 - strlen( strRealMessage ) - 1 );
	
	new strSenderAuthID[ 36 ];
	get_user_authid( iPlayerID, strSenderAuthID, 35 );
	
	new iPlayers[ 32 ], iNum;
	get_players( iPlayers, iNum, "c" );
	
	log_amx( "%s AMX_SAY - Sender: ^"%s<%d><%s><>^" Message: ^"%s^"", g_strPluginPrefix, strSenderName, iPlayerID, strSenderAuthID, strMessage );
	
	for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
		SendMessage( strRealMessage, iPlayers[ iLoop ] );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Psay( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 1 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strMessage[ 256 ];
	read_args( strMessage, 255 );
	
	BaseSendPM( strMessage, iPlayerID );
	
	return PLUGIN_HANDLED;
}

public ConCmd_Chat( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 1 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strMessage[ 256 ];
	read_args( strMessage, 255 );
	remove_quotes( strMessage );
	
	SendAdminMessage( strMessage, iPlayerID );
	
	return PLUGIN_HANDLED;
}

#endif

/* ADMIN_LEVEL_A Console Commands */
public ConCmd_Health( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 3 ) ) {
		return PLUGIN_HANDLED;
	}
	
	if( read_argc( ) > 3 ) {
		console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new strCommand[ 32 ], bool:bSetHealth;
	new strTarget[ 32 ], strHealth[ 8 ], iHealth;
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	
	read_argv( 0, strCommand, 31 );
	read_argv( 1, strTarget, 31 );
	read_argv( 2, strHealth, 7 );
	
	( strCommand[ 5 ] == 'e' ) ? ( bSetHealth = false ) : ( bSetHealth = true );
	
	iHealth = str_to_num( strHealth );
	iHealth = Clamp( iHealth, MIN_HEALTH, MAX_HEALTH );
	
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			if( bSetHealth ) {
				set_user_health( iTempID, iHealth );
			} else {
				set_user_health( iTempID, Maximum( get_user_health( iTempID ) + iHealth, MAX_HEALTH ) );
			}
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin %s %s players%s%i%s.", g_strPluginPrefix, bSetHealth ? "set the health of" : "gave", strTeam, bSetHealth ? " to " : " ", iHealth, bSetHealth ? "" : " health" );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s %s %s players%s%i%s.", g_strPluginPrefix, strAdminName, bSetHealth ? "set the health of" : "gave", strTeam, bSetHealth ? " to " : " ", iHealth, bSetHealth ? "" : " health" );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin %s %s players%s%i%s.", g_strPluginPrefix, bSetHealth ? "set the health of" : "gave", strTeam, bSetHealth ? " to " : " ", iHealth, bSetHealth ? "" : " health" );
			case 2: client_print( 0, print_chat, "%s Admin %s %s %s players%s%i%s.", g_strPluginPrefix, strAdminName, bSetHealth ? "set the health of" : "gave", strTeam, bSetHealth ? " to " : " ", iHealth, bSetHealth ? "" : " health" );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) %s %i health to %s players.", g_strPluginPrefix, strAdminName, strAdminAuthID, bSetHealth ? "set" : "gave", iHealth, strTeam );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		if( bSetHealth ) {
			set_user_health( iTarget, iHealth );
		} else {
			set_user_health( iTarget, Maximum( get_user_health( iTarget ) + iHealth, MAX_HEALTH ) );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin %s %s%i%s.", g_strPluginPrefix, bSetHealth ? "set the health of" : "gave", strTargetName, bSetHealth ? "to " :"", iHealth, bSetHealth ? "" : " health" );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s %s %s %s%i%s.", g_strPluginPrefix, strAdminName, bSetHealth ? "set the health of" : "gave", strTargetName, bSetHealth ? "to " : "", iHealth, bSetHealth ? "" : " health" );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin %s %s%i%s.", g_strPluginPrefix, bSetHealth ? "set the health of" : "gave", strTargetName, bSetHealth ? "to" :"", iHealth, bSetHealth ? "" : " health" );
			case 2:	client_print( 0, print_chat, "%s Admin %s %s %s %s%i%s.", g_strPluginPrefix, strAdminName, bSetHealth ? "set the health of" : "gave", strTargetName, bSetHealth ? "to" : "", iHealth, bSetHealth ? "" : " health" );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) %s %s (%s)%s%i%s.", g_strPluginPrefix, strAdminName, strAdminAuthID, bSetHealth ? "set the health of" : "gave", strTargetName, strTargetAuthID, bSetHealth ? "to" : "", iHealth, bSetHealth ? "" : " health" );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Armor( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 3 ) ) {
		return PLUGIN_HANDLED;
	}
	
	if( read_argc( ) > 3 ) {
		console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new strCommand[ 32 ], bool:bSetArmor;
	new strTarget[ 32 ], strArmor[ 8 ], iArmor;
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	
	read_argv( 0, strCommand, 31 );
	read_argv( 1, strTarget, 31 );
	read_argv( 2, strArmor, 7 );
	
	( strCommand[ 5 ] == 'p' ) ? ( bSetArmor = true ) : ( bSetArmor = false );
	
	iArmor = str_to_num( strArmor );
	iArmor = Clamp( iArmor, MIN_ARMOR, MAX_ARMOR );
	
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			if( bSetArmor ) {
				cs_set_user_armor( iTempID, iArmor, CS_ARMOR_VESTHELM );
			} else {
				cs_set_user_armor( iTempID, Maximum( get_user_armor( iTempID ) + iArmor, MAX_ARMOR ), CS_ARMOR_VESTHELM );
			}
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin %s all %s players%s %i%s.", g_strPluginPrefix, bSetArmor ? "set the armor of" : "gave", strTeam, bSetArmor ? " to" : "", iArmor, bSetArmor ? "" : " armor" );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s %s all %s players%s %i%s.", g_strPluginPrefix, strAdminName, bSetArmor ? "set the armor of" : "gave", strTeam, bSetArmor ? " to" : "", iArmor, bSetArmor ? "" : " armor" );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin %s all %s players%s %i%s.", g_strPluginPrefix, bSetArmor ? "set the armor of" : "gave", strTeam, bSetArmor ? " to" : "", iArmor, bSetArmor ? "" : " armor" );
			case 2:	client_print( 0, print_chat, "%s Admin %s %s all %s players%s %i%s.", g_strPluginPrefix, strAdminName, bSetArmor ? "set the armor of" : "gave", strTeam, bSetArmor ? " to" : "", iArmor, bSetArmor ? "" : " armor" );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) %s all %s players%s %i%s.", g_strPluginPrefix, strAdminName, strAdminAuthID, bSetArmor ? "set the armor of" : "gave", strTeam, bSetArmor ? " to" : "", iArmor, bSetArmor ? "" : " armor" );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		if( bSetArmor ) {
			cs_set_user_armor( iTarget, iArmor, CS_ARMOR_VESTHELM );
		} else {
			cs_set_user_armor( iTarget, Maximum( get_user_armor( iTarget ) + iArmor, MAX_ARMOR ), CS_ARMOR_VESTHELM );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin %s %s%s %i%s.", g_strPluginPrefix, bSetArmor ? "set the armor of" : "gave", strTargetName, bSetArmor ? " to" : "", iArmor, bSetArmor ? "" : " armor" );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s %s %s%s %i%s.", g_strPluginPrefix, strAdminName, bSetArmor ? "set the armor of" : "gave", strTargetName, bSetArmor ? " to" : "", iArmor, bSetArmor ? "" : " armor" );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin %s %s%s %i%s.", g_strPluginPrefix, bSetArmor ? "set the armor of" : "gave", strTargetName, bSetArmor ? " to" : "", iArmor, bSetArmor ? "" : " armor" );
			case 2:	client_print( 0, print_chat, "%s Admin %s %s %s%s %i%s.", g_strPluginPrefix, strAdminName, bSetArmor ? "set the armor of" : "gave", strTargetName, bSetArmor ? " to" : "", iArmor, bSetArmor ? "" : " armor" );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) %s %s (%s)%s %i%s.", g_strPluginPrefix, strAdminName, strAdminAuthID, bSetArmor ? "set the armor of" : "gave", strTargetName, strTargetAuthID, bSetArmor ? " to" : "", iArmor, bSetArmor ? "" : " armor" );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Ammo( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strStatus[ 8 ], iStatus;
	
	switch( read_argc( ) ) {
		case 2: {
			iStatus = 0;
		}
		
		case 3: {
			read_argv( 2, strStatus, 7 );
			iStatus = str_to_num( strStatus );
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	new strTarget[ 32 ], strCommand[ 32 ], bool:bClipAmmo;
	
	read_argv( 0, strCommand, 31 );
	read_argv( 1, strTarget, 31 );
	
	( strCommand[ 10 ] == 'b' ) ? ( bClipAmmo = false ) : ( bClipAmmo = true );
	
	iStatus = Clamp( iStatus, 0, 1 );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			if( bClipAmmo ) {
				( iStatus ) ? SetBit( g_bitHasUnAmmo, iTempID ) : ClearBit( g_bitHasUnAmmo, iTempID );
			} else {
				( iStatus ) ? SetBit( g_bitHasUnBPAmmo, iTempID ) : ClearBit( g_bitHasUnBPAmmo, iTempID );
			}
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin %s %s players%s unlimited%s ammo.", g_strPluginPrefix, iStatus ? "gave" : "revoked", strTeam, iStatus ? "" : "'s", bClipAmmo ? "clip" : "bp" );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s %s players%s unlimited%s ammo.", g_strPluginPrefix, strAdminName, iStatus ? "gave" : "revoked", strTeam, iStatus ? "" : "'s", bClipAmmo ? "clip" : "bp" );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin %s %s players%s unlimited %s ammo.", g_strPluginPrefix, iStatus ? "gave" : "revoked", strTeam, iStatus ? "" : "'s", bClipAmmo ? "clip" : "bp" );
			case 2:	client_print( 0, print_chat, "%s Admin %s %s players%s unlimited %s ammo.", g_strPluginPrefix, strAdminName, iStatus ? "gave" : "revoked", strTeam, iStatus ? "" : "'s", bClipAmmo ? "clip" : "bp" );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) %s %s players%s unlimited %s ammo.", g_strPluginPrefix, strAdminName, strAdminAuthID, iStatus ? "gave" : "revoked", strTeam, iStatus ? "" : "'s", bClipAmmo ? "clip" : "bp" );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		if( bClipAmmo ) {
			( iStatus ) ? SetBit( g_bitHasUnAmmo, iTarget ) : ClearBit( g_bitHasUnAmmo, iTarget );
		} else {
			( iStatus ) ? SetBit( g_bitHasUnBPAmmo, iTarget ) : ClearBit( g_bitHasUnBPAmmo, iTarget );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin %s %s%s unlimited %s ammo.", g_strPluginPrefix, iStatus ? "gave" : "revoked", strTargetName, iStatus ? "" : "'s", bClipAmmo ? "clip" : "bp" );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s %s %s%s unlimited %s ammo.", g_strPluginPrefix, strAdminName, iStatus ? "gave" : "revoked", strTargetName, iStatus ? "" : "'s", bClipAmmo ? "clip" : "bp" );
			#else
			case 1:	client_print( 0, print_chat, "%sAn admin %s %s%s unlimited %s ammo.", g_strPluginPrefix, iStatus ? "gave" : "revoked", strTargetName, iStatus ? "" : "'s", bClipAmmo ? "clip" : "bp" );
			case 2:	client_print( 0, print_chat, "%sAdmin %s %s %s%s unlimited %s ammo.", g_strPluginPrefix, strAdminName, iStatus ? "gave" : "revoked", strTargetName, iStatus ? "" : "'s", bClipAmmo ? "clip" : "bp" );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) %s %s (%s)%s unlimited %s ammo.", g_strPluginPrefix, strAdminName, strAdminAuthID, iStatus ? "gave" : "revoked", strTargetName, strTargetAuthID, iStatus ? "" : "'s", bClipAmmo ? "clip" : "bp" );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Score( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 4 ) ) {
		return PLUGIN_HANDLED;
	}
	
	if( read_argc( ) > 4 ) {
		console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new strTarget[ 32 ];
	new strFrags[ 8 ], iFrags;
	new strDeaths[ 8 ], iDeaths;
	
	read_argv( 1, strTarget, 31 );
	read_argv( 2, strFrags, 7 );
	read_argv( 3, strDeaths, 7 );
	
	iFrags	= str_to_num( strFrags );
	iDeaths	= str_to_num( strDeaths );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			set_user_frags( iTempID, iFrags );
			cs_set_user_deaths( iTempID, iDeaths );
			UpdateScore( iTempID, iFrags, iDeaths );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin set the score of %s players to %i:%i.", g_strPluginPrefix, strTeam, iFrags, iDeaths );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s set the score of %s players to %i:%i.", g_strPluginPrefix, strAdminName, strTeam, iFrags, iDeaths );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin set the score of %s players to %i:%i.", g_strPluginPrefix, strTeam, iFrags, iDeaths );
			case 2:	client_print( 0, print_chat, "%s Admin %s set the score of %s players to %i:%i.", g_strPluginPrefix, strAdminName, strTeam, iFrags, iDeaths );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) set the score of %s players to %i:%i.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTeam, iFrags, iDeaths );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		set_user_frags( iTarget, iFrags );
		cs_set_user_deaths( iTarget, iDeaths );
		UpdateScore( iTarget, iFrags, iDeaths );
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin set the score of %s to %i:%i.", g_strPluginPrefix, strTargetName, iFrags, iDeaths );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s set the score of %s to %i:%i.", g_strPluginPrefix, strAdminName, strTargetName, iFrags, iDeaths );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin set the score of %s to %i:%i.", g_strPluginPrefix, strTargetName, iFrags, iDeaths );
			case 2:	client_print( 0, print_chat, "%s Admin %s set the score of %s to %i:%i.", g_strPluginPrefix, strAdminName, strTargetName, iFrags, iDeaths );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) set the score of %s (%s) to %i:%i.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTargetName, strTargetAuthID, iFrags, iDeaths );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Revive( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strHealth[ 8 ], strArmor[ 8 ];
	
	switch( read_argc( ) ) {
		case 2: {
			g_iSpawnHealth = SPAWN_DEF_HEALTH;
			g_iSpawnArmor	= SPAWN_DEF_ARMOR;
		}
		
		case 3: {
			read_argv( 2, strHealth, 7 );
			g_iSpawnHealth = str_to_num( strHealth );
		}
		
		case 4: {
			read_argv( 2, strHealth, 7 );
			read_argv( 3, strArmor, 7 );
			
			g_iSpawnHealth = str_to_num( strHealth );
			g_iSpawnArmor	= str_to_num( strArmor );
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	new strTarget[ 32 ];
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	
	read_argv( 1, strTarget, 31 );
	
	g_iSpawnHealth = Clamp( g_iSpawnHealth, MIN_HEALTH, MAX_HEALTH );
	g_iSpawnArmor = Clamp( g_iSpawnArmor, MIN_ARMOR, MAX_ARMOR );
	
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			#if defined REVIVE_ALIVE
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "e", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "e", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "e", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum );
			}
			#else
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "be", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "be", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "be", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "b" );
			}
			#endif
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			RevivePlayer( iTempID );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "%s An admin revived %s players with %i health and %i armor.", g_strPluginPrefix, strTeam, g_iSpawnHealth, g_iSpawnArmor );
			case 2:	ColorChat( 0, NORMAL, "%s Admin %s revived %s players with %i health and %i armor.", g_strPluginPrefix, strAdminName, strTeam, g_iSpawnHealth, g_iSpawnArmor );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin revived %s players with %i health and %i armor.", g_strPluginPrefix, strTeam, g_iSpawnHealth, g_iSpawnArmor );
			case 2:	client_print( 0, print_chat, "%s Admin %s revived %s players with %i health and %i armor.", g_strPluginPrefix, strAdminName, strTeam, g_iSpawnHealth, g_iSpawnArmor );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) revived %s players with %i health and %i armor.", g_strPluginName, strAdminName, strAdminAuthID, strTeam, g_iSpawnHealth, g_iSpawnArmor );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		#if !defined REVIVE_ALIVE
		if( CheckBit( g_bitIsAlive, iTarget ) ) {
			console_print( iPlayerID, "%s ERROR: you cannot revive alive players.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		#endif
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		RevivePlayer( iTarget );
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin revived %s with %i health and %i armor.", g_strPluginPrefix, strTargetName, g_iSpawnHealth, g_iSpawnArmor );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s revived %s with %i health and %i armor.", g_strPluginPrefix, strAdminName, strTargetName, g_iSpawnHealth, g_iSpawnArmor );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin revived %s with %i health and %i armor.", g_strPluginPrefix, strTargetName, g_iSpawnHealth, g_iSpawnArmor );
			case 2:	client_print( 0, print_chat, "%s Admin %s revived %s with %i health and %i armor.", g_strPluginPrefix, strAdminName, strTargetName, g_iSpawnHealth, g_iSpawnArmor );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) revived %s (%s) with %i health and %i armor.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTargetName, strTargetAuthID, g_iSpawnHealth, g_iSpawnArmor );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_NoclipGodmode( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strStatus[ 8 ], iStatus;
	
	switch( read_argc( ) ) {
		case 2: {
			iStatus = 0;
		}
		
		case 3: {
			read_argv( 2, strStatus, 7 );
			iStatus = str_to_num( strStatus );
		}
		
		default: {
			return PLUGIN_HANDLED;
		}
	}
	
	new strCommand[ 32 ], bool:bNoClip;
	new strTarget[ 32 ];
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	
	read_argv( 0, strCommand, 31 );
	read_argv( 1, strTarget, 31 );
	
	( strCommand[ 4 ] == 'n' ) ? ( bNoClip = true ) : ( bNoClip = false );
	
	iStatus =  Clamp( iStatus, 0, 2 );
	
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			if( bNoClip ) {
				switch( iStatus ) {
					case 0: {
						set_user_noclip( iTempID );
						ClearBit( g_bitHasNoClip, iTempID );
					}
					
					case 1: {
						set_user_noclip( iTempID, 1 );
					}
					
					case 2: {
						set_user_noclip( iTempID, 1 );
						SetBit( g_bitHasNoClip, iTempID );
					}
				}
			} else {
				switch( iStatus ) {
					case 0: {
						set_user_godmode( iTempID );
						ClearBit( g_bitHasGodmode, iTempID );
					}
					
					case 1: {
						set_user_godmode( iTempID, 1 );
					}
					
					case 2: {
						set_user_godmode( iTempID, 1 );
						SetBit( g_bitHasGodmode, iTempID );
					}
				}
			}
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin set %s %i on %s players.", g_strPluginPrefix, bNoClip ? "noclip" : "godmode", iStatus, strTeam );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s set %s %i on %s players.", g_strPluginPrefix, strAdminName, bNoClip ? "noclip" : "godmode", iStatus, strTeam );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin set %s %i on %s players.", g_strPluginPrefix, bNoClip ? "noclip" : "godmode", iStatus, strTeam );
			case 2:	client_print( 0, print_chat, "%s Admin %s set %s %i on %s players.", g_strPluginPrefix, strAdminName, bNoClip ? "noclip" : "godmode", iStatus, strTeam );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) set %s %i on %s players.", g_strPluginPrefix, strAdminName, strAdminAuthID, bNoClip ? "noclip" : "godmode", iStatus, strTeam );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		if( bNoClip ) {
			switch( iStatus ) {
				case 0: {
					set_user_noclip( iTarget );
					ClearBit( g_bitHasNoClip, iTarget );
				}

				case 1: {
					set_user_noclip( iTarget, 1 );
				}

				case 2: {
					set_user_noclip( iTarget, 1 );
					SetBit( g_bitHasNoClip, iTarget );
				}
			}
		} else {
			switch( iStatus ) {
				case 0: {
					set_user_godmode( iTarget );
					ClearBit( g_bitHasGodmode, iTarget );
				}

				case 1: {
					set_user_godmode( iTarget, 1 );
				}

				case 2: {
					set_user_godmode( iTarget, 1 );
					SetBit( g_bitHasGodmode, iTarget );
				}
			}
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin set %s %i on %s.", g_strPluginPrefix, bNoClip ? "noclip" : "godmode", iStatus, strTargetName );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s set %s %i on %s.", g_strPluginPrefix, strAdminName, bNoClip ? "noclip" : "godmode", iStatus, strTargetName );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin set %s %i on %s.", g_strPluginPrefix, bNoClip ? "noclip" : "godmode", iStatus, strTargetName );
			case 2:	client_print( 0, print_chat, "%s Admin %s set %s %i on %s.", g_strPluginPrefix, strAdminName, bNoClip ? "noclip" : "godmode", iStatus, strTargetName );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) set %s %i on %s (%s).", g_strPluginPrefix, strAdminName, strAdminAuthID, bNoClip ? "noclip" : "godmode", iStatus, strTargetName, strTargetAuthID );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Teleport( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new iOrigin[ 3 ];
	new strOriginX[ 8 ], strOriginY[ 8 ], strOriginZ[ 8 ];
	
	switch( read_argc( ) ) {
		case 2: {
			iOrigin = g_iSavedOrigin;
			iOrigin[ 2 ] += 5;
		}
		
		case 3, 4: {
			console_print( iPlayerID, "%s ERROR: you have to specify all 3 coordinates.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		case 5: {
			read_argv( 2, strOriginX, 7 );
			read_argv( 3, strOriginY, 7 );
			read_argv( 4, strOriginZ, 7 );
			
			iOrigin[ 0 ] = str_to_num( strOriginX );
			iOrigin[ 1 ] = str_to_num( strOriginY );
			iOrigin[ 2 ] = str_to_num( strOriginZ );
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	new strTarget[ 32 ];
	read_argv( 1, strTarget, 31 );
	
	if( strTarget[ 0 ] == '@' ) {
		console_print( iPlayerID, "%s ERROR: you cannot choose multiple players to teleport to the same location.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
	
	if( !iTarget ) {
		return PLUGIN_HANDLED;
	}
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	new strTargetName[ 32 ], strTargetAuthID[ 36 ];
	get_user_name( iTarget, strTargetName, 31 );
	get_user_authid( iTarget, strTargetAuthID, 35 );
	
	set_user_origin( iTarget, iOrigin );
	
	switch( get_pcvar_num( g_cvarShowActivity ) ) {
		#if defined GREEN_CHAT
		case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin teleported %s to another location.", g_strPluginPrefix, strTargetName );
		case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s teleported %s to another location.", g_strPluginPrefix, strAdminName, strTargetName );
		#else
		case 1:	client_print( 0, print_chat, "%s An admin teleported %s to another location.", g_strPluginPrefix, strTargetName );
		case 2:	client_print( 0, print_chat, "%s Admin %s teleported %s to another location.", g_strPluginPrefix, strAdminName, strTargetName );
		#endif
	}
	
	log_amx( "%s Admin %s (%s) teleported %s (%s) to another location.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTargetName, strTargetAuthID );
	
	return PLUGIN_HANDLED;
}

public ConCmd_UserOrigin( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	if( read_argc( ) > 2 ) {
		console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new strTarget[ 32 ];
	read_argv( 1, strTarget, 31 );
	
	if( strTarget[ 0 ] == '@' ) {
		console_print( iPlayerID, "%s ERROR: you cannot choose multiple players to teleport to the same location.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
	
	if( !iTarget ) {
		return PLUGIN_HANDLED;
	}
	
	get_user_origin( iTarget, g_iSavedOrigin );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	new strTargetName[ 32 ], strTargetAuthID[ 36 ];
	get_user_name( iTarget, strTargetName, 31 );
	get_user_authid( iTarget, strTargetAuthID, 35 );
	
	log_amx( "%s Admin %s (%s) saved %s (%s)'s location.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTargetName, strTargetAuthID );
	
	return PLUGIN_HANDLED;
}

public ConCmd_Speed( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strStatus[ 8 ], iStatus;
	
	switch( read_argc( ) ) {
		case 2: {
			iStatus = 0;
		}
		
		case 3: {
			read_argv( 2, strStatus, 7 );
			iStatus = str_to_num( strStatus );
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	iStatus = Clamp( iStatus, 0, 1 );
	
	new strTarget[ 32 ];
	read_argv( 1, strTarget, 31 );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			switch( iStatus ) {
				case 0: {
					ClearBit( g_bitHasSpeed, iTempID );
					ResetUserMaxSpeed( iTempID );
				}
				
				case 1: {
					SetBit( g_bitHasSpeed, iTempID );
					Event_CurWeapon( iTempID );
				}
			}
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin turned speed %s on %s players.", g_strPluginPrefix, iStatus ? "On" : "Off", strTeam );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s turned speed %s on %s players.", g_strPluginPrefix, strAdminName, iStatus ? "On" : "Off", strTeam );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin turned speed %s on %s players.", g_strPluginPrefix, iStatus ? "On" : "Off", strTeam );
			case 2:	client_print( 0, print_chat, "%s Admin %s turned speed %s on %s players.", g_strPluginPrefix, strAdminName, iStatus ? "On" : "Off", strTeam );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) turned speed %s on %s players.", g_strPluginPrefix, strAdminName, strAdminAuthID, iStatus ? "On" : "Off", strTeam );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		switch( iStatus ) {
			case 0: {
				ClearBit( g_bitHasSpeed, iTarget );
				ResetUserMaxSpeed( iTarget );
			}
			
			case 1: {
				SetBit( g_bitHasSpeed, iTarget );
				Event_CurWeapon( iTarget );
			}
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin turned speed %s on %s.", g_strPluginPrefix, iStatus ? "On" : "Off", strTargetName );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s turned speed %s on %s.", g_strPluginPrefix, strAdminName, iStatus ? "On" : "Off", strTargetName );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin turned speed %s on %s.", g_strPluginPrefix, iStatus ? "On" : "Off", strTargetName );
			case 2:	client_print( 0, print_chat, "%s Admin %s turned speed %s on %s.", g_strPluginPrefix, strAdminName, iStatus ? "On" : "Off", strTargetName );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) turned speed %s on %s (%s).", g_strPluginPrefix, strAdminName, strAdminAuthID,  iStatus ? "On" : "Off", strTargetName, strTargetAuthID );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Drug( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strTarget[ 32 ];
	read_argv( 1, strTarget, 31 );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			DrugPlayer( iTempID );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin gave drugs to %s players.", g_strPluginPrefix, strTeam );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s gave drugs to %s players.", g_strPluginPrefix, strAdminName, strTeam );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin gave drugs to %s players.", g_strPluginPrefix, strTeam );
			case 2:	client_print( 0, print_chat, "%s Admin %s gave drugs to %s players.", g_strPluginPrefix, strAdminName, strTeam );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) gave drugs to %s.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTeam );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		DrugPlayer( iTarget );
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin gave drugs to %s.", g_strPluginPrefix, strTargetName );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s gave drugs to %s.", g_strPluginPrefix, strAdminName, strTargetName );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin gave drugs to %s.", g_strPluginPrefix, strTargetName );
			case 2:	client_print( 0, print_chat, "%s Admin %s gave drugs to %s.", g_strPluginPrefix, strAdminName, strTargetName );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) gave drugs to %s (%s).", g_strPluginPrefix, strAdminName, strAdminAuthID, strTargetName, strTargetAuthID );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Weapon( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 3 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strWeapon[ 32 ], iWeapon;
	new strAmmo[ 8 ], iAmmo;
	
	switch( read_argc( ) ) {
		case 3: {
			read_argv( 2, strWeapon, 31 );
			iWeapon = str_to_num( strWeapon );
			
			iAmmo = -1;
		}
		
		case 4: {
			read_argv( 2, strWeapon, 31 );
			read_argv( 3, strAmmo, 7 );
			
			iWeapon = str_to_num( strWeapon );
			iAmmo = str_to_num( strAmmo );
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	if( !iWeapon ) {
		for( new iLoop = 0; iLoop < 31; iLoop++ ) {
			if( containi( strWeapon, g_strWeapons[ iLoop ][ 7 ] ) != -1 ) {
				iWeapon = iLoop;
				break;
			}
		}
		
		if( !iWeapon ) {
			console_print( iPlayerID, "%s ERROR: no such weapon was found. Please try again.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	} else {
		new bool:bFoundMatch = false;
		
		for( new iLoop = 0; iLoop < 31; iLoop++ ) {
			if( iWeapon == g_iWeaponLayout[ iLoop ] ) {
				iWeapon = iLoop;
				bFoundMatch = true;
				break;
			}
		}
		
		if( !bFoundMatch ) {
			console_print( iPlayerID, "%s ERROR: no such weapon was found. Please try again.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	if( iAmmo == -1 ) {
		iAmmo = g_iWeaponBackpack[ iWeapon ];
	} else {
		iAmmo = Clamp( iAmmo, 0, g_iWeaponBackpack[ iWeapon ] );
	}
	
	new strTarget[ 32 ];
	read_argv( 1, strTarget, 31 );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			GiveWeapon( iTempID, iWeapon, iAmmo );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1: ColorChat( 0, NORMAL, "!g%s !nAn admin gave %s players %s with %i ammo.", g_strPluginPrefix, strTeam, g_strWeapons[ iWeapon ], iAmmo );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s gave %s players %s with %i ammo.", g_strPluginPrefix, strAdminName, strTeam, g_strWeapons[ iWeapon ], iAmmo );
			#else
			case 1: client_print( 0, print_chat, "%s An admin gave %s players %s with %i ammo.", g_strPluginPrefix, strTeam, g_strWeapons[ iWeapon ], iAmmo );
			case 2:	client_print( 0, print_chat, "%s Admin %s gave %s players %s with %i ammo.", g_strPluginPrefix, strAdminName, strTeam, g_strWeapons[ iWeapon ], iAmmo );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) gave %s players %s with %i ammo.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTeam, g_strWeapons[ iWeapon ], iAmmo );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		GiveWeapon( iTarget, iWeapon, iAmmo );
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1: ColorChat( 0, NORMAL, "!g%s !nAn admin gave %s %s with %i ammo.", g_strPluginPrefix, strTargetName, g_strWeapons[ iWeapon ], iAmmo );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s gave %s %s with %i ammo.", g_strPluginPrefix, strAdminName, strTargetName, g_strWeapons[ iWeapon ], iAmmo );
			#else
			case 1: client_print( 0, print_chat, "%s An admin gave %s %s with %i ammo.", g_strPluginPrefix, strTargetName, g_strWeapons[ iWeapon ], iAmmo );
			case 2:	client_print( 0, print_chat, "%s Admin %s gave %s %s with %i ammo.", g_strPluginPrefix, strAdminName, strTargetName, g_strWeapons[ iWeapon ], iAmmo );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) gave %s (%s) %s with %i ammo.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTargetName, strTargetAuthID, g_strWeapons[ iWeapon ], iAmmo );
	}
	
	return PLUGIN_HANDLED;
}

/* ADMIN_LEVEL_B */
public ConCmd_BlanksNobuy( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strStatus[ 8 ], iStatus;
	
	switch( read_argc( ) ) {
		case 2: {
			iStatus = 0;
		}
		
		case 3: {
			read_argv( 2, strStatus, 7 );
			iStatus = str_to_num( strStatus );
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	iStatus = Clamp( iStatus, 0, 1 );
	
	new bool:bBlanks;
	new strCommand[ 32 ], strTarget[ 32 ];
	read_argv( 0, strCommand, 31 );
	read_argv( 1, strTarget, 31 );
	
	( strCommand[ 4 ] == 'b' ) ? ( bBlanks = true ) : ( bBlanks = false );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			if( bBlanks ) {
				iStatus ? set_user_hitzones( iTempID, 0, 0 ) : set_user_hitzones( iTempID, 0, 255 );
			} else {
				iStatus ? SetBit( g_bitHasNoBuy, iTempID ) : ClearBit( g_bitHasNoBuy, iTempID );
			}
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin set %s %i on %s players.", g_strPluginPrefix, bBlanks ? "blank bullets" : "nobuy", iStatus, strTeam );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s set %s %i on %s players.", g_strPluginPrefix, strAdminName, bBlanks ? "blank bullets" : "nobuy", iStatus, strTeam );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin set %s %i on %s players.", g_strPluginPrefix, bBlanks ? "blank bullets" : "nobuy", iStatus, strTeam );
			case 2:	client_print( 0, print_chat, "%s Admin %s set %s %i on %s players.", g_strPluginPrefix, strAdminName, bBlanks ? "blank bullets" : "nobuy", iStatus, strTeam );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) set %s %i on %s players.", g_strPluginPrefix, strAdminName, strAdminAuthID, bBlanks ? "blank bullets" : "nobuy", iStatus, strTeam );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		if( bBlanks ) {
			iStatus ? set_user_hitzones( iTarget, 0, 0 ) : set_user_hitzones( iTarget, 0, 255 );
		} else {
			iStatus ? SetBit( g_bitHasNoBuy, iTarget ) : ClearBit( g_bitHasNoBuy, iTarget );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin set %s %i on %s.", g_strPluginPrefix, bBlanks ? "blank bullets" : "nobuy", iStatus, strTargetName );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s set %s %i on %s.", g_strPluginPrefix, strAdminName, bBlanks ? "blank bullets" : "nobuy", iStatus, strTargetName );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin set %s %i on %s.", g_strPluginPrefix, bBlanks ? "blank bullets" : "nobuy", iStatus, strTargetName );
			case 2:	client_print( 0, print_chat, "%s Admin %s set %s %i on %s.", g_strPluginPrefix, strAdminName, bBlanks ? "blank bullets" : "nobuy", iStatus, strTargetName );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) set %s %i on %s (%s).", g_strPluginPrefix, strAdminName, strAdminAuthID, bBlanks ? "blank bullets" : "nobuy", iStatus, strTargetName, strTargetAuthID );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Un_Bury( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	if( read_argc( ) > 2 ) {
		console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new bool:bBury;
	new strCommand[ 32 ], strTarget[ 32 ];
	read_argv( 0, strCommand, 31 );
	read_argv( 1, strTarget, 31 );
	
	( strCommand[ 4 ] == 'b' ) ? ( bBury = true ) : ( bBury = false );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			Bury_Unbury( iTempID, bBury );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin %s %s players.", g_strPluginPrefix, bBury ? "buried" : "unburied", strTeam );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s %s %s players.", g_strPluginPrefix, strAdminName, bBury ? "buried" : "unburied", strTeam );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin %s %s players.", g_strPluginPrefix, bBury ? "buried" : "unburied", strTeam );
			case 2:	client_print( 0, print_chat, "%s Admin %s %s %s players.", g_strPluginPrefix, strAdminName, bBury ? "buried" : "unburied", strTeam );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) %s %s players.", g_strPluginPrefix, strAdminName, strAdminAuthID, bBury ? "buried" : "unburied", strTeam );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		Bury_Unbury( iTarget, bBury );
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin %s %s.", g_strPluginPrefix, bBury ? "buried" : "unburied", strTargetName );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s %s %s.", g_strPluginPrefix, strAdminName, bBury ? "buried" : "unburied", strTargetName );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin %s %s.", g_strPluginPrefix, bBury ? "buried" : "unburied", strTargetName );
			case 2:	client_print( 0, print_chat, "%s Admin %s %s %s.", g_strPluginPrefix, strAdminName, bBury ? "buried" : "unburied", strTargetName );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) %s %s (%s).", g_strPluginPrefix, strAdminName, strAdminAuthID, bBury ? "buried" : "unburied", strTargetName, strTargetAuthID );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Disarm( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	if( read_argc( ) > 2 ) {
		console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new strTarget[ 32 ];
	read_argv( 1, strTarget, 31 );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			StripPlayerWeapons( iTempID );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin disarmed %s players.", g_strPluginPrefix, strTeam );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s disarmed %s players.", g_strPluginPrefix, strAdminName, strTeam );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin disarmed %s players.", g_strPluginPrefix, strTeam );
			case 2:	client_print( 0, print_chat, "%s Admin %s disarmed %s players.", g_strPluginPrefix, strAdminName, strTeam );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) disarmed %s players.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTeam );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		StripPlayerWeapons( iTarget );
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin disarmed %s.", g_strPluginPrefix, strTargetName );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s disarmed %s.", g_strPluginPrefix, strAdminName, strTargetName );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin disarmed %s.", g_strPluginPrefix, strTargetName );
			case 2:	client_print( 0, print_chat, "%s Admin %s disarmed %s.", g_strPluginPrefix, strAdminName, strTargetName );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) disarmed %s (%s).", g_strPluginPrefix, strAdminName, strAdminAuthID, strTargetName, strTargetAuthID );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_UberslapFire( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	if( read_argc( ) > 2 ) {
		console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new bool:bFire;
	new strCommand[ 32 ], strTarget[ 32 ];
	read_argv( 0, strCommand, 31 );
	read_argv( 1, strCommand, 31 );
	
	( strCommand[ 4 ] == 'f' ) ? ( bFire = true ) : ( bFire = false );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	new strPlayer[ 2 ];
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			if( bFire ) {
				strPlayer[ 0 ] = iTempID;
				SetBit( g_bitIsOnFire, iTempID );
				
				IgnitePlayer( strPlayer );
				IgniteEffects( strPlayer );
			} else {
				StripPlayerWeapons( iTempID );
				set_task( 0.1, "Task_UberslapPlayer", TASK_UBERSLAP + iTempID, _, _, "a", 100 );
			}
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin %s %s players%s.", g_strPluginPrefix, bFire ? "set" : "uberslapped", strTeam, bFire ? " on fire" : "" );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s %s %s players%s.", g_strPluginPrefix, strAdminName, bFire ? "set" : "uberslapped", strTeam, bFire ? " on fire" : "" );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin %s %s players%s.", g_strPluginPrefix, bFire ? "set" : "uberslapped", strTeam, bFire ? " on fire" : "" );
			case 2:	client_print( 0, print_chat, "%s Admin %s %s %s players%s.", g_strPluginPrefix, strAdminName, bFire ? "set" : "uberslapped", strTeam, bFire ? " on fire" : "" );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) %s %s players%s.", g_strPluginPrefix, strAdminName, strAdminAuthID, bFire ? "set" : "uberslapped", strTeam, bFire ? " on fire" : "" );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		if( bFire ) {
			strPlayer[ 0 ] = iTarget;
			SetBit( g_bitIsOnFire, iTarget );
			
			IgnitePlayer( strPlayer );
			IgniteEffects( strPlayer );
		} else {
			StripPlayerWeapons( iTarget );
			set_task( 0.1, "Task_UberslapPlayer", TASK_UBERSLAP + iTarget, _, _, "a", 100 );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin %s %s%s.", g_strPluginPrefix, bFire ? "set" : "uberslapped", strTargetName, bFire ? " on fire" : "" );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s %s %s%s.", g_strPluginPrefix, strAdminName, bFire ? "set" : "uberslapped", strTargetName, bFire ? " on fire" : "" );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin %s %s%s.", g_strPluginPrefix, bFire ? "set" : "uberslapped", strTargetName, bFire ? " on fire" : "" );
			case 2:	client_print( 0, print_chat, "%s Admin %s %s %s%s.", g_strPluginPrefix, strAdminName, bFire ? "set" : "uberslapped", strTargetName, bFire ? " on fire" : "" );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) %s %s (%s)%s.", g_strPluginPrefix, strAdminName, strAdminAuthID, bFire ? "set" : "uberslapped", strTargetName, strTargetAuthID, bFire ? " on fire" : "" );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_AutoSlay( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strStatus[ 8 ], iStatus;
	
	switch( read_argc( ) ) {
		case 2: {
			iStatus = 0;
		}
		
		case 3: {
			read_argv( 2, strStatus, 7 );
			iStatus = str_to_num( strStatus );
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	iStatus = Clamp( iStatus, 0, 1 );
	
	new strTarget[ 32 ];
	read_argv( 1, strTarget, 31 );
	
	new strAdminName[ 32 ], strAdminAuthID[ 32 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			if( iStatus ) {
				SetBit( g_bitHasAutoSlay, iTempID );
				
				if( CheckBit( g_bitIsAlive, iTempID ) ) {
					user_kill( iTempID );
				}
			} else {
				ClearBit( g_bitHasAutoSlay, iTempID );
			}
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin set auto slay on %s players to %s.", g_strPluginPrefix, strTeam, iStatus ? "On" : "Off" );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s set auto slay on %s players to %s.", g_strPluginPrefix, strAdminName, strTeam, iStatus ? "On" : "Off" );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin set auto slay on %s players to %s.", g_strPluginPrefix, strTeam, iStatus ? "On" : "Off" );
			case 2:	client_print( 0, print_chat, "%s Admin %s set auto slay on %s players to %s.", g_strPluginPrefix, strAdminName, strTeam, iStatus ? "On" : "Off" );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) set auto slay on %s players to %s.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTeam, iStatus ? "On" : "Off" );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		if( iStatus ) {
			SetBit( g_bitHasAutoSlay, iTarget );
			
			if( CheckBit( g_bitIsAlive, iTarget ) ) {
				user_kill( iTarget );
			}
		} else {
			ClearBit( g_bitHasAutoSlay, iTarget );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin set auto slay on %s to %s.", g_strPluginPrefix, strTargetName, iStatus ? "On" : "Off" );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s set auto slay on %s to %s.", g_strPluginPrefix, strAdminName, strTargetName, iStatus ? "On" : "Off" );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin set auto slay on %s to %s.", g_strPluginPrefix, strTargetName, iStatus ? "On" : "Off" );
			case 2:	client_print( 0, print_chat, "%s Admin %s set auto slay on %s to %s.", g_strPluginPrefix, strAdminName, strTargetName, iStatus ? "On" : "Off" );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) set auto slay on %s (%s) to %s.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTargetName, strTargetAuthID, iStatus ? "On" : "Off" );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Rocket( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	if( read_argc( ) > 2 ) {
		console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new strTarget[ 32 ];
	read_argv( 1, strTarget, 31 );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			RocketPlayer( iTempID );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin made a rocket out of %s players.", g_strPluginPrefix, strTeam );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s made a rocket out of %s players.", g_strPluginPrefix, strAdminName, strTeam );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin made a rocket out of %s players.", g_strPluginPrefix, strTeam );
			case 2:	client_print( 0, print_chat, "%s Admin %s made a rocket out of %s players.", g_strPluginPrefix, strAdminName, strTeam );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) made a rocket out of %s players.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTeam );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		RocketPlayer( iTarget );
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin made a rocket out of %s.", g_strPluginPrefix, strTargetName );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s made a rocket out of %s.", g_strPluginPrefix, strAdminName, strTargetName );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin made a rocket out of %s.", g_strPluginPrefix, strTargetName );
			case 2:	client_print( 0, print_chat, "%s Admin %s made a rocket out of %s.", g_strPluginPrefix, strAdminName, strTargetName );
			#endif
		}
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_BadAim( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strStatus[ 8 ], iStatus;
	
	switch( read_argc( ) ) {
		case 2: {
			iStatus = 0;
		}
		
		case 3: {
			read_argv( 2, strStatus, 7 );
			iStatus = str_to_num( strStatus );
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	Minimum( iStatus, 0 );
	
	new strTarget[ 32 ];
	read_argv( 1, strTarget, 31 );
	
	if( strTarget[ 0 ] == '@' ) {
		console_print( iPlayerID, "%s ERROR: you cannot give badaim to multiple players at the same time.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF );
	
	if( !iTarget ) {
		return PLUGIN_HANDLED;
	}
	
	switch( iStatus ) {
		case 0: {
			ClearBit( g_bitHasBadaim, iTarget );
		}
		
		case 1: {
			SetBit( g_bitHasBadaim, iTarget );
		}
		
		default: {
			SetBit( g_bitHasBadaim, iTarget );
			set_task( float( iStatus ), "Task_RemoveBadaim", TASK_BADAIM + iTarget );
		}
	}
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	new strTargetName[ 32 ], strTargetAuthID[ 36 ];
	get_user_name( iTarget, strTargetName, 31 );
	get_user_authid( iTarget, strTargetAuthID, 35 );
	
	switch( get_pcvar_num( g_cvarShowActivity ) ) {
		#if defined GREEN_CHAT
		case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin %s %s%s bad aim.", g_strPluginPrefix, iStatus ? "gave" : "removed", strTargetName, iStatus ? "" : "'s" );
		case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s %s %s%s bad aim.", g_strPluginPrefix, strAdminName, iStatus ? "gave" : "removed", strTargetName, iStatus ? "" : "'s" );
		#else
		case 1:	client_print( 0, print_chat, "%s An admin %s %s%s bad aim.", g_strPluginPrefix, iStatus ? "gave" : "removed", strTargetName, iStatus ? "" : "'s" );
		case 2:	client_print( 0, print_chat, "%s Admin %s %s %s%s bad aim.", g_strPluginPrefix, strAdminName, iStatus ? "gave" : "removed", strTargetName, iStatus ? "" : "'s" );
		#endif
	}
	
	log_amx( "%s Admin %s (%s) %s %s%s bad aim.", g_strPluginPrefix, strAdminName, strAdminAuthID, iStatus ? "gave" : "removed", strTargetName, strTargetAuthID, iStatus ? "" : "'s" );
	
	return PLUGIN_HANDLED;
}

public ConCmd_Slay2( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strType[ 8 ], iType;
	
	switch( read_argc( ) ) {
		case 2: {
			iType = 0;
		}
		
		case 3: {
			read_argv( 2, strType, 7 );
			iType = str_to_num( strType );
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	iType = Clamp( iType, 0, SLAY_EXPLODE );
	
	new strTarget[ 32 ];
	read_argv( 1, strTarget, 31 );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			Slay2Player( iTempID, iType );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin slayed %s players.", g_strPluginPrefix, strTeam );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s slayed %s players.", g_strPluginPrefix, strAdminName, strTeam );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin slayed %s players.", g_strPluginPrefix, strTeam );
			case 2:	client_print( 0, print_chat, "%s Admin %s slayed %s players.", g_strPluginPrefix, strAdminName, strTeam );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) slayed %s players.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTeam );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		Slay2Player( iTarget, iType );
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin slayed %s.", g_strPluginPrefix, strTargetName );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s slayed %s.", g_strPluginPrefix, strAdminName, strTargetName );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin slayed %s.", g_strPluginPrefix, strTargetName );
			case 2:	client_print( 0, print_chat, "%s Admin %s slayed %s.", g_strPluginPrefix, strAdminName, strTargetName );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) slayed %s.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTargetName );
	}
	
	return PLUGIN_HANDLED;
}

/* ADMIN_LEVEL_C */
public ConCmd_PGravity( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strGravity[ 8 ], iGravity;
	
	switch( read_argc( ) ) {
		case 2: {
			iGravity = 800;
		}
		
		case 3: {
			read_argv( 2, strGravity, 7 );
			iGravity = str_to_num( strGravity );
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	new Float:fGrav = float( iGravity ) / 800.0;
	
	new strTarget[ 32 ];
	read_argv( 1, strTarget, 31 );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			set_user_gravity( iTempID, fGrav );
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin set %s players' gravity to !g%i!n.", g_strPluginPrefix, strTeam, iGravity );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s set %s players' gravity to !g%i!n.", g_strPluginPrefix, strAdminName, strTeam, iGravity );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin set %s players' gravity to %i.", g_strPluginPrefix, strTeam, iGravity );
			case 2:	client_print( 0, print_chat, "%s Admin %s set %s players; gravity to %i.", g_strPluginPrefix, strAdminName, strTeam, iGravity );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) set %s players' gravity to %i.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTeam, iGravity );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		set_user_gravity( iTarget, fGrav );
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin set %s's gravity to !g%i!n.", g_strPluginPrefix, strTargetName, iGravity );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s set %s's gravity to !g%i!n.", g_strPluginPrefix, strAdminName, strTargetName, iGravity );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin set %s's gravity to %i.", g_strPluginPrefix, strTargetName, iGravity );
			case 2:	client_print( 0, print_chat, "%s Admin %s set %s's gravity to %i.", g_strPluginPrefix, strAdminName, strTargetName, iGravity );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) set %s players' gravity to %i.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTargetName, strTargetAuthID, iGravity );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Pass( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strPassword[ 128 ];
	read_argv( 1, strPassword, 127 );
	
	remove_quotes( strPassword );
	set_pcvar_string( g_cvarPassword, strPassword );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	switch( get_pcvar_num( g_cvarShowActivity ) ) {
		#if defined GREEN_CHAT
		case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin has set a !gpassword !nto the server.", g_strPluginAuthor );
		case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s has set a !gpassword !nto the server.", g_strPluginPrefix, strAdminName );
		#else
		case 1:	client_print( 0, print_chat, "%s An admin has set a password to the server.", g_strPluginPrefix );
		case 2:	client_print( 0, print_chat, "%s Admin %s has set a password to the server.", g_strPluginPrefix, strAdminName );
		#endif
	}
	
	log_amx( "%s Admin %s (%s) has set a password to the server (%s).", g_strPluginPrefix, strAdminName, strAdminAuthID, strPassword );
	
	return PLUGIN_HANDLED;
}

public ConCmd_NoPass( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 1 ) ) {
		return PLUGIN_HANDLED;
	}
	
	set_pcvar_string( g_cvarPassword, "" );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	switch( get_pcvar_num( g_cvarShowActivity ) ) {
		#if defined GREEN_CHAT
		case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin has removed the !gpassword !nfrom the server.", g_strPluginAuthor );
		case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s has removed the !gpassword !nfrom the server.", g_strPluginPrefix, strAdminName );
		#else
		case 1:	client_print( 0, print_chat, "%s An admin has removed the password from the server.", g_strPluginPrefix );
		case 2:	client_print( 0, print_chat, "%s Admin %s has removed the password from the server.", g_strPluginPrefix, strAdminName );
		#endif
	}
	
	log_amx( "%s Admin %s (%s) has reset the password from the server.", g_strPluginPrefix, strAdminName, strAdminAuthID );
	
	return PLUGIN_HANDLED;
}

public ConCmd_IP( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 1 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new bool:bAllPlayers;
	
	switch( read_argc( ) ) {
		case 1: {
			bAllPlayers = true;
		}
		
		case 2: {
			bAllPlayers = false;
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	if( bAllPlayers ) {
		new iPlayers[ 32 ], iNum, iTempID;
		get_players( iPlayers, iNum );
		
		console_print( iPlayerID, "%s The following is the list of IP of all players.", g_strPluginPrefix );
		console_print( iPlayerID, "#id IP Name" );
		
		new strPlayerName[ 32 ], strNumber[ 8 ], strPlayerIP[ 32 ];
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			get_user_name( iTempID, strPlayerName, 31 );
			get_user_ip( iTempID, strPlayerIP, 15, IP_PORT );
			num_to_str( iTempID, strNumber, 7 );
			
			console_print( iPlayerID, "#%d %s %s", strNumber, strPlayerIP, strPlayerName );
		}
		
		console_print( iPlayerID, "%s %d players listed in total.", g_strPluginPrefix, iNum );
		
		return PLUGIN_HANDLED;
	}
	
	
	new strTarget[ 32 ];
	read_argv( 1, strTarget, 31 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		console_print( iPlayerID, "%s The following is the list of IP of all players.", g_strPluginPrefix );
		console_print( iPlayerID, "#id IP Name" );
		
		new strPlayerName[ 32 ], strNumber[ 8 ], strPlayerIP[ 32 ];
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			get_user_name( iTempID, strPlayerName, 31 );
			get_user_ip( iTempID, strPlayerIP, 15, IP_PORT );
			num_to_str( iTempID, strNumber, 7 );
			
			console_print( iPlayerID, "#%d %s %s", strNumber, strPlayerIP, strPlayerName );
		}
		
		console_print( iPlayerID, "%s %d players listed in total.", g_strPluginPrefix, iNum );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Transfer( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strTeamDest[ 8 ], iTeam;
	
	switch( read_argc( ) ) {
		case 2: {
			iTeam = AUTO;
		}
		
		case 3: {
			read_argv( 2, strTeamDest, 7 );
			
			switch( strTeamDest[ 0 ] ) {
				case 't', 'T': {
					iTeam = TERRORIST;
					formatex( strTeamDest, 31, "TERRORIST" );
				}
				
				case 'c', 'C': {
					iTeam = COUNTER;
					formatex( strTeamDest, 31, "COUNTER-TERRORIST" );
				}
				
				case 's', 'S': {
					iTeam = SPECTATOR;
					formatex( strTeamDest, 31, "SPECTATOR" );
				}
				
				default: {
					console_print( iPlayerID, "%s ERROR: invalid team name.", g_strPluginPrefix );
					console_print( iPlayerID, "%s VALID TEAM NAMES: t, ct and spec.", g_strPluginPrefix );
					
					return PLUGIN_HANDLED;
				}
			}
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	new strTarget[ 32 ];
	read_argv( 1, strTarget, 31 );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( strTarget[ 0 ] == '@' ) {
		new iPlayers[ 32 ], iNum, iTempID;
		new strTeam[ 32 ];
		
		switch( strTarget[ 1 ] ) {
			case 't', 'T': {
				formatex( strTeam, 31, "TERRORIST" );
				get_players( iPlayers, iNum, "ae", "TERRORIST" );
			}
			
			case 'c', 'C': {
				formatex( strTeam, 31, "COUNTER-TERRORIST" );
				get_players( iPlayers, iNum, "ae", "CT" );
			}
			
			case 's', 'S': {
				formatex( strTeam, 31, "SPECTATOR" );
				get_players( iPlayers, iNum, "ae", "SPECTATOR" );
			}
			
			case 'a', 'A': {
				formatex( strTeam, 31, "ALL" );
				get_players( iPlayers, iNum, "a" );
			}
			
			default: {
				console_print( iPlayerID, "%s ERROR: invalid 3rd argument.", g_strPluginPrefix );
				console_print( iPlayerID, "%s VALID ARGUMENTS: @t,  @ct, @spec and @all.", g_strPluginPrefix );
				
				return PLUGIN_HANDLED;
			}
		}
		
		if( !iNum ) {
			console_print( iPlayerID, "%s ERROR: no players found in such team.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
			iTempID = iPlayers[ iLoop ];
			
			if( Access( iTempID, ADMIN_IMMUNITY ) ) {
				continue;
			}
			
			switch( iTeam ) {
				case TERRORIST: {
					cs_set_user_team( iTempID, CS_TEAM_T, CS_T_MODEL );
					
					if( CheckBit( g_bitIsAlive, iTempID ) ) {
						ExecuteHamB( Ham_CS_RoundRespawn, iTempID );
					}
				}
				
				case COUNTER: {
					cs_set_user_team( iTempID, CS_TEAM_CT, CS_CT_MODEL );
					
					if( CheckBit( g_bitIsAlive, iTempID ) ) {
						ExecuteHamB( Ham_CS_RoundRespawn, iTempID );
					}
				}
				
				case AUTO: {
					switch( cs_get_user_team( iTempID ) ) {
						case CS_TEAM_T: {
							cs_set_user_team( iTempID, CS_TEAM_CT, CS_CT_MODEL );
							
							if( CheckBit( g_bitIsAlive, iTempID ) ) {
								ExecuteHamB( Ham_CS_RoundRespawn, iTempID );
							}
						}
						
						case CS_TEAM_CT: {
							cs_set_user_team( iTempID, CS_TEAM_T, CS_T_MODEL );
							
							if( CheckBit( g_bitIsAlive, iTempID ) ) {
								ExecuteHamB( Ham_CS_RoundRespawn, iTempID );
							}
						}
					}
				}
				
				case SPECTATOR: {
					if( !CheckBit( g_bitIsAlive, iTempID ) ) {
						user_silentkill( iTempID );
					}
					
					cs_set_user_team( iTempID, CS_TEAM_SPECTATOR );
				}
			}
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin transfered %s players to the %s team.", g_strPluginPrefix, strTeam, strTeamDest );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s transfered %s players to the %s team.", g_strPluginPrefix, strAdminName, strTeam, strTeamDest );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin transfered %s players to the %s team.", g_strPluginPrefix, strTeam, strTeamDest );
			case 2:	client_print( 0, print_chat, "%s Admin %s transfered %s players to the %s team.", g_strPluginPrefix, strAdminName, strTeam, strTeamDest );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) transfered %s players to the %s team.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTeam, strTeamDest );
	} else {
		new iTarget = cmd_target( iPlayerID, strTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
		
		if( !iTarget ) {
			return PLUGIN_HANDLED;
		}
		
		new strTargetName[ 32 ], strTargetAuthID[ 36 ];
		get_user_name( iTarget, strTargetName, 31 );
		get_user_authid( iTarget, strTargetAuthID, 35 );
		
		switch( iTeam ) {
			case TERRORIST: {
				cs_set_user_team( iTarget, CS_TEAM_T, CS_T_MODEL );
				ExecuteHamB( Ham_CS_RoundRespawn, iTarget );
			}
			
			case COUNTER: {
				cs_set_user_team( iTarget, CS_TEAM_CT, CS_CT_MODEL );
				ExecuteHamB( Ham_CS_RoundRespawn, iTarget );
			}
			
			case AUTO: {
				switch( cs_get_user_team( iTarget ) ) {
					case CS_TEAM_T: {
						formatex( strTeamDest, 31, "COUNTER-TERRORIST" );
						
						cs_set_user_team( iTarget, CS_TEAM_CT, CS_CT_MODEL );
						ExecuteHamB( Ham_CS_RoundRespawn, iTarget );
					}
					
					case CS_TEAM_CT: {
						formatex( strTeamDest, 31, "TERRORIST" );
						
						cs_set_user_team( iTarget, CS_TEAM_T, CS_T_MODEL );
						ExecuteHamB( Ham_CS_RoundRespawn, iTarget );
					}
				}
			}
			
			case SPECTATOR: {
				user_silentkill( iTarget );
				cs_set_user_team( iTarget, CS_TEAM_SPECTATOR );
			}
		}
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin transfered %s to the %s team.", g_strPluginPrefix, strTargetName, strTeamDest );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s transfered %s to the %s team.", g_strPluginPrefix, strAdminName, strTargetName, strTeamDest );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin transfered %s to the %s team.", g_strPluginPrefix, strTargetName, strTeamDest );
			case 2:	client_print( 0, print_chat, "%s Admin %s transfered %s to the %s team.", g_strPluginPrefix, strAdminName, strTargetName, strTeamDest );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) transfered %s (%s) to the %s team.", g_strPluginPrefix, strAdminName, strAdminAuthID, strTargetName, strTargetAuthID, strTeamDest );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_Swap( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 3 ) ) {
		return PLUGIN_HANDLED;
	}
	
	if( read_argc( ) > 3 ) {
		console_print( iPlayerID, "%s ERROR: you can only swap two players at a time.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new strTarget1[ 32 ], strTarget2[ 32 ];
	read_argv( 1, strTarget1, 31 );
	read_argv( 2, strTarget2, 31 );
	
	new iTarget1 = cmd_target( iPlayerID, strTarget1, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
	new iTarget2 = cmd_target( iPlayerID, strTarget2, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_ONLY_ALIVE );
	
	if( !iTarget1 || !iTarget2 ) {
		return PLUGIN_HANDLED;
	}
	
	new CsTeams:iTeam1 = cs_get_user_team( iTarget1 );
	new CsTeams:iTeam2 = cs_get_user_team( iTarget2 );
	
	if( iTeam1 == iTeam2 ) {
		console_print( iPlayerID, "%s ERROR: you cannot swap two players in the same team.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	if( iTeam1 == CS_TEAM_UNASSIGNED || iTeam2 == CS_TEAM_UNASSIGNED ) {
		console_print( iPlayerID, "%s ERROR: you cannot transfer a player that is not assigned a team in the first place.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	if( iTeam1 == CS_TEAM_SPECTATOR ) {
		user_silentkill( iTarget2 );
	}
	
	if( iTeam2 == CS_TEAM_SPECTATOR ) {
		user_silentkill( iTarget1 );
	}
	
	cs_set_user_team( iTarget1, iTeam2 );
	cs_set_user_team( iTarget2, iTeam1 );
	
	if( CheckBit( g_bitIsAlive, iTarget1 ) ) {
		ExecuteHamB( Ham_CS_RoundRespawn, iTarget1 );
	}
	
	if( CheckBit( g_bitIsAlive, iTarget2 ) ) {
		ExecuteHamB( Ham_CS_RoundRespawn, iTarget2 );
	}
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	new strTarget1Name[ 32 ], strTarget1AuthID[ 36 ];
	get_user_name( iTarget1, strTarget1Name, 31 );
	get_user_authid( iTarget1, strTarget1AuthID, 35 );
	
	new strTarget2Name[ 32 ], strTarget2AuthID[ 36 ];
	get_user_name( iTarget2, strTarget2Name, 31 );
	get_user_authid( iTarget2, strTarget2AuthID, 35 );
	
	switch( get_pcvar_num( g_cvarShowActivity ) ) {
		#if defined GREEN_CHAT
		case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin swapped !g%s !nand !g%s!n.", g_strPluginPrefix, strTarget1Name, strTarget2Name );
		case 2: ColorChat( 0, NORMAL, "!g%s !nAdmin %s swapped !g%s !nand !g%s!n.", g_strPluginPrefix, strAdminName, strTarget1Name, strTarget2Name );
		#else
		case 1: client_print( 0, print_chat, "%s An admin swapped !g%s !nand !g%s!n.", g_strPluginPrefix, strTarget1Name, strTarget2Name );
		case 2:	client_print( 0, print_chat, "%s Admin %s swapped !g%s !nand !g%s!n.", g_strPluginPrefix, strAdminName, strTarget1Name, strTarget2Name );
		#endif
	}
	
	log_amx( "%s Admin %s (%s) swapped %s (%s) and %s (%s).", g_strPluginPrefix, strAdminName, strAdminAuthID, strTarget1Name, strTarget1AuthID, strTarget2Name, strTarget2AuthID );
	
	return PLUGIN_HANDLED;
}

public ConCmd_SwapTeams( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 1 ) ) {
		return PLUGIN_HANDLED;
	}
	
	if( read_argc( ) > 1 ) {
		console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new iPlayers[ 32 ], iNum, iTempID;
	get_players( iPlayers, iNum );
	
	for( new iLoop = 0; iLoop < iNum; iLoop++ ) {
		iTempID = iPlayers[ iLoop ];
		
		switch( cs_get_user_team( iTempID ) ) {
			case CS_TEAM_CT: {
				cs_set_user_team( iTempID, CS_TEAM_T );
			}
			
			case CS_TEAM_T: {
				cs_set_user_team( iTempID, CS_TEAM_CT );
			}
		}
		
		if( CheckBit( g_bitIsAlive, iTempID ) ) {
			ExecuteHamB( Ham_CS_RoundRespawn, iTempID );
		}
	}
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	switch( get_pcvar_num( g_cvarShowActivity ) ) {
		#if defined GREEN_CHAT
		case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin swapped both teams.", g_strPluginPrefix );
		case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s swapped both teams.", g_strPluginPrefix, strAdminName );
		#else
		case 1: client_print( 0, print_chat, "%s An admin swapped both teams.", g_strPluginPrefix );
		case 2:	client_print( 0, print_chat, "%s Admin %s swapped both teams.", g_strPluginPrefix, strAdminName );
		#endif
	}
	
	log_amx( "%s Admin %s (%s) swapped both teams.", g_strPluginPrefix, strAdminName, strAdminAuthID );
	
	return PLUGIN_HANDLED;
}

/* ADMIN_LEVEL_D */
public ConCmd_HSOnly( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strStatus[ 8 ], iStatus;
	read_argv( 1, strStatus, 7 );
	
	iStatus = str_to_num( strStatus );
	iStatus = Clamp( iStatus, 0, 1 );
	
	( iStatus ) ? ( set_user_hitzones( 0, 0, 2 ) ) : ( set_user_hitzones( 0, 0, 255 ) );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	switch( get_pcvar_num( g_cvarShowActivity ) ) {
		#if defined GREEN_CHAT
		case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin has set headshot only mode to %s.", g_strPluginPrefix, iStatus ? "ON" : "OFF" );
		case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s has set headshot only mode to %s.", g_strPluginPrefix, strAdminName, iStatus ? "ON" : "OFF" );
		#else
		case 1:	client_print( 0, print_chat, "%s An admin has set headshot only mode to %s.", g_strPluginPrefix, iStatus ? "ON" : "OFF" );
		case 2:	client_print( 0, print_chat, "%s Admin %s has set headshot only mode to %s.", g_strPluginPrefix, strAdminName, iStatus ? "ON" : "OFF" );
		#endif
	}
	
	log_amx( "%s Admin %s (%s) has set headshot only mode to %s.", g_strPluginPrefix, strAdminName, strAdminAuthID, iStatus ? "ON" : "OFF" );
	
	return PLUGIN_HANDLED;
}

public ConCmd_Extend( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	if( read_argc( ) > 2 ) {
		return PLUGIN_HANDLED;
	}
	
	new strTime[ 8 ], iTime;
	read_argv( 1, strTime, 7 );
	
	iTime = str_to_num( strTime );
	
	if( iTime < MIN_EXTEND || iTime > MAX_EXTEND ) {
		console_print( iPlayerID, "%s ERROR: the extend time must be between %i and %i.", g_strPluginPrefix, MIN_EXTEND, MAX_EXTEND );
		
		return PLUGIN_HANDLED;
	}
	
	g_iTotalExtendTime += iTime;
	
	if( g_iTotalExtendTime > get_pcvar_num( g_pcvarMaxExtendTime ) ) {
		console_print( iPlayerID, "%s ERROR: you are not allowed to extend this map any more.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	set_pcvar_float( g_cvarTimeLimit, get_pcvar_float( g_cvarTimeLimit ) + iTime );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	switch( get_pcvar_num( g_cvarShowActivity ) ) {
		#if defined GREEN_CHAT
		case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin has extended this map for an additional !g%i minutes!n.", g_strPluginPrefix, iTime );
		case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s has extended this map for an additional !g%i minutes!n.", g_strPluginPrefix, strAdminName, iTime );
		#else
		case 1:	client_print( 0, print_chat, "%s An admin has extended this map for an additional %i minutes.", g_strPluginPrefix, iTime );
		case 2:	client_print( 0, print_chat, "%s Admin %s has extended this map for an additional %i minutes.", g_strPluginPrefix, strAdminName, iTime );
		#endif
	}
	
	log_amx( "%s Admin %s (%s) extended the map %i minutes.", g_strPluginPrefix, strAdminName, strAdminAuthID, iTime );
	
	return PLUGIN_HANDLED;
}

public ConCmd_Un_Lock( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 1 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strCommand[ 32 ], strTeam[ 32 ];
	read_argv( 0, strCommand, 31 );
	read_argv( 1, strTeam, 31 );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	new bool:bLock, iTeam;
	
	if( strCommand[ 4 ] == 'l' ) {
		bLock = true;
		
		if( read_argc( ) == 1 ) {
			new strCmd[ 32 ], strInfo[ 128 ], iFlag;
			get_concmd( iCid, strCmd, 31, iFlag, strInfo, 127, iLevel );
			
			console_print( iPlayerID, "Usage: %s %s", strCmd, strInfo );
			
			return PLUGIN_HANDLED;
		}
	} else {
		bLock = false;
		
		if( read_argc( ) == 1 ) {
			for( new iLoop = 0; iLoop < TEAMS_MAX; iLoop++ ) {
				g_bBlockTeamJoin[ iLoop ] = false;
			}
			
			switch( get_pcvar_num( g_cvarShowActivity ) ) {
				#if defined GREEN_CHAT
				case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin unlocked all teams.", g_strPluginPrefix );
				case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s unlocked all teams.", g_strPluginPrefix, strAdminName );
				#else
				case 1:	client_print( 0, print_chat, "%s An admin unlocked all teams.", g_strPluginPrefix );
				case 2:	client_print( 0, print_chat, "%s Admin %s unlocked all teams.", g_strPluginPrefix, strAdminName );
				#endif
			}
			
			log_amx( "%s Admin %s (%s) unlocked all teams.", g_strPluginPrefix, strAdminName, strAdminAuthID );
			
			return PLUGIN_HANDLED;
		}
	}
	
	switch( strTeam[ 0 ] ) {
		case 't', 'T': {
			iTeam = TERRORIST;
		}
		
		case 'c', 'C': {
			iTeam = COUNTER;
		}
		
		case 'a', 'A': {
			iTeam = AUTO;
		}
		
		case 's', 'S': {
			iTeam = SPECTATOR;
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: no valid team found.", g_strPluginPrefix );
			console_print( iPlayerID, "%s VALID TEAMS: T, CT, AUTO and SPEC.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	if( bLock ) {
		g_bBlockTeamJoin[ iTeam ] = true;
	} else {
		g_bBlockTeamJoin[ iTeam ] = false;
	}
	
	switch( get_pcvar_num( g_cvarShowActivity ) ) {
		#if defined GREEN_CHAT
		case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin locked the %s team.", g_strPluginPrefix, g_strLockerTeamNames[ iTeam ] );
		case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s locked the %s team,", g_strPluginPrefix, strAdminName, g_strLockerTeamNames[ iTeam ] );
		#else
		case 1:	client_print( 0, print_chat, "%s An admin locked the %s team.", g_strPluginPrefix, g_strLockerTeamNames[ iTeam ] );
		case 2:	client_print( 0, print_chat, "%s Admin %s locked the %s team.", g_strPluginPrefix, strAdminName, g_strLockerTeamNames[ iTeam ] );
		#endif
	}
	
	log_amx( "%s Admin %s (%s) locked the %s team.", g_strPluginPrefix, strAdminName, strAdminAuthID, g_strLockerTeamNames[ iTeam ] );
	
	return PLUGIN_HANDLED;
}

public ConCmd_Gravity( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 1 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strGravity[ 8 ], iGravity;
	
	switch( read_argc( ) ) {
		case 1: {
			console_print( iPlayerID, "%s Current gravity value: %i.", g_strPluginPrefix, get_pcvar_num( g_cvarGravity ) );
			console_print( iPlayerID, "%s Default value is: 800.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
		
		case 2: {
			read_argv( 1, strGravity, 7 );
			iGravity = str_to_num( strGravity );
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	set_pcvar_num( g_cvarGravity, iGravity );
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	switch( get_pcvar_num( g_cvarShowActivity ) ) {
		#if defined GREEN_CHAT
		case 1:     ColorChat( 0, NORMAL, "!g%s !nAn admin set gravity to !g%i!n.", g_strPluginPrefix, iGravity );
		case 2:     ColorChat( 0, NORMAL, "!g%s !nAdmin %s set gravity to !g%i!n.", g_strPluginPrefix, strAdminName, iGravity );
		#else
		case 1:     client_print( 0, print_chat, "%s An admin set gravity to %i.", g_strPluginPrefix, iGravity );
		case 2:     client_print( 0, print_chat, "%s Admin %s set gravity to %i.", g_strPluginPrefix, strAdminName, iGravity );
		#endif
	}
	
	log_amx( "%s Admin %s (%s) set gravity to %i.", g_strPluginPrefix, strAdminName, strAdminAuthID, iGravity );
	
	return PLUGIN_HANDLED;
}

/* Server Rcon Commands */
public ConCmd_NoMoreRcon( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 1 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strCommand[ 32 ];
	read_argv( 0, strCommand, 31 );
	
	if( strCommand[ 5 ] == 'a'&& strCommand[ 9 ] == 'y' ) {
		console_print( iPlayerID, "%s If you wish to change the gravity, please use amx_gravity instead.", g_strPluginPrefix );
		
		return PLUGIN_CONTINUE;
	}
	
	/*
		In here we are checking if the admin has inputed only the command
		(that means he wishes to get the value of that cvar) so we print its
		value, or that he wants to change its value.
	*/
	new strArgument[ 32 ];
	
	if( read_argc( ) > 1 ) {
		read_argv( 1, strArgument, 31 );
		
		set_cvar_string( strCommand, strArgument );
		console_print( iPlayerID, "%s ^"%s^" ^"%s^"", g_strPluginPrefix, strCommand, strArgument );
		
		new strAdminName[ 32 ], strAdminAuthID[ 36 ];
		get_user_name( iPlayerID, strAdminName, 31 );
		get_user_authid( iPlayerID, strAdminAuthID, 35 );
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin has set ^"%s^" to ^"%s^".", g_strPluginPrefix, strCommand, strArgument );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s has set ^"%s^" to ^"%s^".", g_strPluginPrefix, strAdminName, strCommand, strArgument );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin has set ^"%s^" to ^"%s^".", g_strPluginPrefix, strCommand, strArgument );
			case 2:	client_print( 0, print_chat, "%s Admin %s has set ^"%s^" to ^"%s^".", g_strPluginPrefix, strAdminName, strCommand, strArgument );
			#endif
		}
		
		log_amx( "Admin %s (%s) has set ^"%s^" to ^"%s^".", strAdminName, strAdminAuthID, strCommand, strArgument );
	} else {
		get_cvar_string( strCommand, strArgument, 31 );
		
		console_print( iPlayerID, "%s ^"%s^" ^"%s^"", g_strPluginPrefix, strCommand, strArgument );
	}
	
	return PLUGIN_HANDLED;
}

/* Other Console Commands */
public ConCmd_ReloadCvars( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 1 ) ) {
		return PLUGIN_HANDLED;
	}
	
	if( read_argc( ) > 1 ) {
		console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	ReloadCvars( );
	console_print( iPlayerID, "%s All cvars have been reloaded. Changes should take place instantely.", g_strPluginPrefix );
	
	return PLUGIN_HANDLED;
}

public ConCmd_RestartServer( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 1 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strTimer[ 8 ], iTimer;
	
	switch( read_argc( ) ) {
		case 1: {
			iTimer = DEF_TIMER;
		}
		
		case 2: {
			read_argv( 1, strTimer, 4 );
			iTimer = str_to_num( strTimer );
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( iTimer == -1 ) {
		if( task_exists( TASK_COUNTDOWN_RESTART ) ) {
			remove_task( TASK_COUNTDOWN_RESTART );
			
			switch( get_pcvar_num( g_cvarShowActivity ) ) {
				#if defined GREEN_CHAT
				case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin has just canceled server restart.", g_strPluginPrefix );
				case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s has just canceled server restart.", g_strPluginPrefix, strAdminName );
				#else
				case 1:	client_print( 0, print_chat, "%s An admin has just canceled server restart.", g_strPluginPrefix );
				case 2:	client_print( 0, print_chat, "%s Admin %s has just canceled server restart.", g_strPluginPrefix, strAdminName );
				#endif
			}
			
			log_amx( "%s Admin %s (%s) has just canceled server restart.", g_strPluginPrefix, strAdminName, strAdminAuthID );
		} else {
			console_print( iPlayerID, "%s ERROR: there is no countdown in progess to cancel.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	if( task_exists( TASK_COUNTDOWN_RESTART ) ) {
		console_print( iPlayerID, "%s Another admin has already started a timer to restart the server.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	if( task_exists( TASK_COUNTDOWN_RESTARTROUND ) || task_exists( TASK_COUNTDOWN_SHUTDOWN ) ) {
		console_print( iPlayerID, "%s Another countdown is already in progress.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	if( iTimer < MIN_TIMER || iTimer > MAX_TIMER ) {
		console_print( iPlayerID, "%s Please provide a timer between %i and %i (-1 to cancel)", g_strPluginPrefix, MIN_TIMER, MAX_TIMER );
		
		return PLUGIN_HANDLED;
	}
	
	if( !iTimer ) {
		log_amx( "%s Admin %s (%s) has just restarted the server.", g_strPluginPrefix, strAdminName, strAdminAuthID );
		
		server_cmd( "reload" );
	} else {
		g_iTimeLeft = iTimer + 1;
		set_task( 1.0, "Task_Countdown_Restart", TASK_COUNTDOWN_RESTART, _, _, "a", g_iTimeLeft );
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:     ColorChat( 0, NORMAL, "!g%s !nAn admin has initiated a %i seconds timer to restart the server.", g_strPluginPrefix, iTimer );
			case 2:     ColorChat( 0, NORMAL, "!g%s !nAdmin %s has initiated a %i seconds timer to restart the server.", g_strPluginPrefix, strAdminName, iTimer );
			#else
			case 1:     client_print( 0, print_chat, "%s An admin has initiated a %i seconds timer to restart the server.", g_strPluginPrefix, iTimer );
			case 2:     client_print( 0, print_chat, "%s Admin %s has initiated a %i seconds timer to restart the server.", g_strPluginPrefix, strAdminName, iTimer );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) has inititated a %i seconds timer to restart the server.", g_strPluginPrefix, strAdminName, strAdminAuthID, iTimer );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_ShutdownServer( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 1 ) ) {
		return PLUGIN_HANDLED;
	}
	
	new strTimer[ 8 ], iTimer;
	
	switch( read_argc( ) ) {
		case 1: {
			iTimer = DEF_TIMER;
		}
		
		case 2: {
			read_argv( 1, strTimer, 7 );
			iTimer = str_to_num( strTimer );
		}
		
		default: {
			console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	new strAdminName[ 32 ], strAdminAuthID[ 36 ];
	get_user_name( iPlayerID, strAdminName, 31 );
	get_user_authid( iPlayerID, strAdminAuthID, 35 );
	
	if( iTimer == -1 ) {
		if( task_exists( TASK_COUNTDOWN_SHUTDOWN ) ) {
			remove_task( TASK_COUNTDOWN_SHUTDOWN );
			
			switch( get_pcvar_num( g_cvarShowActivity ) ) {
				#if defined GREEN_CHAT
				case 1:	ColorChat( 0, NORMAL, "%s An admin has just canceled server shutdown.", g_strPluginPrefix );
				case 2:	ColorChat( 0, NORMAL, "%s Admin %s has just canceled server shutdown.", g_strPluginPrefix, strAdminName );
				#else
				case 1:	client_print( 0, print_chat, "%s An admin has just canceled server shutdown.", g_strPluginPrefix );
				case 2:	client_print( 0, print_chat, "%s Admin %s has just canceled server shutdown.", g_strPluginPrefix, strAdminName );
				#endif
			}
			
			log_amx( "%s Admin %s (%s) has just canceled server shutdown.", g_strPluginPrefix, strAdminName, strAdminAuthID );
		} else {
			console_print( iPlayerID, "%s ERROR: there is no countdown in progess to cancel.", g_strPluginPrefix );
			
			return PLUGIN_HANDLED;
		}
	}
	
	if( task_exists( TASK_COUNTDOWN_SHUTDOWN ) ) {
		console_print( iPlayerID, "%s Another admin has already started a timer to shutdown the server.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	if( task_exists( TASK_COUNTDOWN_RESTARTROUND ) || task_exists( TASK_COUNTDOWN_RESTART ) ) {
		console_print( iPlayerID, "%s Another countdown is already in progress.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	if( iTimer < MIN_TIMER || iTimer > MAX_TIMER ) {
		console_print( iPlayerID, "%s Please provide a timer between %i and %i (-1 to cancel)", g_strPluginPrefix, MIN_TIMER, MAX_TIMER );
		
		return PLUGIN_HANDLED;
	}
	
	if( !iTimer ) {
		log_amx( "%s Admin %s (%s) has just shutdown the server.", g_strPluginPrefix, strAdminName, strAdminAuthID );
		
		server_cmd( "quit" );
	} else {
		g_iTimeLeft = iTimer + 1;
		set_task( 1.0, "Task_Countdown_Shutdown", TASK_COUNTDOWN_SHUTDOWN, _, _, "a", g_iTimeLeft );
		
		switch( get_pcvar_num( g_cvarShowActivity ) ) {
			#if defined GREEN_CHAT
			case 1:	ColorChat( 0, NORMAL, "!g%s !nAn admin has initiated a %i seconds timer to shutdown the server.", g_strPluginPrefix, iTimer );
			case 2:	ColorChat( 0, NORMAL, "!g%s !nAdmin %s has initiated a %i seconds timer to shutdown the server.", g_strPluginPrefix, strAdminName, iTimer );
			#else
			case 1:	client_print( 0, print_chat, "%s An admin has initiated a %i seconds timer to shutdown the server.", g_strPluginPrefix, iTimer );
			case 2:	client_print( 0, print_chat, "%s Admin %s has initiated a %i seconds timer to shutdown the server.", g_strPluginPrefix, strAdminName, iTimer );
			#endif
		}
		
		log_amx( "%s Admin %s (%s) has inititated a %i seconds timer to shutdown the server.", g_strPluginPrefix, strAdminName, strAdminAuthID, iTimer );
	}
	
	return PLUGIN_HANDLED;
}

public ConCmd_SearchCommands( iPlayerID, iLevel, iCid ) {
	if( !cmd_access( iPlayerID, iLevel, iCid, 2 ) ) {
		return PLUGIN_HANDLED;
	}
	
	if( read_argc( ) > 2 ) {
		console_print( iPlayerID, "%s ERROR: invalid number of arguments. See the commands usage.", g_strPluginPrefix );
		
		return PLUGIN_HANDLED;
	}
	
	new strArgument[ 32 ];
	read_argv( 1, strArgument, 31 );
	
	new iAdminFlag = get_user_flags( iPlayerID );
	new iNum = get_concmdsnum( iAdminFlag, -1 ) + 1;
	
	new iCommandsFlag, strCommand[ 64 ], strCommandInfo[ 256 ];
	new iTotal = 0;
	
	for( new iLoop = 0; iLoop <= iNum; iLoop++ ) {
		get_concmd( iLoop, strCommand, 63, iCommandsFlag, strCommandInfo, 255, iAdminFlag, -1 );
		
		if( containi( strCommand, strArgument ) != -1 ) {
			if( !iTotal ) {
				console_print( iPlayerID, "%s Results:", g_strPluginPrefix );
			}
			
			iTotal++;
			console_print( iPlayerID, "%d: %s %s", iLoop + 1, strCommand, strCommandInfo );
		}
	}
	
	if( iTotal != 0 ) {
		console_print( iPlayerID, "%s %d results found matching your request (%s).", g_strPluginPrefix, iTotal, strArgument );
	} else {
		console_print( iPlayerID, "%s No results found matching your request (%s).", g_strPluginPrefix, strArgument );
	}
	
	return PLUGIN_HANDLED;
}

/* Ham Hooks */
public Ham_Spawn_Player_Post( iPlayerID ) {
	if( !is_user_alive( iPlayerID ) ) {
		return HAM_IGNORED;
	}

	SetBit( g_bitIsAlive, iPlayerID );

	if( CheckBit( g_bitHasNoClip, iPlayerID ) ) {
		set_user_noclip( iPlayerID, 1 );
	}

	if( CheckBit( g_bitHasGodmode, iPlayerID ) ) {
		set_user_godmode( iPlayerID, 1 );
	}

	if( CheckBit( g_bitCvarStatus, CVAR_REFUND ) ) {
		#if defined GREEN_CHAT
		ColorChat( iPlayerID, NORMAL, "!g%s !nYour money has been set to !g%i!n.", g_strPluginPrefix, g_iSpawnMoney );
		#else
		client_print( iPlayerID, print_chat, "%s Your money has been set to %i.", g_strPluginPrefix, g_iSpawnMoney );
		#endif
		cs_set_user_money( iPlayerID, g_iSpawnMoney );
	}

	if( CheckBit( g_bitHasAutoSlay, iPlayerID ) ) {
		set_task( DELAY_AUTOSLAY, "Task_AutoSlayPlayer", TASK_AUTOSLAY + iPlayerID );
	}

	return HAM_IGNORED;
}

public Ham_Killed_Player_Post( iPlayerID ) {
	if( is_user_alive( iPlayerID ) ) {
		return HAM_IGNORED;
	}

	ClearBit( g_bitIsAlive, iPlayerID );

	return HAM_IGNORED;
}

public Ham_Touch_BuyZone_Pre( iEnt, iPlayerID ) {
	/*
		In here we are completely blocking buyzone touching for all
		the players who have been given nobuy by an admin, so even if
		they had tons of money, they cannot buy any weapons.
	*/
	if( CheckBit( g_bitHasNoBuy, iPlayerID ) ) {
		return HAM_SUPERCEDE;
	}

	return HAM_IGNORED;
}

// public Ham_Spawn_ArmouryEntity_Post( iEntity ) {
	// /*
		// In here I am fixing the armoury entity push bug, where it
		// can be pushed by vehicles.
	// */
	// engfunc( EngFunc_DropToFloor, iEntity );
	// set_pev( iEntity, pev_movetype, MOVETYPE_NONE );
// }

/* Events */
public Event_CurWeapon( iPlayerID ) {
	if( !CheckBit( g_bitIsAlive, iPlayerID ) ) {
		return PLUGIN_CONTINUE;
	}

	if( CheckBit( g_bitHasSpeed, iPlayerID ) ) {
		static Float:fMaxSpeed;
		fMaxSpeed = get_user_maxspeed( iPlayerID );

		fMaxSpeed *= 4.0;
		set_pev( iPlayerID, pev_maxspeed, fMaxSpeed );
	}

	/*
	Here it is ideal for giving unlimited ammo, we check
	when the ammo is low, we resupply the player with the 
	ammo, therefore he does not run out.
	*/
	if( CheckBit( g_bitHasUnAmmo, iPlayerID ) ) {
		static strWeaponName[ 32 ], iClip;
		static iWeaponID, iWeaponIndex;
		iWeaponID = read_data( 2 );
		iClip = read_data( 3 );

		switch( iWeaponID ) {
			case CSW_C4, CSW_KNIFE, CSW_HEGRENADE, CSW_FLASHBANG, CSW_SMOKEGRENADE: {
				return PLUGIN_CONTINUE;
			}
		}

		if( iClip ) {
			return PLUGIN_CONTINUE;
		}

		get_weaponname( iWeaponID, strWeaponName, 31 );
		iWeaponIndex = -1;
		
		while( ( iWeaponIndex = find_ent_by_class( iWeaponIndex, strWeaponName ) ) != 0 ) {
			if( iPlayerID == pev( iWeaponIndex, pev_owner ) ) {
				cs_set_weapon_ammo( iWeaponIndex, g_iWeaponClip[ iWeaponID ] );
			}
		}
	} else if( CheckBit( g_bitHasUnBPAmmo, iPlayerID ) ) {
		static iWeaponID;
		iWeaponID = read_data( 2 );

		switch( iWeaponID ) {
			case CSW_C4, CSW_KNIFE, CSW_HEGRENADE, CSW_FLASHBANG, CSW_SMOKEGRENADE: {
				return PLUGIN_CONTINUE;
			}
		}

		if( cs_get_user_bpammo( iPlayerID, iWeaponID ) != g_iWeaponBackpack[ iWeaponID ] ) {
			cs_set_user_bpammo( iPlayerID, iWeaponID, g_iWeaponBackpack[ iWeaponID ] );
		}
	}

	return PLUGIN_CONTINUE;
}

public Event_Damage( iPlayerID ) {
	/*
	Here is where the magic is done. Every time a player 
	receives any damage, we print the ammount of damage done
	to the receiver and that exact ammount to the inflicter.
	*/
	if( CheckBit( g_bitCvarStatus, CVAR_ABD ) ) {
		static iAttacker, iDamage;
		iAttacker = get_user_attacker( iPlayerID );
		iDamage = read_data( 2 );

		set_hudmessage( 255, 0, 0, 0.45, 0.50, 2, 0.1, 4.0, 0.1, 0.1, -1 );
		ShowSyncHudMsg( iPlayerID, g_hudSync1, "%i^n", iDamage );

		if( CheckBit( g_bitIsConnected, iAttacker ) && iPlayerID != iAttacker ) {
			if( !CheckBit( g_bitCvarStatus, CVAR_ABD_WALL ) && is_visible( iAttacker, iPlayerID ) ) {
				set_hudmessage( 0, 100, 200, -1.0, 0.55, 2, 0.1, 4.0, 0.02, 0.02, -1 );
				ShowSyncHudMsg( iAttacker, g_hudSync2, "%i^n", iDamage );
			}

			if( CheckBit( g_bitCvarStatus, CVAR_ABD_WALL ) ) {
				set_hudmessage( 0, 100, 200, -1.0, 0.55, 2, 0.1, 4.0, 0.02, 0.02, -1 );
				ShowSyncHudMsg( iAttacker, g_hudSync2, "%i^n", iDamage );
			}
		}
	}
}

public Event_SayText( iPlayerID ) {
	if( !CheckBit( g_bitCvarStatus, CVAR_ADMINLISTEN ) && !CheckBit( g_bitCvarStatus, CVAR_DEADLISTEN ) ) {
		return PLUGIN_CONTINUE;
	}

	/*
	In here is where I check the messages and prints them
	to the admins and dead players as well.
	*/
	static iSender, iReceiver, strMessage[ 256 ], iLoop, bool:bTeamMessage;
	static strChannel[ 356 ], strSenderName[ 32 ], bool:bCount[ 33 ][ 33 ];
	iSender = read_data( 1 );
	iReceiver = read_data( 0 );

	read_data( 2, strChannel, 255 );
	read_data( 4, strMessage, 255 );

	if( contain( strChannel, "Terrorist" ) != -1 ) {
		bTeamMessage = true;
	} else {
		bTeamMessage = false;
	}

	get_user_name( iSender, strSenderName, 31 );

	bCount[ iSender ][ iReceiver ] = true;

	if( iSender == iReceiver ) {
		static iPlayers[ 32 ], iNum, iTempID;
		get_players( iPlayers, iNum );

		for( iLoop = 0; iLoop < iNum; iLoop ++ ) {
			iTempID = iPlayers[ iLoop ];

			if( !bCount[ iSender ][ iTempID ] ) {
				if( CheckBit( g_bitCvarStatus, CVAR_ADMINLISTEN ) && ( get_user_flags( iTempID ) & ADMIN_LISTEN ) ) {
					if( !( bTeamMessage && ( !CheckBit( g_bitCvarStatus, CVAR_ADMINLISTEN_TEAM ) || get_user_team( iSender ) != get_user_team( iReceiver ) ) ) ) {
						message_begin( MSG_ONE, g_msgSayText, { 0, 0, 0 }, iTempID );
						write_byte( iSender );
						write_string( strChannel );
						write_string( strSenderName );
						write_string( strMessage );
						message_end( );
					}
				} else if( CheckBit( g_bitCvarStatus, CVAR_DEADLISTEN ) && !CheckBit( g_bitIsAlive, iReceiver ) && CheckBit( g_bitIsAlive, iSender ) ) {
					if( !( bTeamMessage && ( !CheckBit( g_bitCvarStatus, CVAR_DEADLISTEN_TEAM ) || get_user_team( iSender ) != get_user_team( iReceiver ) ) ) ) {
						message_begin( MSG_ONE, g_msgSayText, { 0, 0, 0 }, iTempID );
						write_byte( iSender );
						write_string( strChannel );
						write_string( strSenderName );
						write_string( strMessage );
						message_end( );
					}
				}
			}

			bCount[ iSender ][ iTempID ] = false;
		}
	}

	return PLUGIN_CONTINUE;
}

public Event_HLTV( ) {
	g_bFreezeTime = true;
	g_bSpawn = true;
	g_bPlanting = false;
	g_iBombCarrier = 0;
	g_iC4Timer = get_pcvar_num( g_cvarC4Timer );
}

public Event_WeapPickup( iPlayerID ) {
	g_iBombCarrier = iPlayerID;
}

public Event_BarTime( iPlayerID ) {
	if( iPlayerID == g_iBombCarrier ) {
		g_bPlanting = bool:read_data( 1 );
		get_user_origin( iPlayerID, g_iPlayerOrigin[ iPlayerID ] );
		g_iPlayerTime[ iPlayerID ] = 0;
	}
}

public Event_TextMsg( ) {
	g_bSpawn = false;
	g_bPlanting = false;
	g_iBombCarrier = 0;
}

/* LogEvents */
public LogEvent_RoundStart( ) {
	if( CheckBit( g_bitCvarStatus, CVAR_AUTORR ) && !g_bRestartedRound ) {
		g_iTimeLeft = get_pcvar_num( g_pcvarAutoRestartTime ) + 1;
		set_task( 1.0, "Task_Countdown_RestartRound", TASK_COUNTDOWN_RESTARTROUND, _, _, "a", g_iTimeLeft );

		g_bRestartedRound = true;
	}

	static iPlayers[ 32 ], iNum, iTempID, iLoop;
	get_players( iPlayers, iNum );

	if( !iNum ) {
		return PLUGIN_CONTINUE;
	}

	g_bFreezeTime = false;

	for( iLoop = 0; iLoop < iNum; iLoop++ ) {
		iTempID = iPlayers[ iLoop ];

		get_user_origin( iTempID, g_iPlayerOrigin[ iTempID ] );
		g_iPlayerTime[ iTempID ] = 0;
	}

	return PLUGIN_CONTINUE;
}

public LogEvent_BombPlanted( ) {
	static iPlayers[ 32 ], iNum, iLoop;
	get_players( iPlayers, iNum, "ac" );

	for( iLoop = 0; iLoop < iNum; iLoop++ ) {
		set_task( 1.0, "Task_UpdateTimer", TASK_UPDATETIMER + iPlayers[ iLoop ] );
	}
}

/* Menu */
public Menu_TeamSelect( iPlayerID, iKey ) {
	if( g_bBlockTeamJoin[ iKey ] ) {
		engclient_cmd( iPlayerID, "chooseteam" );
		return PLUGIN_HANDLED;
	}

	return PLUGIN_CONTINUE;
}

/* Task Functions */
public Task_PlayerRevived( iTaskID ) {
	new iPlayerID = iTaskID - TASK_REVIVE;
	
	StripPlayerWeapons( iPlayerID );
	
	switch( cs_get_user_team( iPlayerID ) ) {
		case CS_TEAM_CT: {
			give_item( iPlayerID, "weapon_usp" );
			cs_set_user_bpammo( iPlayerID, CSW_USP, BPAMMO_USP );
		}
		
		case CS_TEAM_T: {
			give_item( iPlayerID, "weapon_glock18" );
			cs_set_user_bpammo( iPlayerID, CSW_GLOCK18, BPAMMO_GLOCK18 );
		}
		
		/*
			Here I am checking if the player is a spectator, so I can glow him.
			Because alive specs have the same skins as the ct players. Therefore 
			players can differentiate between cts and specs.
		*/	
		case CS_TEAM_SPECTATOR: {
			set_user_rendering( iPlayerID, kRenderFxGlowShell, 255, 255, 255, kRenderNormal, 5 );
		}
	}
	
	if( g_iSpawnHealth != SPAWN_DEF_HEALTH ) {
		set_user_health( iPlayerID, g_iSpawnHealth );
	}
	
	cs_set_user_armor( iPlayerID, g_iSpawnArmor, CS_ARMOR_VESTHELM );
}

public Task_RemoveBadaim( iTaskID ) {
	new iPlayerID = iTaskID - TASK_BADAIM;
	
	new strPlayerName[ 32 ];
	get_user_name( iPlayerID, strPlayerName, 31 );
	
	#if defined GREEN_CHAT
	ColorChat( 0, NORMAL, "!g%s !n%s no longer has badaim.", g_strPluginPrefix, strPlayerName );
	#else 
	client_print( 0, print_chat, "%s %s no longer has badaim.", g_strPluginPrefix, strPlayerName );
	#endif

	ClearBit( g_bitHasBadaim, iPlayerID );
}

public Task_UpdateTimer( iTaskID ) {
	static iPlayerID;
	iPlayerID = iTaskID - TASK_UPDATETIMER;

	message_begin( MSG_ONE_UNRELIABLE, g_msgShowTimer, _, iPlayerID );
	message_end( );

	message_begin( MSG_ONE_UNRELIABLE, g_msgRoundTime, _, iPlayerID );
	write_short( g_iC4Timer );
	message_end( );

	message_begin( MSG_ONE_UNRELIABLE, g_msgScenario, _, iPlayerID );
	write_byte( 1 );
	write_string( "bombticking" );
	write_byte( 150 );
	write_short( 0 );
	message_end( );
}

public Task_AFK_BombCheck( iTaskID ) {
	if( g_bFreezeTime || !CheckBit( g_bitCvarStatus, CVAR_AFK ) || !CheckBit( g_bitCvarStatus, CVAR_AFK_BOMBTRANSFER ) || !g_iBombCarrier ) {
		return PLUGIN_CONTINUE;
	}
	
	if( g_iPlayerTime[ g_iBombCarrier ] < g_iAFKTime_Bomb ) {
		return PLUGIN_CONTINUE;
	}

	static iDistance, iReceiver, iOrigin2[ 3 ], iMinDistance;
	iMinDistance = 999999;
	iReceiver = 0;

	static iPlayers[ 32 ], iNum, iTempID, iOrigin[ 3 ], iLoop;
	get_players( iPlayers, iNum, "ae", "TERRORIST" );

	get_user_origin( g_iBombCarrier, iOrigin );

	if( iNum < 2 ) {
		return PLUGIN_CONTINUE;
	}
	
	for( iLoop = 0; iLoop < iNum; iLoop++ ) {
		iTempID = iPlayers[ iLoop ];
		
		if( g_iPlayerTime[ iTempID ] < g_iAFKTime_Bomb ) {
			get_user_origin( iTempID, iOrigin2 );
			iDistance = get_distance( iOrigin, iOrigin2 );
			
			if( iDistance < iMinDistance ) {
				iMinDistance = iDistance;
				iReceiver = iTempID;
			}
		}
	}
	
	if( !iReceiver ) {
		return PLUGIN_CONTINUE;
	}

	static iBombEnt, iBackpack;
	engclient_cmd( g_iBombCarrier, "drop", "weapon_c4" );
	iBombEnt = find_ent_by_class( -1, "weapon_c4" );

	if( !iBombEnt ) {
		return PLUGIN_CONTINUE;
	}

	iBackpack = pev( iBombEnt, pev_owner );
	if( iBackpack <= MAX_PLAYERS ) {
		return PLUGIN_CONTINUE;
	}
	
	static strCarrierName[ 32 ];
	get_user_name( g_iBombCarrier, strCarrierName, 31 );

	set_pev( iBackpack, pev_flags, pev( iBackpack, pev_flags ) | FL_ONGROUND );
	fake_touch( iBackpack, iReceiver );

	set_hudmessage( 0, 255, 0, 0.35, 0.8, _, _, 7.0, _, _, -1 );
	static strMessage[ 128 ], strReceiverName[ 32 ];
	get_user_name( iReceiver, strReceiverName, 31 );

	formatex( strMessage, 127, "Bomb transferred to ^"%s^"^n since^"%s^" is AFK", strReceiverName, strCarrierName );
	ShowSyncHudMsg( 0, g_hudSync4, strMessage );

	#if defined GREEN_CHAT
	ColorChat( iReceiver, NORMAL, "!g%s !nYou got the bomb. Go plant it.", g_strPluginPrefix );
	#else
	client_print( iReceiver, print_chat, "%s You got the bomb. Go plant it.", g_strPluginPrefix );
	#endif

	return PLUGIN_CONTINUE;
}

public Task_AFK_Check( iTaskID ) {
	if( g_bFreezeTime || !CheckBit( g_bitCvarStatus, CVAR_AFK ) ) {
		return PLUGIN_CONTINUE;
	}

	static iPlayers[ 32 ], iNum, iTempID, iOrigin[ 3 ], iLoop;
	get_players( iPlayers, iNum, "a" );

	for( iLoop = 0; iLoop < iNum; iLoop++ ) {
		iTempID = iPlayers[ iLoop ];

		get_user_origin( iTempID, iOrigin );

		if( iOrigin[ 0 ] != g_iPlayerOrigin[ iTempID ][ 0 ] ||
		iOrigin[ 1 ] != g_iPlayerOrigin[ iTempID ][ 1 ] ||
		iOrigin[ 2 ] != g_iPlayerOrigin[ iTempID ][ 2 ] ||
		( iTempID == g_iBombCarrier && g_bPlanting ) ) {
		g_iPlayerTime[ iTempID ] = 0;

		g_iPlayerOrigin[ iTempID ][ 0 ] = iOrigin[ 0 ];
		g_iPlayerOrigin[ iTempID ][ 1 ] = iOrigin[ 1 ];
		g_iPlayerOrigin[ iTempID ][ 2 ] = iOrigin[ 2 ];

		if( g_bSpawn && iTempID == g_iBombCarrier ) {
			g_bSpawn = false;
		}
		} else {
			g_iPlayerTime[ iTempID ] += AFK_FREQUENCY;
		}
		
		if( g_iPlayerTime[ iTempID ] == ( g_iAFKTime - AFK_WARNING ) ) {
			#if defined GREEN_CHAT
			ColorChat( iTempID, NORMAL, "!g%s !nYou have %i more seconds to move, or you will be counted as AFK.", g_strPluginPrefix, AFK_WARNING );
			#else
			client_print( iTempID, print_chat, "%s You have %i more seconds to move, or you will be counted as AFK.", g_strPluginPrefix );
			#endif
		}

		if( g_iPlayerTime[ iTempID ] < g_iAFKTime ) {
			return PLUGIN_CONTINUE;
		}

		PunsihAFKPlayer( iTempID );
	}

	return PLUGIN_CONTINUE;
}

public Task_AutoSlayPlayer( iTaskID ) {
	new iPlayerID = iTaskID - TASK_AUTOSLAY;

	user_kill( iPlayerID );
	
	#if defined GREEN_CHAT
	ColorChat( iPlayerID, NORMAL, "!g%s !nYou have been automatically slayed.", g_strPluginPrefix );
	#else
	client_print( iPlayerID, print_chat, "%s You have been slayed automatically.", g_strPluginPrefix );
	#endif
}

public Task_UberslapPlayer( iTaskID ) {
	static iPlayerID;
	iPlayerID = iTaskID - TASK_UBERSLAP;

	if( get_user_health( iPlayerID ) > 1 ) {
		user_slap( iPlayerID, 1 );
	} else {
		user_slap( iPlayerID, 0 );
	}
}

public Task_Countdown_Shutdown( ) {
	g_iTimeLeft--;

	static strNumber[ 32 ];

	switch( g_iTimeLeft ) {
		case 1..10: {
			num_to_word( g_iTimeLeft, strNumber, 31 );
			client_cmd( 0, "spk ^"fvox/%s^"", strNumber );
		}

		case 0: {
			server_cmd( "quit" );
		}
	}
}

public Task_Countdown_RestartRound( ) {
	g_iTimeLeft--;

	static strNumber[ 32 ];

	set_hudmessage( 0, 255, 0, -1.0, 0.25, _, _, _, _, _, -1 );
	ShowSyncHudMsg( 0, g_hudSync3, "Restart round in %i seconds", g_iTimeLeft );

	switch( g_iTimeLeft ) {
		case 1..10: {
			num_to_word( g_iTimeLeft, strNumber, 31 );
			client_cmd( 0, "spk ^"fvox/%s^"", strNumber );
		}

		case 0: {
			server_cmd( "sv_restartround 1" );
		}
	}
}

public Task_Countdown_Restart( ) {
	g_iTimeLeft--;

	static strNumber[ 32 ];

	switch( g_iTimeLeft ) {
		case 1..10: {
			num_to_word( g_iTimeLeft, strNumber, 31 );
			client_cmd( 0, "spk ^"fvox/%s^"", strNumber );
		}

		case 0: {
			server_cmd( "reload" );
		}
	}
}

/* Other Public Functions */
public RocketLiftoff( strPlayer[ ] ) {
	static iVictim;
	iVictim = strPlayer[ 0 ];

	set_user_gravity( iVictim, -0.50 );

	/*
		I am setting the player's origin instead of making him jump,
		because with the 2013 update, you are no longer able to execute
		commands on players.
		
		EDIT: on second though it seems that the +jump command is not blocked
	*/
	
	/* static iOrigin[ 3 ];

	get_user_origin( iVictim, iOrigin );
	iOrigin[ 2 ] += 20;
	set_user_origin( iVictim, iOrigin );*/
	engclient_cmd( iVictim, "+jump" );

	emit_sound( iVictim, CHAN_VOICE, g_strSounds[ SOUND_ROCKET ], 1.0, 0.5, 0, PITCH_NORM );
	RocketEffects( strPlayer );
}

public RocketEffects( strPlayer[ ] ) {
	static iVictim;
	iVictim = strPlayer[ 0 ];

	if( CheckBit( g_bitIsAlive, iVictim ) ) {
		static iOrigin[ 3 ];
		get_user_origin( iVictim, iOrigin );

		message_begin( MSG_ONE, g_msgDamage, { 0, 0, 0 }, iVictim );
		write_byte( 30 );			// Damage save
		write_byte( 30 );			// Damage take
		write_long( 1<<16 );			// Visible Damage Bits
		write_coord( iOrigin[ 0 ] );		// X Origin
		write_coord( iOrigin[ 1 ] );		// Y Origin
		write_coord( iOrigin[ 2 ] );		// Z Origin
		message_end( );

		if( g_iRocket[ iVictim ] == iOrigin[ 2 ] ) {
			RocketExplode( iVictim );
		}

		g_iRocket[ iVictim ] = iOrigin[ 2 ];

		// TE_SPRITETRAIL
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
		write_byte( 15 );
		write_coord( iOrigin[ 0 ] );				// Start
		write_coord( iOrigin[ 1 ] );
		write_coord( iOrigin[ 2 ] );
		write_coord( iOrigin[ 0 ] );				// End
		write_coord( iOrigin[ 1 ] );
		write_coord( iOrigin[ 2 ] - 30 );
		write_short( g_iSprites[ SPRITE_BLUEFLARE ] );		// Sprite
		write_byte( 5 );					// Count
		write_byte( 1 );					// Life (0.1)
		write_byte( 1 );					// Scale (0.1)
		write_byte( 10 );					// Velocity (0.1)
		write_byte( 5 );					// Randomness (0.1)
		message_end( );

		// TE_SPRITE
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
		write_byte( 17 );
		write_coord( iOrigin[ 0 ] );
		write_coord( iOrigin[ 1 ] );
		write_coord( iOrigin[ 2 ] - 30 );
		write_short( g_iSprites[ SPRITE_MUZZLEFALSH ] );
		write_byte( 15 );					// Scale (0.1)
		write_byte( 255 );					// Brightness
		message_end( );

		set_task( 0.2, "RocketEffects", TASK_ROCKETEFFECTS, strPlayer, 2 );
	}
}

public IgniteEffects( strPlayer[ ] ) {
	static iPlayerID;
	iPlayerID = strPlayer[ 0 ];

	if( CheckBit( g_bitIsAlive, iPlayerID ) && CheckBit( g_bitIsOnFire, iPlayerID ) ) {
		static iOrigin[ 3 ];
		get_user_origin( iPlayerID, iOrigin );

		message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
		write_byte( 17 );
		write_coord( iOrigin[ 0 ] );
		write_coord( iOrigin[ 1 ] );
		write_coord( iOrigin[ 2 ] );
		write_short( g_iSprites[ SPRITE_MUZZLEFALSH ] );
		write_byte( 20 );
		write_byte( 200 );
		message_end( );

		message_begin( MSG_BROADCAST, SVC_TEMPENTITY, iOrigin );
		write_byte( 5 );
		write_coord( iOrigin[ 0 ] );
		write_coord( iOrigin[ 1 ] );
		write_coord( iOrigin[ 2 ] );
		write_short( g_iSprites[ SPRITE_SMOKE ] );
		write_byte( 20 );
		write_byte( 15 );
		message_end( );

		set_task( 0.2, "IgniteEffects", 0, strPlayer, 2 );
	} else {
		if( CheckBit( g_bitIsOnFire, iPlayerID ) ) {
			emit_sound( iPlayerID, CHAN_AUTO, g_strSounds[ SOUND_SCREAM21 ], 0.6, ATTN_NORM, 0, PITCH_HIGH );
			ClearBit( g_bitIsOnFire, iPlayerID );
		}
	}
}

public IgnitePlayer( strPlayer[ ] ) {
	static iPlayerID;
	iPlayerID = strPlayer[ 0 ];

	if( CheckBit( g_bitIsAlive, iPlayerID ) && CheckBit( g_bitIsOnFire, iPlayerID ) ) {
		static iOrigin[ 3 ];
		get_user_origin( iPlayerID, iOrigin );
		set_user_health( iPlayerID, get_user_health( iPlayerID ) - abs( FIRE_DAMAGE ) );

		message_begin( MSG_ONE, g_msgDamage, { 0, 0, 0 }, iPlayerID );
		write_byte( 30 );
		write_byte( 30 );
		write_long( 1<<21 );
		write_coord( iOrigin[ 0 ] );
		write_coord( iOrigin[ 1 ] );
		write_coord( iOrigin[ 2 ] );
		message_end( );

		emit_sound( iPlayerID, CHAN_ITEM, g_strSounds[ SOUND_FLAMEBURST ], 0.6, ATTN_NORM, 0, PITCH_NORM );

		set_task( 2.0, "IgnitePlayer", 0, strPlayer, 2 );
	}
}

/* Other Functions */
ReloadCvars( ) {
	/*
		In my opinion, its better to refresh all the cvars on demand and
		caching them instead of getting its value everytime we want it.
		And that way we do not waste useful CPU power.
	*/
	get_pcvar_num( g_pcvarResetScore )			? SetBit( g_bitCvarStatus, CVAR_RESETSCORE )		: ClearBit( g_bitCvarStatus, CVAR_RESETSCORE );
	get_pcvar_num( g_pcvarResetScoreDisplay )		? SetBit( g_bitCvarStatus, CVAR_RESETSCORE_DISPLAY )	: ClearBit( g_bitCvarStatus, CVAR_RESETSCORE_DISPLAY );
	get_pcvar_num( g_pcvarAdminCheck )			? SetBit( g_bitCvarStatus, CVAR_ADMINCHECK )		: ClearBit( g_bitCvarStatus, CVAR_ADMINCHECK );
	get_pcvar_num( g_pcvarBulletDamage )			? SetBit( g_bitCvarStatus, CVAR_ABD )			: ClearBit( g_bitCvarStatus, CVAR_ABD );
	get_pcvar_num( g_pcvarRefund )				? SetBit( g_bitCvarStatus, CVAR_REFUND )		: ClearBit( g_bitCvarStatus, CVAR_REFUND );
	get_pcvar_num( g_pcvarAutoRestart )			? SetBit( g_bitCvarStatus, CVAR_AUTORR )                : ClearBit( g_bitCvarStatus, CVAR_AUTORR );
	get_pcvar_num( g_pcvarBulletDamageWall )		? SetBit( g_bitCvarStatus, CVAR_ABD_WALL )              : ClearBit( g_bitCvarStatus, CVAR_ABD_WALL );
	get_pcvar_num( g_pcvarAdminListen )			? SetBit( g_bitCvarStatus, CVAR_ADMINLISTEN )           : ClearBit( g_bitCvarStatus, CVAR_ADMINLISTEN );
	get_pcvar_num( g_pcvarDeadListen )			? SetBit( g_bitCvarStatus, CVAR_DEADLISTEN )            : ClearBit( g_bitCvarStatus, CVAR_DEADLISTEN );
	get_pcvar_num( g_pcvarAFKBombTransfer )			? SetBit( g_bitCvarStatus, CVAR_AFK_BOMBTRANSFER )      : ClearBit( g_bitCvarStatus, CVAR_AFK_BOMBTRANSFER );
	get_pcvar_num( g_pcvarC4Timer )				? SetBit( g_bitCvarStatus, CVAR_C4_TIMER )              : ClearBit( g_bitCvarStatus, CVAR_C4_TIMER );
	get_pcvar_num( g_pcvarAdminListenTeam )			? SetBit( g_bitCvarStatus, CVAR_ADMINLISTEN_TEAM )      : ClearBit( g_bitCvarStatus, CVAR_ADMINLISTEN_TEAM );
	get_pcvar_num( g_pcvarDeadListenTeam )			? SetBit( g_bitCvarStatus, CVAR_DEADLISTEN_TEAM )       : ClearBit( g_bitCvarStatus, CVAR_DEADLISTEN_TEAM );
	get_pcvar_num( g_pcvarAFK )				? SetBit( g_bitCvarStatus, CVAR_AFK )                   : ClearBit( g_bitCvarStatus, CVAR_AFK );
	
	g_iSpawnMoney	= Clamp( get_pcvar_num( g_pcvarRefundValue ),		0,	16000 );
	g_iAFKTime	= Clamp( get_pcvar_num( g_pcvarAFKTime ),		10,	60 );
	g_iAFKTime_Bomb	= Clamp( get_pcvar_num( g_pcvarAFKBombTransfer_Time ),	5,	15 );
	g_iAFKPunishment= Clamp( get_pcvar_num( g_pcvarAFKPunishment ),		0,	2 );
}

UpdateScore( iPlayerID, iFrags, iDeaths ) {
	message_begin( MSG_ALL, g_msgScoreInfo );
	write_byte( iPlayerID );
	write_short( iFrags );
	write_short( iDeaths );
	write_short( 0 );
	write_short( get_user_team( iPlayerID ) );
	message_end( );
}

/*
	I wrote the Maximum, Minimum and Clamp functions
	here and didn't use the natives cause it appears 
	that they are not working properly. I have no idea
	why.
*/
Maximum( iNumber, iMax ) {
	if( iNumber > iMax ) {
		return iMax;
	}
	
	return iNumber;
}

Minimum( iNumber, iMin ) {
	if( iNumber < iMin ) {
		return iMin;
	}
	
	return iNumber;
}

Clamp( iNumber, iMin, iMax ) {
	if( iNumber < iMin ) {
		return iMin;
	}
	
	if( iNumber > iMax ) {
		return iMax;
	}
	
	return iNumber;
}

StripPlayerWeapons( iPlayerID ) {
	strip_user_weapons( iPlayerID );
	set_pdata_int( iPlayerID, 116, 0 );
	
	give_item( iPlayerID, "weapon_knife" );
}

ResetUserMaxSpeed( iPlayerID ) {
	new Float:fMaxSpeed;
	
	switch( get_user_weapon( iPlayerID ) ) {
		case CSW_SG550, CSW_AWP, CSW_G3SG1:		fMaxSpeed = 210.0;
		case CSW_M249:					fMaxSpeed = 220.0;
		case CSW_AK47:					fMaxSpeed = 221.0;
		case CSW_M3, CSW_M4A1:				fMaxSpeed = 230.0;
		case CSW_SG552:					fMaxSpeed = 235.0;
		case CSW_XM1014, CSW_AUG, CSW_GALIL, CSW_FAMAS:	fMaxSpeed = 240.0;
		case CSW_P90:					fMaxSpeed = 245.0;
		case CSW_SCOUT:					fMaxSpeed = 260.0;
		default :					fMaxSpeed = 250.0;
	}
	
	set_user_maxspeed( iPlayerID, fMaxSpeed );
}

DrugPlayer( iPlayerID ) {
	message_begin( MSG_ONE, g_msgSetFOV, { 0, 0, 0 }, iPlayerID );
	write_byte( 180 );
	message_end( );
}

RocketPlayer( iPlayerID ) {
	emit_sound( iPlayerID, CHAN_WEAPON, g_strSounds[ SOUND_ROCKETFIRE ], 1.0, ATTN_NORM, 0, PITCH_NORM );
	set_user_maxspeed( iPlayerID, 0.1 );
	
	static strPlayer[ 2 ];
	strPlayer[ 0 ] = iPlayerID;
	set_task( 1.2, "RocketLiftoff", TASK_ROCKETLIFTOFF, strPlayer, 2 );
}

GiveWeapon( iPlayerID, iWeapon, iAmmo ) {
	give_item( iPlayerID, g_strWeapons[ iWeapon ] );
	
	switch( iWeapon ) {
		case 2, 6, 29: {
			return PLUGIN_HANDLED;
		}
		
		default: {
			cs_set_user_bpammo( iPlayerID, iWeapon, iAmmo );
		}
	}
	
	return PLUGIN_HANDLED;
}

Slay2Player( iPlayerID, iType ) {
	static strPlayerName[ 32 ], iOrigin[ 3 ], iOrigin2[ 3 ];
	get_user_name( iPlayerID, strPlayerName, 31 );
	get_user_origin( iPlayerID, iOrigin );
	iOrigin[ 2 ] -= 26;

	iOrigin2[ 0 ] = iOrigin[ 0 ] + 150;
	iOrigin2[ 1 ] = iOrigin[ 1 ] + 150;
	iOrigin2[ 2 ] = iOrigin[ 2 ] + 400;

	switch( iType ) {
		case SLAY_LIGHTINING : {
			message_begin( MSG_BROADCAST,SVC_TEMPENTITY);
			write_byte( 0 );
			write_coord( iOrigin2[ 0 ] );
			write_coord( iOrigin2[ 1 ] );
			write_coord( iOrigin2[ 2 ] );
			write_coord( iOrigin[ 0 ] );
			write_coord( iOrigin[ 1 ] );
			write_coord( iOrigin[ 2 ] );
			write_short( g_iSprites[ SPRITE_LIGHTNING ] );
			write_byte( 1 );		// framestart 
			write_byte( 5 );		// framerate 
			write_byte( 2 );		// life 
			write_byte( 20 );		// width 
			write_byte( 30 );		// noise 
			write_byte( 200 );		// r 
			write_byte( 200 );		// g
			write_byte( 200 );		// b
			write_byte( 200 );		// brightness 
			write_byte( 200 );		// speed 
			message_end( );
		    
			emit_sound( iPlayerID, CHAN_ITEM, g_strSounds[ SOUND_THUNDERCLAP ], 1.0, ATTN_NORM, 0, PITCH_NORM );
		}

		case SLAY_BLOOD: {
			message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
			write_byte( 10 );
			write_coord( iOrigin[ 0 ] );
			write_coord( iOrigin[ 1 ] );
			write_coord( iOrigin[ 2 ] );
			message_end( );
		    
			emit_sound( iPlayerID, CHAN_ITEM, g_strSounds[ SOUND_HEADSHOT ], 1.0, ATTN_NORM, 0, PITCH_NORM );
		}

		case SLAY_EXPLODE: {
			message_begin( MSG_BROADCAST, SVC_TEMPENTITY, iOrigin ) ;
			write_byte( 21 );
			write_coord( iOrigin[ 0 ] );
			write_coord( iOrigin[ 1 ] );
			write_coord( iOrigin[ 2 ] + 16 );
			write_coord( iOrigin[ 0 ] );
			write_coord( iOrigin[ 1 ] );
			write_coord( iOrigin[ 2 ] + 1936 );
			write_short( g_iSprites[ SPRITE_WHITE ] );
			write_byte( 0 );            // startframe 
			write_byte( 0 );            // framerate 
			write_byte( 2 );            // life 
			write_byte( 16 );           // width 
			write_byte( 0 );            // noise 
			write_byte( 188 );          // r 
			write_byte( 220 );          // g 
			write_byte( 255 );          // b 
			write_byte( 255 );          //brightness 
			write_byte( 0 );            // speed 
			message_end( ); 

			message_begin( MSG_BROADCAST, SVC_TEMPENTITY ) ;
			write_byte( 12 );
			write_coord( iOrigin[ 0 ] );
			write_coord( iOrigin[ 1 ] );
			write_coord( iOrigin[ 2 ] );
			write_byte( 188 );          // byte (scale in 0.1's) 
			write_byte( 10 );           // byte (framerate) 
			message_end( );

			message_begin( MSG_BROADCAST, SVC_TEMPENTITY/*, iOrigin*/ );
			write_byte( 5 );
			write_coord( iOrigin[ 0 ] );
			write_coord( iOrigin[ 1 ] );
			write_coord( iOrigin[ 2 ] );
			write_short( g_iSprites[ SPRITE_SMOKE ] );
			write_byte( 2 );
			write_byte( 10 );
			message_end( );
		}
	}

	user_kill( iPlayerID, 1 );
}

PunsihAFKPlayer( iPlayerID ) {
	if( Access( iPlayerID, AFK_IMMUNITY ) ) {
		return PLUGIN_CONTINUE;
	}

	switch( g_iAFKPunishment ) {
		case 0: {
			return PLUGIN_CONTINUE;
		}

		case 1: {
			if( CheckBit( g_bitIsAlive, iPlayerID ) ) {
				user_kill( iPlayerID );
			}

			cs_set_user_team( iPlayerID, CS_TEAM_SPECTATOR );

			new strPlayerName[ 32 ];
			get_user_name( iPlayerID, strPlayerName, 31 );

			#if defined GREEN_CHAT
			ColorChat( 0, NORMAL, "!g%s !n%s has been transferred to the !gSpectator !nteam for being !gAFK!n.", g_strPluginPrefix, strPlayerName );
			#else
			client_print( 0, print_chat, "%s %s has been transfered to the Spectator team for being AFK.", g_strPluginPrefix, strPlayerName );
			#endif
		}

		case 2: {
			server_cmd( "kick #%i ^"You have been AFK for too long.^"", get_user_userid( iPlayerID ) );

			new strPlayerName[ 32 ];
			get_user_name( iPlayerID, strPlayerName, 31 );

			#if defined GREEN_CHAT
			ColorChat( 0, NORMAL, "!g%s !n%s has been kicked for being !gAFK!n.", g_strPluginPrefix, strPlayerName );
			#else
			client_print( 0, print_chat, "%s %s has been kicked for being AFK.", g_strPluginPrefix, strPlayerName );
			#endif
		}
	}

	return PLUGIN_CONTINUE;
}

RocketExplode( iVictim ) {
	if( CheckBit( g_bitIsAlive, iVictim ) ) {
		static iOrigin[ 3 ];
		get_user_origin( iVictim, iOrigin );

		// Blast Circles
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY, iOrigin );
		write_byte( 21 );
		write_coord( iOrigin[ 0 ] );
		write_coord( iOrigin[ 1 ] );
		write_coord( iOrigin[ 2 ] - 10 );
		write_coord( iOrigin[ 0 ] );
		write_coord( iOrigin[ 1 ] );
		write_coord( iOrigin[ 2 ] + 1910 );
		write_short( g_iSprites[ SPRITE_WHITE ] );
		write_byte( 0 );	// Startframe
		write_byte( 0 );	// Framerate
		write_byte( 2 );	// Life
		write_byte( 16 );	// Width
		write_byte( 0 );	// Noise
		write_byte( 188 );	// Red
		write_byte( 220 );	// Green
		write_byte( 255 );	// Blue
		write_byte( 255 );	// Brightness
		write_byte( 0 );	// Speed
		message_end( );

		// Explosion2
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
		write_byte( 12 );
		write_coord( iOrigin[ 0 ] );
		write_coord( iOrigin[ 1 ] );
		write_coord( iOrigin[ 2 ] );
		write_byte( 188 );	// Scale
		write_byte( 10 );	// Framerate
		message_end( );

		// Smoke
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
		write_byte( 5 );
		write_coord( iOrigin[ 0 ] );
		write_coord( iOrigin[ 1 ] );
		write_coord( iOrigin[ 2 ] );
		write_short( g_iSprites[ SPRITE_SMOKE ] );
		write_byte( 2 );
		write_byte( 10 );
		message_end( );

		user_kill( iVictim, 1 );
	}

	emit_sound( iVictim, CHAN_VOICE, g_strSounds[ SOUND_ROCKET ], 0.0, 0.0, ( 1<<5 ), PITCH_NORM );

	set_user_maxspeed( iVictim, 1.0 );
	set_user_gravity( iVictim, 1.0 );
}

Access( iPlayerID, iFlag ) {
	if( get_user_flags( iPlayerID ) & iFlag ) {
		return 1;
	}
	
	return 0;
}

RevivePlayer( iPlayerID ) {
	ExecuteHamB( Ham_CS_RoundRespawn, iPlayerID );
	set_task( 0.25, "Task_PlayerRevived", TASK_REVIVE + iPlayerID );
}

Bury_Unbury( iPlayerID, bool:bBury ) {
	new iOrigin[ 3 ];
	get_user_origin( iPlayerID, iOrigin );
	
	new strWeaponName[ 32 ], iWeapons[ 32 ];
	new iWeaponsNum;
	
	if( bBury ) {
		get_user_weapons( iPlayerID, iWeapons, iWeaponsNum );
		
		for( new iInnerLoop = 0; iInnerLoop < iWeaponsNum; iInnerLoop++ ) {
			get_weaponname( iWeapons[ iInnerLoop ], strWeaponName, 31 );
			engclient_cmd( iPlayerID, "drop", strWeaponName );
		}
		
		engclient_cmd( iPlayerID, "weapon_knife" );
		
		iOrigin[ 2 ] -= 30;
	} else {
		iOrigin[ 2 ] += 35;
	}
	
	set_user_origin( iPlayerID, iOrigin );
}

#if defined GREEN_CHAT
SendAdminMessage( strMessage[ ], iSenderID ) {
	new strFormatedMessage[ 256 ] = "^x04(ADMINS) ";

	static strSenderName[ 32 ], iLoop;
	get_user_name( iSenderID, strSenderName, 31 );

	add( strFormatedMessage, 255, strSenderName );
	add( strFormatedMessage, 255, ": ^x01" );
	add( strFormatedMessage, 255, strMessage, 256 - strlen( strFormatedMessage ) - 1 );

	static strSenderAuthID[ 36 ];
	get_user_authid( iSenderID, strSenderAuthID, 35 );

	static iPlayers[ 32 ], iNum, iTempID;
	get_players( iPlayers, iNum, "c" );

	log_amx( "%s AMX_CHAT - Sender: ^"%s<%d><%s><>^" Message: ^"%s^"", g_strPluginPrefix, strSenderName, iSenderID, strSenderAuthID, strMessage );

	for( iLoop = 0; iLoop < iNum; iLoop++ ) {
		iTempID = iPlayers[ iLoop ];

		if( get_user_flags( iTempID ) & ADMIN_CHAT ) {
			SendMessage( strFormatedMessage, iTempID );
		}
	}
}

BaseSendPM( strArguments[ ], iSenderID ) {
	static strTarget[ 36 ], strMessage[ 256 ];

	strbreak( strArguments, strTarget, 35, strMessage, 255 );
	remove_quotes( strTarget );
	replace( strMessage, 255, "^"", "" );

	static iTarget;
	if( equal( strTarget, "STEAM_", 6 ) ) {
		iTarget = find_player( "chl", strTarget );
	} else {
		iTarget = find_player( "bhl", strTarget );
	}

	if( !iTarget ) {
		static strSenderAuthID[ 36 ];
		get_user_authid( iSenderID, strSenderAuthID, 35 );
	
		if( iTarget ) {
			SendPM( strMessage, iSenderID, iTarget );
		}
	}
}

SendPM( strMessage[ ], iSenderID, iReceiverID ) {
	new strRealMessage[ 256 ] = "^x04(";

	static strSenderName[ 32 ];
	get_user_name( iSenderID, strSenderName, 31 );

	add( strRealMessage, 255, strSenderName );
	add( strRealMessage, 255, ") PM: ^x01" );
	add( strRealMessage, 255, strMessage, 256 - strlen( strRealMessage ) - 1 );

	static strReceiverAuhtID[ 36 ], strSenderAuthID[ 36 ];
	static strReceiverName[ 32 ];

	get_user_authid( iSenderID, strSenderAuthID, 35 );
	get_user_authid( iReceiverID, strReceiverAuhtID, 35 );
	get_user_name( iReceiverID, strReceiverName, 31 );

	log_amx( "%s AMX_PSAY - From: ^"%s<%d><%s><>^" To: ^"%s<%d><%s><>^" Message: ^"%s^"", g_strPluginPrefix, strSenderName, iSenderID, strSenderAuthID, strReceiverName, iReceiverID, strReceiverName, strMessage );
	SendMessage( strRealMessage, iReceiverID );

	new strToAdmin[ 256 ] = "^x04(";
	add( strToAdmin, 255, strReceiverName );
	add( strToAdmin, 255, ") PM: ^x01" );
	add( strToAdmin, 255, strMessage, 256 - strlen( strToAdmin ) - 1 );

	SendMessage( strToAdmin, iSenderID );
}

SendMessage( strMessage[ ], iReceiverID ) {
	message_begin( MSG_ONE, g_msgSayText, { 0, 0, 0 }, iReceiverID );
	write_byte( iReceiverID );
	write_string( strMessage );
	message_end( );
}

/* Color Chat */
ColorChat( iPlayerID, iColor, const strText[ ], any:... ) {
	if( !get_playersnum( ) ) {
		return;
	}

	static strMessage[ 192 ];

	strMessage[ 0 ] = 0x01;
	vformat( strMessage[ 1 ], 191, strText, 4 );

	replace_all( strMessage, 191, "!g", "^x04" );
	replace_all( strMessage, 191, "!n", "^x01" );
	replace_all( strMessage, 191, "!t", "^x03" );

	static index, iMsgType;
	
	if( !iPlayerID ) {
		static iLoop;
		for( iLoop = 1; iLoop <= MAX_PLAYERS; iLoop++ ) {
			if( CheckBit( g_bitIsConnected, iLoop ) ) {
				index = iLoop;
				break;
			}
		}
		
		iMsgType = MSG_ALL;
	} else {
		iMsgType = MSG_ONE;
		index = iPlayerID;
	}
	
	static bool:bChanged;
	
	if( iColor == GREY || iColor == RED || iColor == BLUE ) {
		message_begin( iMsgType, g_msgTeamInfo, _, index );
		write_byte( index );
		write_string( g_strTeamName[ iColor ] );
		message_end( );
		
		bChanged = true;
	}
	
	message_begin( iMsgType, g_msgSayText, _, index );
	write_byte( index );
	write_string( strMessage );
	message_end( );
	
	if( bChanged ) {
		message_begin( iMsgType, g_msgTeamInfo, _, index );
		write_byte( index );
		write_string( g_strTeamName[ _:cs_get_user_team( index ) ] );
		message_end( );
	}
}
#endif

/*
	Notepad++ Allied Modders Edition v6.2
	Style Configuration:    Default
	Font:                   Consolas
	Font size:              10
	Indent:                 8 spaces
*/

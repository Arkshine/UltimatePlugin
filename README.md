UltimatePlugin
==============
by tonykaram1993

NOTE: this plugin is still in beta and testing is in process. However because it is 
a very big plugin, and plus the fact that I do not have access to an online server, 
some things cannot be tested. I would appreciate if you tested it and report any problems 
or things that needs fixing.

We all know the famous amx_super plugin. Most servers use it as a wonderful
administrative tool to let admins take control over their servers and manage
it in a better and more efficient way. At first I started by editing that
plugin to make it use less resources and do things in a better way (AFAIK).
But later, I ended up rewriting the whole thing from scratch (ofc it is based
on amx_super so a lot of resemblance can be found). I hope I succeeded in
my mission. I am not the best coder there is, but I think I have some good
knowledge in scripting (I hope).

Plugins Included
================
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

Commands
========
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
	
	/* Other Console Commands */
	register_concmd( "amx_reloadcvars",	"ConCmd_ReloadCvars",		ADMIN_CVAR,		" - Reloads all the cvars of the UltimatePlugin" );
	register_concmd( "amx_restart",		"ConCmd_RestartServer",		ADMIN_RCON,		"<timer> - Min:0 | Max:60 | Cancel:-1" );
	register_concmd( "amx_shutdown",	"ConCmd_ShutdownServer",	ADMIN_RCON,		"<timer> - Min:0 | Max:60 | Cancel:-1" );
	register_concmd( "amx_search",		"ConCmd_SearchCommands",	ADMIN_ADMIN,		"<command>" );

CVARS
=====
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

Notes
=====
* To report an issue with the plugin or even suggest an improvement, please do so in here https://github.com/tonykaram1993/UltimatePlugin/issues/new .
* To view the full change log of the plugin, please go here https://github.com/tonykaram1993/UltimatePlugin/blob/master/CHANGELOG.md
* If you would like to talk to me in private, send me an e-mail to the following e-mail address tonykaram1993@gmail.com .

/* 定义YDWE 需要用到的全局变量 */
globals

	/* 全局系统 */
	//DEBUG
	boolean isDebug = false
	//系统时间
	integer System_time = 0
	integer System_sec = 0
	integer System_min = 0
	integer System_hour = 0
	integer System_time_count = 0
	boolean isNight = false
	real Share_Range = 1000
	//call DoNothing() YDNL exitwhen true 退出循环为什么不是break，什么傻逼语法

	/* Apm */
    integer array Apm



	/* 电影 */
	integer Moive_Msg_Length
	string array Moive_Msg

	/* 天气 */
	integer WeatherEffect_Sun 			= 'LRaa'	//日光
    integer WeatherEffect_Moon		= 'LRma'	//月光
    integer WeatherEffect_Shield 		= 'MEds'	//紫光盾
    integer WeatherEffect_Rain			= 'RAlr'	//雨
    integer WeatherEffect_RainStorm 	= 'RAhr'	//大雨
    integer WeatherEffect_Snow 		= 'SNls'	//雪
    integer WeatherEffect_SnowStorm 	= 'SNhs'	//大雪
    integer WeatherEffect_Wind 		= 'WOlw'	//风
    integer WeatherEffect_WindStorm 	= 'WNcw'	//大风
    integer WeatherEffect_MistWhite 	= 'FDwh'	//白雾
    integer WeatherEffect_MistGreen 	= 'FDgh'	//绿雾
    integer WeatherEffect_MistBlue 	= 'FDbh'	//蓝雾
    integer WeatherEffect_MistRed 		= 'FDrh'	//红雾


	/* 玩家 */
	player array Players
	//最大玩家数
	integer Max_Player_num  = 7
	//当前玩家数
	integer Current_Player_num = 0
	//初始玩家数
	integer Start_Player_num = 0
	//最后一点技能点的英雄等级
	integer Last_skillPointsLv = 500
	//玩家势力队伍
	integer Player_team_num = 1
	force array Player_team
	//敌人玩家
	player Player_Enemy = Player(10)
	integer Enemy_Army_Group_Max = 4
	player array Enemy_Army_GroupPlayer
	group array Enemy_Army_Group
	//友军玩家
	player Player_Ally = Player(11)
	string array Player_names
	unit array Player_heros
	unit array Selcet_hero_token
	string array Player_heros_face
	string array Player_heros_name
	string array Player_heros_status
	boolean array Player_heros_isDead
	unit array Player_heros_tombs
	unit array Player_heros_tomb_views
	integer array Player_heros_level
	integer array Player_heros_skillPoints
	string array Player_status
	//random
	boolean array canRandom
	boolean array canRepick
	//repick
	integer array Repick_unitTypeIds
	//死亡复活相关
	boolean array Reborn_tombs_status   //墓碑每秒伤害限制状态

	//伤害目标筛选
	string FILTER_ALL = "FILTER_ALL"        	//全部
	string FILTER_ALLY = "FILTER_ALLY"      	//友军
	string FILTER_ENEMY = "FILTER_ENEMY"	//敌军

	/* 全局单位Id */
	unit Unit_Fail_Road = null   //引起游戏路线失败的单位
	unit Unit_Fail_Hero = null   //引起游戏失败的英雄
	//英雄选择
	integer Unit_Select_Hero = 'o004'
	//马甲们
	//超级马甲
	integer Unit_Token_Super = 'h00J'
	//伤害
	integer Unit_Token_Hunt = 'h00D'
	//伤害 - 无法回避
	integer Unit_Token_Hunt_Not_Avoid = 'h00K'
	//闪电链
	integer Unit_Token_ThunderLink = 'h00I'
	//墓碑地面视野
	integer Unit_TombView = 'n00B'
	//墓碑
	integer Unit_Tomb = 'o03I'
	//墓碑Key
	integer Key_Hash_Tomb_Index = 110
	integer Key_Hash_Tomb_ViewUnit = 111
	integer Key_Hash_Tomb_Hero = 112
	integer Key_Hash_Tomb_Unit = 115
	integer Key_Hash_Tomb_Jesus = 117
	//占据点
	integer Unit_Occupying = 'o01Q'

endglobals

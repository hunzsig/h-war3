/* 定义YDWE 需要用到的全局变量 */
globals

	/* YDWE属性系统*/
	//生命魔法在英雄上限为65535
	integer YDWE_ATTR_MAX_LIFE = 0
	integer YDWE_ATTR_MAX_MANA = 1
	integer YDWE_ATTR_EQUAL = 2
	//call YDWEGeneralBounsSystemUnitSetBonus( GetTriggerUnit(), YDWE_ATTR_MAX_LIFE, YDWE_ATTR_EQUAL, 300 )



	/* 全局系统 */
	//DEBUG
	boolean isDebug = false
	//系统时间
	integer System_time = 0
	integer System_sec = 0
	integer System_min = 0
	integer System_hour = 0
	boolean isNight = false
	real Share_Range = 3000
	//call DoNothing() YDNL exitwhen true 退出循环为什么不是break，什么傻逼语法


	/* 玩家 */
	player array Players
	//最大玩家数
	integer Max_Player_num  = 8
	//初始玩家数
	integer Start_Player_num = 0
	//当前玩家数
	integer Current_Player_num = 0
	//最后一点技能点的英雄等级
	integer Last_skillPointsLv = 200
	//玩家势力队伍
	integer Player_team_num = 2
	force array Player_team
	//敌人玩家
	player Player_Enemy_Army = Player(10)
	player Player_Enemy_Building = Player(11)
	integer Enemy_Army_Group_Max = 2
	player array Enemy_Army_GroupPlayer
	group array Enemy_Army_Group
	//友军玩家
	player Player_Ally_Building = Player(8)
	unit array Player_Ally_Speaker
	string array Player_names
	unit array Player_heros
	unit array Selcet_hero_token
	string array Player_heros_face
	string array Player_heros_name
	string array Player_heros_status
	boolean array Player_heros_isDead
	integer array Player_heros_level
	integer array Player_heros_skillPoints
	//random
	boolean array canRandom
	boolean array canRepick
	//repick
	integer array Repick_unitTypeIds
	//死亡复活相关
	boolean array Reborn_tombs_status   //墓碑每秒伤害限制状态


	/* 定义科技全局变量 */
	//敌军科技
	integer Tec_enemy_lv = 0
	integer Tec_tomb_lv = 'R002'
	//玩家友军科技升级
	integer Friend_upLevel_tec = 'R00D'
	integer Village_upLevel_tec = 'R00E'
	integer GodWood_upLevel_tec = 'R00M'
	integer Gold_upLevel_tec = 'R00Z'


	/* 难度对话框 */
	dialog Dialog_diff = DialogCreate()
	button array Dialog_diff_button
	integer Diff_MaxLv = 5
	integer DIFF = 0

	/* 字符串 */
	string array STRING_STATUS
	string array STRING_DIFF

	//伤害目标筛选
	string FILTER_ALL = "FILTER_ALL"        	//全部
	string FILTER_ALLY = "FILTER_ALLY"      	//友军
	string FILTER_ENEMY = "FILTER_ENEMY"	//敌军

	/* 计时器 */
	//难度计时器
	timer Timer_diff = null
	timerdialog Timer_diff_dialog = null
	//选择英雄计时器
	timer Timer_choose_hero = null
	timerdialog Timer_choose_hero_dialog = null
	//准备计时器
	timer Timer_ready = null
	timerdialog Timer_ready_dialog = null
	//英雄恢复计时器（活力，魔法）
	timer Timer_life_mana_back = null
	//英雄恢复计时器（硬直）
	timer Timer_punish_back = null
	//金矿给钱计时器
	timer Timer_gold_base_give = null
	//金矿被击计时器
	timer Timer_gold_base_attack = null

	/* 全局单位Id */

	unit Unit_Fail_Road = null   //引起游戏路线失败的单位
	unit Unit_Fail_Hero = null   //引起游戏失败的英雄
	//英雄选择
	integer Unit_Select_Hero = 'o004'
	integer STOCK_HASH_ID = 1569
	//复活石头
	integer Unit_Reborn_StoneId_Normal ='n00L'
	integer Unit_Reborn_StoneId_Crazy ='o00W'
	integer Unit_Reborn_StoneId_God ='n00L'
	unit array Unit_Reborn_Stone
	//神木
	integer Unit_God_Tree_Core = 'e004'
	integer Unit_God_Tree_Normal = 'e000'
	integer Unit_God_Tree_Crazy = 'e002'
	integer Unit_God_Tree_God = 'e003'
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
	//村庄
	integer Unit_village_gold = 'o01C'
	integer Unit_village_water = 'o01D'
	integer Unit_village_big = 'o01Q'
	//玩家队伍
	integer Unit_Team_shortRange1 = 'n00T'
	integer Unit_Team_middleRange1 = 'n00U'
	integer Unit_Team_longRange1 = 'n016'
	integer Unit_Team_shortRange2 = 'n00P'
	integer Unit_Team_middleRange2 = 'n00Q'
	integer Unit_Team_longRange2 = 'n00R'


endglobals

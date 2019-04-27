
#include "event/beAttacked.j"
#include "event/beSpelled.j"
#include "event/beDamaged.j"

globals

endglobals

library m1Init requires m1Ally

	/* 任务 */
	private function initMission takes nothing returns nothing
		local integer i
	    local string array tipsTitle
	    local string array tipsConst
	    local string array tipsTitleHelp
	    local string array tipsConstHelp

		set tipsTitle[1] = "地图介绍"
	    set tipsConst[1] = "地图名称：英雄无极传"
	    set tipsConst[1] = tipsConst[1] + "|n地图类型：生存激战"
	    set tipsConst[1] = tipsConst[1] + "|n语言：中文|n魔兽版本：1.26以上|n作者：hunzsig"
	    set tipsConst[1] = tipsConst[1] + "|n支持人数：1-7"
	    set tipsConst[1] = tipsConst[1] + "|n官方QQ群：325338043"
	    set tipsConst[1] = tipsConst[1] + "|n始创日期：2016年10月"

	    set tipsTitle[2] = "如何进入次元森林"
	    set tipsConst[2] = "选择你的英雄，按下“Z”或点击“次元森林”进入"
	    set tipsConst[2] = tipsConst[2] + "|n森林链接异次元，里面有各种商店，无论何时何地轻松购买"

	    set tipsTitle[3] = "游戏流程"
	    set tipsConst[3] = "胜利目标：剧情通关"
	    set tipsConst[3] = tipsConst[3] + "失败条件：英雄团灭"

	    set tipsTitle[4] = "游戏指令"
	    set tipsConst[4] ="|n-随机选择英雄：-random"
	    set tipsConst[4] = tipsConst[4] + "|n-重新选择英雄：-repick"

	    set tipsTitle[5] = "地图资源"
	    set tipsConst[5] = "地图上有很多隐藏的资源，细心留意，获得它们！"
	    set tipsConst[5] = tipsConst[5] + "|n这些资源都是免费的哦，说不定官网有攻略呢"

	    set tipsTitle[6]= "死亡碑塔"
	    set tipsConst[6] = "英雄牺牲时灵气会聚集形成死亡碑塔，击打碑塔根据救助力"
	    set tipsConst[6] = tipsConst[6] + "|n完全击破碑塔才可以救活队友！"
	    set tipsConst[6] = tipsConst[6] + "|n每个英雄每1秒只能对碑塔造成1次伤害"
	    set tipsConst[6] = tipsConst[6] + "|n死亡次数越多，墓碑将变得越来越坚固"
	    set tipsConst[6] = tipsConst[6] + "|n如果只有一个英雄，非常遗憾，永恒绝望"

	    set tipsTitle[7] = "英雄技能点"
	    set tipsConst[7] = "英雄只有达到某些特定等级时才会获得技能点|n这些特定的等级是："
	    set tipsConst[7] = tipsConst[7] + "|n1/2/3/4/6/8/10/15/18"
	    set tipsConst[7] = tipsConst[7] + "|n20/25/27"
	    set tipsConst[7] = tipsConst[7] + "|n30/40/50/60"
	    set tipsConst[7] = tipsConst[7] + "|n70/80/90/100"
	    set tipsConst[7] = tipsConst[7] + "|n150/200/250/300"

	    set i = 1
	    loop
	        exitwhen i > 7
	        	call funcs_setMissionLeft(tipsTitle[i], tipsConst[i], "ReplaceableTextures\\CommandButtons\\BTNScrollUber.blp")
	        set i = i + 1
	    endloop

	    call FlashQuestDialogButton()
	endfunction

	/* 电影 */
	private function initMoive takes nothing returns nothing
		local string array tips
	    local integer i
	    local location loc = null
	    local unit moive_Speaker = null

		//播放剧情
	    call CinematicModeBJ( true, GetPlayersAll() )
	    call ForceCinematicSubtitles( true )
	    call CameraSetupApplyForceDuration( gg_cam_init, true, 5.00 )

		set tips[1] = "在荒原大地中心，有几所破落小酒馆～你是其中一个英雄解决所有的事件|n虽然英雄身怀绝技，心存浩气。不怕得罪各方势力。|n但小心，被杀害也是常有的事！"
		set tips[2] = "要记住森林一直与你同在~|n|n选中英雄按Z键链接次元森林购买物资|n|n进入中途按ESC可以返回"
		set tips[3] = "你的背包能承受一定负重，但物品太多会掉出来|n|n我也经营着一间友善小店，只要肯给3倍钱!立马卖你"
		set tips[4] = "死亡后灵气会聚成碑塔，打破它伙伴才可以复活|n|n碑塔很坚固，需要强大的救助力"
		set tips[5] = "不说太多～森林等着你................"
		set loc = Location(10240, 1700)
		set moive_Speaker = funcs_createUnitFacing(Player_Ally, 'n00O' , loc, 270)
		set Moive_Msg_Length = 5
		set Moive_Msg[Moive_Msg_Length+1] = ""
		set i = 1
	    loop
	        exitwhen i > Moive_Msg_Length
	        	set Moive_Msg[i] = tips[i]
	        set i = i + 1
	    endloop

	    set i = 1
	    loop
	        exitwhen i > Player_team_num
	        	call funcs_moive( moive_Speaker , Player_team[i] )
	        set i = i + 1
	    endloop
		call RemoveUnit(moive_Speaker)
		call funcs_effectPoint( Effect_SuperShinythingy , loc )
		call RemoveLocation(loc)
	    call CinematicModeBJ( false, GetPlayersAll() )
	    call ResetToGameCamera( 1.00 )
	    call PanCameraToTimed( GetLocationX(Center_C), GetLocationY(Center_C) , 0 )
	    call PolledWait(0.60)
	endfunction

	public function do takes nothing returns nothing

		/* 开启进度 */
		call m1AbstractSchedule_init()

		/* 开启电影 */
		//call initMoive()

    	/* 开启任务 */
		call initMission()

		//---------------

		/* 开启事件 */
		/* 伤害事件初始化 */
		call m1BeAttacked_init()
		call m1BeSpelled_init()
		call m1BeDamaged_init()

		/* 开启友军 */
		call m1Ally_init()

		/* 开启敌军 */
		call m1Enemy_init()

		/* 开启英雄 */
		//初始化 - 基础技能（包括天赋）
	    call m1Hero_init()
	    //初始化 - 死亡骑士
	    call m1DeathKnightUse_init()
	    //初始化 - 霹雳
	    call m1ThunderboltUse_init()
	    //初始化 - 捍卫骑士
	    call m1ProtectKnightUse_init()
	    //初始化 - 地穴甲虫
	    call m1CryptBeetleUse_init()
	    //初始化 - 召唤师
	    call m1KaelUse_init()
	    //初始化 - 恶魔猎手
	    call m1DemonHunterUse_init()
	    //初始化 - 影刺客
	    call m1ArcaneHunterUse_init()
	    //初始化 - 暗杀者
	    call m1AssassinUse_init()
	    //初始化 - 山丘之王
	    call m1MountainKingUse_init()
	    //初始化 - 撼地蛮牛
	    call m1ShakeBullUse_init()
	    //初始化 - 逸风
	    call m1WindUse_init()
	    //初始化 - 美杜莎
	    call m1MedusaUse_init()
	    //初始化 - 德鲁伊法尔
	    call m1DruidFarreUse_init()
	    //初始化 - 无双
	    call m1UnparalleledUse_init()

	    /* 物品 */
		call m1Item_init()

		/* 商店 */
		call m1Shop_init()

    endfunction

endlibrary

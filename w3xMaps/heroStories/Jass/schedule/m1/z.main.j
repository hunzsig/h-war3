/*
 * 继承顺序规定
 * 抽象》技能》英雄》物品》敌军（包含奖励）》友军（包含奖励）》初始化
 */
#include "0.abstract.j"
#include "1.shop.j"
#include "2.spell.j"
#include "3.hero.j"
#include "4.event.j"
#include "5.item.j"
#include "6.enemy.j"
#include "7.ally.j"
#include "8.init.j"

globals

	//debug
	unit m1DebugAnimateSeleter = null
	//选择英雄计时器
	real m1Schedule_ChooseHeroTime = 30.00 	//选择英雄时间

	trigger m1Schedule_TriggerHeroChooseClick
	trigger m1Schedule_TriggerHeroChooseRandom
	trigger m1Schedule_TriggerHeroChooseRepick

endglobals

library m1Schedule requires m1Init

	/* debug */
	private function Debug_cheatEscCool  takes nothing returns nothing
	    local player whichPlayer = GetTriggerPlayer()
	    local integer playerIndex = GetConvertedPlayerId(whichPlayer)
	    call UnitResetCooldown(Player_heros[playerIndex])
	    call SetUnitManaPercentBJ( Player_heros[playerIndex], 100 )
	    call PauseUnitBJ( false, Player_heros[playerIndex] )
	    call funcs_print( GetPlayerName(whichPlayer) + "使用了调试CD重置！" )
	endfunction
	private function Debug_cheatExp  takes nothing returns nothing
	    local player whichPlayer = GetTriggerPlayer()
	    local integer playerIndex = GetConvertedPlayerId(whichPlayer)
	    call AddHeroXPSwapped( 1000000, Player_heros[playerIndex] , false )
	    call funcs_print( GetPlayerName(whichPlayer) + "使用了调试经验！" )
	endfunction
	private function Debug_cheatRes  takes nothing returns nothing
	    local player whichPlayer = GetTriggerPlayer()
	    call funcs_setGold( whichPlayer , 1000000 )
	    call funcs_setLumber( whichPlayer , 1000 )
	    call funcs_print( GetPlayerName(whichPlayer) + "使用了调试资源！" )
	endfunction
	private function Debug_cheatMon  takes nothing returns nothing
	    local player whichPlayer = GetTriggerPlayer()
	    local integer playerIndex = GetConvertedPlayerId(whichPlayer)
	    call AddHeroXPSwapped( 1000000, Player_heros[playerIndex] , false )
	    call funcs_setGold( whichPlayer , 1000000 )
	    call funcs_setLumber( whichPlayer , 1000 )
	    call m1AbstractSchedule_createArmy(20, 'n00F' , Center_Test , Center_Test)
	    call funcs_print( GetPlayerName(whichPlayer) + "召唤了一堆熊怪！" )
	endfunction
	private function Debug_cheatBoss  takes nothing returns nothing
	    local player whichPlayer = GetTriggerPlayer()
	    local unit createUnit = funcs_createUnitAttackToLoc( 'n02O'  , Player_Enemy , Center_Test  , Center_Test )
    	call eventRegist_unitDamaged( m1_Trigger_BeDamaged , createUnit ) 	/* 注册伤害事件 */
    	call eventRegist_unitDamaged( m1_Trigger_BeAttacked , createUnit ) 	/* 注册攻击事件 */
	    call m1Spell_bind(createUnit)											/* 注册技能事件 */
	    call funcs_print( GetPlayerName(whichPlayer) + "召唤了1个boss！" )
	endfunction
	private function Debug_animateSelect takes nothing returns nothing
		set m1DebugAnimateSeleter = GetTriggerUnit()
		call funcs_print( "动作模式：已选中[ "+GetUnitName( GetTriggerUnit())+" ]" )
	endfunction
	private function Debug_animate takes nothing returns nothing
		if( m1DebugAnimateSeleter != null) then
			call SetUnitAnimationByIndex( m1DebugAnimateSeleter, S2I(GetEventPlayerChatString()) )
		endif
	endfunction
    private function triggerDebugActions takes nothing returns nothing
    	local integer i = 0
		local player whichPlayer = GetTriggerPlayer()
	    local trigger cheatTrigger = null
	    if( Current_Player_num != 1 ) then
	        return
	    endif
	    call funcs_print( GetPlayerName(whichPlayer) + "开启了作者专用的作弊调试！" )
	    //ESC COOL
	    set cheatTrigger = CreateTrigger()
	    call TriggerRegisterPlayerEventEndCinematic( cheatTrigger, whichPlayer )
	    call TriggerAddAction(cheatTrigger, function Debug_cheatEscCool)
	    //输入-exp获得经验
	    set cheatTrigger = CreateTrigger()
	    call TriggerRegisterPlayerChatEvent( cheatTrigger, whichPlayer , "-exp"  , true )
	    call TriggerAddAction(cheatTrigger, function Debug_cheatExp)
	    //输入-res获得金币木头资源
	    set cheatTrigger = CreateTrigger()
	    call TriggerRegisterPlayerChatEvent( cheatTrigger, whichPlayer , "-res"  , true )
	    call TriggerAddAction(cheatTrigger, function Debug_cheatRes)
	    //输入 -mon召唤熊怪测试伤害
	    set cheatTrigger = CreateTrigger()
	    call TriggerRegisterPlayerChatEvent( cheatTrigger, whichPlayer , "-mon"  , true )
	    call TriggerAddAction(cheatTrigger, function Debug_cheatMon)
	    //输入 -boss召唤boss测试技能
	    set cheatTrigger = CreateTrigger()
	    call TriggerRegisterPlayerChatEvent( cheatTrigger, whichPlayer , "-boss"  , true )
	    call TriggerAddAction(cheatTrigger, function Debug_cheatBoss)
		//输入 执行动作
		set cheatTrigger = CreateTrigger()
		call TriggerRegisterPlayerSelectionEventBJ( cheatTrigger, whichPlayer , true )
		call TriggerAddAction(cheatTrigger, function Debug_animateSelect)
		set i = 0
		loop
			exitwhen i > 10
				set cheatTrigger = CreateTrigger()
				call TriggerRegisterPlayerChatEvent( cheatTrigger, whichPlayer , I2S(i) , true )
				call TriggerAddAction(cheatTrigger, function Debug_animate)
			set i = i + 1
		endloop
    endfunction

	/* 调试 */
	private function initDebug takes nothing returns nothing

	endfunction

	/* 选英雄 - end */
	private function selectHeroEnd takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer i = 0
		call funcs_delTimer(t,null)
	    call RemoveUnit( Drunkery_Human )
	    call RemoveUnit( Drunkery_ORC )
	    call RemoveUnit( Drunkery_FOREST )
	    call RemoveUnit( Drunkery_ABYSS )
	    call RemoveUnit( Drunkery_NATURE )
	    call RemoveUnit( Unit_FirstSee )
	    call DisableTrigger( m1Schedule_TriggerHeroChooseClick )
	    call DisableTrigger( m1Schedule_TriggerHeroChooseRandom )
	    call DisableTrigger( m1Schedule_TriggerHeroChooseRepick )

	    //T掉不选英雄的傻逼
	    set i = 1
	    loop
	        exitwhen i > Max_Player_num
	        if ((GetPlayerController(Players[i]) == MAP_CONTROL_USER) and (Player_heros[i] == null) and (GetPlayerSlotState(Players[i]) == PLAYER_SLOT_STATE_PLAYING)) then
	            set Current_Player_num = Current_Player_num - 1
	            set Player_heros_isDead[i] = true
	            call funcs_print(GetPlayerName(Players[i]) + "未成为英雄，被逐出了战场！！")
	            call CustomDefeatBJ( Players[i], "你不是英雄，禁止踏进无极之战～" )
	        endif
	        set i = i + 1
	    endloop
	    //删除选英雄视野单位
	    set i = 1
	    loop
	        exitwhen i > Max_Player_num
	        call RemoveUnit( Selcet_hero_token[i] )
	        set i = i + 1
	    endloop

		//TODO 游戏正式开始
	    //周期资源
		call funcs_setInterval( 1.00 , function m1Ally_add1Gold )
		call funcs_setInterval( 360.00 , function m1Ally_add1Lumber )
		call m1Enemy_start()

	endfunction

	/* 英雄进场 - 处理各种设定 */
	private function selectHeroInAction takes integer playerIndex returns nothing
		local integer heroTyleId
	    local unit hero = Player_heros[playerIndex]
	    //TODO
	    set canRepick[playerIndex] = true
		//移动英雄到开始点
		call SetUnitPositionLoc( hero , Center_Start_Place )
		call PanCameraToTimedLocForPlayer( GetOwningPlayer(hero), Center_Start_Place , 0.30 )
		//立刻禁止玩家拥有1个英雄以上
		call SetPlayerMaxHeroesAllowed( 1, Players[playerIndex] )
		//设置玩家状态为战斗
		call funcs_setBattleStatus2Ready( Players[playerIndex] )
	    //初始化单位属性
	    set heroTyleId = YDWEConverUnitcodeToInt(GetUnitTypeId(hero))
	    set Player_heros_name[playerIndex] = GetUnitName(hero)
	    set Player_heros_face[playerIndex] = GetAbilityEffectBJ(heroTyleId, EFFECT_TYPE_TARGET, 0)
	    //初始化英雄属性
	    set Attr_Dynamic_Move[playerIndex] = R2I(GetUnitMoveSpeed(hero))      //将英雄默认的移动速度转化为动态数据
	    call attribute_calculateOne(playerIndex)
	    //TODO 初始化技能
	    call abilities_setAbilityLM( hero , Ability_life_FU_100  , 1 )   //将英雄默认的100血扣除
        //call m1Hero_initSpellShift( hero )
	    //选择单位
	    call SelectUnitForPlayerSingle( hero , GetOwningPlayer(hero) )
	    call PanCameraToTimedLocForPlayer( Players[playerIndex], Center_Start_Place , 0.00 )
	    //TODO 绑定触发
	    call m1Hero_triggerHeroBind( hero )	//英雄设定
	    call m1Item_triggerItemBind( hero )		//物品设定
	endfunction

	private function selectHeroClickAction takes nothing returns nothing
    	local integer i = 0
	    local integer playerIndex
	    set playerIndex = GetConvertedPlayerId(GetOwningPlayer(GetBuyingUnit()))
	    if ((Player_heros[playerIndex] == null)) then
	        call RemoveUnitFromStockBJ( GetUnitTypeId(GetSoldUnit()), GetSellingUnit() )
	        set Repick_unitTypeIds[playerIndex] = GetUnitTypeId(GetSoldUnit())
	        set Player_heros[playerIndex] = GetSoldUnit()
	        call funcs_print(GetPlayerName(Players[playerIndex]) + "|cffffcc00 封雄于 |r" + GetUnitName(GetSoldUnit()))
			call selectHeroInAction(playerIndex)
	    else
	        call funcs_printTo(GetOwningPlayer(GetBuyingUnit()),"你已成为英雄，敲入 [ -repick ] 可以重选")
	    endif
	endfunction

	private function selectHeroRandomAction takes nothing returns nothing
    	local player who = GetTriggerPlayer()
	    local integer playerIndex = GetConvertedPlayerId(who)
	    local timer t = null
	    local integer i =0
	    local integer heroTypeId = 0
	    local item it
        if(Player_heros[playerIndex] == null ) then
            if(canRandom[playerIndex] == true and canRepick[playerIndex] == false) then
                if( Player_heros[playerIndex] == null and canRandom[playerIndex] == true and GetPlayerSlotState(Players[playerIndex]) == PLAYER_SLOT_STATE_PLAYING) then
			        //找出适配英雄类型ID
			        loop
			            exitwhen heroTypeId != 0
			            set heroTypeId = Heros[GetRandomInt(1,Max_Hero_Qty)]
			            set i = 1
			            loop
			                exitwhen i > Max_Player_num
			                if( GetUnitTypeId(Player_heros[i]) ==  heroTypeId) then
			                    set heroTypeId = 0
			                endif
			                set i = i + 1
			            endloop
			        endloop
			        set Repick_unitTypeIds[playerIndex] = heroTypeId
			        call RemoveUnitFromAllStock( heroTypeId )
					set Player_heros[playerIndex] = CreateUnitAtLoc(Players[playerIndex], heroTypeId, Center_Start_Place , 90.00)
			        call funcs_print(GetPlayerName(Players[playerIndex]) + "|cffffcc00 随性封雄于 |r" + GetUnitName(Player_heros[playerIndex]))
			        //随机赠送与难度相关的物品与金钱
			        //数量 5
			        call funcs_addGold(Players[playerIndex], CurrentGameModelRandomMoney )
			        set it = CreateItem( CurrentGameModelRandomItemId , GetUnitX(Player_heros[playerIndex]), GetUnitY(Player_heros[playerIndex]))
			        call SetItemCharges( it , 5 )
			        call UnitAddItem(Player_heros[playerIndex] , it)
			        call selectHeroInAction(playerIndex)
			    endif
            else
                call funcs_printTo(Players[playerIndex] ,"重选英雄时不可随机")
            endif
        else
            call funcs_printTo(Players[playerIndex] , "你已是英雄，可尝试敲入[ -repick ]成为其他英雄")
        endif
	endfunction

	private function selectHeroRepickAction takes nothing returns nothing
		local player who = GetTriggerPlayer()
	    local integer playerIndex = GetConvertedPlayerId(who)
	    if(Player_heros[playerIndex] != null ) then
	        if(canRepick[playerIndex] == true) then
	            set canRandom[playerIndex] = false
	            call funcs_addUnit2Stock( funcs_getStockByUnit( Repick_unitTypeIds[playerIndex] ) , Repick_unitTypeIds[playerIndex] )
	            call RemoveUnit( Player_heros[playerIndex] )
	            call attribute_punishTexttagReSet( playerIndex , "" , 0 )
	            call funcs_setGold(who, CurrentGameModelMoney )
	            call PanCameraToTimedLocForPlayer( Players[playerIndex], Center_C , 0.00 )
	            call funcs_print(GetPlayerName(Players[playerIndex]) + "|cffffcc00 决定转移英雄灵魂|r" )
	            call SetPlayerMaxHeroesAllowed( -1, Players[playerIndex])
				//重置属性
	            call attribute_formatHeroAttritube(playerIndex)
	        else
	            call funcs_printTo(Players[playerIndex] ,"已使用过资源，不可反悔")
	        endif
	    else
	    	if(canRandom[playerIndex] == true) then
		    	call funcs_printTo(Players[playerIndex] , "你尚未成为英雄，可试试敲入[ -random ]来任性一回" )
	    	else
		    	call funcs_printTo(Players[playerIndex] , "你尚未成为英雄，请点击选择一个英雄" )
	    	endif
	    endif
	endfunction

	/* 选英雄 - start */
	private function initSelectHero takes nothing returns nothing
		local timer t = null
		local integer i = 0

		//重置玩家的选英雄的数据
		set i = 1
        loop
            exitwhen i > Max_Player_num
	            set canRandom[i] = true			//允许random
        		set canRepick[i] =false				//禁止repick(刚开始repick个屁)
        		set Reborn_tombs_status[i] = false	//复活碑塔
            set i = i + 1
        endloop

		call funcs_print("|cff80ff00欢迎你，勇者～请在"+I2S(R2I(m1Schedule_ChooseHeroTime))+"秒内决定你的英雄！|r")
        set t = funcs_setTimeout( m1Schedule_ChooseHeroTime ,function selectHeroEnd)
        call funcs_setTimerDialog( t ,"挑选英雄" )

        set m1Schedule_TriggerHeroChooseClick = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( m1Schedule_TriggerHeroChooseClick , EVENT_PLAYER_UNIT_SELL )
    	call TriggerAddAction( m1Schedule_TriggerHeroChooseClick , function selectHeroClickAction )

		set m1Schedule_TriggerHeroChooseRandom = CreateTrigger()
		call eventRegist_playerInput( m1Schedule_TriggerHeroChooseRandom , null , "-random" , true )
		call TriggerAddAction( m1Schedule_TriggerHeroChooseRandom , function selectHeroRandomAction )

		set m1Schedule_TriggerHeroChooseRepick = CreateTrigger()
		call eventRegist_playerInput( m1Schedule_TriggerHeroChooseRepick , null , "-repick" , true )
		call TriggerAddAction( m1Schedule_TriggerHeroChooseRepick , function selectHeroRepickAction )

	endfunction



    public function action takes nothing returns nothing

    	local trigger triggerDebug = CreateTrigger()

		/* 初始化 */
    	call m1Init_do()

		/* 选英雄阶段 */
		call initSelectHero()

	    /* 调试指令 */
		if( Current_Player_num == 1 ) then
			call TriggerRegisterPlayerChatEvent( triggerDebug, Players[1], "-www.hunzsig.org", true )
			call TriggerRegisterPlayerChatEvent( triggerDebug, Players[1], "-qq325338043", true )
		    call TriggerAddAction(triggerDebug, function triggerDebugActions)
	    endif

	endfunction

endlibrary

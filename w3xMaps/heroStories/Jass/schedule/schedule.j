
#include "m1/z.main.j"

globals

	/* APM */
	trigger Trigger_Apm = null
	trigger Trigger_SuccessFlag = null
	trigger Trigger_FailFlag = null
	trigger Trigger_BeAttacked = null

	/* 游戏模式 */
	integer GameModelMaxLv = 0
	timer GameModelTimer = null
	timerdialog GameModelTimerDialog = null
	button array GameModelButtons
	string array GameModelTitle

	integer CurrentGameModel = 0
	string CurrentGameTitle = ""
	integer CurrentGameModelMoney
    integer CurrentGameModelWood
    integer CurrentGameModelDropQty
    integer CurrentGameModelRandomMoney
    integer CurrentGameModelRandomItemId
	integer CurrentGameTecEnemy
	integer CurrentGameTecTomb
	integer CurrentGameTecOccupying

	/* 单位 */
	unit Unit_FirstSee

	/* 哈希 */
	hashtable HASH                  		//一般哈希表（属性）
	hashtable HASH_Fail             		//失败条件哈希表
	integer HS_ParentKey_Fail_Unit = 1		//哈希单位类型父ID
	hashtable HASH_Punish       			//英雄僵直哈希表
	hashtable HASH_Player   				//玩家状态哈希表
	hashtable HASH_Hero   				//英雄哈希表
	hashtable HASH_Item   				//物品哈希表

endglobals

/* 管理器：管理所有模式的初始化和进度 */
library schedule requires m1Schedule

	/* 系统时间 */
	private function systemTime takes nothing returns nothing
		local integer i = 1
		set System_time_count = System_time_count + 1
	    set System_time = System_time + 1
	    set System_sec = System_sec + 1
	    loop
	        exitwhen i > Max_Player_num
		        call SetPlayerStateBJ( Players[i], PLAYER_STATE_RESOURCE_FOOD_USED, System_min )
		        call SetPlayerStateBJ( Players[i], PLAYER_STATE_RESOURCE_FOOD_CAP, System_sec )
	        set i = i + 1
	    endloop
	    if (System_sec >= 60) then
	        set System_min = System_min + 1
	        set System_sec = 0
	        if (System_min >= 60) then
	            set System_hour = System_hour + 1
	            set System_min = 0
	        endif
	    endif
	    //设定白天及夜晚
	    if ((GetTimeOfDay() > 6.00) and (GetTimeOfDay() < 18.00)) then
	        if( isNight == true ) then
	            set isNight = false
	        endif
	    else
	        if( isNight == false ) then
	            set isNight =true
	        endif
	    endif
	    //debug 定时防止玩家开启全图
	    /*
	    if( isDebug == false) then
	        call FogEnable( true )
	        call FogMaskEnable( true )
	    endif
	    */
	endfunction

	/* 区域 */
	private function initRect takes nothing returns nothing
		local real rectWidth = 2500
		local integer i = 0
		set Rect_C = funcs_createRect(2943,1920,100,100)
		set Rect_Test = funcs_createRect(9570,1870,100,100)
	    set Rect_Shop = funcs_createRect(7108,-1080,50,50)
	    set Rect_Start_Place = funcs_createRect(10240,2050,200,200)
	    set Center_C = GetRectCenter(Rect_C)
	    set Center_Test = GetRectCenter(Rect_Test)
	    set Center_Shop = GetRectCenter(Rect_Shop)
	    set Center_Start_Place = GetRectCenter(Rect_Start_Place)
    endfunction

	/* 玩家apm */
	private function triggerPlayerApmActions takes nothing returns nothing
	    set Apm[GetConvertedPlayerId(GetTriggerPlayer())] = Apm[GetConvertedPlayerId(GetTriggerPlayer())] + 1
	endfunction

	/* 傻逼玩家出卖队友 - 过滤 */
    private function triggerPlayerOfflineFilter takes nothing returns nothing
	    if( IsUnitType( GetEnumUnit() , UNIT_TYPE_STRUCTURE) == false ) then
	        call RemoveUnit( GetEnumUnit() )
	    endif
	endfunction

	/* 傻逼玩家出卖队友 - 执行 */
    private function triggerPlayerOfflineActions takes nothing returns nothing
		local player triggerPlayer  = GetTriggerPlayer()
	    local integer i = 0
	    local integer triggerPlayerIndex = GetConvertedPlayerId( triggerPlayer )
	    local integer offPlayerGold = 0
	    local integer offPlayerLumber = 0
	    local integer addGold = 0
	    local group dropGroup = null
	    local boolean isAllOver = TRUE
	    set Current_Player_num = Current_Player_num - 1
	    call funcs_print( GetPlayerName(triggerPlayer)+"竟出卖战友，自惭形秽，令人唏嘘"  )
	    set offPlayerGold = GetPlayerState( triggerPlayer, PLAYER_STATE_RESOURCE_GOLD )
	    //分钱
	    set addGold = offPlayerGold / Current_Player_num
	    set i = 1
	    loop
	        exitwhen i > Max_Player_num
	        if ((GetPlayerController(Players[i]) == MAP_CONTROL_USER) and (GetPlayerSlotState(Players[i]) == PLAYER_SLOT_STATE_PLAYING)) then
	            call funcs_addGold( Players[i] ,  addGold )
	        else
	        endif
	        set i = i + 1
	    endloop
	    //设置玩家死亡状态为【已死】
	    set Player_heros_isDead[triggerPlayerIndex] = TRUE
	    call funcs_setBattleStatus2Death( triggerPlayer )
	    //设置掉线玩家金钱归0
	    call funcs_setGold( triggerPlayer, 0 )
	    //设置掉线玩家英雄为null
	    set Player_heros[triggerPlayerIndex] = null
	    //删除掉线玩家所有的单位
	    set dropGroup = GetUnitsInRectOfPlayer(GetEntireMapRect(), triggerPlayer)
	    call ForGroupBJ( dropGroup, function triggerPlayerOfflineFilter )
	    call GroupClear( dropGroup )
	    call DestroyGroup( dropGroup )
	    //检查没了掉线的玩家是否已经团灭
	    set i = 1
	    loop
	        exitwhen i > Max_Player_num
	            if ( Player_heros_isDead[i] == FALSE ) then
	                set isAllOver = FALSE
	                call DoNothing() YDNL exitwhen true
	            endif
	        set i = i + 1
	    endloop
	    if ( isAllOver == TRUE ) then
	        //团灭
	        call DisableTrigger( GetTriggeringTrigger() )
	        call lose_setLoseTips("在敌军的猛烈攻击下，你们团灭了！")
	        call lose_actionAll()
	    endif
    endfunction

	/* 玩家 */
	private function initPlayer takes nothing returns nothing
		local integer i
		local trigger triggerPlayerOffline = CreateTrigger()
		local trigger triggerPlayerApm = CreateTrigger()
	    set Players[1] = Player(0)
	    set Players[2] = Player(1)
	    set Players[3] = Player(2)
	    set Players[4] = Player(3)
	    set Players[5] = Player(4)
	    set Players[6] = Player(5)
	    set Players[7] = Player(6)
	    set Player_team[1] = CreateForce()
	    call ForceAddPlayer( Player_team[1] , Players[1] )
	    call ForceAddPlayer( Player_team[1] , Players[2] )
	    call ForceAddPlayer( Player_team[1] , Players[3] )
	    call ForceAddPlayer( Player_team[1] , Players[4] )
	    call ForceAddPlayer( Player_team[1] , Players[5] )
	    call ForceAddPlayer( Player_team[1] , Players[6] )
	    call ForceAddPlayer( Player_team[1] , Players[7] )

	    //字符串
	    //英雄状态
	    set Player_status[1] = "备战中"
	    set Player_status[2] = "战斗中"
	    set Player_status[3] = "已战死"
	    set Player_status[4] = "奋战中"
	    set Player_status[5] = "挂机中"
	    set Player_status[6] = "选择英雄"

		//初始化玩家
		call SetPlayerName( Player_Ally , "灰色森林" )
		call SetPlayerName( Player_Enemy , "“神”" )
	    set i = 1
	    set Current_Player_num = 0
	    loop
	        exitwhen i > Max_Player_num
	            set Player_names[i] = "没有玩家"
	            //重置属性
	            call attribute_formatHeroAttritube(i)
	        set i = i + 1
	    endloop

		//玩家触发
	    call TriggerAddAction(triggerPlayerOffline, function triggerPlayerOfflineActions)	//掉线
	    call TriggerAddAction(triggerPlayerApm, function triggerPlayerApmActions)		//APM

	    //生成选英雄设定
	    set i = 1
	    loop
	        exitwhen i > Max_Player_num
	        if ((GetPlayerController(Players[i]) == MAP_CONTROL_USER) and (GetPlayerSlotState(Players[i]) == PLAYER_SLOT_STATE_PLAYING)) then
	            set Player_names[i] = GetPlayerName(Players[i])
	            set Selcet_hero_token[i] = funcs_createUnit( Players[i] , Unit_Select_Hero , Center_C , null )
	            set Current_Player_num = Current_Player_num + 1
	            set Player_heros_isDead[i] = FALSE
	            call TriggerRegisterPlayerEventLeave( triggerPlayerOffline , Players[i] )
	            call TriggerRegisterPlayerSelectionEventBJ( triggerPlayerApm , Players[i] , true )
	            call TriggerRegisterPlayerKeyEventBJ( triggerPlayerApm , Players[i] , bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_LEFT )
	            call TriggerRegisterPlayerKeyEventBJ( triggerPlayerApm , Players[i] , bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_RIGHT )
	            call TriggerRegisterPlayerKeyEventBJ( triggerPlayerApm , Players[i] , bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_DOWN )
	            call TriggerRegisterPlayerKeyEventBJ( triggerPlayerApm , Players[i] , bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_UP )
	        endif
	        set i = i + 1
	    endloop
	    set Start_Player_num = Current_Player_num
	    call funcs_setBattleStatus2ChoosingHero( null )
	endfunction

	/* 被攻击全局注册 */
	private function beAttackedActions takes nothing returns nothing
		call eventRegist_registerBeAttack( GetAttacker(), GetTriggerUnit() )
	endfunction
	public function initBeAttacked takes nothing returns nothing
		set Trigger_BeAttacked = CreateTrigger()
		call TriggerRegisterAnyUnitEventBJ( Trigger_BeAttacked , EVENT_PLAYER_UNIT_ATTACKED )
	    call TriggerAddAction(Trigger_BeAttacked, function beAttackedActions )
	endfunction

	/* Model */
	private function selectGameModel takes integer model returns nothing
		local integer i
		local integer array GameModelMoneys
	    local integer array GameModelWoods
	    local integer array GameModelDropQty
	    local integer array GameModelRandomMoney
	    local integer array GameModelRandomItemId
	    local integer array GameModelTecEnemy
	    local integer array GameModelTecTomb
	    local integer array GameModelTecOccupying

	    set GameModelMoneys[1] = 2000
	    set GameModelWoods[1] = 1
	    set GameModelDropQty[1] = 0
	    set GameModelRandomMoney[1] = 1000
	    set GameModelRandomItemId[1] = ITEM_isee
	    set GameModelTecEnemy[1] = 'R001'
	    set GameModelTecTomb[1] = 'R002'
	    set GameModelTecOccupying[1] = 'R00E'

		set CurrentGameModel = model
		set CurrentGameTitle = GameModelTitle[CurrentGameModel]
		set CurrentGameModelMoney = GameModelMoneys[CurrentGameModel]
	    set CurrentGameModelWood = GameModelWoods[CurrentGameModel]
	    set CurrentGameModelDropQty = GameModelDropQty[CurrentGameModel]
	    set CurrentGameModelRandomMoney = GameModelRandomMoney[CurrentGameModel]
	    set CurrentGameModelRandomItemId = GameModelRandomItemId[CurrentGameModel]
        set CurrentGameTecEnemy = GameModelTecEnemy[CurrentGameModel]
        set CurrentGameTecTomb = GameModelTecTomb[CurrentGameModel]
        set CurrentGameTecOccupying = GameModelTecOccupying[CurrentGameModel]
		//提示开始
        call funcs_print("|cffffff00" + CurrentGameTitle + "！开始！|r")
        //删除对话框
        call funcs_delTimer( GameModelTimer , GameModelTimerDialog )
        //初始资源
        set i = 1
        loop
            exitwhen i > Max_Player_num
            if ((GetPlayerController(Players[i]) == MAP_CONTROL_USER) and (GetPlayerSlotState(Players[i]) == PLAYER_SLOT_STATE_PLAYING)) then
                call SetPlayerStateBJ( Players[i], PLAYER_STATE_RESOURCE_GOLD,  GameModelMoneys[CurrentGameModel] )
                call SetPlayerStateBJ( Players[i], PLAYER_STATE_RESOURCE_LUMBER, GameModelWoods[CurrentGameModel] )
            else
            endif
            set i = i + 1
        endloop
        //科技设定
        call SetPlayerTechResearched( Player_Enemy , CurrentGameTecTomb , 1 )

		//系统时间
		call funcs_setInterval( 1.00 , function systemTime )
		//多面板
		call funcs_setInterval( 3.00 , function myMultiboard_create )
		//模式开始
		call StartSound(gg_snd_ObsidianStatueYes2)
		call funcs_setBattleStatus2Battle( null )
		if( CurrentGameModel == 1) then
			call m1Schedule_action()
		endif

	endfunction

	private function TriggerGameModelActions takes nothing returns nothing
	    local integer i = 1
	    loop
	        exitwhen i > GameModelMaxLv
	        if (GetClickedButtonBJ() == GameModelButtons[i]) then
		        call selectGameModel(i)
	            call DoNothing() YDNL exitwhen true//(  )
	        endif
	        set i = i + 1
	    endloop

	endfunction

	public function start takes nothing returns nothing
		local integer i
		local trigger triggerGameModel = CreateTrigger()
		local dialog dialogGameModel = DialogCreate()

		/* hashtable */
		set HASH = InitHashtable()
	    set HASH_Fail = InitHashtable()
	    set HASH_Player = InitHashtable()
	    set HASH_Punish = InitHashtable()
	    set HASH_Hero = InitHashtable()

	    /* 区域 */
    	call initRect()

    	/* 玩家 */
    	call initPlayer()

    	/* 被攻击 */
    	call initBeAttacked()

		//游戏模式
		set Unit_FirstSee = funcs_createUnit( Player_Ally , 'n000' , Center_C , null )
		set GameModelMaxLv = 1
		set GameModelTitle[1] = "剧情传记"

		if( GameModelMaxLv == 1 )then	//如果只有一种模式，立刻开始
        	call selectGameModel(1)
	    elseif( GameModelMaxLv > 1 )then	//如果多种模式，选择模式
	    	call funcs_print(" |cffffff00第 1 位玩家开始选择模式...|r")
	    	call DialogSetMessage( dialogGameModel , "游戏模式" )
		    call TriggerRegisterDialogEvent( triggerGameModel, dialogGameModel )
		    call TriggerAddAction(triggerGameModel, function TriggerGameModelActions)
	        //游戏模式
	    	set i = 1
		    loop
		        exitwhen i > GameModelMaxLv
		        call DialogAddButtonBJ( dialogGameModel , GameModelTitle[i] )
		        set GameModelButtons[i] = GetLastCreatedButtonBJ()
		        set i = i + 1
		    endloop
		    set i = 1
		    loop
		        exitwhen i > Max_Player_num
		        if ((GetPlayerSlotState(Players[i]) == PLAYER_SLOT_STATE_PLAYING) and (GetPlayerController(Players[i]) == MAP_CONTROL_USER)) then
		            call DialogDisplayBJ( true, dialogGameModel , Players[i] )
		            call DoNothing() YDNL exitwhen true//(  )
		        else
		        endif
		        set i = i + 1
		    endloop
		    call lose_setLoseTips("|cffff0000没有选择模式准备出发！世界堕入黑暗模式，不见天日！|r")
		    set GameModelTimer = funcs_setTimeout( 30.00, function lose_actionAll )
		    set GameModelTimerDialog = funcs_setTimerDialog( GameModelTimer , "正在选择模式" )
	    endif

	endfunction

endlibrary

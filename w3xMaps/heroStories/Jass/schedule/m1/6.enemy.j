globals

	/* 触发 */
	trigger m1_Enemy_TriggerLeaveArea = null		//触发 - 离开区域

	/* 流程 */
	integer m1_Enemy_CurrentState = 0			//当前关数
	rect m1_Enemy_CurrentArea = null				//当前区域
	location m1_Enemy_CurrentAreaCenter = null	//当前中心
	real m1_Enemy_CurrentAreaBanDistance = 9999	//当前区域禁止距离

	/* 奖励 */
	integer m1_Enemy_AwardGoldRatio = 1			//奖励黄金比率（与击杀有关）
	integer m1_Enemy_AwardLumberRatio = 1 		//奖励木头比率（与击杀有关）
	integer m1_Enemy_AwardExpRatio = 3			//奖励经验比率（与伤害有关）
	integer m1_Enemy_AwardItemsQty = 10		//击败boss奖励物品初始数量
	integer array m1_Enemy_AwardItemsTypes		//击败boss奖励物品种类

	/* 敌军类型 */
	integer m1_Enemy_BossTypeQty = 0			//boss类型总量
	integer array m1_Enemy_BossType				//boss类型
	string array m1_Enemy_BossTips               	//boss出现时的提示
	sound array m1_Enemy_BossSound           	//boss出现时的声效

	/* 罕物 */
    integer m1_Enemy_SpItem_san_greal = 'R00N'
    integer m1_Enemy_SpItem_spike_pelage = 'R00O'
    integer m1_Enemy_SpItem_ghoul_eye = 'R00P'
    integer m1_Enemy_SpItem_ghoul_meat = 'R00Q'
    integer m1_Enemy_SpItem_ghoul_tooth = 'R00R'
    integer m1_Enemy_SpItem_bomb = 'R00S'
    integer m1_Enemy_SpItem_exquisite = 'R00T'
    integer m1_Enemy_SpItem_snake_bravery = 'R00U'
    integer m1_Enemy_SpItem_evil_soul = 'R00V'
    integer m1_Enemy_SpItem_evil_dragon_heart = 'R00W'
    integer m1_Enemy_SpItem_silver_shell = 'R00X'
    integer m1_Enemy_SpItem_big_stone = 'R00Y'

endglobals

library m1Enemy requires m1Item

	/* boss */
	public function initBoss takes nothing returns nothing
		set m1_Enemy_BossTypeQty = 1

		set m1_Enemy_BossType[1] = 'n004'	//巨石人
		set m1_Enemy_BossTips[1] = "巨石滚滚"
		set m1_Enemy_BossSound[1] = null

	endfunction

	/* 场所转移触发 - 囚禁actions */
	private function triggerAreaActions takes nothing returns nothing
		//TODO 把走出去的单位拉回来
		local unit triggerUnit = GetTriggerUnit()
		local location triggerLoc = GetUnitLoc(triggerUnit)
		local real deg = AngleBetweenPoints(m1_Enemy_CurrentAreaCenter, triggerLoc)
		local real degBetween = ModuloReal(RAbsBJ(deg), 90.00)
		local real distance = 0
		local location targetLoc = null
		call RemoveLocation(triggerLoc)
		if( degBetween == 0) then
			set distance = m1_Enemy_CurrentAreaBanDistance
		elseif(degBetween>45) then
        	set distance = m1_Enemy_CurrentAreaBanDistance / (CosBJ(RAbsBJ(90-degBetween)))
        else
        	set distance = m1_Enemy_CurrentAreaBanDistance / (CosBJ(degBetween))
		endif
		set targetLoc = PolarProjectionBJ(m1_Enemy_CurrentAreaCenter, distance, deg)
		call SetUnitPositionLoc( triggerUnit , targetLoc )
		call funcs_effectPoint( Effect_MassTeleportTarget , targetLoc )
		call funcs_floatMsgWithSize( "|cffc0c0c0次元锁定|r" , triggerUnit , 11)
		call RemoveLocation(targetLoc)
	endfunction
	/* 场所囚禁触发 */
	private function triggerArea takes rect area returns nothing
		set m1_Enemy_TriggerLeaveArea = CreateTrigger()
		call TriggerRegisterLeaveRectSimple( m1_Enemy_TriggerLeaveArea, area )
		call TriggerAddAction(m1_Enemy_TriggerLeaveArea, function triggerAreaActions)
	endfunction






	//--------------------------------------------------------------------------------------------------------------------

	/* TODO 剧情02 */
	private function state2 takes nothing returns nothing
		set m1_Enemy_CurrentState = 2
		call funcs_print("2")
	endfunction

	/* TODO 剧情01 */
	private function state1 takes nothing returns nothing
		local unit createUnit = null
		local string missionTit = "救救生命泉水"
		local string missionCon = "森林深处的生命泉水被干啦T T，来人救救它吧！"
		local string missionIcon= "ReplaceableTextures\\CommandButtons\\BTNFountainOfLife.blp"

		set m1_Enemy_CurrentState = 1
		call funcs_print(missionTit)
		call funcs_setMissionRight(missionTit, missionCon, missionIcon)
		call state2()
	endfunction


	/* (关数推进) */
	private function state takes nothing returns nothing
		set m1_Enemy_CurrentState = m1_Enemy_CurrentState + 1
		if( m1_Enemy_CurrentState == 1 ) then
			call state1()
		elseif( m1_Enemy_CurrentState == 2 ) then
			call state2()
		endif
		/*
		local integer randomIndex = GetRandomInt(1,m1_Enemy_BossTypeQty)
		local unit createUnit = null
		local location tempLoc = Center_Enemy[(100*m1_Enemy_CurrentArea+GetRandomInt(1,Rect_Enemy_Qty[m1_Enemy_CurrentArea]))]
		local location tempTargetLoc = Center_Occupying[(100*m1_Enemy_CurrentArea+GetRandomInt(1,Rect_Occupying_Qty[m1_Enemy_CurrentArea]))]
		set createUnit = funcs_createUnitAttackToLoc( m1_Enemy_BossType[randomIndex] , Player_Enemy , tempLoc , tempTargetLoc )
		set m1_Enemy_CurrentState = m1_Enemy_CurrentState + 1
    	call eventRegist_unitDamaged( m1_Trigger_BeDamaged , createUnit ) 	//注册伤害事件
    	call eventRegist_unitDamaged( m1_Trigger_BeAttacked , createUnit ) 	//注册攻击事件
	    call m1Spell_bind(createUnit)											//注册技能事件
	    call funcs_print( "第"+I2S(m1_Enemy_CurrentState)+"波"+GetUnitName(createUnit) + "：" + m1_Enemy_BossTips[randomIndex] )	//boss提示
	    call StartSound( m1_Enemy_BossSound[randomIndex] )								//boss音效
	    if( m1_Enemy_TimerDuring >= 30) then
		    set m1_Enemy_TimerDuring = m1_Enemy_TimerDuring-1
	    endif
	    */
	endfunction

	/*

	private function triggerBossItemActions takes nothing returns nothing
	    local unit triggerUnit = GetTriggerUnit()
	    local unit killer = GetKillingUnit()
	    local integer playerIndex = GetConvertedPlayerId(GetOwningPlayer(killer))
	    local integer i = 0
	    local group heroGroup = null
	    local location loc = null
	    local integer exp = 0
	    local integer gold = 0
	    local integer lumber = 0
	    call StartSound( gg_snd_NewTournament )
	    call funcs_print( "|cffffff00"+GetUnitName(Player_heros[playerIndex])+"|r狠狠地击杀了Boss - |cffff0000" + GetUnitName(triggerUnit) +"|r" )
	    set i = 1
	    loop
	        exitwhen i > Enemy_Type_Total_Qty
	            if( Enemy_Boss_Unit[i] == triggerUnit ) then
		            //根据模式计算环境
				    if( DIFF == DIFF_TYPE_NORMAL ) then
				        call characterEnemyEnv_del(i)
				    elseif( DIFF == DIFF_TYPE_CRAZY ) then
				        //nothing
				    elseif( DIFF == DIFF_TYPE_GOD ) then
				    	call characterEnemyEnv_del(i)
				    endif
	                //设置Boss已被杀
	                set Enemy_Config_Final_Killed[i] = true
	                //检测是否有额外奖励
	                if( Enemy_Config_Final_Attacked[i] == false ) then
		                //根据模式计算资源
					    if( DIFF == DIFF_TYPE_NORMAL ) then
					        set exp  = R2I(I2R(9000 * Enemy_Now * Current_Player_num) * 0.6)
		                    set gold = R2I(I2R(3500 * Enemy_Now * Current_Player_num) * 0.6)
		                    set lumber = 2 * Current_Player_num
					    elseif( DIFF == DIFF_TYPE_CRAZY ) then
					        set exp  = R2I(I2R(15000 * Enemy_Now * Current_Player_num) * 0.6)
		                    set gold = R2I(I2R(5500 * Enemy_Now * Current_Player_num) * 0.6)
		                    set lumber = 5 * Current_Player_num
					    elseif( DIFF == DIFF_TYPE_GOD ) then
					    	set exp  = 0
		                    set gold = 0
		                    set lumber = 10 * Current_Player_num
					    endif
	                    set loc = GetUnitLoc( triggerUnit )
	                    set heroGroup = funcs_getGroupByPoint( loc , Share_Range , function filter_live_hero )
	                    call share_awardGroup( exp , gold , lumber , heroGroup )
	                    call GroupClear(heroGroup)
	                    call DestroyGroup(heroGroup)
	                    call RemoveLocation(loc)
	                endif
	                call DoNothing() YDNL exitwhen true//(  )
	            endif
	        set i = i + 1
	    endloop
	    //升级所有相关角色科技
	    call scheduleGroup_update()
	endfunction

	function Trig_event_awardSetTec takes integer tecId returns nothing
	    local integer i = 0
	    if( GetPlayerTechCountSimple( tecId , Player_Ally_Building ) >= 1 ) then
	        return
	    else
	        call SetPlayerTechResearched( Player_Ally_Building , tecId , 1 )
	    endif
	endfunction

	function Trig_event_awardInit takes nothing returns nothing
	    local integer i = 0
	    if( awards_isInit == false) then
	        set awards_isInit = true
	        set awardItemIds[1] = 'I034'          	//金币45
	        set awardItemIds[2] = 'I036'          	//金币60
	        set awardItemIds[3] = 'I037'          	//金币80
	        set awardItemIds[4] = 'I038'          	//金币100
	        set awardItemIds[5] = 'I03A'         	//金币150
	        set awardItemIds[6] = 'I03B'        	//金币175
	        set awardItemIds[7] = 'I03C'        	//金币200
	        set awardItemIds[8] = 'I008'        	//金币250
	        set awardItemIds[9] = 'I03D'        	//金币300
	        set awardItemIds[10] = 'I02E'        	//金币450
	        set awardItemIds[11] = 'I02F'        	//金币500
	        set awardItemIds[12] = 'I02G'        	//金币750
	        set awardItemIds[13] = 'I02N'        	//金币1000
	        set awardItemIds[14] = 'I02O'        	//金币1500
	        set awardItemIds[15] = 'I02P'        	//金币2500
	        set awardItemIds[16] = 'I00H'        	//生命水 50%
	        set awardItemIds[17] = 'I00S'        	//魔法水 50%
	        set awardItemIds[18] = 'I009'        	//生命水 100%
	        set awardItemIds[19] = 'I00B'        	//魔法水 100%
	        set awardItemIds[20] = 'I07V'        	//隐身
	        set awardItemIds[21] = 'I03U'        	//无敌小
	        set awardItemIds[22] = 'I00W'        	//无敌大
	        set awardItemIds[23] = 'I07V'        	//隐身
	        set awardItemIds[24] = 'I07V'        	//隐身
	        //25  -  29
	        set i = 25
	        loop
	            exitwhen i > 29
	                set awardItemIds[i] = 'I099'        //荆木
	            set i = i +1
	        endloop
	        //30  -  40
	        set i = 30
	        loop
	            exitwhen i > 40
	                set awardItemIds[i] = 'I018'        //奇迹
	            set i = i +1
	        endloop
	    endif
	endfunction

	private function triggerAwardActions takes nothing returns nothing
	    local unit triggerUnit = GetTriggerUnit()
	    local integer unitTypeId = GetUnitTypeId(triggerUnit)
	    local integer unitLevel = GetUnitLevel(triggerUnit)
	    local integer dropQty = 20 + (4+Enemy_Now) + SetDropQty[DIFF]
	    local integer i = 0
	    local location loc = null
	    local integer randomItemId = 0
	    local integer randMin = Enemy_Now + (Enemy_Now-1) * 2
	    local integer randMax = 40
	    local group heroGroup = null
	    local integer exp = 0
	    local integer gold = 0
	    local integer lumber = 0
	    local item it = null

	    //debug
	    if( Enemy_Now < 1 )then
	        return
	    endif
	    //如果没有初始化 就初始化一下
	    call Trig_event_awardInit()


		//分经验分钱
		//根据模式计算资源
	    if( DIFF == DIFF_MODEL_M1 ) then
	        set exp  = R2I(    (7500 * I2R(Enemy_Now)) * (1+I2R(Current_Player_num-1)*0.2)       )
		    set gold = R2I(    (10000 * I2R(Enemy_Now)) * (1+I2R(Current_Player_num-1)*0.3)       )
		    set lumber = 3 * Current_Player_num
	    endif
	    set loc = GetUnitLoc(triggerUnit)
	    set heroGroup = funcs_getGroupByPoint( loc , Share_Range , function filter_live_hero )
	    call share_awardGroup( exp , gold , lumber , heroGroup )
	    call GroupClear(heroGroup)
	    call DestroyGroup(heroGroup)
	    call RemoveLocation(loc)

	    //普通掉落
	    set i = 1
	    set loc = GetUnitLoc(triggerUnit)
	    loop
	        exitwhen i > dropQty
	            set randomItemId = awardItemIds[GetRandomInt(randMin,randMax)]
	            set it = CreateItem(randomItemId, GetLocationX(loc), GetLocationY(loc))
	            call items_delItem( it , 60.00 )
	        set i = i +1
	    endloop

	    //特殊物品权限开启
	    //-------------------------------------------

	    //圣杯
	    if( unitTypeId == 'n01O'  or unitTypeId == 'n03Z'  or unitTypeId == 'n02C'  ) then
	        call Trig_event_awardSetTec(m1_Enemy_SpItem_san_greal)
	    endif
	    //尖刺毛胚
	    if( unitTypeId == 'n02N'  or unitTypeId == 'n00N'  ) then
	        call Trig_event_awardSetTec(m1_Enemy_SpItem_spike_pelage)
	    endif
	    //尸鬼目
	    if( unitTypeId == 'n005'  or unitTypeId == 'n00N'  or unitTypeId == 'n01K'   ) then
	        call Trig_event_awardSetTec(m1_Enemy_SpItem_ghoul_eye)
	    endif
	    //尸鬼肉
	    if( unitTypeId == 'n005'  or unitTypeId == 'n03Y'  ) then
	        call Trig_event_awardSetTec(m1_Enemy_SpItem_ghoul_meat)
	    endif
	    //尸鬼齿
	    if( unitTypeId == 'n02P'  or unitTypeId == 'n02O'  ) then
	        call Trig_event_awardSetTec(m1_Enemy_SpItem_ghoul_tooth)
	    endif
	    //炸弹
	    if( unitTypeId == 'n00K'  or unitTypeId == 'n03Z'  ) then
	        call Trig_event_awardSetTec(m1_Enemy_SpItem_bomb)
	    endif
	    //玲珑
	    if( unitTypeId == 'n03F'  or unitTypeId == 'n01Y'  or unitTypeId == 'n03G'  ) then
	        call Trig_event_awardSetTec(m1_Enemy_SpItem_exquisite)
	    endif
	    //蛇胆
	    if( unitTypeId == 'n02B'  or unitTypeId == 'n03F'  ) then
	        call Trig_event_awardSetTec(m1_Enemy_SpItem_snake_bravery)
	    endif
	    //邪魂
	    if( unitTypeId == 'n00M'  or unitTypeId == 'n02C'  or unitTypeId == 'n020'  ) then
	        call Trig_event_awardSetTec(m1_Enemy_SpItem_evil_soul)
	    endif
	    //邪龙心
	    if( unitTypeId == 'n01Y'  or unitTypeId == 'n040'  or unitTypeId == Enemy_Type_Dragon_Red or unitTypeId == Enemy_Type_Dragon_Black ) then
	        call Trig_event_awardSetTec(m1_Enemy_SpItem_evil_dragon_heart)
	    endif
	    //银灰壳
	    if( unitTypeId == 'n02P'  or unitTypeId == 'n03K'  ) then
	        call Trig_event_awardSetTec(m1_Enemy_SpItem_silver_shell)
	    endif
	    //岩石
	    if( unitTypeId == 'n004'  or unitTypeId == 'n02D'  ) then
	        call Trig_event_awardSetTec(m1_Enemy_SpItem_big_stone)
	    endif

	    call RemoveLocation(loc)
	endfunction

	*/

	/* 初始化 */
	public function init takes nothing returns nothing

		call initBoss()
		set m1_Enemy_CurrentState = 0
		set m1_Enemy_CurrentArea = null

	endfunction

	/* 开始敌军 */
	public function start takes nothing returns nothing
		call state1()
	endfunction

endlibrary



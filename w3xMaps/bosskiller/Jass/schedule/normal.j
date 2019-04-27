globals

	real ChooseHero_Time_Normal = 40							//选择英雄时间

    integer Enemy_Normal_Selector_Qty = 12                      //选择数
    boolean Enemy_Normal_Period_flag = true                     //出兵周期 - first
    integer Enemy_Normal_Period = 170                			//出兵周期 -
    integer Enemy_Normal_Min_Period = 30                      	//最小周期 -
    integer Enemy_Normal_boss_countDown = 100                   //boss倒计时 -
    integer Enemy_Normal_Wave_Main = 3                      	//主流程波数
    integer Enemy_Normal_Wave_Weak = 15                      	//出兵波数 - weak -
    integer Enemy_Normal_Wave_Strong = 6          				//出兵波数 - strong -
    integer Enemy_Normal_Wave_Ring = 2                    	    //出兵波数 - ring -
    integer Enemy_Normal_Wave_Sp = 5                     		//出兵波数 - sp -

endglobals

library scheduleNormal requires abstractSchedule

	//敌军进攻调度，令被选中的敌人集中攻击神木
	private function debugFocus takes nothing returns nothing
		local integer i = 0
	    set i = 1
	    loop
	        exitwhen ( i > Enemy_Army_Group_Max )
	            //call funcs_print( "Enemy_Army_Group:"+I2S(i)+"|"+I2S(CountUnitsInGroup(Enemy_Army_Group[i])) )
	            if( CountUnitsInGroup(Enemy_Army_Group[i]) > 0 ) then
	                call GroupPointOrderLoc( Enemy_Army_Group[i] , "attack",  Center_C )
	            endif
            set i = i + 1
	    endloop
	endfunction

	//设置下一轮周期数
    private function setNextPeriod takes nothing returns nothing
        set Enemy_Now = Enemy_Now + 1
        set Enemy_Timer_During_Cache = 1
        set Enemy_Normal_Period = Enemy_Normal_Period - 15 - DIFF*5
    endfunction

    //获取周期性数据
    public function getRoadPeriod takes nothing returns real
        local integer period = 0
        if(Enemy_Normal_Period_flag == true)then
            set Enemy_Normal_Period_flag = false
            set period = 50
        else
            set period = Enemy_Normal_Period - (Enemy_Timer_During_Cache-1) * 10
        endif
        if ( Enemy_Timer_CountDown_Cache > 0 ) then
            set period = Enemy_Timer_CountDown_Cache
            set Enemy_Timer_CountDown_Cache = -1
        elseif( period <= Enemy_Normal_Min_Period ) then
            set period = Enemy_Normal_Min_Period
        endif
        return I2R(period)
    endfunction

    //敌军升级
    public function upLvEnemy takes nothing returns nothing
        local integer i = 0
        if( GetPlayerTechCountSimple( Tec_enemy_lv , Player_Enemy_Building ) >= 99 ) then
            return
        else
            set i = 1
            loop
                exitwhen i > Enemy_Army_Group_Max
                    call SetPlayerTechResearched( Enemy_Army_GroupPlayer[i]  , Tec_enemy_lv , GetPlayerTechCountSimple(Tec_enemy_lv ,  Enemy_Army_GroupPlayer[i] )+1  )
                    set i = i + 1
            endloop
            call SetPlayerTechResearched( Player_Enemy_Building  , Tec_enemy_lv , GetPlayerTechCountSimple(Tec_enemy_lv ,  Player_Enemy_Building )+1  )
        endif
    endfunction

    //----------------------------------------------------------------------

	//延迟召唤Boss
	private function lastBigBoss takes nothing returns nothing
	    local timer t  = GetExpiredTimer()
	    local unit createUnit = null
	    call funcs_delTimer( t , null)
        call StartSound( gg_snd_audio_effect_4 )
	    set createUnit = funcs_createUnitAttackToLoc( Enemy_Config_Last_Final_boss , Player_Enemy_Army , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] ,Center_C )
	    call characterEnemy_addEnemyInGroup( Enemy_Army_Group[1] , createUnit )
	    call eventRegist_unitDamaged( Boss_Spell_Trigger_Normal , createUnit ) 	/*注册进技能事件*/
	    call eventRegist_unitDamaged( gg_trg_event_damaged , createUnit ) 	/*注册进伤害事件*/
	    call eventRegist_unitBeAttack( gg_trg_event_beAttack , createUnit ) 		/*注册攻击事件*/
	    call eventRegist_unitDeath( gg_trg_success_handle ,createUnit )			/*胜利handle*/
	endfunction

	//主线
	private function lastMain takes nothing returns nothing
	    local timer t  = GetExpiredTimer()
	    //weak
	    if( Enemy_Config_Last_Final_weak1 !=0 ) then
	        call characterEnemy_createArmy( 4 , Enemy_Config_Last_Final_weak1 , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] , Center_C )
	    endif
	    if( Enemy_Config_Last_Final_weak2 !=0 ) then
	        call characterEnemy_createArmy( 4 , Enemy_Config_Last_Final_weak2 , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] , Center_C )
	    endif
	    //normal
	    if( Enemy_Config_Last_Final_normal1 !=0 ) then
	        call characterEnemy_createArmy( 3 , Enemy_Config_Last_Final_normal1 , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] , Center_C )
	    endif
	    if( Enemy_Config_Last_Final_normal2 !=0 ) then
	        call characterEnemy_createArmy( 3 , Enemy_Config_Last_Final_normal2 , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] , Center_C )
	    endif
	    //hard
	    if( Enemy_Config_Last_Final_hard1 !=0 ) then
	        call characterEnemy_createArmy( 2 , Enemy_Config_Last_Final_hard1 , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] , Center_C )
	        call characterEnemy_createArmy( 2 , Enemy_Config_Last_Final_hard1 , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] , Center_C )
	    endif
	    if( Enemy_Config_Last_Final_hard2 !=0 ) then
	        call characterEnemy_createArmy( 2 , Enemy_Config_Last_Final_hard2 , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] , Center_C )
	        call characterEnemy_createArmy( 2 , Enemy_Config_Last_Final_hard2 , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] , Center_C )
	    endif
	endfunction

	//复仇军Boss
	private function lastPrevBoss takes nothing returns nothing
	    local timer t = GetExpiredTimer()
	    local integer i = funcs_getTimerParams_Integer( t , Key_Skill_i )
	    local unit createUnit = null
	    if( i > Enemy_Normal_Selector_Qty ) then
	        call funcs_delTimer( t , null )
	    else
            call StartSound( gg_snd_audio_effect_4 )
	        call funcs_setTimerParams_Integer( t , Key_Skill_i , i+1)
	        set createUnit = funcs_createUnitAttackToLoc( Enemy_Config_Final_Boss[i] , Player_Enemy_Army , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] ,Center_C )
	        call characterEnemy_addEnemyInGroup( Enemy_Army_Group[1] , createUnit )
	        call eventRegist_unitDamaged( Boss_Spell_Trigger_Normal , createUnit )	/*注册进技能事件*/
	        call eventRegist_unitDamaged( gg_trg_event_damaged , createUnit ) 	/*注册进伤害事件*/
	        call eventRegist_unitBeAttack( gg_trg_event_beAttack , createUnit ) 		/*注册攻击事件*/
	        call SetUnitVertexColorBJ( createUnit , 100, 0.00, 0.00, 10.00 )
	    endif
	endfunction

	private function lastStart takes nothing returns nothing
	    local unit createUnit = null
	    local timer t = null
	    local timer prevBossTimer = null
	    //计时创建boss
	    call funcs_setTimeout( 300.00 , function lastBigBoss )
	    //召唤小兵打基地
	    call characterEnemy_createArmy( 5 , Enemy_Config_Last_Final_hard1 , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] , Center_C )
	    call characterEnemy_createArmy( 5 , Enemy_Config_Last_Final_hard1 , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] , Center_C )
	    call characterEnemy_createArmy( 5 , Enemy_Config_Last_Final_hard2 , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] , Center_C )
	    call characterEnemy_createArmy( 5 , Enemy_Config_Last_Final_hard2 , Center_Boss[GetRandomInt(1,Enemy_Normal_Selector_Qty)] , Center_C )
	    set t = funcs_setInterval( 25.00 , function lastMain )
	    call funcs_setTimerDialog( t , "凶狠部队来了" )
	    //
	    set prevBossTimer = funcs_setInterval( 30.00 , function lastPrevBoss ) //30秒一个
	    call funcs_setTimerParams_Integer( prevBossTimer , Key_Skill_i , 1)
	    call funcs_setTimerDialog( prevBossTimer , "复仇归来" )
	    //环境
	    call characterEnemyEnv_createChaos()
	    //野区
	    if( IsUnitAliveBJ(Enemy_Dragon_Red) == true ) then
	        call IssuePointOrderLoc( Enemy_Dragon_Red , "attack", Center_C )
	        call characterEnemy_addEnemyInGroup( Enemy_Army_Group[2] , Enemy_Dragon_Red )
	    endif
	    if( IsUnitAliveBJ(Enemy_Dragon_Black) == true ) then
	        call IssuePointOrderLoc( Enemy_Dragon_Black , "attack", Center_C )
	        call characterEnemy_addEnemyInGroup( Enemy_Army_Group[2] , Enemy_Dragon_Black )
	    endif

	    //提示
	    call funcs_print( Enemy_Config_Last_Final_Tips )
	    //sound
        call abstractSchedule_bgm( gg_snd_bgm_last )
	    call StartSound( gg_snd_audio_juezhan )
	endfunction

	/* last */
    private function lastCountDown takes nothing returns nothing
        local timer t = GetExpiredTimer()
        call funcs_delTimer( t , null)
        call funcs_print("一股股的寒气忽然从身后传来~！令人毛骨悚然...")
		call lastStart()
    endfunction


	/* normal */
    //weak
    private function mainWeak takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer i = Enemy_Now
        local integer j =0
        local integer during = funcs_getTimerParams_Integer(t, Key_Skill_i )

        if( Enemy_Config_Final_Weak[i] !=0 ) then
	        set j = 1
			loop
				exitwhen j > Enemy_Normal_Selector_Qty
					call characterEnemy_createArmy( 1 , Enemy_Config_Final_Weak[i] , Center_Boss[j] , Center_C )
				set j = j + 1
			endloop
        endif

        if( during > Enemy_Normal_Wave_Weak ) then
            call funcs_delTimer( t , null)
        else
            call funcs_setTimerParams_Integer(t, Key_Skill_i , during+1 )
        endif
    endfunction

    //strong
    private function mainStrong takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer i = Enemy_Now
        local integer j = 0
        local integer during = funcs_getTimerParams_Integer(t, Key_Skill_i )

        if( Enemy_Config_Final_Strong[i] !=0 ) then
	        set j = 1
			loop
				exitwhen j > Enemy_Normal_Selector_Qty
					call characterEnemy_createArmy( 1 , Enemy_Config_Final_Strong[i] , Center_Boss[j] , Center_C )
				set j = j + 1
			endloop
        endif

        if( during > Enemy_Normal_Wave_Strong ) then
            call funcs_delTimer( t , null)
        else
            call funcs_setTimerParams_Integer(t, Key_Skill_i , during+1 )
        endif
    endfunction

    //ring
    private function mainRing takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer i = Enemy_Now
        local integer during = funcs_getTimerParams_Integer(t, Key_Skill_i )
        local integer k = 1
        loop
            exitwhen k > Enemy_Normal_Selector_Qty
                call characterEnemy_createArmy( 4 , Enemy_Config_Final_Weak[i] , Center_Boss[i] , Center_C )
                call characterEnemy_createArmy( 1 , Enemy_Config_Final_Strong[i] , Center_Boss[i] , Center_C )
            set k = k + 1
        endloop

        if( during > Enemy_Normal_Wave_Ring ) then
            call funcs_delTimer( t , null)
        else
            call funcs_setTimerParams_Integer(t, Key_Skill_i , during+1 )
        endif
    endfunction

    //奇袭
    private function mainSp takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer i = Enemy_Now
        local integer during = funcs_getTimerParams_Integer(t, Key_Skill_i )
        local integer k = GetRandomInt(i,8)
        if( Enemy_Config_Final_Weak[i] !=0 ) then
            call characterEnemy_createArmy( 5 , Enemy_Config_Final_Weak[k] , Center_Boss[k] , Center_C )
        endif
        if( Enemy_Config_Final_Strong[i] !=0 ) then
            call characterEnemy_createArmy( 4 , Enemy_Config_Final_Strong[k] , Center_Boss[k] , Center_C )
        endif
        if( during > Enemy_Normal_Wave_Sp ) then
            call funcs_delTimer( t , null)
        else
            call funcs_setTimerParams_Integer(t, Key_Skill_i , during+1 )
        endif
    endfunction

    //主线
    public function main takes nothing returns nothing
        local timer createTimer = null
        local integer i = Enemy_Now
        local unit createUnit = null
        local group bossGroup = null

        //删除计时器
        call funcs_delTimer( Enemy_Timer_Main , null )
        set Enemy_Timer_Main = null

        //进军DEBUG
        //遇到玩家自主进攻杀死敌人后，检测Boss是否还在，如果已经死了，则+1循环,计时器累计清零
        if( i <= Enemy_Normal_Selector_Qty and Enemy_Config_Final_Killed[i] == true ) then
            call setNextPeriod()		//加一关
            call main()				//递归
            return
        endif

        //前进累计
        if( Enemy_Timer_During_Cache >= Enemy_Normal_Wave_Main ) then
            //如果Boss没有死就命令他攻击基地点
            if ( Enemy_Config_Final_Attacked[i] == false and IsUnitAliveBJ(Enemy_Boss_Unit[i])) then
                set Enemy_Config_Final_Attacked[i] = true
                call IssuePointOrderLoc( Enemy_Boss_Unit[i] , "attack", Center_C )
                call characterEnemy_addEnemyInGroup( Enemy_Army_Group[1] , Enemy_Boss_Unit[i] )
                //召唤环境
                call characterEnemyEnv_create(i)
            endif
            // 升级敌人
            call upLvEnemy()
            //加一关
            call setNextPeriod()
        else
            set Enemy_Timer_During_Cache = Enemy_Timer_During_Cache + 1
        endif

        //检测是否已经结束了
        set i = Enemy_Now
        if( i > Enemy_Normal_Selector_Qty ) then
            //倒计时最后一波
            set createTimer = funcs_setTimeout( 100 , function lastCountDown )
            call funcs_setTimerDialog( createTimer , "万分恐怖气息正在逼近.." )
        else
            //否| 出兵
            //如果提示没有提醒过，则提醒一次
            if( Enemy_Config_Final_TipsShow[i] == false ) then
                set Enemy_Config_Final_TipsShow[i] = true
                call funcs_print(Enemy_Config_Final_Tips[i])
            endif
            //窗口文本
            if( Enemy_Timer_During_Cache == Enemy_Normal_Wave_Main ) then
                set Enemy_Timer_Main = funcs_setTimeout( Enemy_Normal_boss_countDown , function main )
                call funcs_setTimerDialog(Enemy_Timer_Main, "凶狠的Boss即将进攻" )
                call PingMinimapLocForForceEx( GetPlayersAll(), Center_Boss_Create[i] , 5.00 , bj_MINIMAPPINGSTYLE_FLASHY, 100, 0, 0 )
            else
                set Enemy_Timer_Main = funcs_setTimeout( getRoadPeriod() , function main )
                call funcs_setTimerDialog(Enemy_Timer_Main,"下一轮敌人" )
            endif

            //weak
            set createTimer = funcs_setInterval( 6.00 ,function mainWeak)
            call funcs_setTimerParams_Integer(createTimer, Key_Skill_i , 1 )
            //strong
            set createTimer = funcs_setInterval( 35.00 ,function mainStrong)
            call funcs_setTimerParams_Integer(createTimer, Key_Skill_i , 1 )
            //ring
            set createTimer = funcs_setInterval( 100.00 ,function mainRing)
            call funcs_setTimerParams_Integer(createTimer, Key_Skill_i , 1 )
            //Sp
            if( Enemy_Timer_During_Cache > 0 and ModuloInteger( Enemy_Timer_During_Cache, 4 ) == 0 ) then
                set createTimer = funcs_setInterval( 30.00 , function mainSp)
                call funcs_setTimerParams_Integer(createTimer, Key_Skill_i , 1 )
            endif

            //sound
            call StartSound(gg_snd_audio_effect_4)
        endif
    endfunction

	/* 初始化 */
    public function init takes nothing returns nothing
		local integer random = 0
	    local integer i = 1
	    local integer j = 1
	    local unit u = null
	    local unit boss = null
	    local group leaderGroup = CreateGroup()       //用作随机
	    local location loc
	    local unit backMan = null
	    local integer last_stage = GetRandomInt( 1 , Enemy_Last_Type_Total_Qty )

    	/* 引路人 */
    	//将引路人全部生成并加入到单位组里
	    set  i = 1
	    set loc = Location( 8214 , 5523 )
	    loop
	        exitwhen i > Enemy_Type_Total_Qty
	            set Enemy_Boss_Leader_Unit[i] = funcs_createUnitFacing( Player_Enemy_Building , Enemy_Config_Leader[i] ,  loc , bj_UNIT_FACING )
	            call GroupAddUnit( leaderGroup , Enemy_Boss_Leader_Unit[i] )
	        set i = i + 1
	    endloop
	    call RemoveLocation(loc)

		/* 敌军 */
	    //从单位组里把随机的个数取出来！
	    set  i = 1
	    loop
	        exitwhen(IsUnitGroupEmptyBJ(leaderGroup) == true)
	            //must do
	            set u = GroupPickRandomUnit(leaderGroup)
	            call GroupRemoveUnit( leaderGroup , u )
	            if( i <= Enemy_Normal_Selector_Qty ) then
	                //call SetUnitPositionLoc( u , Center_Boss_Leader[i] )
	                set  j = 1
	                loop
	                    exitwhen( j > Enemy_Type_Total_Qty )
	                        if( u == Enemy_Boss_Leader_Unit[j] ) then
	                            //call SetUnitUserData( u , i ) //自定义值
	                            call RemoveUnit( u )
	                            set Enemy_Config_Final_Weak[i] = Enemy_Config_Weak[j]
	                            set Enemy_Config_Final_Strong[i] = Enemy_Config_Strong[j]
	                            set Enemy_Config_Final_Leader[i] = Enemy_Config_Leader[j]
	                            set Enemy_Config_Final_Boss[i] = Enemy_Config_Boss[j]
	                            set Enemy_Config_Final_Tips[i] =  Enemy_Config_Tips[j]
	                            set Enemy_Config_Final_Killed[i] = false
	                            set Enemy_Config_Final_Attacked[i] = false
	                            set Enemy_Config_Final_TipsShow[i] = false
	                            set Enemy_Config_Final_Environment[i] = CreateGroup()
	                            set Enemy_Boss_Unit[i] = funcs_createUnitFacing( Player_Enemy_Army , Enemy_Config_Boss[j] ,  Center_Boss_Create[i] , bj_UNIT_FACING )
	                            call eventRegist_unitDamaged( Boss_Spell_Trigger_Normal , Enemy_Boss_Unit[i] )	/*注册进技能事件*/
	                            call eventRegist_unitDeath( gg_trg_event_award,  Enemy_Boss_Unit[i] )			/*注册进奖励事件*/
	                            call eventRegist_unitDeath( gg_trg_event_transfer,  Enemy_Boss_Unit[i] ) 			/*注册进传送事件*/
	                            call eventRegist_unitBeAttack( gg_trg_event_beAttack , Enemy_Boss_Unit[i] )		/*注册攻击事件*/
	                            call eventRegist_unitDamaged( gg_trg_event_damaged , Enemy_Boss_Unit[i] ) 	/*注册进伤害事件*/
	                        endif
	                    set j = j + 1
	                endloop
	            else
	                call RemoveUnit(u)
	            endif
	        set i = i + 1
	    endloop
	    call GroupClear(leaderGroup)
	    call DestroyGroup(leaderGroup)

	    /* 野区 */
	    set Enemy_Dragon_Red = funcs_createUnitFacing( Player_Enemy_Army , Enemy_Type_Dragon_Red ,  Center_Dragon_Red , bj_UNIT_FACING-90 )
	    call eventRegist_unitDamaged( Boss_Spell_Trigger_Normal , Enemy_Dragon_Red )	/*注册进技能事件*/
	    call eventRegist_unitDeath( gg_trg_event_award,  Enemy_Dragon_Red )			/*注册进奖励事件*/
	    call eventRegist_unitDamaged( gg_trg_event_damaged , Enemy_Dragon_Red )	/*注册进伤害事件*/
	    call eventRegist_unitBeAttack( gg_trg_event_beAttack , Enemy_Dragon_Red )		/*注册攻击事件*/
	    set Enemy_Dragon_Black = funcs_createUnitFacing( Player_Enemy_Army , Enemy_Type_Dragon_Black ,  Center_Dragon_Black , bj_UNIT_FACING-180 )
	    call eventRegist_unitDamaged( Boss_Spell_Trigger_Normal , Enemy_Dragon_Black )	/*注册进技能事件*/
	    call eventRegist_unitDeath( gg_trg_event_award,  Enemy_Dragon_Black )				/*注册进奖励事件*/
	    call eventRegist_unitDamaged( gg_trg_event_damaged , Enemy_Dragon_Black )		/*注册进伤害事件*/
	    call eventRegist_unitBeAttack( gg_trg_event_beAttack , Enemy_Dragon_Black ) 		/*注册攻击事件*/

	    /* Last */
	    set Enemy_Config_Last_Final_Tips = Enemy_Config_Last_Tips[last_stage]
	    set Enemy_Config_Last_Final_boss = Enemy_Config_Last_boss[last_stage]
	    set Enemy_Config_Last_Final_weak1 = Enemy_Config_Last_weak1[last_stage]
	    set Enemy_Config_Last_Final_weak2 = Enemy_Config_Last_weak2[last_stage]
	    set Enemy_Config_Last_Final_normal1 = Enemy_Config_Last_normal1[last_stage]
	    set Enemy_Config_Last_Final_normal2 = Enemy_Config_Last_normal2[last_stage]
	    set Enemy_Config_Last_Final_hard1 = Enemy_Config_Last_hard1[last_stage]
	    set Enemy_Config_Last_Final_hard2 = Enemy_Config_Last_hard2[last_stage]

        //每N秒升级一次
        call funcs_setInterval( 270.00-I2R(DIFF)*10 , function upLvEnemy )
	    //开启集中debug
	    call funcs_setInterval( 30.00 , function debugFocus )

	    //设为第 1 关
	    set Enemy_Now = 1

        //
        call abstractSchedule_bgm( gg_snd_bgm_normal_1 )
	endfunction

endlibrary

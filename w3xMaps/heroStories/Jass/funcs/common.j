/**
 * 由于调用了YDWE的某些功能，请直接把下面的代码复制进YDWE使用而不是include
 */

library funcs

    /**
     * 在屏幕(0.0)处打印信息给所有玩家
     */
    public function print takes string msg returns nothing
        call DisplayTextToForce( GetPlayersAll(), msg)
    endfunction

    public function echo takes string msg returns nothing
        call DisplayTextToForce( GetPlayersAll(), msg)
    endfunction

    /**
     * 在屏幕(0.0)处打印信息console给指定玩家
     */
    public function printTo takes player who,string msg returns nothing
        call DisplayTextToPlayer( who, 0, 0, msg)
    endfunction

    /**
     * Debug 信息
     */
    public function console takes string msg returns nothing
        if(isDebug==TRUE) then
            call print(msg)
        endif
    endfunction

    /**
     * 特效 点
     */
    public function effectPoint takes string effectModel,location point returns nothing
        call DestroyEffect(AddSpecialEffectLoc(effectModel, point))
    endfunction
    /**
     * 特效 绑定单位
     */
    public function effectUnit takes string effectModel,widget targetUnit ,string attach returns nothing
        call DestroyEffect(AddSpecialEffectTargetUnitBJ(attach, targetUnit , effectModel))
    endfunction

    /**
     * 绑定单位音效
     */
    public function soundPlay takes sound s,unit u returns nothing
        call PlaySoundOnUnitBJ( s, 100, u )
    endfunction

    /**
     *  获取两个单位间距离，如果其中一个单位为空 返回0
     */
    public function getDistanceBetweenUnits takes unit u1,unit u2 returns real
        local location loc1 = null
        local location loc2 = null
        local real distance = 0
        if( u1 == null or u2 == null ) then
            return 0
        endif
        set loc1 = GetUnitLoc(u1)
        set loc2 = GetUnitLoc(u2)
        set distance = DistanceBetweenPoints(loc1, loc2)
        call RemoveLocation( loc1 )
        call RemoveLocation( loc2 )
        return distance
    endfunction

    /**
     *  获取两个单位间面向角度，如果其中一个单位为空 返回0
     */
    public function getFacingBetweenUnits takes unit u1,unit u2 returns real
        local location loc1 = null
        local location loc2 = null
        local real facing = 0
        if( u1 == null or u2 == null ) then
            return 0
        endif
        set loc1 = GetUnitLoc(u1)
        set loc2 = GetUnitLoc(u2)
        set facing = AngleBetweenPoints(loc1, loc2)
        call RemoveLocation( loc1 )
        call RemoveLocation( loc2 )
        return facing
    endfunction

	/**
	 * 设定中心点（X,Y）创建一个长width宽height的矩形区域
	 */
    public function createRect takes real locX , real locY , real width , real height returns rect
		local real startX = locX-(width * 0.5)
		local real startY = locY-(height * 0.5)
		local real endX = locX+(width * 0.5)
		local real endY = locY+(height * 0.5)
		return Rect( startX , startY , endX , endY )
    endfunction

	/**
	 * 创建天气
	 */
    public function createWeather takes rect whichRect , integer whichWeather returns weathereffect
    	local weathereffect w = AddWeatherEffectSaveLast( whichRect , whichWeather )
    	call EnableWeatherEffect( w , true )
    	return w
    endfunction



    /**
     * GET SET TIMER PARAMS
     * HASH
     */
     //SET
    public function setTimerParams_Real takes timer t,integer k,real value returns nothing
        local integer timerHandleId = GetHandleId(t)
        call SaveReal(HASH, timerHandleId, k, value)
    endfunction
    public function setTimerParams_Integer takes timer t,integer k,integer value returns nothing
        local integer timerHandleId = GetHandleId(t)
        call SaveInteger(HASH, timerHandleId, k, value)
    endfunction
    public function setTimerParams_Unit takes timer t,integer k,unit value returns nothing
        local integer timerHandleId = GetHandleId(t)
        call SaveUnitHandle(HASH, timerHandleId, k, value)
    endfunction
    public function setTimerParams_String takes timer t,integer k,string value returns nothing
        local integer timerHandleId = GetHandleId(t)
        call SaveStr(HASH, timerHandleId, k, value)
    endfunction
    public function setTimerParams_Boolean takes timer t,integer k,boolean value returns nothing
        local integer timerHandleId = GetHandleId(t)
        call SaveBoolean(HASH, timerHandleId, k, value)
    endfunction
    public function setTimerParams_Loc takes timer t,integer k,location value returns nothing
        local integer timerHandleId = GetHandleId(t)
        call SaveLocationHandle(HASH, timerHandleId, k, value)
    endfunction
    public function setTimerParams_Group takes timer t,integer k,group value returns nothing
        local integer timerHandleId = GetHandleId(t)
        call SaveGroupHandle(HASH, timerHandleId, k, value)
    endfunction
    public function setTimerParams_Player takes timer t,integer k,player value returns nothing
        local integer timerHandleId = GetHandleId(t)
        call SavePlayerHandle(HASH, timerHandleId, k, value)
    endfunction
    public function setTimerParams_Item takes timer t,integer k,item value returns nothing
        local integer timerHandleId = GetHandleId(t)
        call SaveItemHandle(HASH, timerHandleId, k, value)
    endfunction
    public function setTimerParams_TimerDialog takes timer t,integer k,timerdialog value returns nothing
        local integer timerHandleId = GetHandleId(t)
        call SaveTimerDialogHandle(HASH, timerHandleId, k, value)
    endfunction
    public function setTimerParams_Texttag takes timer t,integer k,texttag value returns nothing
        local integer timerHandleId = GetHandleId(t)
        call SaveTextTagHandle(HASH, timerHandleId, k, value)
    endfunction
    //GET
    public function getTimerParams_Real takes timer t,integer k returns real
        local integer timerHandleId = GetHandleId(t)
        return LoadReal(HASH, timerHandleId, k)
    endfunction
    public function getTimerParams_Integer takes timer t,integer k returns integer
        local integer timerHandleId = GetHandleId(t)
        return LoadInteger(HASH, timerHandleId, k)
    endfunction
    public function getTimerParams_Unit takes timer t,integer k returns unit
        local integer timerHandleId = GetHandleId(t)
        return LoadUnitHandle(HASH, timerHandleId, k)
    endfunction
    public function getTimerParams_String takes timer t,integer k returns string
        local integer timerHandleId = GetHandleId(t)
        return LoadStr(HASH, timerHandleId, k)
    endfunction
    public function getTimerParams_Boolean takes timer t,integer k returns boolean
        local integer timerHandleId = GetHandleId(t)
        return LoadBoolean(HASH, timerHandleId, k)
    endfunction
    public function getTimerParams_Loc takes timer t,integer k returns location
        local integer timerHandleId = GetHandleId(t)
        return LoadLocationHandle(HASH, timerHandleId, k)
    endfunction
    public function getTimerParams_Group takes timer t,integer k returns group
        local integer timerHandleId = GetHandleId(t)
        return LoadGroupHandle(HASH, timerHandleId, k)
    endfunction
    public function getTimerParams_Player takes timer t,integer k returns player
        local integer timerHandleId = GetHandleId(t)
        return LoadPlayerHandle(HASH, timerHandleId, k)
    endfunction
    public function getTimerParams_Item takes timer t,integer k returns item
        local integer timerHandleId = GetHandleId(t)
        return LoadItemHandle(HASH, timerHandleId, k)
    endfunction
    public function getTimerParams_TimerDialog takes timer t,integer k returns timerdialog
        local integer timerHandleId = GetHandleId(t)
        return LoadTimerDialogHandle(HASH, timerHandleId, k)
    endfunction
    public function getTimerParams_Texttag takes timer t,integer k returns texttag
        local integer timerHandleId = GetHandleId(t)
        return LoadTextTagHandle(HASH, timerHandleId, k)
    endfunction

    /**
     * 设置一次性计时器
     */
    public function setTimeout takes real time,code func returns timer
        local timer t = CreateTimer()
        call TimerStart( t, time , false, func )
        return t
    endfunction

    /**
     * 设置计时器窗口
     */
    public function setTimerDialog takes timer t,string title returns timerdialog
        local timerdialog td = CreateTimerDialog(t)
        call TimerDialogSetTitle(td, title)
        call TimerDialogDisplay(td, true)
        call setTimerParams_TimerDialog( t , 9001 , td )
        return td
    endfunction

    /**
     * 获取计时器窗口
     */
    public function getTimerDialog takes timer t returns timerdialog
    	if(t == null) then
	    	return null
    	endif
    	return getTimerParams_TimerDialog( t , 9001 )
    endfunction

    /**
     * 删除计时器 | 窗口
     */
    public function delTimer takes timer t,timerdialog td returns nothing
        if(t != null) then
	        call PauseTimer(t)
	        //如果没有窗口，就去找找看哈希表，看看有没有
	        if(td == null) then
	            set td = getTimerDialog(t)
	        endif
	        if(td != null) then
	            call DestroyTimerDialog(td)
	        endif
            call DestroyTimer(t)
        endif
    endfunction

    /**
     * 设置循环计时器
     */
    public function setInterval takes real time,code func returns timer
        local timer t = CreateTimer()
        call TimerStart( t, time , true, func )
        return t
    endfunction




	//-漂浮文字-
	/**
	 * 删除漂浮字
	 */
	public function floatMsgDel takes texttag ttg returns nothing
		call DestroyTextTag( ttg )
	endfunction

	/**
     * 漂浮文字 - 默认 (在某单位头上)
     *  msg 信息
     *  u 某单位
     */
    public function floatMsg takes string msg,unit u returns texttag
        local texttag ttg
        local real text_size = 10.00               	//字体大小
        local real text_zOffset = 20.00         		//Z轴位移
        local real text_opacity = 18.00         		//透明
        local real text_time = 0.50               	//时间
        set ttg = CreateTextTag()
        call SetTextTagTextBJ(ttg, msg, text_size)
        call SetTextTagPosUnitBJ(ttg, u, text_zOffset)
        call SetTextTagColorBJ(ttg, 100.00, 100.00, 100.00, text_opacity)
        call SetTextTagPermanent( ttg, false )
        call SetTextTagVelocityBJ( ttg, 200.00, 90.00 )
        call SetTextTagLifespan( ttg, text_time)
        call SetTextTagFadepoint( ttg, text_time)
        return ttg
    endfunction

    /**
     * 漂浮文字 - 可设字体大小(在某单位头上)
     *  msg 信息
     *  u 某单位
     *  fontSize 字体大小
     */
    public function floatMsgWithSize takes string msg,unit u,real text_size returns texttag
        local texttag ttg
        local real text_zOffset = 20.00         	//Z轴位移
        local real text_opacity = 18.00         	//透明
        local real text_time = 0.50        		//时间
        set ttg = CreateTextTag()
        call SetTextTagTextBJ(ttg, msg, text_size)
        call SetTextTagPosUnitBJ(ttg, u, text_zOffset)
        call SetTextTagColorBJ(ttg, 100.00, 100.00, 100.00, text_opacity)
        call SetTextTagPermanent( ttg, false )
        call SetTextTagVelocityBJ( ttg, 200.00, 90.00 )
        call SetTextTagLifespan( ttg, text_time)
        call SetTextTagFadepoint( ttg, text_time)
        return ttg
    endfunction

	/**
     * 漂浮文字 - 可设 字体大小 | z轴位移 (绑定在某单位头上，跟随移动)
     * CALL函数 ， 作用在于循环设定漂浮字的位置
     */
    private function floatMsgWithSizeAutoBindCall takes nothing returns nothing
    	local timer t = GetExpiredTimer()
        local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
        local texttag ttg = funcs_getTimerParams_Texttag( t , Key_Skill_Texttag )
        local real text_zOffset = funcs_getTimerParams_Real( t , Key_Skill_i )
        local real text_xOffect = funcs_getTimerParams_Real( t , Key_Skill_j )
        if( IsUnitAliveBJ(u) == true ) then
	        call SetTextTagPos( ttg , GetUnitX(u)+text_xOffect , GetUnitY(u) , text_zOffset )
	        call SetTextTagVisibility( ttg , true )
       	else
       		call SetTextTagVisibility( ttg , false )
		endif
    endfunction

	/**
     * 漂浮文字 - 可设 字体大小 | z轴位移 (绑定在某单位头上，跟随移动)
     *  msg 信息
     *  u 某单位
     *  fontSize 字体大小
     */
    public function floatMsgWithSizeAutoBind takes string msg, unit u, real text_size ,real text_zOffset ,real text_opacity , real text_xOffect returns texttag
        local texttag ttg = null
        local timer t = null
        if( text_size < 5 ) then		//字体大小
	        set text_size = 5
        endif
        if( text_zOffset < 20 ) then		//Z轴位移
         	set text_zOffset = 20.00
     	endif
        if( text_opacity < 0 ) then		//透明
        	set text_opacity = 0.00
    	endif
        set ttg = CreateTextTag()
        call SetTextTagTextBJ(ttg, msg, text_size)
        call SetTextTagPosUnitBJ(ttg, u, text_zOffset)
        call SetTextTagColorBJ(ttg, 100.00, 100.00, 100.00, text_opacity)
        call SetTextTagPermanent( ttg, true )
        //计时器
        set t = funcs_setInterval( 0.04 , function floatMsgWithSizeAutoBindCall )
        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u )
        call funcs_setTimerParams_Texttag( t , Key_Skill_Texttag , ttg )
        call funcs_setTimerParams_Real( t , Key_Skill_i , text_zOffset )
        call funcs_setTimerParams_Real( t , Key_Skill_j , text_xOffect )
        return ttg
    endfunction

	/**
	 * 对玩家组播放电影
	 */
    public function moive takes unit speaker , force toForce returns nothing
    	local integer i = 0
    	local real during = 0
    	set i = 1
	    loop
	        exitwhen i > Moive_Msg_Length
	        	if( Moive_Msg[i] == "" ) then
					call DoNothing() YDNL exitwhen true
	        	else
		        	set during = I2R(StringLength(Moive_Msg[i]))*0.03 + 3.00
        			call TransmissionFromUnitWithNameBJ( toForce , speaker , GetUnitName(speaker) , gg_snd_BattleNetTick , Moive_Msg[i] , bj_TIMETYPE_SET, during , true )
	        	endif
	        set i = i + 1
	    endloop
    endfunction

    //-UNIT-
    /**
     * 设置单位的生命周期
     */
    public function setUnitLife takes unit u,real life returns nothing
        call UnitApplyTimedLifeBJ(life, 'BTLF', u)
    endfunction

    /**
     * 删除单位回调
     */
    private function delUnitCall takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit targetUnit = funcs_getTimerParams_Unit( t, Key_Skill_Unit )
        if( targetUnit != null ) then
	        call RemoveUnit( targetUnit )
    	endif
        call delTimer(t,null)
    endfunction

    /**
     * 删除单位，可延时
     */
    public function delUnit takes unit targetUnit , real during returns nothing
        local timer t = null
        if( during <= 0 ) then
            call RemoveUnit( targetUnit )
        else
            set t = funcs_setTimeout( during , function delUnitCall)
            call funcs_setTimerParams_Unit( t, Key_Skill_Unit ,targetUnit )
        endif
    endfunction



     /**
     * GET SET Player PARAMS
     * HASH
     */
     //SET
    public function setPlayerParams_Boolean takes player whichPlayer,integer k,boolean value returns nothing
        local integer handleId = GetConvertedPlayerId(whichPlayer)
        call SaveBoolean(HASH_Player, handleId, k, value)
    endfunction
    //GET
    public function getPlayerParams_Boolean takes player whichPlayer,integer k returns boolean
        local integer handleId = GetConvertedPlayerId(whichPlayer)
        return LoadBoolean(HASH_Player, handleId, k)
    endfunction


    /**
    * 获取p玩家glod金钱
    */
    public function getGold takes player p returns integer
        return GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD)
    endfunction

    /**
    * 设置p玩家glod金钱
    */
    public function setGold takes player p,integer gold returns nothing
        call SetPlayerStateBJ( p, PLAYER_STATE_RESOURCE_GOLD, gold )
    endfunction

    /**
    * 增加p玩家glod金钱
    * 使用负数减少
    */
    public function addGold takes player p,integer gold returns nothing
        call AdjustPlayerStateBJ(gold, p , PLAYER_STATE_RESOURCE_GOLD )
    endfunction

    /**
    * 设置p玩家glod金钱
    */
    public function setLumber takes player p,integer lumber returns nothing
        call SetPlayerStateBJ( p, PLAYER_STATE_RESOURCE_LUMBER, lumber )
    endfunction

    /**
    * 获取p玩家lumber木材
    */
    public function getLumber takes player p returns integer
        return GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER)
    endfunction

    /**
    * 增加p玩家lumber木材
    * 使用负数减少
    */
    public function addLumber takes player p,integer lumber returns nothing
        call AdjustPlayerStateBJ(lumber, p , PLAYER_STATE_RESOURCE_LUMBER )
    endfunction

    /**
     * 修改玩家战斗状态（通用）
     * 状态字符串在 触发器 init_action 初始化
     */
    private function setBattleStatus takes string status,player whichPlayer returns nothing
        local integer i
        if( whichPlayer != null ) then
            set Player_heros_status[GetConvertedPlayerId(whichPlayer)] = status
        else
            set i = 1
            loop
                exitwhen i > Max_Player_num
                    set Player_heros_status[i] = status
                set i = i + 1
            endloop
        endif
    endfunction
    //修改玩家战斗状态 -> 备战中
    public function setBattleStatus2Ready takes player whichPlayer returns nothing
        call setBattleStatus( Player_status[1] ,whichPlayer )
    endfunction
     //修改玩家战斗状态 -> 战斗中
    public function setBattleStatus2Battle takes player whichPlayer returns nothing
        call setBattleStatus( Player_status[2] ,whichPlayer )
    endfunction
     //修改玩家战斗状态 -> 已战死
    public function setBattleStatus2Death takes player whichPlayer returns nothing
        call setBattleStatus( Player_status[3] ,whichPlayer )
    endfunction
     //修改玩家战斗状态 -> 奋战中
    public function setBattleStatus2VeryBattle takes player whichPlayer returns nothing
        call setBattleStatus( Player_status[4] ,whichPlayer )
    endfunction
    //修改玩家战斗状态 -> 挂机中
    public function setBattleStatus2Idling takes player whichPlayer returns nothing
        call setBattleStatus( Player_status[5] ,whichPlayer )
    endfunction
    //修改玩家战斗状态 -> 选择英雄中
    public function setBattleStatus2ChoosingHero takes player whichPlayer returns nothing
        call setBattleStatus( Player_status[6] ,whichPlayer )
    endfunction

    /**
     * 两整型相除得到real
     */
    public function dividedI2R takes integer i1,integer i2 returns real
        return ( I2R(i1) / I2R(i2) )
    endfunction

    /**
     * 根据固定因子及增益因子计算几率因子
     */
    public function getOdds takes integer odds_stable,real odds_gain,integer timers returns real
        local real odds = odds_stable + odds_stable*( I2R(timers-1) * odds_gain)
        return odds
    endfunction



    /**
     * 一般伤害
     */
    public function huntBySelf takes real damage,unit damageSource,unit toUnit returns nothing
        call UnitDamageTargetBJ( damageSource, toUnit, damage, ATTACK_TYPE_MELEE, DAMAGE_TYPE_NORMAL)
    endfunction

    /**
     * 生成同玩家马甲的一般伤害
     */
    public function huntByToken takes real damage,unit damageSource,unit toUnit returns nothing
        local unit token = CreateUnit( GetOwningPlayer(damageSource) , Unit_Token_Hunt , GetUnitX(toUnit),GetUnitY(toUnit),0.00)
        call UnitDamageTargetBJ( token, toUnit, damage, ATTACK_TYPE_MELEE, DAMAGE_TYPE_NORMAL)
        call UnitApplyTimedLife(token,'BTLF',  0.30)
    endfunction

    /**
     * 生成同玩家马甲的一般无法回避伤害
     */
    public function huntByToken_NotAvoid takes real damage,unit damageSource,unit toUnit returns nothing
        local unit token = CreateUnit( GetOwningPlayer(damageSource) , Unit_Token_Hunt_Not_Avoid , GetUnitX(toUnit),GetUnitY(toUnit),0.00)
        call UnitDamageTargetBJ( token, toUnit, damage, ATTACK_TYPE_MELEE, DAMAGE_TYPE_NORMAL)
        call UnitApplyTimedLife(token,'BTLF',  0.30)
    endfunction

    /**
     * 无视防御伤害
     */
    public function huntBySelf_BreakDefend takes real damage,unit damageSource,unit toUnit returns nothing
        call UnitDamageTargetBJ( damageSource, toUnit, damage, ATTACK_TYPE_MELEE, DAMAGE_TYPE_ENHANCED)
    endfunction

    /**
     * 生成同玩家马甲的无视防御无法回避伤害
     */
    public function huntByToken_BreakDefend_NotAvoid takes real damage,unit damageSource,unit toUnit returns nothing
        local unit token = CreateUnit( GetOwningPlayer(damageSource) , Unit_Token_Hunt , GetUnitX(toUnit),GetUnitY(toUnit),0.00)
        call UnitDamageTargetBJ( token, toUnit, damage, ATTACK_TYPE_MELEE, DAMAGE_TYPE_ENHANCED)
        call UnitApplyTimedLife(token,'BTLF',  1.00)
    endfunction

    /**
     * 生成同玩家马甲的无视防御伤害
     */
    public function huntByToken_BreakDefend takes real damage,unit damageSource,unit toUnit returns nothing
        local unit token = CreateUnit( GetOwningPlayer(damageSource) , Unit_Token_Hunt_Not_Avoid , GetUnitX(toUnit),GetUnitY(toUnit),0.00)
        call UnitDamageTargetBJ( token, toUnit, damage, ATTACK_TYPE_MELEE, DAMAGE_TYPE_ENHANCED)
        call UnitApplyTimedLife(token,'BTLF',  1.00)
    endfunction

    /**
     * 伤害单位组
     * 当 repeatG = null 则代表可以重复伤害，如果是一个group则不能重复伤害
     * targetTag代表作用目标，可以参考global string里面的【伤害目标筛选】
     */
    public function huntGroup takes group g,unit source,real damage,string HEffect,group repeatG,string targetTag returns nothing
        local unit u
        local integer i
        local location point
        local integer maxTimers = 50   //最多对多少个单位起作用
        local boolean canHunt
        set i = 0
        loop
            exitwhen(IsUnitGroupEmptyBJ(g) == true or i > maxTimers)
                set canHunt = TRUE
                //must do
                set u = FirstOfGroup(g)
                call GroupRemoveUnit( g , u )
                //检测是否不重复伤害
                if( repeatG != null) then
                    if( IsUnitInGroup(u, repeatG)==true ) then
                        set canHunt = FALSE
                    else
                        call GroupAddUnit( repeatG, u )
                    endif
                endif
                if( targetTag == FILTER_ALL or targetTag == null ) then //nothing
                elseif( targetTag == FILTER_ALLY ) then //检测是否友军
                    if( IsUnitAlly( u , GetOwningPlayer(source)) == FALSE ) then
                        set canHunt = FALSE
                    endif
                elseif( targetTag == FILTER_ENEMY ) then //检测是否敌军
                    if( IsUnitEnemy( u , GetOwningPlayer(source))  == FALSE ) then
                        set canHunt = FALSE
                    endif
                endif
                //符合条件后并且伤害大于0
                if(canHunt == TRUE and damage > 0) then
                    call huntBySelf( damage,source,u)
                    //伤害特效
                    if(HEffect != null)then
                        set point = GetUnitLoc(u)
                        call effectPoint(HEffect,point)
                        call RemoveLocation(point)
                    endif
                endif
            set i = i + 1
        endloop
    endfunction

    /**
     * 伤害单位组(无视防御)
     * 当 repeatG = null 则代表可以重复伤害，如果是一个group则不能重复伤害
     * targetTag代表作用目标，可以参考global string里面的【伤害目标筛选】
     */
    public function huntGroup_BreakDefend takes group g,unit source,real damage,string HEffect,group repeatG,string targetTag returns nothing
        local unit u
        local integer i
        local location point
        local integer maxTimers = 50   //最多对多少个单位起作用
        local boolean canHunt
        set i = 0
        loop
            exitwhen(IsUnitGroupEmptyBJ(g) == true or i > maxTimers)
                set canHunt = TRUE
                //must do
                set u = FirstOfGroup(g)
                call GroupRemoveUnit( g , u )
                //检测是否不重复伤害
                if( repeatG != null) then
                    if( IsUnitInGroup(u, repeatG)==true ) then
                        set canHunt = FALSE
                    else
                        call GroupAddUnit( repeatG, u )
                    endif
                endif
                if( targetTag == FILTER_ALL or targetTag == null ) then //nothing
                elseif( targetTag == FILTER_ALLY ) then //检测是否友军
                    if( IsUnitAlly( u , GetOwningPlayer(source)) == FALSE ) then
                        set canHunt = FALSE
                    endif
                elseif( targetTag == FILTER_ENEMY ) then //检测是否敌军
                    if( IsUnitEnemy( u , GetOwningPlayer(source))  == FALSE ) then
                        set canHunt = FALSE
                    endif
                endif
                //符合条件后并且伤害大于0
                if(canHunt == TRUE and damage > 0) then
                    call huntBySelf_BreakDefend( damage,source,u)
                    //伤害特效
                    if(HEffect != null)then
                        set point = GetUnitLoc(u)
                        call effectPoint(HEffect,point)
                        call RemoveLocation(point)
                    endif
                endif
            set i = i + 1
        endloop
    endfunction

     /**
      * 移动单位组
      * damage
      */
    public function moveGroup takes group g,location loc,unit source,real damage,string MEffect,string targetTag returns nothing
        local unit u
        local location point
        local boolean canMove
        loop
            exitwhen(IsUnitGroupEmptyBJ(g) == true)
                set canMove = TRUE
                //must do
                set u = FirstOfGroup(g)
                call GroupRemoveUnit( g , u )
                //
                if( targetTag == FILTER_ALL or targetTag == null ) then //nothing
                elseif( targetTag == FILTER_ALLY ) then //检测是否友军
                    if( IsUnitAlly( u , GetOwningPlayer(source)) == FALSE ) then
                        set canMove = FALSE
                    endif
                elseif( targetTag == FILTER_ENEMY ) then //检测是否敌军
                    if( IsUnitEnemy( u , GetOwningPlayer(source))  == FALSE ) then
                        set canMove = FALSE
                    endif
                endif
                //符合条件后
                if( canMove == TRUE ) then
                    call SetUnitPositionLoc( u , loc )
                    call PanCameraToTimedLocForPlayer( GetOwningPlayer(u), loc, 0.00 )
                    if(targetTag == FILTER_ENEMY and damage > 0) then
                        call huntBySelf( damage,source,u)
                    endif
                endif
        endloop
        if(MEffect != null) then
            call effectPoint(MEffect,loc)
        endif
    endfunction

    /**
      * 指挥单位组所有单位做动作
      * damage
      */
    public function actionGroup takes group g,string action returns nothing
        local unit u
        local boolean canAction
        loop
            exitwhen(IsUnitGroupEmptyBJ(g) == true)
                set canAction = TRUE
                //must do
                set u = FirstOfGroup(g)
                call GroupRemoveUnit( g , u )
                //
                if( IsUnitDeadBJ(u) ) then //nothing
                    set canAction = FALSE
                endif
                //符合条件后
                if( canAction == TRUE ) then
                    call SetUnitAnimation( u , action )
                endif
        endloop
    endfunction

    /**
     * 创建1单位面向点
     * @return 最后创建单位
     */
    public function createUnit takes player whichPlayer, integer unitid, location loc, location lookAt returns unit
        local unit u = null
        if( lookAt == null ) then
            set u = CreateUnitAtLoc(whichPlayer, unitid, loc, bj_UNIT_FACING)
        else
            set u = CreateUnitAtLoc(whichPlayer, unitid, loc, AngleBetweenPoints(loc, lookAt))
        endif
        return u
    endfunction

    /**
     * 创建1单位面向角度
     * @return 最后创建单位
     */
    public function createUnitFacing takes player whichPlayer, integer unitid, location loc, real facing returns unit
        local unit u = null
        if( facing == null ) then
            set u = CreateUnitAtLoc(whichPlayer, unitid, loc, bj_UNIT_FACING)
        else
            set u = CreateUnitAtLoc(whichPlayer, unitid, loc, facing)
        endif
        return u
    endfunction

    /**
     * 创建N单位面向点
     * @return 最后创建单位组
     */
    public function createNUnit takes integer qty , player whichPlayer, integer unitid, location loc, location lookAt returns group
        local group g = CreateGroup()
        loop
            set qty = qty - 1
            exitwhen qty < 0
                call CreateUnitAtLocSaveLast(whichPlayer, unitid, loc, AngleBetweenPoints(loc, lookAt))
                call GroupAddUnit(g, bj_lastCreatedUnit)
        endloop
        return g
    endfunction

    /**
     * 创建1单位面向点移动到某点
     * @return 最后创建单位
     */
    public function createUnitAttackToLoc takes integer unitid ,player whichPlayer, location loc, location attackLoc returns unit
        local unit u = createUnit( whichPlayer , unitid , loc , attackLoc)
        call  IssuePointOrderLoc( u, "attack", attackLoc )
        return u
    endfunction
    /**
     * 创建N单位攻击移动到某点
     * @return 最后创建单位组
     */
    public function createNUnitAttackToLoc takes  integer qty, integer unitid ,player whichPlayer, location loc, location attackLoc returns group
        local group g = createNUnit( qty , whichPlayer , unitid , loc , attackLoc )
        call GroupPointOrderLoc( g , "attack", attackLoc )
        return g
    endfunction

    /**
     * 单位组
     * 以point点为中心radius距离
     * filter 条件适配器
     */
    public function getGroupByPoint takes location loc,real radius,code filter returns group
        local group g
        local boolexpr bx = Condition(filter)
        set g = CreateGroup()
        call GroupEnumUnitsInRangeOfLoc(g, loc , radius, bx)
        call DestroyBoolExpr(bx)
        return g
    endfunction

     /**
     * 单位组
     * 以区域为范围选择
     * filter 条件适配器
     */
    public function getGroupByRect takes rect r,code filter returns group
        local group g
        local boolexpr bx = Condition(filter)
        set g = CreateGroup()
        call GroupEnumUnitsInRect(g, r, bx)
        call DestroyBoolExpr(bx)
        return g
    endfunction


    /**
     * 单位组
     * 以某个单位为中心radius距离
     * filter 条件适配器
     */
    public function getGroupByUnit takes unit u,real radius,code filter returns group
        local group g
        local boolexpr bx = Condition(filter)
        local location point = GetUnitLoc( u )
        set g = CreateGroup()
        call GroupEnumUnitsInRangeOfLoc(g,point, radius, bx)
        call DestroyBoolExpr(bx)
        call RemoveLocation( point )
        return g
    endfunction

    /**
     * 判断是否水面，否则地面
     */
    public function isWater takes location loc returns boolean
        if (IsTerrainPathableBJ(loc, PATHING_TYPE_FLOATABILITY) == false) then
            return true
        else
            return false
        endif
    endfunction

    /**
     * 单位身上是否有某物品
     */
    public function isOwnItem takes unit u,integer itemId returns boolean
        return (GetItemTypeId(GetItemOfTypeFromUnitBJ(u, itemId)) == itemId)
    endfunction

    /**
     * 设置单位可飞，用于设置单位飞行高度之前
     */
    public function setUnitFly takes unit u returns nothing
    	local integer Storm = 'Arav'	//风暴之鸦
		call UnitAddAbility( u , Storm )
		call UnitRemoveAbility( u , Storm )
    endfunction

	/**
	 * 发布任务（左边）
	 */
    public function setMissionLeft takes string tit,string con,string icon returns nothing
    	if( tit=="" or con=="" or icon=="" )then
			return
		endif
    	call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED,tit,con,icon)
		call FlashQuestDialogButton()
	endfunction

	/**
	 * 发布任务（右边）
	 */
	public function setMissionRight takes string tit,string con,string icon returns nothing
		if( tit=="" or con=="" or icon=="" )then
			return
		endif
    	call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED,tit,con,icon)
		call FlashQuestDialogButton()
	endfunction

	/**
	 * 添加单位进库存
	 * 同时记录入库的店
	 * 这里单位指的是类型，所以是int
	 */
	public function addUnit2Stock takes unit stock,integer unitTypeId returns nothing
		call SaveUnitHandle( HASH_Hero , STOCK_HASH_ID , unitTypeId , stock )
		call AddUnitToStockBJ( unitTypeId , stock , 1 , 1 )
	endfunction

	/**
	 * 取出单位进库存时的店
	 * 这里单位指的是类型，所以是int
	 */
	public function getStockByUnit takes integer unitTypeId returns unit
		return LoadUnitHandle( HASH_Hero , STOCK_HASH_ID , unitTypeId )
	endfunction

	/**
	 * 添加物品进库存
	 * 同时记录入库的店
	 * 这里物品指的是类型，所以是int
	 */
	public function addItemStock takes unit stock,integer itemTypeId returns nothing
		call SaveUnitHandle( HASH_Item , STOCK_HASH_ID , itemTypeId , stock )
		call AddItemToStockBJ( itemTypeId , stock , 1 , 1 )
	endfunction

	/**
	 * 取出物品进库存时的店
	 * 这里物品指的是类型，所以是int
	 */
	public function getStockByItem takes integer itemTypeId returns unit
		return LoadUnitHandle( HASH_Item , STOCK_HASH_ID , itemTypeId )
	endfunction

endlibrary

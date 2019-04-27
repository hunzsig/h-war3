globals

    integer SHAKEBULL_NORMAL_jianta = 'A074'
    integer SHAKEBULL_NORMAL_tuwei = 'A062'
    integer SHAKEBULL_NORMAL_zhendangbo = 'A052'
    integer SHAKEBULL_NORMAL_canyingta = 'A081'
    integer SHAKEBULL_NORMAL_zhenhandadi = 'A04R'

    integer SHAKEBULL_NORMAL_zhendangbo_arrow = 'o005'
    integer SHAKEBULL_NORMAL_canyingta_token = 'o00V'

endglobals

library shakeBullNormal requires heroBase

	//践踏
	public function jianta takes nothing returns nothing
	endfunction

	//突围 - 回调
	private function tuweiCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
	    local integer during = funcs_getTimerParams_Integer( t , Key_Skill_During )
	    local unit mover = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local real facing = funcs_getTimerParams_Real( t , Key_Skill_Facing )
	    local real distance = funcs_getTimerParams_Real( t , Key_Skill_Distance )
	    local real speed = funcs_getTimerParams_Real( t , Key_Skill_Speed )
	    local string chargeType = funcs_getTimerParams_String( t , Key_Skill_Type )
	    local real hunt = funcs_getTimerParams_Real( t , Key_Skill_Hunt )
	    local real range = funcs_getTimerParams_Real( t , Key_Skill_Range )
	    local location loc = null
	    if( during >= 5 ) then
	        call funcs_delTimer( t ,null )
	        call SetUnitAnimationByIndex(mover , 3 )    //3是行走
	        set loc = GetUnitLoc(mover)
	        call funcs_effectPoint( Effect_RoarCaster , loc )
	        call RemoveLocation(loc)
	        call skills_charge(mover,facing,distance,speed,chargeType,null,hunt,range,null,false)
	    else
	        call funcs_setTimerParams_Integer( t , Key_Skill_During , during+1 )
	        call SetUnitTimeScalePercent( mover, 100+50*during )
	        set loc = GetUnitLoc(mover)
	        call funcs_effectPoint( Effect_ImpaleTargetDust , loc )
	        call RemoveLocation(loc)
	    endif
	endfunction

	//突围
	public function tuwei takes nothing returns nothing
		local unit mover = GetTriggerUnit()
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(mover))
	    local integer skillLv = GetUnitAbilityLevel(mover ,SHAKEBULL_NORMAL_tuwei)
	    local real facing = GetUnitFacing(mover)
	    local real distance = 500.00
	    local real speed = 9.00
	    local string chargeType = SKILL_CHARGE_CRASH
	    local real hunt = I2R(Attr_Move[index]) + skillLv * 225.00
	    local real range = 150.00
	    local timer t = null

	    call PauseUnit( mover , true )
	    call SetUnitAnimationByIndex(mover , 3 )    //3是行走
	    set t = funcs_setInterval( 0.20 , function tuweiCall )
	    call funcs_setTimerParams_Integer( t , Key_Skill_During , 0 )
	    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , mover )
	    call funcs_setTimerParams_Real( t , Key_Skill_Facing , facing )
	    call funcs_setTimerParams_Real( t , Key_Skill_Distance , distance )
	    call funcs_setTimerParams_Real( t , Key_Skill_Speed , speed )
	    call funcs_setTimerParams_String( t , Key_Skill_Type , chargeType )
	    call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt )
	    call funcs_setTimerParams_Real( t , Key_Skill_Range , range )
	endfunction

	//震荡波
	public function zhendangbo takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local location loc = GetUnitLoc( u )
	    local location targetLoc = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real hunt = I2R(Attr_Move[index]) + I2R(level) * 300
	    local real range = 800.00
	    local real speed = 27
	    local real facing = AngleBetweenPoints( loc , targetLoc )
	    local string chargeType = SKILL_CHARGE_DRAG
	    local unit arrow = null
	    local location locStart = null
	    local location locEnd = null
	    set arrow = funcs_createUnit ( GetOwningPlayer(u) , SHAKEBULL_NORMAL_zhendangbo_arrow ,  loc ,  loc )
	    call funcs_setUnitLife( arrow , range / (speed*45) )
	    call skills_charge( arrow , facing , range, speed ,chargeType,null,hunt,125,null,false)
	    call RemoveLocation(loc)
	endfunction

	//残影踏
	private function canyingtaCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
	    local unit triggerUnit = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local integer index = funcs_getTimerParams_Integer( t , Key_Skill_i  )
	    local integer shadowQty = funcs_getTimerParams_Integer( t , Key_Skill_j  )
	    local integer shadowQtyInc = funcs_getTimerParams_Integer( t , Key_Skill_k  )
	    local real hunt = funcs_getTimerParams_Real( t , Key_Skill_Hunt  )
	    local location loc
	    local group g
	    local unit u
	    if( shadowQtyInc < shadowQty ) then
	        //获取一个随机单位位置，后建组
	        set loc = GetUnitLoc(triggerUnit)
	        set g = funcs_getGroupByPoint( loc , 300.00 , function filter_live_disbuild)
	        call RemoveLocation(loc)
	        loop
	            exitwhen(IsUnitGroupEmptyBJ(g) == true)
	                //must do
	                set u = GroupPickRandomUnit(g)
	                call GroupRemoveUnit( g , u )
	                //检测是否敌军
	                if( IsUnitEnemy( u , GetOwningPlayer(triggerUnit))  == TRUE ) then
	                    set loc = GetUnitLoc(u)
	                    call DoNothing() YDNL exitwhen true
	                endif
	        endloop
	        call DestroyGroup(g)

	        set u = funcs_createUnitFacing( GetOwningPlayer(triggerUnit) , SHAKEBULL_NORMAL_canyingta_token ,loc , GetRandomReal(0.00,360.00))
	        call IssueImmediateOrder( u , "stomp" )
	        call SetUnitVertexColorBJ( u, 100, 100, 100, 50.00 )
	        call funcs_delUnit( u , 1.25 )
	        set g = funcs_getGroupByPoint( loc , 250.00 , function filter_live_disbuild)
	        call funcs_huntGroup(g, triggerUnit,hunt,null,null,FILTER_ENEMY)
	        call DestroyGroup(g)
	        call RemoveLocation(loc)
	    else
	        call funcs_delTimer( t ,null )
	    endif
	    call funcs_setTimerParams_Integer( t , Key_Skill_k , shadowQtyInc+1 )
	endfunction

	//残影踏
	public function canyingta takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer skillLv = GetUnitAbilityLevel( triggerUnit , SHAKEBULL_NORMAL_canyingta )
	    local integer shadowQty = 7 + skillLv * 3
	    local real hunt = 0.00
	    local timer t = null
	    set hunt = skillLv * 175 + Attr_Move[index]
	    //神秘附加
	    if( funcs_isOwnItem(triggerUnit , ITEM_mysterious_ground_totem) ) then
	        set shadowQty = shadowQty + 10
	    endif
	    set t = funcs_setInterval( 0.20 , function canyingtaCall )
	    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , triggerUnit)
	    call funcs_setTimerParams_Integer( t , Key_Skill_i , index )
	    call funcs_setTimerParams_Integer( t , Key_Skill_j , shadowQty )
	    call funcs_setTimerParams_Integer( t , Key_Skill_k , 0 )
	    call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt )
	endfunction

	//震撼大地
	public function zhenhandadi takes nothing returns nothing
	endfunction


endlibrary


library shakeBull requires shakeBullNormal


	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		//normal
		if( abilityId == SHAKEBULL_NORMAL_jianta ) then
			call shakeBullNormal_jianta()
		elseif( abilityId == SHAKEBULL_NORMAL_tuwei ) then
			call shakeBullNormal_tuwei()
		elseif( abilityId == SHAKEBULL_NORMAL_zhendangbo ) then
			call shakeBullNormal_zhendangbo()
		elseif( abilityId == SHAKEBULL_NORMAL_canyingta ) then
			call shakeBullNormal_canyingta()
		elseif( abilityId == SHAKEBULL_NORMAL_zhenhandadi ) then
			call shakeBullNormal_zhenhandadi()
		endif
	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		//local integer abilityId = GetLearnedSkill()
	endfunction

	public function init takes nothing returns nothing
		local trigger trigger_shakeBull_spell_effect = CreateTrigger()
		local trigger trigger_shakeBull_spell_study = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_shakeBull_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_shakeBull_spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_shakeBull_spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( trigger_shakeBull_spell_study , function action_spell_study )
	endfunction

endlibrary

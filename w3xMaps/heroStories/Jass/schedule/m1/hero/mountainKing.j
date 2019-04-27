globals

    integer m1MountainKing_spell_wuxingzhichui = 'A04Q'
    integer m1MountainKing_spell_chuiji = 'A009'
    integer m1MountainKing_spell_bufanzhongji = 'A01H'
    integer m1MountainKing_spell_tianshenxiafan = 'A031'
    integer m1MountainKing_spell_lianchuiwu = 'A03P'

endglobals

library m1MountainKing requires m1Hero

	//无形之锤
	public function wuxingzhichui takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
	    local location targetLoc = GetSpellTargetLoc()
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer level = GetUnitAbilityLevel(triggerUnit, m1MountainKing_spell_wuxingzhichui)
	    local real hunt = I2R(Attr_Power[index] + level * 30)
	    local real range = 300.00
	    local real swimTime = 1.00
	    local group g = null
	    local unit u = null
	    call funcs_effectPoint( Effect_ThunderClapCaster , targetLoc )
	    set g = funcs_getGroupByPoint( targetLoc , range , function filterTrigger_enemy_live_disbuild )
	    call RemoveLocation(targetLoc)
	    loop
	        exitwhen(IsUnitGroupEmptyBJ(g) == true)
	            //must do
	            set u = FirstOfGroup(g)
	            call GroupRemoveUnit( g , u )
	            call skills_swim( u, swimTime )
	            call funcs_huntBySelf( hunt , triggerUnit , u )
	    endloop
	    call GroupClear( g )
	    call DestroyGroup( g )
	endfunction

	//锤击
	public function chuiji takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
	    local location targetLoc = GetUnitLoc(triggerUnit)
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer level = GetUnitAbilityLevel(triggerUnit, m1MountainKing_spell_chuiji)
	    local real hunt = I2R(Attr_Attack[index] + level * 150)
	    local real range = 300.00
	    local group g = null
	    local unit u = null
	    set g = funcs_getGroupByPoint( targetLoc , range , function filterTrigger_enemy_live_disbuild )
	    call RemoveLocation(targetLoc)
	    loop
	        exitwhen(IsUnitGroupEmptyBJ(g) == true)
	            //must do
	            set u = FirstOfGroup(g)
	            call GroupRemoveUnit( g , u )
	            call funcs_huntBySelf( hunt , triggerUnit , u )
	    endloop
	    call GroupClear( g )
	    call DestroyGroup( g )
	endfunction

	//不凡重击
	public function bufanzhongji takes nothing returns nothing
		//----see event damaged
	endfunction

	//天神下凡
	public function tianshenxiafan takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer level = GetUnitAbilityLevel(triggerUnit, m1MountainKing_spell_tianshenxiafan)
	    local integer attack = level * 100
	    local integer defend = level * 20
	    local integer knocking = level * 1250
	    local integer violence = level * 1500
	    local real during = 60.00
	    //加成
	    call attribute_changeAttribute(Tag_Attack ,index, attack ,during)
	    call attribute_changeAttribute(Tag_Defend ,index, defend ,during)
	    call attribute_changeAttribute(Tag_Knocking ,index, knocking ,during)
	    call attribute_changeAttribute(Tag_Violence ,index, violence ,during)
	endfunction

	//连锤舞 - 回调
	private function lianchuiwuCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
	    local integer duringInc = funcs_getTimerParams_Integer( t , Key_Skill_DuringInc )
	    local unit triggerUnit = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local location targetLoc = funcs_getTimerParams_Loc( t , Key_Skill_TargetLoc )
	    local real range = funcs_getTimerParams_Real( t , Key_Skill_Range )
	    local real hunt = funcs_getTimerParams_Real( t , Key_Skill_Hunt ) * I2R(duringInc)
	    local real animateScale = funcs_getTimerParams_Real( t , Key_Skill_k )
	    local real timerTimeout = TimerGetTimeout(t)
	    local real timerTimeoutNew = TimerGetTimeout(t) * 0.8
	    local group g = null
	    local unit u = null
	    if( timerTimeout < 0.1 or IsUnitDeadBJ(triggerUnit) == TRUE ) then
	        call funcs_delTimer(t,null)
	        call RemoveLocation(targetLoc)
	        call SetUnitTimeScale( triggerUnit , 1.00 )
	        call PauseUnit( triggerUnit , false )
	    else
	        call funcs_delTimer(t,null)
	        //动作
	        call SetUnitTimeScale( triggerUnit , animateScale * ( 2.00 / timerTimeoutNew ) )
	        call SetUnitAnimation( triggerUnit , "attack slam" )
	        call funcs_effectPoint( Effect_EarthDetonation , targetLoc ) //特效
	        set g = funcs_getGroupByPoint( targetLoc , range , function filter_live_disbuild )
	        loop
	            exitwhen(IsUnitGroupEmptyBJ(g) == true)
	                //must do
	                set u = FirstOfGroup(g)
	                call GroupRemoveUnit( g , u )
	                //检测是否敌军
	                if( IsUnitEnemy( u , GetOwningPlayer(triggerUnit))  == TRUE ) then
	                    call skills_punish( u  , 0.75 , 0 )
	                    call funcs_huntBySelf( hunt , triggerUnit , u )
	                endif
	        endloop
	        call GroupClear( g )
	        call DestroyGroup( g )
	        //锤击特效
	        if( timerTimeout < 0.25 ) then
	            call funcs_effectPoint( Effect_LightningsLong , targetLoc )
	        elseif( timerTimeout < 0.50 ) then
	            call funcs_effectPoint( Effect_MonsoonBoltTarget , targetLoc )
	        elseif( timerTimeout < 1.00 ) then
	            call funcs_effectPoint( Effect_ThunderClapCaster , targetLoc )
	        endif
	        //新一轮打击
	        set t = funcs_setTimeout( timerTimeoutNew , function lianchuiwuCall )
	        call funcs_setTimerParams_Integer( t , Key_Skill_DuringInc , 1 )
	        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , triggerUnit )
	        call funcs_setTimerParams_Loc( t , Key_Skill_TargetLoc , targetLoc )
	        call funcs_setTimerParams_Real( t , Key_Skill_Range , range )
	        call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt )
	        call funcs_setTimerParams_Real( t , Key_Skill_k , animateScale )
	    endif
	endfunction

	//连锤舞
	public function lianchuiwu takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
	    local location loc = GetUnitLoc(triggerUnit)
	    local location targetLoc = GetSpellTargetLoc()
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer level = GetUnitAbilityLevel(triggerUnit, m1MountainKing_spell_lianchuiwu)
	    local real range = 150.00
	    local real hunt = I2R( Attr_Attack[index] * 3 + level * 750 )
	    local real animateScale = 0.3
	    local timer t = null
	    call funcs_effectPoint( Effect_SuperShinythingy , loc )
	    call RemoveLocation(loc)
	    call PauseUnit( triggerUnit , true )
	    //神秘附加
	    if( funcs_isOwnItem(triggerUnit , ITEM_mysterious_force_axe) ) then
	        set range = range * 3
	    endif
	    //开启狂锤之路
	    set t = funcs_setTimeout( 2.00 , function lianchuiwuCall )
	    call funcs_setTimerParams_Integer( t , Key_Skill_DuringInc , 1 )
	    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , triggerUnit )
	    call funcs_setTimerParams_Loc( t , Key_Skill_TargetLoc , targetLoc )
	    call funcs_setTimerParams_Real( t , Key_Skill_Range , range )
	    call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt )
	    call funcs_setTimerParams_Real( t , Key_Skill_k , animateScale )
	    call PolledWait(0.25)
	    call SetUnitTimeScale( triggerUnit , animateScale )
	    call SetUnitAnimation( triggerUnit , "attack slam" )
	endfunction

endlibrary


library m1MountainKingUse requires m1MountainKing

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		if( abilityId == m1MountainKing_spell_wuxingzhichui ) then
			call m1MountainKing_wuxingzhichui()
		elseif( abilityId == m1MountainKing_spell_chuiji ) then
			call m1MountainKing_chuiji()
		elseif( abilityId == m1MountainKing_spell_tianshenxiafan ) then
			call m1MountainKing_tianshenxiafan()
		elseif( abilityId == m1MountainKing_spell_lianchuiwu ) then
			call m1MountainKing_lianchuiwu()
		endif

	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		if( abilityId == m1MountainKing_spell_bufanzhongji ) then
			call m1MountainKing_bufanzhongji()
		endif
	endfunction

	public function init takes nothing returns nothing
		local trigger trigger_spell_effect = CreateTrigger()
		local trigger trigger_spell_study = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( trigger_spell_study , function action_spell_study )
	endfunction

endlibrary

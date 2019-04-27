globals

    integer m1Kael_spell_mingxiang = 'A00O'
    integer m1Kael_spell_xianjijingling = 'A06C'
    integer m1Kael_spell_wangzhehusheng = 'A08Y'
    integer m1Kael_spell_yinianzuzhou = 'A094'
    integer m1Kael_spell_kongming = 'A097'

    integer m1Kael_spell_MODEL_mingxiang = 'A095'

    integer m1Kael_spell_xianjijingling_token = 'u00B'

    integer array m1Kael_spell_yinianzuzhou_Inc
    boolean array m1Kael_spell_yinianzuzhou_Actioning
    boolean array m1Kael_spell_kongming_status

endglobals

/* 召唤师 */
library m1Kael requires m1Hero

	//冥想
	public function mingxiang takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer thinkPower = 35
	    //学习大于等于5级增加模型特效
	    if(level == 5) then
	        call abilities_registAbility(u,m1Kael_spell_MODEL_mingxiang)
	    endif
	    set Attr_Dynamic_SkillDamage[index] = Attr_Dynamic_SkillDamage[index] + thinkPower
	    call attribute_calculateOne(index)
	endfunction

	//献祭精灵 - 回调
	private function xianjijinglingCall takes nothing returns nothing
	    local timer t = GetExpiredTimer()
	    local unit source = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local unit fairy = funcs_getTimerParams_Unit( t , Key_Skill_UnitSource )
	    local real hunt = funcs_getTimerParams_Real( t , Key_Skill_Hunt )
	    local real range = funcs_getTimerParams_Real( t , Key_Skill_Range )
	    local group exg = null
	    local location loc = null
	    //-------------
	    set loc = GetUnitLoc(fairy)
	    call ExplodeUnitBJ( fairy )
	    call funcs_effectPoint(Effect_Stomp,loc)
	    set exg = funcs_getGroupByPoint( loc, range , function filter_live_disbuild )
	    call funcs_huntGroup(exg, source, hunt, null , null , FILTER_ENEMY)
	    call RemoveUnit( fairy )
	    call GroupClear( exg )
	    call DestroyGroup( exg )
	    call RemoveLocation(loc)
	    call funcs_delTimer(t,null)
	endfunction

	//献祭精灵
	public function xianjijingling takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local unit fairy = null
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer soulQty = 1
	    local real hunt = level * 175.00
	    local real range = 175 + I2R(level) * 25
	    local timer t = null
	    local location loc = GetUnitLoc(u)
	    local location targetLoc = GetSpellTargetLoc()
	    local location targetLoc2 = null
	    set fairy = funcs_createUnitAttackToLoc( m1Kael_spell_xianjijingling_token ,GetOwningPlayer(u), loc, targetLoc)
	    set t = funcs_setTimeout( 2.50 , function xianjijinglingCall )
	    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u )
	    call funcs_setTimerParams_Unit( t , Key_Skill_UnitSource , fairy )
	    call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt )
	    call funcs_setTimerParams_Real( t , Key_Skill_Range , range )
	endfunction

	//亡者呼声
	public function wangzhehusheng takes nothing returns nothing
		//----see event damaged
	endfunction

	//意念诅咒 - 回调
	private function yinianzuzhouCall takes nothing returns nothing
	    local timer t = GetExpiredTimer()
	    local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local integer index = funcs_getTimerParams_Integer( t , Key_Skill_i )
	    local location loc = null
	    local real range = funcs_getTimerParams_Real( t , Key_Skill_Range )
	    local group g = null
	    local integer gCount = 0
	    local integer skillUp = 0

	    if(TimerGetTimeout(t) < 1.00 and m1Kael_spell_yinianzuzhou_Actioning[index] == true) then
	        call funcs_delTimer(t,null)
	        set t = funcs_setInterval( 1.00 , function yinianzuzhouCall )
	        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u)
	        call funcs_setTimerParams_Integer( t , Key_Skill_i , index)
	        call funcs_setTimerParams_Real( t , Key_Skill_Range , range)
	    endif

	    if( m1Kael_spell_yinianzuzhou_Actioning[index] == true and IsUnitAliveBJ(u) == true ) then
	        set loc = GetUnitLoc(u)
	        set g = funcs_getGroupByPoint( loc , range , function filter_live_disbuild )
	        set gCount = CountUnitsInGroup(g)
	        call funcs_effectPoint(Effect_CrushingWhiteRing,loc)
	        call RemoveLocation(loc)
	        call GroupClear( g )
	        call DestroyGroup( g )
	        if(gCount < 10 ) then
	            set skillUp = 125
	        elseif(gCount >=10 and gCount < 20 ) then
	            set skillUp = 225
	        elseif(gCount >=20 ) then
	            set skillUp = 450
	        endif
	        set m1Kael_spell_yinianzuzhou_Inc[index] = m1Kael_spell_yinianzuzhou_Inc[index] + skillUp
	        set Attr_Dynamic_SkillDamage[index] = Attr_Dynamic_SkillDamage[index] + skillUp
	        call attribute_calculateOne(index)
	    else
	        call funcs_delTimer(t,null)
	        //最后一击
	        set loc = GetUnitLoc(u)
	        call funcs_effectPoint(Effect_ShadowAssault,loc)
	        call funcs_effectPoint(Effect_S_EvilWave_Effect,loc)
	        set g = funcs_getGroupByPoint( loc, 600.00, function filter_live_disbuild )
	        call funcs_huntGroup(g, u, Attr_SkillDamage[index], null , null , FILTER_ENEMY)
	        call GroupClear( g )
	        call DestroyGroup( g )
	        call RemoveLocation(loc)
	        set Attr_Dynamic_SkillDamage[index] = Attr_Dynamic_SkillDamage[index] - m1Kael_spell_yinianzuzhou_Inc[index]
	        set m1Kael_spell_yinianzuzhou_Inc[index] = 0
	        call attribute_changeAttribute(Tag_SkillDamage,index, -99999  ,5.00)
	        call attribute_changeAttribute(Tag_Move,index, -200  ,5.00)
	        call attribute_calculateOne(index)
	    endif

	endfunction

	//意念诅咒
	public function yinianzuzhou takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real range = 600.00
	    local timer t
	    if( m1Kael_spell_yinianzuzhou_Actioning[index] == false ) then
		    set m1Kael_spell_yinianzuzhou_Actioning[index] = true
	        set m1Kael_spell_yinianzuzhou_Inc[index] = 0
	        set t = funcs_setTimeout( 0.00,function yinianzuzhouCall )
	        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u)
	        call funcs_setTimerParams_Integer( t , Key_Skill_i , index)
	        call funcs_setTimerParams_Real( t , Key_Skill_Range , range)
	    endif
	endfunction

	//意念诅咒 - 中止
	public function yinianzuzhou_abort takes nothing returns nothing
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
	    if( m1Kael_spell_yinianzuzhou_Actioning[index] == true ) then
	        set m1Kael_spell_yinianzuzhou_Actioning[index] = false
	    endif
	endfunction

	//意念诅咒 - 施法结束
	public function yinianzuzhou_finish takes nothing returns nothing
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
	    if( m1Kael_spell_yinianzuzhou_Actioning[index] == true ) then
	        set m1Kael_spell_yinianzuzhou_Actioning[index] = false
	    endif
	endfunction

	//空冥 - 回调
	private function kongmingCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
		local integer index =GetConvertedPlayerId( GetOwningPlayer(u) )
		local integer level = GetUnitAbilityLevel( u , m1Kael_spell_kongming )
		local integer skillDamage = GetRandomInt( 1 , level * 1000 )
	    local location loc = null
	    if( m1Kael_spell_kongming_status[index] == true ) then
		    set loc = GetUnitLoc(u)
		    call funcs_effectPoint(Effect_ReplenishManaCaster,loc)
		    call attribute_changeAttribute(Tag_SkillDamage, index, skillDamage , 16.00)
			call RemoveLocation(loc)
	   	endif
	endfunction

	//空冥
	public function kongming takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer skillDamage = 1000
	    local timer t = null
	    set Attr_Dynamic_SkillDamage[index] = Attr_Dynamic_SkillDamage[index] + skillDamage
	    call attribute_calculateOne(index)
	    if( m1Kael_spell_kongming_status[index] == false ) then
		    set m1Kael_spell_kongming_status[index] = true
	        call funcs_setInterval( 10.00 , function kongmingCall )
	    endif
	endfunction

endlibrary

/* 召唤师 */
library m1KaelUse requires m1Kael

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		//normal
		if( abilityId == m1Kael_spell_xianjijingling ) then
			call m1Kael_xianjijingling()
		elseif( abilityId == m1Kael_spell_wangzhehusheng ) then
			call m1Kael_wangzhehusheng()
		elseif( abilityId == m1Kael_spell_yinianzuzhou ) then
			call m1Kael_yinianzuzhou()
		endif

	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		if( abilityId == m1Kael_spell_mingxiang ) then
			call m1Kael_mingxiang()
		elseif( abilityId == m1Kael_spell_kongming ) then
			call m1Kael_kongming()
		endif
	endfunction

	//Action - 停止施法
	private function action_spell_abort takes nothing returns nothing
	    local integer abilityId = GetSpellAbilityId()
	    if( abilityId == m1Kael_spell_yinianzuzhou ) then
			call m1Kael_yinianzuzhou_abort()
		endif
	endfunction

	//Action - 施法结束
	private function action_spell_finish takes nothing returns nothing
	    local integer abilityId = GetSpellAbilityId()
	    if( abilityId == m1Kael_spell_yinianzuzhou ) then
			call m1Kael_yinianzuzhou_finish()
		endif
	endfunction


	public function init takes nothing returns nothing
		local trigger trigger_spell_effect = CreateTrigger()
		local trigger trigger_spell_study = CreateTrigger()
		local trigger trigger_spell_abort = CreateTrigger()
		local trigger trigger_spell_finish = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( trigger_spell_study , function action_spell_study )
	    //停止施法
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_abort, EVENT_PLAYER_UNIT_SPELL_ENDCAST )
		call TriggerAddAction( trigger_spell_abort , function action_spell_abort )
    	//施法结束
    	call TriggerRegisterAnyUnitEventBJ( trigger_spell_finish, EVENT_PLAYER_UNIT_SPELL_FINISH )
    	call TriggerAddAction( trigger_spell_finish , function action_spell_finish )
	endfunction

endlibrary

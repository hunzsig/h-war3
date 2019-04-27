globals

    integer DIXUEJIACHONG_chuanci = 'A032'
    integer DIXUEJIACHONG_zuandi = 'A082'
    integer DIXUEJIACHONG_fushichongye = 'A096'
    integer DIXUEJIACHONG_tuike = 'A098'

	boolean DIXUEJIACHONG_fushichongye_opening = false
    boolean array DIXUEJIACHONG_fushichongye_status

endglobals

library cryptBeetle requires heroBase

	//穿刺
	private function chuanci takes nothing returns nothing

	endfunction

	//钻地
	private function zuandi takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local location point = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real damage = 0.00
	    //神秘附加
	    if( funcs_isOwnItem(u , ITEM_mysterious_ancient_oracle) ) then
	        set damage = damage + Attr_Quick[index]
	    endif
	    call skills_addLifePercent(u,I2R(level)*10.00)
	    call SetUnitVertexColorBJ( u, 100, 100, 100, 90.00 )
	    call skills_leap(u,point,20.00,null,damage,1.00,null,true)
	endfunction


	//腐蚀虫液 - 实际效果
	private function fushichongyeEffect takes nothing returns nothing
		local timer t = GetExpiredTimer()
	    local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit  )
	    local real hunt = funcs_getTimerParams_Real( t , Key_Skill_Hunt  )
	    local integer during = funcs_getTimerParams_Integer( t , Key_Skill_During )
	    local integer duringInc = funcs_getTimerParams_Integer( t , Key_Skill_DuringInc )
	    local string HEffect = Effect_HydraCorrosiveGroundEffect
	    local location loc
	    local group g
	    if( duringInc < during and IsUnitAliveBJ(u) == true and IsUnitPausedBJ(u) == false ) then
	        call funcs_setTimerParams_Integer( t , Key_Skill_DuringInc , duringInc+1 )
	        set loc = GetUnitLoc( u )
	        set g = funcs_getGroupByPoint( loc , 180.00 , function filter_live_disbuild )
	        call funcs_huntGroup( g, u , hunt , HEffect , null , FILTER_ENEMY )
	        call RemoveLocation( loc )
	        call DestroyGroup( g )
	    else
	        call funcs_delTimer( t ,null )
	    endif
	endfunction

	//腐蚀虫液 - 回调
	private function fushichongyeCall takes nothing returns nothing
		local timer callTimer = GetExpiredTimer()
		local unit triggerUnit = funcs_getTimerParams_Unit( callTimer ,Key_Skill_Unit )
		local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer level = GetUnitAbilityLevel( triggerUnit , DIXUEJIACHONG_fushichongye )
	    local integer during = 10
	    local real hunt = I2R(level) * Attr_Quick[index] * 0.1
	    local timer t =null
	    local location loc = null
	    if( IsUnitAliveBJ(triggerUnit) == true and IsUnitPausedBJ(triggerUnit) == false ) then
	        set loc = GetUnitLoc( triggerUnit )
	        set t = funcs_setInterval( 0.10 , function fushichongyeEffect )
	        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , triggerUnit )
	        call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt )
	        call funcs_setTimerParams_Integer( t , Key_Skill_During , during )
	        call funcs_setTimerParams_Integer( t , Key_Skill_DuringInc , 0 )
	        call RemoveLocation( loc )
	    endif
	endfunction

	//腐蚀虫液
	private function fushichongye takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
		local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
		local timer t =null
	    if(DIXUEJIACHONG_fushichongye_status[index] == false) then
		    set DIXUEJIACHONG_fushichongye_status[index] = true
	    endif
        //如果技能效果未开，则开启
        set t = funcs_setInterval( 7.00 , function fushichongyeCall )
        call funcs_setTimerParams_Unit( t ,Key_Skill_Unit , triggerUnit )
	endfunction

	//蜕壳
	private function tuike takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer addAttack = 0
	    local integer addDefend = 0
	    local integer addPunish = 0
	    local integer addToughness = 0
	    //--
	    if(level == 1) then
            set addAttack = 25
            set addDefend = 3
            set addToughness = 15
        elseif(level == 2) then
            set addAttack = 30
            set addDefend = 4
            set addToughness = 25
        elseif(level == 3) then
            set addAttack = 35
            set addDefend = 5
            set addToughness = 35
        endif
	    //神秘附加
	    if( funcs_isOwnItem(u , ITEM_mysterious_ancient_oracle) ) then
	        set addAttack = addAttack * 2
            set addDefend = addDefend * 2
            set addToughness = addToughness * 2
	    endif
	    set Attr_Dynamic_Attack[index] = Attr_Dynamic_Attack[index] + addAttack
	    set Attr_Dynamic_Defend[index] = Attr_Dynamic_Defend[index] + addDefend
	    set Attr_Dynamic_Toughness[index] = Attr_Dynamic_Toughness[index] + addToughness
	    call attribute_calculateOne(index)
	endfunction


	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		if( abilityId == DIXUEJIACHONG_chuanci ) then
			call chuanci()
		elseif( abilityId == DIXUEJIACHONG_zuandi ) then
			call zuandi()
		elseif( abilityId == DIXUEJIACHONG_tuike ) then
			call tuike()
		endif
	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		if( abilityId == DIXUEJIACHONG_fushichongye ) then
			call fushichongye()
		endif
	endfunction

	public function init takes nothing returns nothing
		local trigger trigger_cryptBeetle_spell_effect = CreateTrigger()
		local trigger trigger_cryptBeetle_spell_study = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_cryptBeetle_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_cryptBeetle_spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_cryptBeetle_spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( trigger_cryptBeetle_spell_study , function action_spell_study )
	endfunction

endlibrary

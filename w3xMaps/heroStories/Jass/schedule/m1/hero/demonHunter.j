globals

    integer m1DemonHunter_spell_egui = 'A036'
    integer m1DemonHunter_spell_hennianchanshen = 'A034'
    integer m1DemonHunter_spell_guiying = 'A03V'
    integer m1DemonHunter_spell_guiyingchongchong = 'A01R'
    integer m1DemonHunter_spell_canyingqiege = 'A039'

	boolean m1DemonHunter_spell_egui_isInit = false
    integer m1DemonHunter_spell_egui_not2has_Model = 'A016'
    integer m1DemonHunter_spell_egui_has2not_Model = 'A03C'

    group m1DemonHunter_spell_hennianchanshen_group = CreateGroup()

    integer m1DemonHunter_spell_guiying_not = 'u00Q'
    integer m1DemonHunter_spell_guiying_has = 'u00R'

    integer m1DemonHunter_spell_guiying_max_qty = 10
    integer array m1DemonHunter_spell_guiying_current_qty
    integer m1DemonHunter_spell_guiyingchongchong_max_qty = 10
    integer array m1DemonHunter_spell_guiyingchongchong_current_qty

endglobals

library m1DemonHunter requires m1Hero

	//恶鬼 - 回调
	private function eguiCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
	    local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    //模型变化
	    call UnitAddAbility( u , m1DemonHunter_spell_egui_has2not_Model )
		call UnitRemoveAbility( u , m1DemonHunter_spell_egui_has2not_Model )
	    call funcs_delTimer(t,null)
	    //debug
	    call PolledWait(0.10) //模型变化需要一点时间，所以这里加延时,在对单位进行属性计算
	    call attribute_calculateOne(index)
	endfunction


	//恶鬼
	public function egui takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local location point = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer attackSpeed = level * 10
	    local integer split = level * 10
	    local integer hemophagia = level * 7
	    local real during = 55.00
	    local location loc = GetUnitLoc(u)
	    local timer t = null
	    //模型变化
		call UnitAddAbility( u , m1DemonHunter_spell_egui_not2has_Model )
		call UnitRemoveAbility( u , m1DemonHunter_spell_egui_not2has_Model )

	    call funcs_effectPoint( Effect_HowlCaster , loc )
	    call RemoveLocation(loc)
	    call attribute_changeAttribute( Tag_AttackSpeed ,index, attackSpeed , during )
	    call attribute_changeAttribute( Tag_Split ,index, split , during )
	    call attribute_changeAttribute( Tag_Hemophagia ,index, hemophagia , during )
	    set t = funcs_setTimeout( during , function eguiCall )
	    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u )
	    //debug
	    call PolledWait(0.10) //模型变化需要一点时间，所以这里加延时,在对单位进行属性计算
	    call attribute_calculateOne(index)
	endfunction

	//恨念缠身 - 循环效果
	private function hennianchanshenEffect takes nothing returns nothing
	    local location loc = GetUnitLoc(GetEnumUnit())
	    call funcs_effectPoint( Effect_UndeadDissipate , loc )
	    call RemoveLocation(loc)
	endfunction

	//恨念缠身 - 回调
	private function hennianchanshenCall takes nothing returns nothing
	    local timer t = GetExpiredTimer()
	    local unit triggerUnit = funcs_getTimerParams_Unit( t , Key_Skill_Unit  )
	    local group g = funcs_getTimerParams_Group( t , Key_Skill_Group )
	    local real during = funcs_getTimerParams_Real( t , Key_Skill_During ) * 0.5
	    local real duringInc = funcs_getTimerParams_Real( t , Key_Skill_DuringInc )

	    if( duringInc > during ) then
	        call funcs_delTimer(t,null)
	        call GroupRemoveGroup( m1DemonHunter_spell_hennianchanshen_group , g )
	        call DestroyGroup(g)
	    else
	        call funcs_setTimerParams_Real( t , Key_Skill_DuringInc , duringInc+1 )
	        call ForGroup( g , function hennianchanshenEffect )
	    endif

	endfunction

	//恨念缠身
	public function hennianchanshen takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
	    local location targetLoc = GetSpellTargetLoc()
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer level = GetUnitAbilityLevel(triggerUnit, GetSpellAbilityId())
	    local real range = 300.00
	    local real hunt = I2R(Attr_Attack[index] * level)
	    local real during = 15.00
	    local group g = null
	    local group g2 = null
	    local timer t = null
	    set g2 = funcs_getGroupByPoint( targetLoc , range , function filterTrigger_enemy_live_disbuild )
	    call funcs_huntGroup( g2 , triggerUnit , hunt , Effect_UndeadDissipate , null , FILTER_ENEMY )
	    set g = funcs_getGroupByPoint( targetLoc , range , function filterTrigger_enemy_live_disbuild )
	    if( CountUnitsInGroup(g) > 0) then
	        call GroupAddGroup( m1DemonHunter_spell_hennianchanshen_group , g )
	        set t = funcs_setInterval( 3.0 , function hennianchanshenCall )
	        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , triggerUnit )
	        call funcs_setTimerParams_Group( t , Key_Skill_Group , g )
	        call funcs_setTimerParams_Real( t , Key_Skill_During , during )
	        call funcs_setTimerParams_Real( t , Key_Skill_DuringInc , 1 )
	    endif
	    call RemoveLocation(targetLoc)
	endfunction

	//删除鬼影 - 回调
	private function guiyingDelCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
		local integer index = funcs_getTimerParams_Integer( t , Key_Skill_i )
		local boolean isGuiying = funcs_getTimerParams_Boolean( t , Key_Skill_j )
		call RemoveUnit( u )
		if( isGuiying == true)then
			set m1DemonHunter_spell_guiying_current_qty[index] = m1DemonHunter_spell_guiying_current_qty[index] - 1
		else
			set m1DemonHunter_spell_guiyingchongchong_current_qty[index] = m1DemonHunter_spell_guiyingchongchong_current_qty[index] - 1
		endif
	endfunction

	//删除鬼影
	public function guiyingDel takes integer index , unit u , real during , boolean isGuiying returns nothing
		local timer t = funcs_setTimeout( during , function guiyingDelCall )
		call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u )
		call funcs_setTimerParams_Integer( t , Key_Skill_i , index )
		call funcs_setTimerParams_Boolean( t , Key_Skill_j , isGuiying )
	endfunction

	//鬼影
	public function guiying takes nothing returns nothing
		//----see event damaged
	endfunction

	//鬼影重重
	public function guiyingchongchong takes nothing returns nothing
		local player owner = GetOwningPlayer(GetAttacker())
	    local integer playerIndex = GetConvertedPlayerId( owner )
	    local unit hero = Player_heros[playerIndex]
	    local integer levelGuiying = GetUnitAbilityLevel(hero, m1DemonHunter_spell_guiying)
	    local integer level = GetUnitAbilityLevel(hero, m1DemonHunter_spell_guiyingchongchong)
	    local real during = 4.00
	    local unit createUnit = null
	    local location loc = null
	    if( level > 0 and m1DemonHunter_spell_guiyingchongchong_current_qty[playerIndex] < m1DemonHunter_spell_guiyingchongchong_max_qty and IsUnitAliveBJ(hero) == true and GetRandomInt(1,100) < (level*5) ) then
	        //神秘附加
	        if( funcs_isOwnItem( hero , ITEM_mysterious_soul_break ) ) then
	            set during = during + 2.00
	        endif

	        set loc = GetUnitLoc(GetTriggerUnit())
	        call funcs_effectPoint( Effect_MirrorDemon , loc )
	        if( GetUnitTypeId(GetAttacker()) == m1DemonHunter_spell_guiying_has ) then
	            set createUnit = funcs_createUnit( owner , m1DemonHunter_spell_guiying_has ,  loc,  loc )
	        else
	            set createUnit = funcs_createUnit( owner , m1DemonHunter_spell_guiying_not ,  loc,  loc )
	        endif
	        set m1DemonHunter_spell_guiyingchongchong_current_qty[playerIndex] = m1DemonHunter_spell_guiyingchongchong_current_qty[playerIndex] + 1
	        call guiyingDel( playerIndex , createUnit , during , false )
	        call attribute_copyAttrForShadow( playerIndex , createUnit , 0 , 0.20 , 0.20 , 0.50 )
	        call SetUnitVertexColorBJ( createUnit , 80 , 80 , 80, 70.00 )
	        call RemoveLocation(loc)
	    endif
	endfunction

	//残影切割 - 影子
	public function canyingqiegeShadow takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
		local integer i = funcs_getTimerParams_Integer( t , Key_Skill_i )
		local integer playerIndex = GetConvertedPlayerId(GetOwningPlayer(u))
		local location loc = null
		local unit createUnit = null
		call funcs_setTimerParams_Integer( t , Key_Skill_i , i+1 )
		if( i > 4 ) then
			call funcs_delTimer( t , null)
		else
			set loc = GetUnitLoc(u)
			call funcs_effectPoint( Effect_MirrorDemon , loc )
            if( GetUnitTypeId(u) == Hero_demon_hunter_sp  ) then
                set createUnit = funcs_createUnit( GetOwningPlayer(u) , m1DemonHunter_spell_guiying_has ,  loc,  loc )
            else
                set createUnit = funcs_createUnit( GetOwningPlayer(u) , m1DemonHunter_spell_guiying_not ,  loc,  loc )
            endif
            set m1DemonHunter_spell_guiying_current_qty[playerIndex] = m1DemonHunter_spell_guiying_current_qty[playerIndex] + 1
            call guiyingDel( playerIndex , createUnit , 6.00 , true )
            //神秘附加
		    if( funcs_isOwnItem( u , ITEM_mysterious_soul_break ) ) then
		        call attribute_copyAttrForShadow( playerIndex , createUnit , 0 , 1.35 , 1.20 , 1.25 )
		    else
		    	call attribute_copyAttrForShadow( playerIndex , createUnit , 0 , 1.20 , 1.20 , 1.25 )
		    endif
            call SetUnitVertexColorBJ( createUnit , 80 , 80 , 80, 75.00 )
			call RemoveLocation(loc)
		endif
	endfunction

	//残影切割
	public function canyingqiege takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local location loc = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real speed = 60
	    local real hunt = I2R( Attr_Attack[index] * level )
	    local real range = 100
	    local timer t = null
	    call SetUnitAnimation( u, "attack 2" )
	    call skills_leap( u , u ,loc ,speed, null , hunt,range , Effect_Boold_Cut , false )
	    set t = funcs_setInterval( 0.07 , function canyingqiegeShadow )
	    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u )
	    call funcs_setTimerParams_Integer( t , Key_Skill_i , 1 )
	endfunction

endlibrary

library m1DemonHunterUse requires m1DemonHunter

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		//m1
		if( abilityId == m1DemonHunter_spell_egui ) then
			call m1DemonHunter_egui()
		elseif( abilityId == m1DemonHunter_spell_hennianchanshen ) then
			call m1DemonHunter_hennianchanshen()
		elseif( abilityId == m1DemonHunter_spell_canyingqiege ) then
			call m1DemonHunter_canyingqiege()
		endif

	endfunction

	//Action - 被攻击
	private function action_unit_beAttack takes nothing returns nothing
		if( GetUnitTypeId(GetAttacker()) == m1DemonHunter_spell_guiying_not or GetUnitTypeId(GetAttacker()) == m1DemonHunter_spell_guiying_has ) then
			call m1DemonHunter_guiyingchongchong()
		endif
 	endfunction

	public function init takes nothing returns nothing
		local trigger trigger_spell_effect = CreateTrigger()
		local trigger trigger_unit_deAttack = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_spell_effect , function action_spell_effect )
	    //被攻击
	    call TriggerRegisterAnyUnitEventBJ( trigger_unit_deAttack, EVENT_PLAYER_UNIT_ATTACKED )
    	call TriggerAddAction( trigger_unit_deAttack , function action_unit_beAttack )
	endfunction

endlibrary

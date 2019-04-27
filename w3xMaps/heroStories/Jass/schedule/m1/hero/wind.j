globals

    integer m1Wind_spell_yicha = 'A019'
    integer m1Wind_spell_xunshou = 'A01T'
    integer m1Wind_spell_wuyingzhan = 'A0C5'
    integer m1Wind_spell_wuyingzhanfeng = 'A04D'
    integer m1Wind_spell_jijijiansha = 'A01U'
    integer m1Wind_spell_fengshenjue = 'A047'

    integer m1Wind_spell_MODEL_xunshou = 'A01F'
    integer m1Wind_spell_MODEL_wuyingzhan = 'A084'
    integer m1Wind_spell_MODEL_wuyingzhanfeng = 'A01X'
    integer m1Wind_spell_MODEL_fengshenjue = 'A06S'

endglobals

library m1Wind requires m1Hero

	//一刹
	public function yicha takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local location point = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real speed
	    local real hunt
	    local real range = 75
	    if(level<5)then
	        set hunt = I2R(Attr_Attack[index]) + I2R(level) * 25
	    else
	        set hunt = I2R(Attr_Attack[index]) + I2R(Attr_Quick[index]) + I2R(level) * 25
	    endif
	    if(level<10)then
	        set speed = 30
	    else
	        set speed = 60
	    endif
	    //神秘附加
	    if( funcs_isOwnItem(u , ITEM_mysterious_escape_wind) ) then
	        set hunt = hunt + Attr_Move[index]
	    endif
	    call skills_leap(u,u,point,speed,null,hunt,range,Effect_Boold_Cut,false)
	endfunction

	//迅手
	public function xunshou takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer speed = 15
	    //学习大于等于7级增加模型特效
	    if(level == 7) then
	        call abilities_registAbility(u,m1Wind_spell_MODEL_xunshou)
	    endif
	    set Attr_Dynamic_AttackSpeed[index] = Attr_Dynamic_AttackSpeed[index] + I2R(speed)
	    call attribute_calculateOne(index)
	endfunction

	//无影斩
	public function wuyingzhan takes nothing returns nothing
		local location targetLoc = null
	    local unit triggerUnit = GetTriggerUnit()
	    local group targetGroup = null
	    local integer level = GetUnitAbilityLevel(triggerUnit, GetSpellAbilityId())
	    local integer playerIndex = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local real speed = 30
	    local real speedPlus = 15
	    local real offsetDistance = 150
	    local real range = 400.00
	    local real hunt = I2R(Attr_Attack[playerIndex]) + I2R(level) * 150
	    local real huntPlus = 10.00
	    local integer attrPlus = 10
	    local integer attrDuring = 3
	    local integer times = 7 + level * 3
	    local string HEffect = Effect_MirrorImageCaster
	    local string JEffect = null
	    local string animate = "attack"
	    //神秘附加
	    if( funcs_isOwnItem(triggerUnit , ITEM_mysterious_escape_wind) ) then
	        set times = times + 15
	    endif
	    //
	    set targetLoc = GetSpellTargetLoc()
	    set targetGroup = funcs_getGroupByPoint( targetLoc , range , function filterTrigger_enemy_live_disbuild)
	    call RemoveLocation(targetLoc)
	    //
	    call SetUnitVertexColorBJ( triggerUnit, 100, 100, 100, 80.00 )
	    call SetUnitAnimation( triggerUnit, "slam" )
	    call skills_shuttleForGroup( triggerUnit,targetGroup,times,hunt,huntPlus,speed,speedPlus,offsetDistance,Tag_Attack,attrPlus,attrDuring,JEffect,HEffect,animate,m1Wind_spell_MODEL_wuyingzhan, 0.00, 0.00 ,true )
	endfunction

	//无影斩·风
	public function wuyingzhanfeng takes nothing returns nothing
		local location targetLoc = null
	    local unit triggerUnit = GetTriggerUnit()
	    local group targetGroup = null
	    local integer level = GetUnitAbilityLevel(triggerUnit, GetSpellAbilityId())
	    local integer playerIndex = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local real speed = 40
	    local real speedPlus = 20
	    local real offsetDistance = 75
	    local real range = 500.00
	    local real hunt = I2R(Attr_Attack[playerIndex]) + I2R(Attr_Quick[playerIndex]) + I2R(level) * 100
	    local real huntPlus = 3
	    local integer attrPlus = 3
	    local integer attrDuring = 10
	    local integer times = level * 10
	    local string HEffect = Effect_MirrorImageCaster
	    local string JEffect = null
	    local string animate = "attack"
	    //神秘附加
	    if( funcs_isOwnItem(triggerUnit , ITEM_mysterious_escape_wind) ) then
	        set times = times + 25
	    endif
	    //
	    set targetLoc = GetSpellTargetLoc()
	    set targetGroup = funcs_getGroupByPoint( targetLoc , range , function filterTrigger_enemy_live_disbuild)
	    call RemoveLocation(targetLoc)
	    //
	    call SetUnitVertexColorBJ( triggerUnit, 100, 100, 100, 95.00 )
	    call SetUnitAnimation( triggerUnit, "slam" )
	    call skills_shuttleForGroup( triggerUnit,targetGroup,times,hunt,huntPlus,speed,speedPlus,offsetDistance,Tag_Quick,attrPlus,attrDuring,JEffect,HEffect,animate,m1Wind_spell_MODEL_wuyingzhanfeng, 0.00, 0.00, true )
	endfunction

	//疾疾剑刹
	public function jijijiansha takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer level = GetUnitAbilityLevel(u, m1Wind_spell_jijijiansha)
	    local real during = 20.00
	    if( level > 0 ) then
		    if(level == 1)then
		        call attribute_changeAttribute(Tag_Attack ,index, 50 , during)
		    elseif(level == 2)then
		        call attribute_changeAttribute(Tag_Attack ,index, 75 , during)
		        call attribute_changeAttribute(Tag_Quick ,index, 30 , during)
		    elseif(level == 3)then
		        call attribute_changeAttribute(Tag_Attack ,index, 90 , during)
		        call attribute_changeAttribute(Tag_Quick ,index, 45 , during)
		        call attribute_changeAttribute(Tag_Avoid ,index, 300 , during)
		    endif
	    endif
	endfunction

endlibrary


library m1WindUse requires m1Wind

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		if( abilityId == m1Wind_spell_yicha ) then
			call m1Wind_yicha()
			call m1Wind_jijijiansha()
		elseif( abilityId == m1Wind_spell_wuyingzhan ) then
			call m1Wind_wuyingzhan()
			call m1Wind_jijijiansha()
		elseif( abilityId == m1Wind_spell_wuyingzhanfeng ) then
			call m1Wind_wuyingzhanfeng()
			call m1Wind_jijijiansha()
		endif

	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		if( abilityId == m1Wind_spell_xunshou ) then
			call m1Wind_xunshou()
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

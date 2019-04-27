globals

    integer WIND_NORMAL_yicha = 'A019'
    integer WIND_NORMAL_xunshou = 'A01T'
    integer WIND_NORMAL_wuyingzhan = 'A0C5'
    integer WIND_NORMAL_wuyingzhanfeng = 'A04D'
    integer WIND_NORMAL_jijijiansha = 'A01U'
    integer WIND_NORMAL_fengshenjue = 'A047'

    integer WIND_NORMAL_MODEL_xunshou = 'A01F'
    integer WIND_NORMAL_MODEL_wuyingzhan = 'A084'
    integer WIND_NORMAL_MODEL_wuyingzhanfeng = 'A01X'
    integer WIND_NORMAL_MODEL_fengshenjue = 'A06S'

endglobals

library windNormal requires heroBase

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
	    call skills_leap(u,point,speed,null,hunt,range,Effect_Boold_Cut,false)
	endfunction

	//迅手
	public function xunshou takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer speed = 25
	    //学习大于等于N级增加模型特效
	    if(level == 5) then
	        call abilities_registAbility(u,WIND_NORMAL_MODEL_xunshou)
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
	        set times = times + 10
	    endif
	    //
	    set targetLoc = GetSpellTargetLoc()
	    set targetGroup = funcs_getGroupByPoint( targetLoc , range , function filterTrigger_enemy_live_disbuild)
	    call RemoveLocation(targetLoc)
	    //
	    call SetUnitVertexColorBJ( triggerUnit, 100, 100, 100, 80.00 )
	    call SetUnitAnimation( triggerUnit, "slam" )
	    call skills_shuttleForGroup( triggerUnit,targetGroup,times,hunt,huntPlus,speed,speedPlus,offsetDistance,Tag_Attack,attrPlus,attrDuring,JEffect,HEffect,animate,WIND_NORMAL_MODEL_wuyingzhan, 0.00, 0.00 ,true )
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
	        set times = times + 20
	    endif
	    //
	    set targetLoc = GetSpellTargetLoc()
	    set targetGroup = funcs_getGroupByPoint( targetLoc , range , function filterTrigger_enemy_live_disbuild)
	    call RemoveLocation(targetLoc)
	    //
	    call SetUnitVertexColorBJ( triggerUnit, 100, 100, 100, 95.00 )
	    call SetUnitAnimation( triggerUnit, "slam" )
	    call skills_shuttleForGroup( triggerUnit,targetGroup,times,hunt,huntPlus,speed,speedPlus,offsetDistance,Tag_Quick,attrPlus,attrDuring,JEffect,HEffect,animate,WIND_NORMAL_MODEL_wuyingzhanfeng, 0.00, 0.00, true )
	endfunction

	//疾疾剑刹
	public function jijijiansha takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer level = GetUnitAbilityLevel(u, WIND_NORMAL_jijijiansha)
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


library wind requires windNormal

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		//normal
		if( abilityId == WIND_NORMAL_yicha ) then
			call windNormal_yicha()
			call windNormal_jijijiansha()
		elseif( abilityId == WIND_NORMAL_wuyingzhan ) then
			call windNormal_wuyingzhan()
			call windNormal_jijijiansha()
		elseif( abilityId == WIND_NORMAL_wuyingzhanfeng ) then
			call windNormal_wuyingzhanfeng()
			call windNormal_jijijiansha()
		endif
	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		if( abilityId == WIND_NORMAL_xunshou ) then
			call windNormal_xunshou()
		endif
	endfunction

	public function init takes nothing returns nothing
		local trigger trigger_wind_spell_effect = CreateTrigger()
		local trigger trigger_wind_spell_study = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_wind_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_wind_spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_wind_spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( trigger_wind_spell_study , function action_spell_study )
	endfunction

endlibrary

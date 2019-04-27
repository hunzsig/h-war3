globals

    integer ShadowShaman_jiasuo = 'A00W'
    integer ShadowShaman_zhiliaotuteng = 'A017'
    integer ShadowShaman_gushuzhiya = 'A02I'
    integer ShadowShaman_dusheshouwei = 'A02J'
    integer ShadowShaman_emowushu = 'A02L'

endglobals

library shadowShaman requires heroBase

	//枷锁
	private function jiasuo takes nothing returns nothing
		local player whichPlayer = GetOwningPlayer(GetTriggerUnit())
		local real range = 150.00 + 50.00 * I2R(GetUnitAbilityLevel(GetTriggerUnit(),GetSpellAbilityId()))
		local location loc = GetSpellTargetLoc()
		local group g = funcs_getGroupByPoint( loc , range , function filterTrigger_enemy_live_disbuild )
		local unit u = null
		loop
            exitwhen(IsUnitGroupEmptyBJ(g) == true)
                //must do
                set u = FirstOfGroup(g)
                call GroupRemoveUnit( g , u )
                call skills_diy2unit( whichPlayer , loc, u, 'A02M', "magicleash",6.00 )
        endloop
        call GroupClear( g )
        call DestroyGroup( g )
        call RemoveLocation(loc)
	endfunction

	//治疗图腾
	private function zhiliaotuteng takes nothing returns nothing
		local player whichPlayer = GetOwningPlayer(GetTriggerUnit())
		local real during = 15.00
		local location loc = GetSpellTargetLoc()
		local unit u = funcs_createUnit(whichPlayer, 'o013' , loc , loc)
		local integer level = GetUnitAbilityLevel(GetTriggerUnit(),GetSpellAbilityId())
		local integer array skills
		set skills[1] = 'A02N'
		set skills[2] = 'A030'
		set skills[3] = 'A03M'
		set skills[4] = 'A03B'
		set skills[5] = 'A03A'
		set skills[6] = 'A03N'
		set skills[7] = 'A02P'
		set skills[8] = 'A02Q'
		set skills[9] = 'A02R'
		set skills[10] = 'A03Q'
		call abilities_registAbility(u,skills[level])
		call funcs_setUnitLife(u,during)
        call RemoveLocation(loc)
	endfunction

	//蛊术之牙
	private function gushuzhiya takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer hemophagia = 7
	    local integer violence = 200
	    set Attr_Dynamic_Hemophagia[index] = Attr_Dynamic_Hemophagia[index] + hemophagia
	    set Attr_Dynamic_Violence[index] = Attr_Dynamic_Violence[index] + violence
	    call attribute_calculateOne(index)
	endfunction

	//毒蛇守卫
	private function dusheshouwei takes nothing returns nothing
		local player whichPlayer = GetOwningPlayer(GetTriggerUnit())
		local location loc = GetSpellTargetLoc()
		local real during = 10.00
		local integer playerIndex = GetConvertedPlayerId(whichPlayer)
		local integer level = GetUnitAbilityLevel(GetTriggerUnit(),GetSpellAbilityId())
		local integer tempa = level * R2I(I2R(Attr_SkillDamage[playerIndex]) * 0.05)
		local integer temp_attack = 0
		local unit u = null
		local integer i = 0
		local integer qty = 5
		//神秘附加
	    if( funcs_isOwnItem(GetTriggerUnit() , ITEM_mysterious_bone_staff) ) then
	        set qty = qty +15
	    endif
		loop
			exitwhen i>=qty
				set u = funcs_createUnit(whichPlayer, 'o014' , loc , loc)
				call funcs_setUnitLife(u,during)
				set temp_attack = tempa
	            call SetUnitAbilityLevel(  u,Ability_attack_10000, (temp_attack/10000)+1 )
	            set temp_attack = temp_attack - (temp_attack/10000)*10000
	            call SetUnitAbilityLevel(  u,Ability_attack_1000, (temp_attack/1000)+1 )
	            set temp_attack = temp_attack - (temp_attack/1000)*1000
	            call SetUnitAbilityLevel(  u,Ability_attack_100, (temp_attack/100)+1 )
	            set temp_attack = temp_attack - (temp_attack/100)*100
	            call SetUnitAbilityLevel(  u,Ability_attack_10, (temp_attack/10)+1 )
	            set temp_attack = temp_attack - (temp_attack/10)*10
	            call SetUnitAbilityLevel(  u,Ability_attack_1, temp_attack+1 )
			set i = i+1
		endloop
        call RemoveLocation(loc)
	endfunction

	//恶魔巫术
	private function emowushu takes nothing returns nothing
		local player whichPlayer = GetOwningPlayer(GetTriggerUnit())
		local real range = 1000.00
		local integer level = GetUnitAbilityLevel(GetTriggerUnit(),GetSpellAbilityId())
		local location loc = GetUnitLoc(GetTriggerUnit())
		local group g = funcs_getGroupByPoint( loc , range , function filterTrigger_ally_live_hero )
		local unit u = null
		local integer index = 0
		local real during = 10.00
		//神秘附加
	    if( funcs_isOwnItem(GetTriggerUnit() , ITEM_mysterious_bone_staff) ) then
	        set during = during +15
	    endif
		loop
            exitwhen(IsUnitGroupEmptyBJ(g) == true)
                //must do
                set u = FirstOfGroup(g)
                call GroupRemoveUnit( g , u )
                call funcs_effectUnit( Effect_CrazyFireMonster , u , "origin")
                call funcs_effectUnitLoc( Effect_BlackExplosion , u)
                set index = GetConvertedPlayerId(GetOwningPlayer(u))
                call attribute_changeAttribute(Tag_Hemophagia, index , level * 50 , during )
                call attribute_changeAttribute(Tag_Attack, index , level * 350 , during )
                call attribute_changeAttribute(Tag_AttackSpeed, index , level * 50 , during )
                call attribute_changeAttribute(Tag_Defend, index , level * -15 , during )
                call attribute_changeAttribute(Tag_LifeBack, index , level * -30 , during )
        endloop
        call GroupClear( g )
        call DestroyGroup( g )
        call RemoveLocation(loc)
	endfunction

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		if( abilityId == ShadowShaman_jiasuo ) then
			call jiasuo()
		elseif( abilityId == ShadowShaman_zhiliaotuteng ) then
			call zhiliaotuteng()
		elseif( abilityId == ShadowShaman_dusheshouwei ) then
			call dusheshouwei()
		elseif( abilityId == ShadowShaman_emowushu ) then
			call emowushu()
		endif
	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		if( abilityId == ShadowShaman_gushuzhiya ) then
			call gushuzhiya()
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

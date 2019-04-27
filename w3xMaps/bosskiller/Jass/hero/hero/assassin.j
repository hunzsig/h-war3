globals

    integer ASSASSIN_NORMAL_fenshen = 'A09G'
    integer ASSASSIN_NORMAL_shanshuo = 'A09F'
    integer ASSASSIN_NORMAL_qiangliegongji = 'A09H'
    integer ASSASSIN_NORMAL_shunshaxiulian = 'A09M'
    integer ASSASSIN_NORMAL_yiji = 'A09N'

    integer ASSASSIN_NORMAL_MODEL_shunshaxiulian  = 'A063'
    integer ASSASSIN_NORMAL_fenshen_faker = 'u00F'

endglobals

library assassinNormal requires heroBase

	//分身
	public function fenshen takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local player whichPlayer = GetOwningPlayer(u)
	    local integer index = GetConvertedPlayerId(whichPlayer)
	    local integer qty = level * 3
	    local real during = 8.00
	    local location loc = GetUnitLoc( u )
	    local location loc2 = null
	    local unit shadow = null
	    local integer i = 1
	    loop
	        exitwhen i > qty
	            set loc2 = PolarProjectionBJ(loc, 175.00, 360.00 / I2R(qty) * I2R(i))
	            set shadow = funcs_createUnit( whichPlayer, ASSASSIN_NORMAL_fenshen_faker , loc2 , loc )
	            call SetUnitVertexColorBJ( shadow, 100, 100, 100, 80.00 )
	            call funcs_delUnit( shadow , during )
	            call RemoveLocation( loc2 )
	        set i = i + 1
	    endloop
	    call RemoveLocation( loc )
	endfunction

	//闪烁
	public function shanshuo takes nothing returns nothing
	endfunction

	//强烈攻击
	public function qiangliegongji takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer addAttack = 35
	    local integer addKnocking = 100
	    //local integer addAvoid = 25
	    set Attr_Dynamic_Attack[index] = Attr_Dynamic_Attack[index] + addAttack
	    set Attr_Dynamic_Knocking[index] = Attr_Dynamic_Knocking[index] + addKnocking
	    //set Attr_Dynamic_Avoid[index] = Attr_Dynamic_Avoid[index] + addAvoid
	    call attribute_calculateOne(index)
	endfunction

	//瞬杀修炼
	public function shunshaxiulian takes nothing returns nothing
 		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer addKnocking = 900
	    local real addAttackSpeed = 23.00
	    //学习大于等于1级增加模型特效
	    if(level == 1) then
	        call abilities_registAbility(u,ASSASSIN_NORMAL_MODEL_shunshaxiulian)
	    endif
	    set Attr_Dynamic_Knocking[index] = Attr_Dynamic_Knocking[index] + addKnocking
	    set Attr_Dynamic_AttackSpeed[index] = Attr_Dynamic_AttackSpeed[index] + addAttackSpeed
	    call attribute_calculateOne(index)
	endfunction

	//一击
	public function yiji takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local unit targetUnit = GetSpellTargetUnit()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real hunt = I2R(level * Attr_Attack[index] * 10)
	    local location loc = GetUnitLoc( targetUnit )
	    if( GetUnitLifePercent(targetUnit) < 5.00 ) then
	        call ExplodeUnitBJ( targetUnit )
	        call RemoveUnit( targetUnit )
	    else
	         //神秘附加
	        if( funcs_isOwnItem(u , ITEM_mysterious_compassion_blade) ) then
	            set hunt = hunt * 2
	        endif
	        call eventRegist_registerBeAttack( u , targetUnit )
	        call funcs_huntByToken_BreakDefend_NotAvoid( hunt , u , targetUnit )
	    endif
	    call funcs_effectPoint( Effect_ShadowAssault ,loc )
	    call funcs_effectPoint( Effect_OrbOfCorruption ,loc )
	    call RemoveLocation( loc )
	endfunction



	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		if( abilityId == ASSASSIN_NORMAL_fenshen ) then
			call fenshen()
		elseif( abilityId == ASSASSIN_NORMAL_shanshuo ) then
			call shanshuo()
		elseif( abilityId == ASSASSIN_NORMAL_yiji ) then
			call yiji()
		endif
	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		if( abilityId == ASSASSIN_NORMAL_qiangliegongji ) then
			call qiangliegongji()
		elseif( abilityId == ASSASSIN_NORMAL_shunshaxiulian ) then
			call shunshaxiulian()
		endif
	endfunction

	public function init takes nothing returns nothing
		local trigger trigger_assassin_spell_effect = CreateTrigger()
		local trigger trigger_assassin_spell_study = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_assassin_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_assassin_spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_assassin_spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( trigger_assassin_spell_study , function action_spell_study )
	endfunction

endlibrary

library assassin requires assassinNormal

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		if( abilityId == ASSASSIN_NORMAL_fenshen ) then
			call assassinNormal_fenshen()
		elseif( abilityId == ASSASSIN_NORMAL_shanshuo ) then
			call assassinNormal_shanshuo()
		elseif( abilityId == ASSASSIN_NORMAL_yiji ) then
			call assassinNormal_yiji()
		endif
	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		if( abilityId == ASSASSIN_NORMAL_qiangliegongji ) then
			call assassinNormal_qiangliegongji()
		elseif( abilityId == ASSASSIN_NORMAL_shunshaxiulian ) then
			call assassinNormal_shunshaxiulian()
		endif
	endfunction

	public function init takes nothing returns nothing
		local trigger trigger_assassin_spell_effect = CreateTrigger()
		local trigger trigger_assassin_spell_study = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_assassin_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_assassin_spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_assassin_spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( trigger_assassin_spell_study , function action_spell_study )
	endfunction

endlibrary

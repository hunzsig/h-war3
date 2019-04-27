globals

    integer DIXUEJIACHONG_chuanci = 'A032'
    integer DIXUEJIACHONG_zuandi = 'A082'
    integer DIXUEJIACHONG_fushichongye = 'A096'
    integer DIXUEJIACHONG_tuike = 'A098'

	boolean DIXUEJIACHONG_fushichongye_opening = false
    boolean array DIXUEJIACHONG_fushichongye_status

endglobals

library ground requires heroBase

	//穿刺
	private function chuanci takes nothing returns nothing

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

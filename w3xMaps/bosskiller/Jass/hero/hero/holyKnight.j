library holyKnight requires heroBase

	globals

	    private integer ab_jianshou = 'A03K'
	    private integer ab_wushizhijun = 'A03L'
	    private integer ab_pengzhuang = 'A03Z'
	    private integer ab_bucuizhibi = 'A03Y'
	    private integer ab_yingxiongwangdehuashen = 'A04F'
	    private integer has2not = 'A04B'
	    private integer not2has = 'A04A'

	endglobals

 	private function jianshou takes nothing returns nothing
 		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer speed = 10
	    local integer life = 1000
	    local integer punish = 1500
	    set Attr_Dynamic_Defend[index] = Attr_Dynamic_Defend[index] + speed
	    set Attr_Dynamic_Life[index] = Attr_Dynamic_Life[index] + life
	    set Attr_Dynamic_PunishFull[index] = Attr_Dynamic_PunishFull[index] + punish
	    call attribute_calculateOne(index)
 	endfunction
 	private function wudizhijun takes nothing returns nothing
 		local unit u = GetTriggerUnit()
 		local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
 		local real during = 5.00 * I2R(level) 
 		local integer lifeback = 20
 		local group g = funcs_getGroupByUnit(u,600.00,function filterTrigger_ally_live_hero)
 		local integer index = 0
 		if(GetUnitTypeId(u)=='E006')then
 			set during = during + 5.00
 		endif
 		loop
            exitwhen(IsUnitGroupEmptyBJ(g) == true)
                //must do
                set u = FirstOfGroup(g)
                call GroupRemoveUnit( g , u )
                call funcs_effectUnitLoc( Effect_ReviveHuman , u)
                set index = GetConvertedPlayerId(GetOwningPlayer(u))
                call skills_invulnerable(Player_heros[index],during)
                call attribute_changeAttribute(Tag_LifeBack,index,lifeback,during)
                call funcs_effectUnitLoc(Effect_LightStrikeArray,u)
        endloop
 		call GroupClear(g)
 		call DestroyGroup(g)
 		set g = null
 	endfunction
 	private function pengzhuang takes nothing returns nothing
 		local unit u = GetTriggerUnit()
 		local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
 		local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
 		local real damage = Attr_Attack[index] + Attr_Defend[index] + level * 100
 		local location loc1 = GetUnitLoc(u)
 		local location loc2 = GetSpellTargetLoc()
 		local real distance = DistanceBetweenPoints(loc1,loc2)
 		local real facing = AngleBetweenPoints(loc1,loc2)
 		local real speed = 10
 		local real range = 100
 		call RemoveLocation(loc1)
 		call RemoveLocation(loc2)
 		set loc1 = null
 		set loc2 = null
 		call PauseUnit( u , true )
 		if(GetUnitTypeId(u)=='E006')then
 			call SetUnitAnimationByIndex(u , 8 )
 			set damage = damage + Attr_Power[index]
 		else
 			call SetUnitAnimationByIndex(u , 12 )
 		endif
 		call skills_charge(u,facing,distance,speed,SKILL_CHARGE_CRASH,null,damage,range,null,false)
 	endfunction
 	private function bucuizhibi takes nothing returns nothing
 		local unit u = GetTriggerUnit()
 		local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
 		local real during = 10.00 + I2R(level) * 1.50
 		local integer defend = level * 20
 		local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
 		if(GetUnitTypeId(u)=='E006')then
 			call attribute_changeAttribute(Tag_Defend,index,defend,during)
 		endif
 	endfunction
	private function yingxiongwangdehuashen takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local location point = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer attack = Attr_Attack[index]
	    local integer attackSpeed = 50
	    local real during = 60+I2R(index)*10
	    //神秘附加
	    if( funcs_isOwnItem(u , ITEM_mysterious_kennedy_shield) ) then
	        set attack = attack * 2
	        set attackSpeed = attackSpeed * 2
	    endif
	    //模型变化
	    call skills_shapeshift(u, during, has2not , not2has, Effect_LightStrikeArray)
	    call attribute_changeAttribute( Tag_Attack ,index, attack , during )
	    call attribute_changeAttribute( Tag_AttackSpeed ,index, attackSpeed , during )
	    //debug
	    call PolledWait(0.10) //模型变化需要一点时间，所以这里加延时,在对单位进行属性计算
	    call attribute_calculateOne(index)
 	endfunction

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		if( abilityId == ab_wushizhijun ) then
			call wudizhijun()
		elseif( abilityId == ab_pengzhuang ) then
			call pengzhuang()
		elseif( abilityId == ab_bucuizhibi ) then
			call bucuizhibi()
		elseif( abilityId == ab_yingxiongwangdehuashen ) then
			call yingxiongwangdehuashen()
		endif
	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		if( abilityId == ab_jianshou ) then
			call jianshou()
		endif
	endfunction

	public function init takes nothing returns nothing
		local trigger spell_effect = CreateTrigger()
		local trigger spell_study = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( spell_study , function action_spell_study )
	endfunction

endlibrary

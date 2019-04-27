globals

    integer m1DruidFarre_spell_zhiliaobo = 'A09A'
    integer m1DruidFarre_spell_shenshengpili = 'A09B'
    integer m1DruidFarre_spell_chengfeng = 'A0B1'
    integer m1DruidFarre_spell_zhihuizhili = 'A09C'
    integer m1DruidFarre_spell_huigui = 'A0B4'

	integer m1DruidFarre_spell_shenshengpili_arrow = 'u00S'
    integer m1DruidFarre_spell_MODEL_zhihuizhili = 'A028'

endglobals

library m1DruidFarre requires m1Hero

	//治疗波
	public function zhiliaobo takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local unit targetUnit = GetSpellTargetUnit()
		local integer level = GetUnitAbilityLevel( u , GetSpellAbilityId() )
		local integer index = GetConvertedPlayerId(GetOwningPlayer(targetUnit))
		local integer lifeBack = level * 10
		local real during = 5.00
		call attribute_changeAttribute( Tag_LifeBack ,index, lifeBack , during )
	endfunction

	//神圣霹雳
	public function shenshengpili takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real hunt = Attr_SkillDamage[index] + level * 500
	    local location targetLoc = GetSpellTargetLoc()
		local location loc = null
		local integer i = 0
		local unit createUnit = null
	    call funcs_effectPoint( Effect_red_shatter ,targetLoc )
	    call funcs_huntBySelf( hunt , u , GetSpellTargetUnit() )
	    //神秘附加
	    if( funcs_isOwnItem(u , ITEM_mysterious_god_tree) ) then
	        set hunt = hunt + Attr_SkillDamage[index] * 0.5
	    endif
		set i = 1
		loop
			exitwhen i > 7
				set loc =PolarProjectionBJ( targetLoc , 75*i , GetRandomReal(0.00,360.00) )
				set createUnit = funcs_createUnit( GetOwningPlayer(u) , m1DruidFarre_spell_shenshengpili_arrow , loc , loc )
				call attribute_copyAttrForShadow( index , createUnit , 0 , 1.00 , 0.00 , 0.00 )
				call funcs_delUnit( createUnit , 12.00 )
				call RemoveLocation(loc)
			set i = i +1
		endloop
		call RemoveLocation( targetLoc )
	endfunction

	//乘风 - 回调
	private function chengfengCall takes nothing returns nothing
	    local timer t = GetExpiredTimer()
	    local unit triggerUnit =  funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local location targetLoc =  funcs_getTimerParams_Loc( t , Key_Skill_Loc )
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer skillLv = GetUnitAbilityLevel( triggerUnit , m1DruidFarre_spell_chengfeng )
	    call funcs_delTimer(t,null)
	    call funcs_effectPoint( Effect_CrushingWhiteRing , targetLoc )
	    call SetUnitPositionLoc( triggerUnit , targetLoc )
	    call PanCameraToTimedLocForPlayer( GetOwningPlayer(triggerUnit), targetLoc , 0.00 )
	    call SelectUnitForPlayerSingle( triggerUnit , GetOwningPlayer(triggerUnit) )
	    call RemoveLocation( targetLoc )
	    call attribute_changeAttribute(Tag_SkillDamage, index , Attr_SkillDamage[index] * skillLv / 10 , 11.00 )
	endfunction

	//乘风
	public function chengfeng takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
	    local location loc = GetUnitLoc(triggerUnit)
	    local location targetLoc = GetSpellTargetLoc()
	    local timer t = null
	    set t = funcs_setTimeout( 1.50 , function chengfengCall )
	    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , triggerUnit )
	    call funcs_setTimerParams_Loc( t , Key_Skill_Loc , targetLoc )
	    call RemoveLocation( loc )
	endfunction

	//智慧之力
	public function zhihuizhili takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer skill = 55
	    local real lifeBack = 15.00
	    //学习大于等于1级增加模型特效
	    if(level == 1) then
	        call abilities_registAbility(u,m1DruidFarre_spell_MODEL_zhihuizhili)
	    endif
	    set Attr_Dynamic_Skill[index] = Attr_Dynamic_Skill[index] + skill
	    set Attr_Dynamic_LifeBack[index] = Attr_Dynamic_LifeBack[index] + lifeBack
	    call attribute_calculateOne(index)
	endfunction

	//回归
	public function huigui takes nothing returns nothing
		local unit targetUnit = GetSpellTargetUnit()
	    local location loc = GetUnitLoc(targetUnit)
	    call UnitResetCooldown( targetUnit )
	    call funcs_effectPoint( Effect_SuperShinythingy , loc )
	    call RemoveLocation( loc )
	endfunction

endlibrary


library m1DruidFarreUse requires m1DruidFarre

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		//m1
		if( abilityId == m1DruidFarre_spell_zhiliaobo ) then
			call m1DruidFarre_zhiliaobo()
		elseif( abilityId == m1DruidFarre_spell_shenshengpili ) then
			call m1DruidFarre_shenshengpili()
		elseif( abilityId == m1DruidFarre_spell_chengfeng ) then
			call m1DruidFarre_chengfeng()
		elseif( abilityId == m1DruidFarre_spell_huigui ) then
			call m1DruidFarre_huigui()
		endif

	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		if( abilityId == m1DruidFarre_spell_zhihuizhili ) then
			call m1DruidFarre_zhihuizhili()
		endif
	endfunction

	public function init takes nothing returns nothing
		local trigger m1Windspell_effect = CreateTrigger()
		local trigger m1Windspell_study = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( m1Windspell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( m1Windspell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( m1Windspell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( m1Windspell_study , function action_spell_study )
	endfunction

endlibrary

globals

    integer m1DeathKnight_spell_yuanqizhan = 'A07D'
    integer m1DeathKnight_spell_jiushu = 'A086'
    integer m1DeathKnight_spell_fankangmingyun = 'A08N'
    integer m1DeathKnight_spell_huiguangfanzhao = 'A08O'
    integer m1DeathKnight_spell_duoluo = 'A08P'

    boolean array m1DeathKnight_spell_ghost_soul_status		//怨气状态
    real array m1DeathKnight_spell_ghost_soul_limit         	//怨气限制
    real array m1DeathKnight_spell_ghost_soul           		//怨气
    texttag array m1DeathKnight_spell_ghost_soul_texttag		//怨气浮动数值条

    integer m1DeathKnight_spell_yuanqizhan_arrow = 'o00K'
    integer m1DeathKnight_spell_model_fankangmingyun = 'A00R'

endglobals


library m1DeathKnight requires m1Hero

	//设定怨气值
	public function setGhostSoul takes integer index , real val ,real limit returns nothing
		local string ttgStr = ""
		local real percent = 0
		local integer block = 0
		local integer blockMax = 25
		local real textSize = 5.00
		local real textZOffset = TEXTTAG_HEIGHT_Lv2
		local real textOpacity = 0.10
		local real textXOffset = -(textSize*blockMax*0.5)
		local string font = "■"
		local integer i = 0
		if( m1DeathKnight_spell_ghost_soul_status[index] == true ) then
			set m1DeathKnight_spell_ghost_soul[index] = val
			set m1DeathKnight_spell_ghost_soul_limit[index] = limit
			//计算字符串
			set percent = val * 100 / limit
			set block = R2I(percent / I2R(100/blockMax))
			if( val >= limit ) then
                set block = blockMax
            endif
			set i = 1
			loop
				exitwhen i > blockMax
					if( i <= block ) then
						set ttgStr = ttgStr + "|cffb162dd"+font+"|r"
					else
						set ttgStr = ttgStr + "|cff000000"+font+"|r"
					endif
				set i = i + 1
			endloop
			if( m1DeathKnight_spell_ghost_soul_texttag[index] == null ) then
				set m1DeathKnight_spell_ghost_soul_texttag[index] = funcs_floatMsgWithSizeAutoBind( ttgStr , Player_heros[index] , textSize , textZOffset , textOpacity , textXOffset )
			else
				call SetTextTagTextBJ( m1DeathKnight_spell_ghost_soul_texttag[index] , ttgStr , textSize )
			endif
		endif
	endfunction

	//怨气斩
	public function yuanqizhan takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
		local location loc = GetUnitLoc( triggerUnit )
		local location targetLoc = GetSpellTargetLoc()
		local player whichPlayer = GetOwningPlayer(triggerUnit)
		local integer index = GetConvertedPlayerId(whichPlayer)
	    local integer level = GetUnitAbilityLevel( triggerUnit , GetSpellAbilityId() )
	    local real facing = AngleBetweenPoints( loc , targetLoc )
	    local real speed = 5
	    local real hunt = 0
	    local real range = 800
	    local unit createUnit = null
	    local location locStart = null
   		local location locEnd = null
   		local real unitLife = range / (speed*45)
   		local string moveEffect = null

		if( m1DeathKnight_spell_ghost_soul_status[index] == true ) then
			//扣除使用了的怨气
			set hunt = I2R(Attr_Attack[index]) + I2R(level) * 75 + m1DeathKnight_spell_ghost_soul[index] * 0.1
			call setGhostSoul( index , m1DeathKnight_spell_ghost_soul[index] * 0.90 , m1DeathKnight_spell_ghost_soul_limit[index] )
			set moveEffect = Effect_NewSoulArmor
		else
			set hunt = I2R(Attr_Attack[index]) + I2R(level) * 75
			set moveEffect = null
		endif


		//斩击
		set locStart = PolarProjectionBJ( loc , 25 , facing )
        set locEnd = PolarProjectionBJ( loc , 25 + range , facing )
		set createUnit = funcs_createUnit(whichPlayer, m1DeathKnight_spell_yuanqizhan_arrow , locStart , locEnd )
		call funcs_setUnitLife( createUnit , unitLife )
		call skills_forward( createUnit ,triggerUnit, locEnd , speed ,moveEffect, hunt, 75 , Effect_UndeadDissipate , false , unitLife )
    	call RemoveLocation( loc )
    	call RemoveLocation( targetLoc )

	endfunction

	//救赎 - 学习
	public function jiushu_study takes nothing returns nothing
		local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
		local integer uLevel = GetUnitLevel(GetTriggerUnit())
		set m1DeathKnight_spell_ghost_soul_status[index] = true
		call setGhostSoul( index , m1DeathKnight_spell_ghost_soul[index] , I2R( uLevel * 100 ) )
	endfunction

	//救赎 - 施法
	public function jiushu_effect takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
		local location loc = GetUnitLoc( triggerUnit )
		local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer level = GetUnitAbilityLevel( triggerUnit , GetSpellAbilityId() )
	    local real range = 350.00
	    local real hunt = m1DeathKnight_spell_ghost_soul[index]
	    local group g = null
	    //扣除使用了的怨气
	    call setGhostSoul( index , 0 , m1DeathKnight_spell_ghost_soul_limit[index] )
		//范围伤害
		call funcs_effectPoint( Effect_DarkLightningNova , loc )
		set g = funcs_getGroupByPoint( loc, range , function filterTrigger_enemy_live_disbuild )
		call funcs_huntGroup( g , triggerUnit , hunt , Effect_ShadowAssault , null , FILTER_ENEMY )
		call GroupClear( g )
		call DestroyGroup( g )
		call RemoveLocation( loc )
	endfunction

	//救赎 - 英雄升级
	public function jiushu_lv_up takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
		local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer uLevel = GetUnitLevel(triggerUnit)
		if( m1DeathKnight_spell_ghost_soul_status[index] == true ) then
			call setGhostSoul( index , m1DeathKnight_spell_ghost_soul[index] , I2R( uLevel * 100 ) )
		endif
	endfunction

	//反抗命运 - 学习
	public function fankangmingyun_study takes nothing returns nothing
		//todo see damaged.j
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer attackSpeedPlus = 7
	    local integer hemophagiaPlus = 10
	    local real lifeBack = -10.00
	    //学习大于等于1级增加模型特效
	    if(level == 1) then
	        call abilities_registAbility(GetTriggerUnit() , m1DeathKnight_spell_model_fankangmingyun )
	    endif
	    set Attr_Dynamic_AttackSpeed[index] = Attr_Dynamic_AttackSpeed[index] + attackSpeedPlus
	    set Attr_Dynamic_Hemophagia[index] = Attr_Dynamic_Hemophagia[index] + hemophagiaPlus
	    set Attr_Dynamic_LifeBack[index] = Attr_Dynamic_LifeBack[index] + lifeBack
	    call attribute_calculateOne(index)
	endfunction

	//回光返照
	public function huiguangfanzhao takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
		local location loc = GetUnitLoc( triggerUnit )
		local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer level = GetUnitAbilityLevel( triggerUnit , GetSpellAbilityId() )
	    local real range = 250.00
	    local real hunt = I2R(level)*300 + m1DeathKnight_spell_ghost_soul[index]*0.50
	    local integer powerPlus = level * 100
	    local group g = null
	    //扣除使用了的怨气
	    call setGhostSoul( index , m1DeathKnight_spell_ghost_soul[index] * 0.50 , m1DeathKnight_spell_ghost_soul_limit[index] )
		//范围伤害
		set g = funcs_getGroupByPoint( loc, range , function filterTrigger_enemy_live_disbuild )
		call funcs_huntGroup( g , triggerUnit , hunt , Effect_Dispersion , null , FILTER_ENEMY )
		call GroupClear( g )
		call DestroyGroup( g )
		call RemoveLocation( loc )
		//回光
		call SetUnitLifeBJ( triggerUnit , GetUnitState(triggerUnit, UNIT_STATE_MAX_LIFE) )
		call SetUnitManaBJ( triggerUnit , GetUnitState(triggerUnit, UNIT_STATE_MAX_MANA) )
		//增强体质
		call attribute_changeAttribute(Tag_Power ,index, powerPlus , 18.00 )
	endfunction

	//堕落
	public function duoluo takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
		local unit targetUnit = GetSpellTargetUnit()
		local location loc = GetUnitLoc( targetUnit )
		local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer level = GetUnitAbilityLevel( triggerUnit , GetSpellAbilityId() )
		local real reduceLife = GetUnitState(targetUnit, UNIT_STATE_LIFE)*0.9
		local real val = I2R(level) * reduceLife * 0.45
		local real valPlus = 1.00
		//设定怨气加成
		if( GetUnitLifePercent(targetUnit) < 0.50 ) then
			set valPlus = valPlus + 0.50
		endif
		if( GetOwningPlayer(triggerUnit) != GetOwningPlayer(targetUnit) ) then
			set valPlus = valPlus + 1.50
		endif
		set val = val * valPlus
		//增加怨气
		if( m1DeathKnight_spell_ghost_soul[index] + val > m1DeathKnight_spell_ghost_soul_limit[index] ) then
			call setGhostSoul( index , m1DeathKnight_spell_ghost_soul_limit[index] , m1DeathKnight_spell_ghost_soul_limit[index] )
		else
			call setGhostSoul( index , m1DeathKnight_spell_ghost_soul[index] + val , m1DeathKnight_spell_ghost_soul_limit[index] )
		endif
		//扣血
		call SetUnitLifeBJ( targetUnit , GetUnitState(targetUnit, UNIT_STATE_LIFE)-reduceLife )
		//特效
		call funcs_effectPoint( Effect_ShadowAssault , loc )
		call funcs_effectPoint( Effect_NewSoulArmor , loc )
		call RemoveLocation( loc )
	endfunction

endlibrary


library m1DeathKnightUse requires m1DeathKnight

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		//m1
		if( abilityId == m1DeathKnight_spell_yuanqizhan ) then
			call m1DeathKnight_yuanqizhan()
		elseif( abilityId == m1DeathKnight_spell_jiushu ) then
			call m1DeathKnight_jiushu_effect()
		elseif( abilityId == m1DeathKnight_spell_huiguangfanzhao ) then
			call m1DeathKnight_huiguangfanzhao()
		elseif( abilityId == m1DeathKnight_spell_duoluo ) then
			call m1DeathKnight_duoluo()
		endif
	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		//m1
		if( abilityId == m1DeathKnight_spell_jiushu ) then
			call m1DeathKnight_jiushu_study()
		elseif( abilityId == m1DeathKnight_spell_fankangmingyun ) then
			call m1DeathKnight_fankangmingyun_study()
		endif
	endfunction

	//Action - 英雄升级
	private function action_hero_level_up takes nothing returns nothing
		call m1DeathKnight_jiushu_lv_up()
	endfunction

	public function init takes nothing returns nothing
		local trigger trigger_spell_effect = CreateTrigger()
		local trigger trigger_spell_study = CreateTrigger()
		local trigger trigger_hero_level_up = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( trigger_spell_study , function action_spell_study )
	    //英雄升级
	    call TriggerRegisterAnyUnitEventBJ( trigger_hero_level_up, EVENT_PLAYER_HERO_LEVEL )
	    call TriggerAddAction( trigger_hero_level_up , function action_hero_level_up )
	endfunction

endlibrary

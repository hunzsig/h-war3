globals

    integer THUNDERBOLT_NORMAL_dianguanghuoshi = 'A08R'
    integer THUNDERBOLT_NORMAL_jingxiapili = 'A059'
    integer THUNDERBOLT_NORMAL_lizichongneng = 'A08U'
    integer THUNDERBOLT_NORMAL_dianchuandao = 'A06G'
    integer THUNDERBOLT_NORMAL_leiqu = 'A049'

    integer THUNDERBOLT_NORMAL_MODEL_dianchuandao = 'A06M'

    integer THUNDERBOLT_NORMAL_leiqu_token_lv1 = 'u00T'
    integer THUNDERBOLT_NORMAL_leiqu_token_lv2 = 'u00U'
    integer THUNDERBOLT_NORMAL_leiqu_token_lv3 = 'u00V'

    texttag array THUNDERBOLT_NORMAL_charge_texttag		//充能浮动数值条

    boolean array Skill_lizichongneng_Status
    integer array Skill_lizichongneng_ChargesQty

endglobals

library thunderboltNormal requires heroBase

	//设定充能值ttg
	private function setChargeTextTag takes integer index , real val ,real limit returns nothing
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
					set ttgStr = ttgStr + "|cff80ffff"+font+"|r"
				else
					set ttgStr = ttgStr + "|cff000000"+font+"|r"
				endif
			set i = i + 1
		endloop
		if( THUNDERBOLT_NORMAL_charge_texttag[index] == null ) then
			set THUNDERBOLT_NORMAL_charge_texttag[index] = funcs_floatMsgWithSizeAutoBind( ttgStr , Player_heros[index] , textSize , textZOffset , textOpacity , textXOffset )
		else
			call SetTextTagTextBJ( THUNDERBOLT_NORMAL_charge_texttag[index] , ttgStr , textSize )
		endif
	endfunction

	//充能
	public function charge takes unit triggerUnit returns nothing
        local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
        local integer skillLv = GetUnitAbilityLevel( triggerUnit , THUNDERBOLT_NORMAL_lizichongneng )
        local real during = 7.00
        local real damage = I2R(Attr_Attack[index]) + I2R(skillLv) * 200
        local real range = 150 + 25.00 * I2R(skillLv)
        local integer chargeMax = 5
        local integer attackSpeedDuringPlus = 6
        local integer moveDuringPlus = 15
        local group g = null
        local location loc = null
        if( triggerUnit !=null and IsUnitDeadBJ(triggerUnit) == false and GetUnitAbilityLevel(triggerUnit,THUNDERBOLT_NORMAL_lizichongneng) > 0 ) then
            //神秘附加
            if( funcs_isOwnItem( triggerUnit , ITEM_mysterious_lighting ) ) then
                set during = during * 2
            endif
            set loc = GetUnitLoc( triggerUnit )
            set Skill_lizichongneng_ChargesQty[index] = Skill_lizichongneng_ChargesQty[index] + 1
            if( Skill_lizichongneng_ChargesQty[index] >= chargeMax ) then
                call funcs_effectPoint( Effect_IceNova ,  loc )
                set g = funcs_getGroupByPoint(  loc , range , function filter_live_disbuild )
                call funcs_huntGroup( g, triggerUnit , damage, Effect_LightningsLong , null , FILTER_ENEMY )
                set Skill_lizichongneng_ChargesQty[index] = 0
            else
                call attribute_changeAttribute(Tag_AttackSpeed ,index, attackSpeedDuringPlus , during )
                call attribute_changeAttribute(Tag_Move ,index, moveDuringPlus , during )
            endif
            call setChargeTextTag( index , I2R(Skill_lizichongneng_ChargesQty[index]) , I2R(chargeMax) )
            call RemoveLocation( loc )
        endif
    endfunction

    //充能
	public function chargeTimer takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit triggerUnit = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
		call charge(triggerUnit)
	endfunction

	//电光火石
	public function dianguanghuoshi takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local location point = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real speed = 70
	    local real hunt = I2R(Attr_Attack[index]) + I2R(level) * 55
	    local integer attackSpeed = level * 10
	    local real attackSpeedDuring = 3.0
	    local real range = 75
	    call SetUnitVertexColorBJ( u, 100, 100, 100, 95.00 )
	    call attribute_changeAttribute( Tag_AttackSpeed ,index, attackSpeed , attackSpeedDuring )
	    call skills_leap(u,point,speed,Effect_LightningSphere_FX,hunt,range,Effect_MonsoonBoltTarget,false)
	endfunction

	//惊吓霹雳
	public function jingxiapili takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local unit targetUnit = GetSpellTargetUnit()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real hunt = I2R(Attr_Attack[index]) + I2R(level) *500
	    local location targetLoc = GetUnitLoc( targetUnit )
	    //僵直3秒
	    call skills_punish( targetUnit  , 3.00 , 0 )
	    call funcs_huntBySelf( hunt , u , targetUnit )
	    call funcs_effectPoint( Effect_ThunderClapCaster , targetLoc )
	    call funcs_floatMsgWithSize( "|cff80ffff 吓！|r", targetUnit , 16.00 )
	    call RemoveLocation(targetLoc)
	endfunction

	//离子充能 - 学习
	public function lizichongneng_study takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
		local integer index = GetConvertedPlayerId(GetOwningPlayer( triggerUnit ))
		local timer t = null

	    if(Skill_lizichongneng_Status[index] == false) then
		    set Skill_lizichongneng_Status[index] = true
	        set Skill_lizichongneng_ChargesQty[index] = 0
	        set t = funcs_setInterval( 1.00 , function chargeTimer )
	        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , triggerUnit )
	    endif
	    //增加魔法
	    set Attr_Dynamic_Mana[index] = Attr_Dynamic_Mana[index] + 200
	    set Attr_Dynamic_ManaBack[index] = Attr_Dynamic_ManaBack[index] + 7
	    call attribute_calculateOne(index)
	endfunction

	//电传导
	public function dianchuandao takes nothing returns nothing
		local location targetLoc = null
	    local unit triggerUnit = GetTriggerUnit()
	    local group targetGroup = null
	    local integer level = GetUnitAbilityLevel(triggerUnit, GetSpellAbilityId())
	    local integer playerIndex = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local real speed = 50
	    local real speedPlus = 5
	    local real offsetDistance = 50
	    local real range = 450.00
	    local real hunt = I2R(Attr_Attack[playerIndex]) * I2R(level) * 0.5
	    local real huntPlus = 0
	    local integer attrPlus = 0
	    local integer attrDuring = 0
	    local integer times = level * 30
	    local string HEffect = Effect_ThunderClapCaster
	    local string JEffect = Effect_LightningSphere_FX
	    local string animate = "attack"

	    //
	    set targetLoc = GetSpellTargetLoc()
	    set targetGroup = funcs_getGroupByPoint( targetLoc , range , function filterTrigger_enemy_live_disbuild)
	    call RemoveLocation(targetLoc)
	    //
	    call SetUnitVertexColorBJ( triggerUnit, 100, 100, 100, 100.00 )
	    call SetUnitAnimation( triggerUnit, "attack" )
	    call skills_shuttleForGroup( triggerUnit,targetGroup,times,hunt,huntPlus,speed,speedPlus,offsetDistance,0,attrPlus,attrDuring,JEffect,HEffect,animate,THUNDERBOLT_NORMAL_MODEL_dianchuandao, 0.00, 0.00, false )
	endfunction

	//雷区
	public function leiqu takes unit triggerUnit returns nothing
		local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
        local integer skillLv = GetUnitAbilityLevel( triggerUnit , THUNDERBOLT_NORMAL_leiqu )
        local real during = 5.00
        local location loc = null
        local unit createUnit = null
        local integer unitType = 0
        if( skillLv <=0 ) then
	        return
        endif
        if( skillLv == 1 ) then
	        set unitType = THUNDERBOLT_NORMAL_leiqu_token_lv1
	    elseif( skillLv == 2 ) then
	        set unitType = THUNDERBOLT_NORMAL_leiqu_token_lv2
        elseif( skillLv == 3 ) then
	        set unitType = THUNDERBOLT_NORMAL_leiqu_token_lv3
        endif
        set loc = GetUnitLoc(triggerUnit)
        set createUnit = funcs_createUnit( GetOwningPlayer(triggerUnit) , unitType , loc , loc )
        call funcs_delUnit( createUnit , during )
        call RemoveLocation(loc)
	endfunction

endlibrary


library thunderbolt requires thunderboltNormal

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		//normal
		if( abilityId == THUNDERBOLT_NORMAL_dianguanghuoshi ) then
			call thunderboltNormal_dianguanghuoshi()
			call thunderboltNormal_charge(GetTriggerUnit())
			call thunderboltNormal_leiqu(GetTriggerUnit())
		elseif( abilityId == THUNDERBOLT_NORMAL_jingxiapili ) then
			call thunderboltNormal_jingxiapili()
			call thunderboltNormal_charge(GetTriggerUnit())
			call thunderboltNormal_leiqu(GetTriggerUnit())
		elseif( abilityId == THUNDERBOLT_NORMAL_dianchuandao ) then
			call thunderboltNormal_dianchuandao()
			call thunderboltNormal_charge(GetTriggerUnit())
			call thunderboltNormal_leiqu(GetTriggerUnit())
		endif
	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
		//熊猫体质
		set Attr_Dynamic_Life[index] = Attr_Dynamic_Life[index] + 100
	    call attribute_calculateOne(index)
		//normal
		if( abilityId == THUNDERBOLT_NORMAL_lizichongneng ) then
			call thunderboltNormal_lizichongneng_study()
		endif
	endfunction

	public function init takes nothing returns nothing
		local trigger trigger_thunderbolt_spell_effect = CreateTrigger()
		local trigger trigger_thunderbolt_spell_study = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_thunderbolt_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_thunderbolt_spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_thunderbolt_spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( trigger_thunderbolt_spell_study , function action_spell_study )
	endfunction

endlibrary

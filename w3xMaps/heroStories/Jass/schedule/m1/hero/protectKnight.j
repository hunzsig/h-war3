globals

    integer m1ProtectKnight_spell_yushu = 'A07C'
    integer m1ProtectKnight_spell_zhanzhenghaojiao = 'A07K'
    integer m1ProtectKnight_spell_guangmingpao = 'A07L'
    integer m1ProtectKnight_spell_shengguangzhu = 'A075'

	integer m1ProtectKnight_spell_guangmingpao_arrow = 'o003'
	integer m1ProtectKnight_spell_shengguangzhu_arrow = 'o010'

endglobals

library m1ProtectKnight requires m1Hero

	//愈术
	public function yushu takes nothing returns nothing
		local integer skillLv = GetUnitAbilityLevel(GetTriggerUnit(),m1ProtectKnight_spell_yushu)
	    local integer attackSpeed = 0
	    local integer hemophagia = 0
	    local integer moveSpeed = 0
	    local real during = 60.00   //持续时间
	    local integer targetIndex = GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))
	    //增加攻击速度
	    set attackSpeed = skillLv * 15   //%
	    call attribute_changeAttribute(Tag_AttackSpeed,targetIndex, attackSpeed ,during)
	    //增加吸血效果
	    set hemophagia = skillLv * 5	//%
	    call attribute_changeAttribute(Tag_Hemophagia,targetIndex, hemophagia ,during)
	endfunction

	//战争号角CALL
	private function zhanzhenghaojiaoCall takes nothing returns nothing
	    local timer t = GetExpiredTimer()
	    local unit u = null
	    local unit hero = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local real range = funcs_getTimerParams_Real( t , Key_Skill_Range )
	    local integer during = funcs_getTimerParams_Integer( t , Key_Skill_During )
	    local integer duringInc = funcs_getTimerParams_Integer( t , Key_Skill_DuringInc )
	    local group g = null
	    local location loc = null
	    if( during > duringInc or IsUnitDeadBJ(hero) == true ) then
	        call funcs_delTimer( t , null )
	    else
	        set loc = GetUnitLoc(hero)
	        call funcs_effectPoint( Effect_RoarCaster , loc )
	        call RemoveLocation(loc)
	        set g = funcs_getGroupByUnit( hero ,range, function filter_live )
	        loop
	            exitwhen(IsUnitGroupEmptyBJ(g) == true)
	                //must do
	                set u = FirstOfGroup(g)
	                call GroupRemoveUnit( g , u )
	                //检测是否敌军
	                if( IsUnitEnemy( u , GetOwningPlayer(hero))  == TRUE ) then
	                    call IssueTargetOrder( u , "attack", hero )
	                endif
	        endloop
	        call DestroyGroup( g )
	        call funcs_setTimerParams_Integer( t , Key_Skill_During , during+1 )
	    endif
	endfunction

	//战争号角
	public function zhanzhenghaojiao takes nothing returns nothing
		local integer skillLv = GetUnitAbilityLevel(GetTriggerUnit(),m1ProtectKnight_spell_zhanzhenghaojiao)
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
	    local real damage = I2R(Attr_Attack[index])
	    local real range = 350.00
	    local unit u = GetTriggerUnit()
	    local integer Add_attack = skillLv * 150
	    local integer Add_Defend = skillLv * 15
    	local timer t = null
	    //神秘附加
	    if( funcs_isOwnItem(u , ITEM_mysterious_provoke_horn) ) then
			set Add_attack = Add_attack * 3
	        set Add_Defend = Add_Defend * 3
	    endif
	    //增加攻击力 | 护甲
	    call attribute_changeAttribute(Tag_Attack, index, Add_attack , 10.00 )
	    call attribute_changeAttribute(Tag_Defend, index , Add_Defend , 10.00 )
	    //t
	    set t = funcs_setInterval( 1.00 , function zhanzhenghaojiaoCall )
	    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u )
	    call funcs_setTimerParams_Real( t , Key_Skill_Range , range )
	    call funcs_setTimerParams_Integer( t , Key_Skill_During , 1 )
	    call funcs_setTimerParams_Integer( t , Key_Skill_DuringInc , 10 )
	endfunction

	//光明炮
	public function guangmingpao takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local location loc = GetUnitLoc( u )
	    local location targetLoc = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real hunt = I2R(Attr_Power[index]) + I2R(level) * 200
	    local real range = 800.00
	    local real speed = 16
	    local real facing = AngleBetweenPoints( loc , targetLoc )
	    local real firstDeg = 0
	    local integer qty = 6
	    local real perDeg = 360 / qty
	    local integer i = 0
	    local unit arrow = null
	    local location locStart = null
	    local location locEnd = null
	    set i = 0
	    loop
	        exitwhen i >= qty
	            set locStart = PolarProjectionBJ( loc , 60 , facing + i * perDeg )
	            set locEnd = PolarProjectionBJ( loc , 60 + range , facing + i * perDeg )
	            set arrow = funcs_createUnit ( GetOwningPlayer(u) , m1ProtectKnight_spell_guangmingpao_arrow, locStart , locEnd )
	            call RemoveLocation( locStart )
	            call funcs_setUnitLife( arrow , range / (speed*45) )
	            call skills_leap( arrow , u , locEnd , speed , null , hunt, 90.00 , null , false)
	        set i = i + 1
	    endloop
	    call RemoveLocation(loc)
	    call RemoveLocation(targetLoc)
	endfunction

	//圣光柱
	public function shengguangzhu takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
	    local location triggerLoc = GetUnitLoc(triggerUnit)
	    local location targetLoc = GetSpellTargetLoc()
	    local integer skillLv = GetUnitAbilityLevel(triggerUnit,m1ProtectKnight_spell_shengguangzhu)
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
	    local real speed = 2
	    local real hunt = (I2R(Attr_Skill[index]) + I2R(skillLv) * 120) * 0.3  //0.3秒每击
	    local real range = 300
	    local real during = 10.00
	    local unit u = funcs_createUnit(GetOwningPlayer(GetTriggerUnit()),m1ProtectKnight_spell_shengguangzhu_arrow,triggerLoc,targetLoc)
	    call SetUnitTimeScalePercent( u, 17.5 )
	    call funcs_setUnitLife( u,during )
	    call skills_forward(u,triggerUnit,targetLoc,speed,Effect_LightStrike,hunt,range,Effect_Incinerate,true,during)
	endfunction

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		if( abilityId == m1ProtectKnight_spell_yushu ) then
			call yushu()
		elseif( abilityId == m1ProtectKnight_spell_zhanzhenghaojiao ) then
			call zhanzhenghaojiao()
		elseif( abilityId == m1ProtectKnight_spell_guangmingpao ) then
			call guangmingpao()
		elseif( abilityId == m1ProtectKnight_spell_guangmingpao ) then
			call guangmingpao()
		elseif( abilityId == m1ProtectKnight_spell_shengguangzhu ) then
			call shengguangzhu()
		endif
	endfunction

	public function init takes nothing returns nothing
		local trigger trigger_protectKnight_spell_effect = CreateTrigger()
		local trigger trigger_protectKnight_spell_study = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_protectKnight_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_protectKnight_spell_effect , function action_spell_effect )
	endfunction

endlibrary

library m1ProtectKnightUse requires m1ProtectKnight

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		//m1
		if( abilityId == m1ProtectKnight_spell_yushu ) then
			call m1ProtectKnight_yushu()
		elseif( abilityId == m1ProtectKnight_spell_zhanzhenghaojiao ) then
			call m1ProtectKnight_zhanzhenghaojiao()
		elseif( abilityId == m1ProtectKnight_spell_guangmingpao ) then
			call m1ProtectKnight_guangmingpao()
		elseif( abilityId == m1ProtectKnight_spell_shengguangzhu ) then
			call m1ProtectKnight_shengguangzhu()
		endif

	endfunction

	public function init takes nothing returns nothing
		local trigger trigger_spell_effect = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_spell_effect , function action_spell_effect )
	endfunction

endlibrary

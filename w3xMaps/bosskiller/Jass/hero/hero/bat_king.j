library batKing requires heroBase

	globals

	    private integer ab_yemujianglin = 'A058'
	    private integer ab_fuchoufuqun = 'A05Y'
	    private integer ab_xixue = 'A061'
	    private integer ab_fuyechongji = 'A05W'
	    public integer ab_fuye = 'A064'
		private integer has2not = 'A04I'
	    private integer not2has = 'A04H'

	endglobals

	private function yemujianglinCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local real time = funcs_getTimerParams_Real(t,666)
		call SetTimeOfDay( time )
    	call SetTimeOfDayScale( 1.00 )
	endfunction
 	private function yemujianglin takes nothing returns nothing
 		local unit u = GetTriggerUnit()
	    local location point = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer move = level * 50
	    local integer attackSpeed = level * 30
	    local real during = 30
	    local real time = GetTimeOfDay()
	    local timer t = null
	    //神秘附加
	    if( funcs_isOwnItem(u , ITEM_mysterious_moon_stone) ) then
	        set during = during + 20
	    endif
	    //设为黑夜
	    call SetTimeOfDay( 0.00 )
    	call SetTimeOfDayScale( 0.00 )
    	set t = funcs_setTimeout(during,function yemujianglinCall)
    	call funcs_setTimerParams_Real(t,666,time)
	    //模型变化
	    call skills_shapeshift(u, during, has2not , not2has, Effect_DarkLightningNova)
	    call attribute_changeAttribute( Tag_Move ,index, move , during )
	    call attribute_changeAttribute( Tag_AttackSpeed ,index, attackSpeed , during )
	    //debug
	    call PolledWait(0.10) //模型变化需要一点时间，所以这里加延时,在对单位进行属性计算
	    call attribute_calculateOne(index)
 	endfunction


 	private function fuchoufuqun takes nothing returns nothing
 		local unit u = GetTriggerUnit()
 		local location loc1 = GetUnitLoc(u)
	    local location loc2 = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real speed = 6
	    local real hunt = I2R(level) * 100 + Attr_Attack[index]
	    local real range = 200
	    local real distance = 600
	   	local real life = 0
	   	local unit temp = null
	   	local real firstDeg = AngleBetweenPoints(loc1,loc2)
	   	local integer qty = 0
	   	local integer i = 0
	   	call RemoveLocation(loc2)
	    if(GetUnitTypeId(u)=='E007')then
	    	set firstDeg = firstDeg-70
	    	set qty = 3
	    else
	    	set firstDeg = firstDeg-35
	    	set qty = 1
	    endif
	    set i=1
	    loop
	    	exitwhen i>qty
	    		set loc2 = PolarProjectionBJ(loc1, distance, firstDeg+i*35)
			   	set temp = funcs_createUnit(Players[index],'o01B',loc1,loc2)
			   	set life = 0.02 * (distance/speed)
		    	call funcs_setUnitLife(temp,life)
			    call skills_leap(temp,loc2,speed,null,hunt,range,null,false)
	    	set i = i+1
	    endloop
	    call RemoveLocation(loc1)
	    set loc1 = null
 	endfunction


 	private function xixue takes nothing returns nothing
 		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer hemophagia = 40
	    set Attr_Dynamic_Hemophagia[index] = Attr_Dynamic_Hemophagia[index] + hemophagia
	    call attribute_calculateOne(index)
 	endfunction

 	private function fuyechongjiCall takes nothing returns nothing
 		local timer t = GetExpiredTimer()
 		local unit u = funcs_getTimerParams_Unit(t,1)
	    local real hunt = funcs_getTimerParams_Real(t,2)
	    local real range = funcs_getTimerParams_Real(t,3)
	    local real distance = 0
	    local location loc1 = funcs_getTimerParams_Loc(t,4)
	    local location loc2 = funcs_getTimerParams_Loc(t,5)
 		local integer qty = funcs_getTimerParams_Integer(t,9)
	   	local integer i = funcs_getTimerParams_Integer(t,10)
	   	local location loc = null
	   	local group g = null
	   	local unit ut = null
	   	if(i>=qty)then
	   		call funcs_delTimer(t,null)
	   		call RemoveLocation(loc1)
	   		call RemoveLocation(loc2)
	   		set loc1 = null
	   		set loc2 = null
	   		return
	   	endif
	   	call funcs_setTimerParams_Integer(t,10,i+1)
	    if(GetUnitTypeId(u)=='E007')then
	    	call funcs_effectPoint(Effect_GreatElderHydraAcidSpew,loc2)
	    	set g = funcs_getGroupByPoint(loc2,range,function filter_live_disbuild_dishero)
			loop
	            exitwhen(IsUnitGroupEmptyBJ(g) == true)
	                set ut = FirstOfGroup(g)
	                call GroupRemoveUnit( g , ut )
	                if(IsUnitEnemy(ut, GetOwningPlayer(u)) == true)then
		            	call funcs_huntBySelf( hunt, u , ut)
	                endif
	        endloop
	 		call GroupClear(g)
	 		call DestroyGroup(g)
	 		set g = null
	    	call RemoveLocation(loc)
	    	set loc = null
	    else
	    	set distance = range * 0.5 + (i-1)*range
	    	set loc = PolarProjectionBJ(loc1, distance, AngleBetweenPoints(loc1,loc2))
        	call funcs_effectPoint(Effect_ToxicField,loc)
	    	set g = funcs_getGroupByPoint(loc,range,function filter_live_disbuild_dishero)
			loop
	            exitwhen(IsUnitGroupEmptyBJ(g) == true)
	                set ut = FirstOfGroup(g)
	                call GroupRemoveUnit( g , ut )
	                if(IsUnitEnemy(ut, GetOwningPlayer(u)) == true)then
		            	call funcs_huntBySelf( hunt, u , ut)
	                endif
	        endloop
	 		call GroupClear(g)
	 		call DestroyGroup(g)
	 		set g = null
	    	call RemoveLocation(loc)
	    	set loc = null
	    endif
 	endfunction
 	private function fuyechongji takes nothing returns nothing
 		local unit u = GetTriggerUnit()
 		local location loc1 = GetUnitLoc(u)
	    local location loc2 = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real hunt = I2R(level) * 200 + Attr_Attack[index]
	    local real range = 225 + I2R(level) * 25
	    local timer t = null
	    local integer qty = 4
	    //神秘附加
	    if( funcs_isOwnItem(u , ITEM_mysterious_moon_stone) ) then
	        set qty = qty + 1
	    endif
	    if(GetUnitTypeId(u)=='E007')then
	    	set qty = qty + 2
	    	set range = range + 100
	    endif
	    set t = funcs_setInterval(0.3,function fuyechongjiCall)
	    call funcs_setTimerParams_Unit(t,1,u)
	    call funcs_setTimerParams_Real(t,2,hunt)
	    call funcs_setTimerParams_Real(t,3,range)
	    call funcs_setTimerParams_Loc(t,4,loc1)
	    call funcs_setTimerParams_Loc(t,5,loc2)
	    call funcs_setTimerParams_Integer(t,9,qty)
	    call funcs_setTimerParams_Integer(t,10,1)
 	endfunction

	private function fuye takes nothing returns nothing
		//see damage
 	endfunction

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		if( abilityId == ab_yemujianglin ) then
			call yemujianglin()
		elseif( abilityId == ab_fuchoufuqun ) then
			call fuchoufuqun()
		elseif( abilityId == ab_fuyechongji ) then
			call fuyechongji()
		endif
	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		if( abilityId == ab_xixue ) then
			call xixue()
		elseif( abilityId == ab_fuye ) then
			call fuye()
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

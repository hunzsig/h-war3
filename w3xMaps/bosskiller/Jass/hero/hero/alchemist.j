library alchemist requires heroBase

	globals

	    private integer ab_suanxingzhadan = 'A03U'
	    private integer ab_xiaosa = 'A043'
	    private integer ab_liancheng = 'A042'
	    private integer ab_huaxuefengbao = 'A046'
	    private integer ab_lianchengzhen = 'A044'
		private integer has2not = 'A048'
	    private integer not2has = 'A045'

	    private boolean array ab_lianchengzhen_actioning
	    public integer get_gold = 0

	endglobals

	private function suanxingzhadanCall takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local unit ut = null
		local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
		local integer indext = 0
		local integer level = GetUnitAbilityLevel(Player_heros[index], ab_suanxingzhadan)
		local group g = funcs_getGroupByUnit(u,175,function filterTrigger_ally_live_hero)
		local group ge = funcs_getGroupByUnit(u,175,function filterTrigger_enemy_live_disbuild)
		local integer move = level * 20
		local integer attackSpeed = level * 12
		local real during = 8.00
		local real damage = level * 115.00
		loop
            exitwhen(IsUnitGroupEmptyBJ(g) == true)
                //must do
                set ut = FirstOfGroup(g)
                call GroupRemoveUnit( g , ut )
                set indext = GetConvertedPlayerId(GetOwningPlayer(ut))
                call attribute_changeAttribute( Tag_Move ,indext, move , during )
			    call attribute_changeAttribute( Tag_AttackSpeed ,indext, attackSpeed , during )
                call funcs_effectUnitLoc(Effect_PoisonStingTarget,ut)
        endloop
 		call GroupClear(g)
 		call DestroyGroup(g)
 		set g = null
 		loop
            exitwhen(IsUnitGroupEmptyBJ(ge) == true)
                //must do
                set ut = FirstOfGroup(ge)
                call GroupRemoveUnit( ge , ut )
                call funcs_huntBySelf( damage, Player_heros[index] , ut)
                call funcs_effectUnitLoc(Effect_HydraCorrosiveGroundEffect,ut)
        endloop
 		call GroupClear(ge)
 		call DestroyGroup(ge)
 		set ge = null
	endfunction
 	private function suanxingzhadan takes nothing returns nothing
 		local unit u = GetTriggerUnit()
	    local location loc1 = GetUnitLoc(u)
	    local location loc2 = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real distance = DistanceBetweenPoints(loc1,loc2)
	    local real speed = 20
	    local real hunt = 0
	    local real range = 1
	   	local real life = 0.02 * (distance/speed)
	   	local unit temp = funcs_createUnit(Players[index],'o019',loc1,loc2)
	   	local trigger tg = CreateTrigger()
	    call TriggerRegisterUnitEvent( tg, temp, EVENT_UNIT_DEATH )
    	call TriggerAddAction(tg, function suanxingzhadanCall)
    	call funcs_setUnitLife(temp,life)
	    call RemoveLocation(loc1)
	    set loc1 = null
	    call skills_leap(temp,loc2,speed,null,hunt,range,null,false)
 	endfunction


 	private function xiaosa takes nothing returns nothing
 		local unit u = GetTriggerUnit()
 		local real facing = GetUnitFacing(u)
 		local location loc1 = GetUnitLoc(u)
	    local location loc2 = null
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real speed = 6
	    local real hunt = I2R(level) * 80 + Attr_Skill[index]
	    local real range = 200
	    local real distance = 200
	   	local real life = 0
	   	local unit temp = null
	   	//神秘附加
	    if( funcs_isOwnItem(u , ITEM_mysterious_sky_staff) ) then
	        set distance = distance + 200
	    endif
	   	set loc2 = PolarProjectionBJ(loc1, distance, facing)
	   	set temp = funcs_createUnit(Players[index],'o01A',loc1,loc2)
	   	set life = 0.02 * (distance/speed)
    	call funcs_setUnitLife(temp,life)
	    call RemoveLocation(loc1)
	    set loc1 = null
	    call skills_leap(temp,loc2,speed,null,hunt,range,null,false)
 	endfunction


 	private function liancheng takes nothing returns nothing
 		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer gold = 1
	    set Attr_Dynamic_GoldRatio[index] = Attr_Dynamic_GoldRatio[index] + gold
	    call attribute_calculateOne(index)
 	endfunction
 	private function huaxuefengbao takes nothing returns nothing
 		local unit u = GetTriggerUnit()
	    local location point = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer move = level * 50
	    local integer attackSpeed = level * 30
	    local integer split = level * 20
	    local real during = 30

	    //模型变化
	    call skills_shapeshift(u, during, has2not , not2has, Effect_DarkLightningNova)
	    call attribute_changeAttribute( Tag_Move ,index, move , during )
	    call attribute_changeAttribute( Tag_AttackSpeed ,index, attackSpeed , during )
	    call attribute_changeAttribute( Tag_Split ,index, split , during )
	    //debug
	    call PolledWait(0.10) //模型变化需要一点时间，所以这里加延时,在对单位进行属性计算
	    call attribute_calculateOne(index)
 	endfunction

 	//炼成阵 - 中止
	public function lianchengzhenStop takes nothing returns nothing
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
	    if( ab_lianchengzhen_actioning[index] == true ) then
	        set ab_lianchengzhen_actioning[index] = false
	    endif
	endfunction

 	private function lianchengzhenCall takes nothing returns nothing
 		local timer t = GetExpiredTimer()
		local unit u = funcs_getTimerParams_Unit(t,1)
		local unit ut = null
		local integer level = GetUnitAbilityLevel(u, ab_lianchengzhen)
		local group g = null
		local integer gold = level * 100
		local real damage = level * 200
		local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
		//神秘附加
	    if( funcs_isOwnItem(u , ITEM_mysterious_sky_staff) ) then
	        set gold = gold * 2
	    endif
		if( ab_lianchengzhen_actioning[index] == true and IsUnitAliveBJ(u) == true ) then
			set g = funcs_getGroupByUnit(u,1000,function filter_live_disbuild_dishero)
			loop
	            exitwhen(IsUnitGroupEmptyBJ(g) == true)
	                //must do
	                set ut = FirstOfGroup(g)
	                call GroupRemoveUnit( g , ut )
	                if(IsUnitEnemy(ut, GetOwningPlayer(u)) == true)then
	                	if(IsUnitDeadBJ(ut)) then
				            call funcs_effectUnitLoc(Effect_PileofGold,ut)
			                call funcs_addGold(GetOwningPlayer(u),gold)
			                call funcs_delUnit(ut,0)
			                set get_gold = get_gold + gold
			            else
			            	call funcs_huntBySelf( damage, u , ut)
				        endif
	                endif
	        endloop
	 		call GroupClear(g)
	 		call DestroyGroup(g)
	 		set g = null
		else
			call funcs_delTimer(t,null)
			set ab_lianchengzhen_actioning[index] = false
		endif
	endfunction
	private function lianchengzhen takes nothing returns nothing
		local timer t = funcs_setInterval(0.6,function lianchengzhenCall)
		local real during = 5.00
		local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
		if(ab_lianchengzhen_actioning[index] == false)then
			set ab_lianchengzhen_actioning[index] = true
			call funcs_setTimerParams_Unit(t,1,GetTriggerUnit())
		endif
 	endfunction

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		if( abilityId == ab_suanxingzhadan ) then
			call suanxingzhadan()
		elseif( abilityId == ab_xiaosa ) then
			call xiaosa()
		elseif( abilityId == ab_huaxuefengbao ) then
			call huaxuefengbao()
		elseif( abilityId == ab_lianchengzhen ) then
			call lianchengzhen()
		endif
	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		if( abilityId == ab_liancheng ) then
			call liancheng()
		endif
	endfunction

	//Action - 停止施法
	private function action_spell_abort takes nothing returns nothing
	    local integer abilityId = GetSpellAbilityId()
	    //normal
	    if( abilityId == ab_lianchengzhen ) then
			call lianchengzhenStop()
		endif
	endfunction

	//Action - 施法结束
	private function action_spell_finish takes nothing returns nothing
		//normal
	    local integer abilityId = GetSpellAbilityId()
	    if( abilityId == ab_lianchengzhen ) then
			call lianchengzhenStop()
		endif
	endfunction


	public function init takes nothing returns nothing
		local trigger spell_effect = CreateTrigger()
		local trigger spell_study = CreateTrigger()
		local trigger spell_abort = CreateTrigger()
		local trigger spell_finish = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( spell_study , function action_spell_study )
	    //停止施法
	    call TriggerRegisterAnyUnitEventBJ( spell_abort, EVENT_PLAYER_UNIT_SPELL_ENDCAST )
		call TriggerAddAction( spell_abort , function action_spell_abort )
    	//施法结束
    	call TriggerRegisterAnyUnitEventBJ( spell_finish, EVENT_PLAYER_UNIT_SPELL_FINISH )
    	call TriggerAddAction( spell_finish , function action_spell_finish )
	endfunction

endlibrary

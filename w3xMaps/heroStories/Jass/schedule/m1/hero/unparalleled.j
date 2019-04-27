globals

    integer m1Unparalleled_spell_huoyanlianzhan = 'A02H'
    integer m1Unparalleled_spell_weiwu= 'A06A'
    integer m1Unparalleled_spell_tianxiawushuang = 'A079'
    integer m1Unparalleled_spell_qianjunpo = 'A033'
    integer m1Unparalleled_spell_huoqiluanwu = 'A03R'

    integer m1Unparalleled_spell_huoyanlianzhan_arrow = 'o00H'

    integer m1Unparalleled_spell_huoqiluanwu_arrow = 'o00L'

    boolean array m1Unparalleled_spell_weiwu_Actioning

    boolean array m1Unparalleled_spell_qianjunpo_Actioning

    boolean array m1Unparalleled_spell_huoqiluanwu_status

endglobals

library m1Unparalleled requires m1Hero

	//火焰连斩 - 回调
	private function huoyanlianzhanCall takes nothing returns nothing
	    local timer t = GetExpiredTimer()
	    local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local real hunt = funcs_getTimerParams_Real( t , Key_Skill_Hunt  )
	    local real speed = funcs_getTimerParams_Real( t , Key_Skill_Speed  )
	    local location locStart = funcs_getTimerParams_Loc( t , Key_Skill_Loc  )
	    local location locEnd = funcs_getTimerParams_Loc( t , Key_Skill_TargetLoc  )
	    local integer during = funcs_getTimerParams_Integer( t , Key_Skill_During )
	    local integer duringInc = funcs_getTimerParams_Integer( t , Key_Skill_DuringInc )
	    local real range = DistanceBetweenPoints(locStart, locEnd)
	    local unit fire = null
	    if( duringInc > during or IsUnitDeadBJ(u) == TRUE ) then
	        call funcs_delTimer( t ,null )
	        call RemoveLocation(locStart)
	        call RemoveLocation(locEnd)
	    else
	        call funcs_setTimerParams_Integer( t , Key_Skill_DuringInc , duringInc+1 )
	        call funcs_setTimerParams_Loc( t , Key_Skill_Loc , Location(GetLocationX(locStart), GetLocationY(locStart)) )
	        call funcs_setTimerParams_Loc( t , Key_Skill_TargetLoc , Location(GetLocationX(locEnd), GetLocationY(locEnd)) )
	        if( ModuloInteger( duringInc , 2 ) == 1 ) then
	            set fire = funcs_createUnit ( GetOwningPlayer(u) , m1Unparalleled_spell_huoyanlianzhan_arrow, locStart , locEnd )
	            call skills_leap( fire , u , locEnd , speed , null , hunt, 75.00 , null , false)
	            call RemoveLocation(locStart)
	        else
	            set fire = funcs_createUnit ( GetOwningPlayer(u) , m1Unparalleled_spell_huoyanlianzhan_arrow, locEnd , locStart  )
	            call skills_leap( fire , u , locStart , speed , null , hunt, 75.00 , null , false)
	            call RemoveLocation(locEnd)
	        endif
	        call funcs_setUnitLife( fire , range / (speed*45) )
	    endif
	endfunction

	//火焰连斩
	public function huoyanlianzhan takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local location loc = GetUnitLoc( u )
	    local location targetLoc = GetSpellTargetLoc()
	    local location targetLoc2 = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real hunt = I2R(Attr_Attack[index]) + I2R(level) * 35
	    local real speed = 75
	    local integer qty = 3
	    local timer t = null
	    set t = funcs_setInterval( 0.15 , function huoyanlianzhanCall )
	    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u )
	    call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt )
	    call funcs_setTimerParams_Real( t , Key_Skill_Speed , speed )
	    call funcs_setTimerParams_Loc( t , Key_Skill_Loc , loc )
	    call funcs_setTimerParams_Loc( t , Key_Skill_TargetLoc , targetLoc )
	    call funcs_setTimerParams_Integer( t , Key_Skill_During , qty )
	    call funcs_setTimerParams_Integer( t , Key_Skill_DuringInc , 1 )
	    call skills_leap( u , u , targetLoc2 , speed , null , 0 , 0.00 , null , false)
	endfunction

	//威武 - 回调
	private function weiwuCall takes nothing returns nothing
	    local timer t = GetExpiredTimer()
	    local unit hero = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local integer index = funcs_getTimerParams_Integer( t , Key_Skill_i )
	    local real range = funcs_getTimerParams_Real( t , Key_Skill_Range )
	    local real during = funcs_getTimerParams_Real( t , Key_Skill_During )
	    local location loc = null
	    local group g = null
	    local integer skillUp = 0
	    local unit u = null
	    local real period = 0.20
	    //神秘附加
	    if( funcs_isOwnItem(hero , ITEM_mysterious_god_fire_sword) ) then
	        set period = 0.10
	    endif
	    if(TimerGetTimeout(t) < period and m1Unparalleled_spell_weiwu_Actioning[index] == TRUE) then
	        call funcs_delTimer(t,null)
	        set t = funcs_setInterval( period , function weiwuCall )
	        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , hero)
	        call funcs_setTimerParams_Integer( t , Key_Skill_i , index)
	        call funcs_setTimerParams_Real( t , Key_Skill_Range , range)
	        call funcs_setTimerParams_Real( t , Key_Skill_During , during )
	    endif
	    if( m1Unparalleled_spell_weiwu_Actioning[index] == TRUE and IsUnitAliveBJ(hero) == TRUE ) then
	        set loc = GetUnitLoc(hero)
	        call funcs_effectPoint(Effect_BloodBanish,loc)
	        call RemoveLocation(loc)
	        set Attr_PunishCurrent[index] = Attr_PunishFull[index]
	        call attribute_changeAttribute(Tag_Quick ,index, 5 , during )
	        call attribute_changeAttribute(Tag_Defend ,index, 1 , during )
	        call attribute_changeAttribute(Tag_PunishFull ,index, 10 , during )
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
	    else
	        call funcs_delTimer(t,null)
	        set loc = GetUnitLoc(hero)
	        call funcs_effectPoint(Effect_RedDrum,loc)
	        call RemoveLocation(loc)
	    endif
	endfunction

	//威武
	public function weiwu takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real range = 400.00
	    local real during = 50.00
	    local timer t
	    if( m1Unparalleled_spell_weiwu_Actioning[index] == false ) then
	        set m1Unparalleled_spell_weiwu_Actioning[index] = true
	        set t = funcs_setTimeout( 0.00 , function weiwuCall )
	        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u)
	        call funcs_setTimerParams_Integer( t , Key_Skill_i , index)
	        call funcs_setTimerParams_Real( t , Key_Skill_Range , range)
	        call funcs_setTimerParams_Real( t , Key_Skill_During , during )
	    endif
	endfunction

	//威武 - 中止
	public function weiwu_abort takes nothing returns nothing
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
	    if( m1Unparalleled_spell_weiwu_Actioning[index] == true ) then
	        set m1Unparalleled_spell_weiwu_Actioning[index] = false
	    endif
	endfunction

	//威武 - 施法结束
	public function weiwu_finish takes nothing returns nothing
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
	    if( m1Unparalleled_spell_weiwu_Actioning[index] == true ) then
	        set m1Unparalleled_spell_weiwu_Actioning[index] = false
	    endif
	endfunction

	//天下无双
	public function tianxiawushuang takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer addAttack = 35
	    local integer addSplit = 12
	    set Attr_Dynamic_Attack[index] = Attr_Dynamic_Attack[index] + addAttack
	    set Attr_Dynamic_Split[index] = Attr_Dynamic_Split[index] + addSplit
	    call attribute_calculateOne(index)
	endfunction


	//千军破 - 回调
	private function qianjunpoCall takes nothing returns nothing
	    local timer t = GetExpiredTimer()
	    local unit hero = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local integer index = funcs_getTimerParams_Integer( t , Key_Skill_i )
	    local integer level = funcs_getTimerParams_Integer( t , Key_Skill_j )
	    local real range = funcs_getTimerParams_Real( t , Key_Skill_Range )
	    local real during = funcs_getTimerParams_Real( t , Key_Skill_During )
	    local location targetLoc = funcs_getTimerParams_Loc( t , Key_Skill_TargetLoc )
	    local location loc = null
	    local group g = null
	    local unit u = null
	    local real hunt = 0
	    if(TimerGetTimeout(t) < 1.00 and m1Unparalleled_spell_qianjunpo_Actioning[index] == TRUE) then
	        call funcs_delTimer(t,null)
	        set t = funcs_setInterval( 1.00 , function qianjunpoCall )
	        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , hero )
	        call funcs_setTimerParams_Integer( t , Key_Skill_i , index )
	        call funcs_setTimerParams_Integer( t , Key_Skill_j , level )
	        call funcs_setTimerParams_Real( t , Key_Skill_Range , range )
	        call funcs_setTimerParams_Real( t , Key_Skill_During , during )
	        call funcs_setTimerParams_Loc( t , Key_Skill_TargetLoc , targetLoc)
	    endif
	    if( m1Unparalleled_spell_qianjunpo_Actioning[index] == TRUE and IsUnitAliveBJ(hero) == TRUE ) then
	        set loc = GetUnitLoc(hero)
	        call funcs_effectPoint(Effect_BloodBanish,loc)
	        call RemoveLocation(loc)
	        call attribute_changeAttribute(Tag_Attack ,index, 50 , during )
	        call attribute_changeAttribute(Tag_Violence ,index, 500 , during )
	    else
	        call funcs_delTimer(t,null)
	        set g = funcs_getGroupByPoint( targetLoc ,range, function filter_live_disbuild_dishero )
	        if( CountUnitsInGroup(g) > 0 ) then
	            set hunt = I2R(Attr_Attack[index] * level * 20 ) / CountUnitsInGroup(g)
	            call funcs_huntGroup( g, hero , hunt , null , null , FILTER_ENEMY )
	            call DestroyGroup( g )
	        endif
	        call funcs_effectPoint(Effect_ABomb,targetLoc)
	        call RemoveLocation(targetLoc)
	    endif

	endfunction

	//千军破
	public function qianjunpo takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local location targetLoc = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real range = 700.00
	    local real during = 12.00
	    local timer t = null
	    if( m1Unparalleled_spell_qianjunpo_Actioning[index] == FALSE ) then
	        set m1Unparalleled_spell_qianjunpo_Actioning[index] = TRUE
	        set t = funcs_setTimeout( 0.00 , function qianjunpoCall )
	        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u)
	        call funcs_setTimerParams_Integer( t , Key_Skill_i , index)
	        call funcs_setTimerParams_Integer( t , Key_Skill_j , level )
	        call funcs_setTimerParams_Real( t , Key_Skill_Range , range)
	        call funcs_setTimerParams_Real( t , Key_Skill_During , during )
	        call funcs_setTimerParams_Loc( t , Key_Skill_TargetLoc , targetLoc )
	    endif
	endfunction

	//千军破 - 中止
	public function qianjunpo_abort takes nothing returns nothing
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
	    if( m1Unparalleled_spell_qianjunpo_Actioning[index] == true ) then
	        set m1Unparalleled_spell_qianjunpo_Actioning[index] = false
	    endif
	endfunction

	//千军破 - 施法结束
	public function qianjunpo_finish takes nothing returns nothing
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
	    if( m1Unparalleled_spell_qianjunpo_Actioning[index] == true ) then
	        set m1Unparalleled_spell_qianjunpo_Actioning[index] = false
	    endif
	endfunction

	//火气乱舞 - 回调
	private function huoqiluanwuCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local integer level = GetUnitAbilityLevel( u, m1Unparalleled_spell_huoqiluanwu )
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real hunt = I2R(level * Attr_Attack[index])
	    local unit tempUnit = null
	    local unit jumper = null
	    local group g = null
	    local location loc = null

	    if( IsUnitAliveBJ(u) == true ) then
		    set g = funcs_getGroupByUnit( u , 200 , function filter_live_disbuild_dishero )
		    loop
			    exitwhen(IsUnitGroupEmptyBJ(g) == true)
                //must do
                set tempUnit = FirstOfGroup(g)
                call GroupRemoveUnit( g , tempUnit )
                //检测是否敌军
                if( IsUnitEnemy( tempUnit , GetOwningPlayer(u))  == true ) then
	                set loc = GetUnitLoc(u)
	                set jumper = funcs_createUnit( GetOwningPlayer(u) , m1Unparalleled_spell_huoqiluanwu_arrow , loc , loc )
					call skills_jump( jumper , tempUnit , 20 , null , hunt , Effect_BloodBanish )
					call funcs_delUnit( jumper , 0.50 )
					call RemoveLocation(loc)
					call DoNothing() YDNL exitwhen true
                endif
		    endloop
		    call GroupClear(g)
		    call DestroyGroup(g)
		endif
	endfunction

	//火气乱舞
	public function huoqiluanwu takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer addAttackSpeed = 20
	    local integer addSplit = 10
	    local timer t = null
	    set Attr_Dynamic_AttackSpeed[index] = Attr_Dynamic_AttackSpeed[index] + addAttackSpeed
	    set Attr_Dynamic_Split[index] = Attr_Dynamic_Split[index] + addSplit
	    call attribute_calculateOne(index)
		if( m1Unparalleled_spell_huoqiluanwu_status[index] == false ) then
			set m1Unparalleled_spell_huoqiluanwu_status[index] = true
			set t = funcs_setInterval( 0.45 , function huoqiluanwuCall )
			call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u )
		endif
	endfunction

endlibrary


library m1UnparalleledUse requires m1Unparalleled

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		if( abilityId == m1Unparalleled_spell_huoyanlianzhan ) then
			call m1Unparalleled_huoyanlianzhan()
		elseif( abilityId == m1Unparalleled_spell_weiwu ) then
			call m1Unparalleled_weiwu()
		elseif( abilityId == m1Unparalleled_spell_qianjunpo ) then
			call m1Unparalleled_qianjunpo()
		endif

	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		if( abilityId == m1Unparalleled_spell_tianxiawushuang ) then
			call m1Unparalleled_tianxiawushuang()
		elseif( abilityId == m1Unparalleled_spell_huoqiluanwu ) then
			call m1Unparalleled_huoqiluanwu()
		endif

	endfunction

	//Action - 停止施法
	private function action_spell_abort takes nothing returns nothing
	    local integer abilityId = GetSpellAbilityId()
	    if( abilityId == m1Unparalleled_spell_weiwu ) then
			call m1Unparalleled_weiwu_abort()
		elseif( abilityId == m1Unparalleled_spell_qianjunpo ) then
			call m1Unparalleled_qianjunpo_abort()
		endif

	endfunction

	//Action - 施法结束
	private function action_spell_finish takes nothing returns nothing
	    local integer abilityId = GetSpellAbilityId()
	    if( abilityId == m1Unparalleled_spell_weiwu ) then
			call m1Unparalleled_weiwu_finish()
		elseif( abilityId == m1Unparalleled_spell_qianjunpo ) then
			call m1Unparalleled_qianjunpo_finish()
		endif

	endfunction




	public function init takes nothing returns nothing
		local trigger trigger_spell_effect = CreateTrigger()
		local trigger trigger_spell_study = CreateTrigger()
		local trigger trigger_spell_abort = CreateTrigger()
		local trigger trigger_spell_finish = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( trigger_spell_study , function action_spell_study )
	    //停止施法
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_abort, EVENT_PLAYER_UNIT_SPELL_ENDCAST )
		call TriggerAddAction( trigger_spell_abort , function action_spell_abort )
    	//施法结束
    	call TriggerRegisterAnyUnitEventBJ( trigger_spell_finish, EVENT_PLAYER_UNIT_SPELL_FINISH )
    	call TriggerAddAction( trigger_spell_finish , function action_spell_finish )
	endfunction



endlibrary

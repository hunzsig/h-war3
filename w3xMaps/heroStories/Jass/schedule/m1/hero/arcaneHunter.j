globals
    integer m1ArcaneHunter_spell_tuxi = 'A07Y'
    integer m1ArcaneHunter_spell_shabei = 'A07Z'
    integer m1ArcaneHunter_spell_anshalingyu = 'A08L'
    integer m1ArcaneHunter_spell_tianzhu = 'A08J'
    integer m1ArcaneHunter_spell_jiyeheiying = 'A08I'
    integer m1ArcaneHunter_spell_MODEL_jiyeheiying = 'A08K'
	boolean array m1ArcaneHunter_spell_jiyeheiying_status
	boolean array m1ArcaneHunter_spell_jiyeheiying_actioned
endglobals

library m1ArcaneHunter requires m1Hero

	//突袭
	public function tuxi takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
	    local unit targetUnit = GetSpellTargetUnit()
	    local real targetFaceDeg = GetUnitFacing(GetSpellTargetUnit())
	    local location loc = PolarProjectionBJ(GetUnitLoc(targetUnit), 75.00, targetFaceDeg+180.00)
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer lv_tuxi = GetUnitAbilityLevel(triggerUnit, m1ArcaneHunter_spell_tuxi)
	    local real hunt = I2R(Attr_Attack[index] + lv_tuxi * 10 )
	    local integer addAttackSpeed = lv_tuxi * 15
	    local real addAttackSpeedDuring = 1.00
	    //僵直1秒
	    call skills_punish( targetUnit  , 1.00 , 0 )
	    //移动
	    call SetUnitPositionLoc(triggerUnit,loc)
	    call SetUnitFacing(triggerUnit,targetFaceDeg)
	    call RemoveLocation(loc)
	    //攻击速度加成
	    call attribute_changeAttribute(Tag_AttackSpeed ,index, addAttackSpeed ,addAttackSpeedDuring)
	    //突袭伤害
	    call funcs_huntBySelf( hunt , triggerUnit , targetUnit )
	    call IssueTargetOrder( triggerUnit , "attack", targetUnit )
	endfunction

	//杀背 - 效果
	private function shabeiEffect takes unit attacker returns nothing
		local integer lv_shabei = GetUnitAbilityLevel(attacker, m1ArcaneHunter_spell_shabei)
		local integer index = GetConvertedPlayerId(GetOwningPlayer(attacker))
	    local integer addAttack = 0
	    local real addAttackDuring = 0
        set addAttack = 25
        set addAttackDuring = 0.50 * I2R(lv_shabei)
        call attribute_changeAttribute(Tag_Attack,index, addAttack ,addAttackDuring)
	endfunction

	//暗杀领域 - 效果
	private function anshalingyuEffect takes unit attacker returns nothing
		local integer lv_anshalingyu = GetUnitAbilityLevel(attacker, m1ArcaneHunter_spell_anshalingyu)
   		local integer index = GetConvertedPlayerId(GetOwningPlayer(attacker))
	    local location group_loc = null
	    local group group_area = null
	    local real area_range = 0
	    local real area_hunt = 0
		if( lv_anshalingyu > 1 )then
            set area_range = 200.00
            set area_hunt = I2R(Attr_Attack[index] * lv_anshalingyu) * 0.30
            set group_loc =  GetUnitLoc(attacker)
            set group_area = funcs_getGroupByPoint(group_loc,area_range,function filter_live_disbuild)
            call funcs_huntGroup(group_area,attacker,area_hunt,Effect_Boold_Cut,null,FILTER_ENEMY)
            call DestroyGroup(group_area)
            call RemoveLocation(group_loc)
        endif
	endfunction

	//杀背
	public function shabei takes nothing returns nothing
		local unit beAttacker = GetTriggerUnit()
	    local unit attacker = GetAttacker()
	    local real deg_beAttacker = GetUnitFacing(beAttacker)
    	local real deg_attacker = GetUnitFacing(attacker)
	    //背击条件
	    if(RAbsBJ(deg_beAttacker-deg_attacker) < 90) then
	        //杀背效果
	        call shabeiEffect( attacker )
	        //暗杀领域效果
	        call anshalingyuEffect( attacker )
	    endif
	endfunction

	//天诛 - 回调
	private function tianzhuCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
	    local unit triggerUnit = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local real hunt =  funcs_getTimerParams_Real( t , Key_Skill_Hunt  )
	    local real range =  funcs_getTimerParams_Real( t , Key_Skill_Range  )
	    local group g =  funcs_getTimerParams_Group( t , Key_Skill_Group )
	    local integer jumpTimes =  funcs_getTimerParams_Integer( t , Key_Skill_Times )
	    local integer i = funcs_getTimerParams_Integer( t , Key_Skill_i )
	    //
	    local unit targetUnit
	    local real targetFaceDeg
	    local location loc = null
	    //
	    if( i <= jumpTimes ) then
	        set targetUnit = GroupPickRandomUnit(g)
	        set targetFaceDeg = GetUnitFacing(targetUnit)
	        set loc = PolarProjectionBJ(GetUnitLoc(targetUnit), 75.00, targetFaceDeg+180.00)
	        call funcs_effectPoint( Effect_OrbOfCorruption , loc )
	        call funcs_setTimerParams_Integer( t , Key_Skill_i , i+1 )
	        //移动
	        call SetUnitPositionLoc(triggerUnit,loc)
	        call SetUnitFacing(triggerUnit,targetFaceDeg)
	        call RemoveLocation(loc)
	        //杀背效果
	        call shabeiEffect( triggerUnit )
	        //暗杀领域效果
	        call anshalingyuEffect( triggerUnit )
	        //天诛伤害
	        call funcs_huntBySelf( hunt , triggerUnit , targetUnit )
	    else
	        call funcs_delTimer( t,null )
	    endif
	endfunction

	//天诛
	public function tianzhu takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
	    local location targetLoc = GetSpellTargetLoc()
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local integer lv_tianzhu = GetUnitAbilityLevel(triggerUnit, m1ArcaneHunter_spell_tianzhu)
	    local integer jumpTimes = lv_tianzhu * 3
	    local real range = 400.00
	    local real hunt = I2R(Attr_Quick[index] * lv_tianzhu)
	    local group g
	    local timer t = null
	    if( jumpTimes > 0) then
	        call funcs_effectPoint( Effect_OrbOfCorruption , targetLoc )
	        set g = funcs_getGroupByPoint( targetLoc , range , function filterTrigger_enemy_live_disbuild )
	        if( CountUnitsInGroup(g) > 0) then
	            set t = funcs_setInterval( 0.25 , function tianzhuCall )
	            call funcs_setTimerParams_Unit( t , Key_Skill_Unit , triggerUnit )
	            call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt )
	            call funcs_setTimerParams_Real( t , Key_Skill_Range , range )
	            call funcs_setTimerParams_Group( t , Key_Skill_Group , g )
	            call funcs_setTimerParams_Integer( t , Key_Skill_Times , jumpTimes )
	            call funcs_setTimerParams_Integer( t , Key_Skill_i , 1 )
	        endif
	    endif
	    call RemoveLocation(targetLoc)
	endfunction

	//极夜黑影 - 回调
	private function jiyeheiyingCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit triggerUnit = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
		local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
		local integer skillLv = GetUnitAbilityLevel( triggerUnit , m1ArcaneHunter_spell_jiyeheiying )
	    local location loc = null
	    local real during = 30.00
	    local integer plusMove
	    local integer plusAttackSpeed
	    local integer plusKnocking
	    local integer plusAvoid
	    local integer plusQuick
	    //如果是夜晚
	    if( isNight == true ) then
		    if( m1ArcaneHunter_spell_jiyeheiying_actioned[index] == false ) then
		        set m1ArcaneHunter_spell_jiyeheiying_actioned[index] = true
		        call skills_addAbilityEffect(triggerUnit,m1ArcaneHunter_spell_MODEL_jiyeheiying,1, during)
		        set loc = GetUnitLoc( triggerUnit )
		        call funcs_effectPoint( Effect_BlackExplosion , loc )
		        call RemoveLocation( loc )
		        if( skillLv >=1) then
	                set plusMove = 100
			    	set plusAttackSpeed = 100
	            endif
	            if( skillLv >=2) then
	                set plusKnocking = 300
			    	set plusAvoid = 1000
	            endif
	            if( skillLv >=3) then
		            set plusQuick = 150
	            endif
		        //神秘附加
		        if( funcs_isOwnItem( triggerUnit , ITEM_mysterious_ruthless_sword) ) then
		            set during = during * 5
		            set plusMove = plusMove * 5
			    	set plusAttackSpeed = plusAttackSpeed * 5
			    	set plusKnocking = plusKnocking * 5
			    	set plusAvoid = plusAvoid * 5
			    	set plusQuick = plusQuick * 5
		        endif
		        if( plusMove > 0 ) then
			        call attribute_changeAttribute(Tag_Move,index, plusMove ,during)
		        endif
		        if( plusAttackSpeed > 0 ) then
			        call attribute_changeAttribute(Tag_AttackSpeed,index, plusAttackSpeed ,during)
		        endif
		        if( plusKnocking > 0 ) then
			        call attribute_changeAttribute(Tag_Knocking,index, plusKnocking ,during)
		        endif
		        if( plusAvoid > 0 ) then
			        call attribute_changeAttribute(Tag_Avoid,index, plusAvoid ,during)
		        endif
		        if( plusQuick > 0 ) then
			        call attribute_changeAttribute(Tag_Quick,index, plusQuick ,during)
		        endif
		    endif
	    //如果是白天
	    else
		    if( m1ArcaneHunter_spell_jiyeheiying_actioned[index] == true ) then
		        set m1ArcaneHunter_spell_jiyeheiying_actioned[index] = false
		    endif
	    endif
	endfunction

	//极夜黑影
	public function jiyeheiying takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
		local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
		local timer t = null
	    if(m1ArcaneHunter_spell_jiyeheiying_status[index] == false)then
	        set m1ArcaneHunter_spell_jiyeheiying_status[index] = true
	        //如果技能效果未开，则开启
	        set t = funcs_setInterval( 3.00 , function jiyeheiyingCall )
	        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , triggerUnit )
	    endif
	endfunction

endlibrary

library m1ArcaneHunterUse requires m1ArcaneHunter

	/* Action - 释放技能 */
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		//m1
		if( abilityId == m1ArcaneHunter_spell_tuxi ) then
			call m1ArcaneHunter_tuxi()
		elseif( abilityId == m1ArcaneHunter_spell_tianzhu ) then
			call m1ArcaneHunter_tianzhu()
		endif

	endfunction

	/* Action - 学习技能 */
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		//m1
		if( abilityId == m1ArcaneHunter_spell_jiyeheiying ) then
			call m1ArcaneHunter_jiyeheiying()
		endif

	endfunction

	/* Action - 被攻击 */
	private function action_unit_beAttack takes nothing returns nothing
		//m1
		if( GetUnitAbilityLevel(GetAttacker(), m1ArcaneHunter_spell_shabei) >= 1 ) then
			call m1ArcaneHunter_shabei()
		endif

 	endfunction

	public function init takes nothing returns nothing
		local trigger trigger_spell_effect = CreateTrigger()
		local trigger trigger_spell_study = CreateTrigger()
		local trigger trigger_unit_deAttack = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( trigger_spell_study , function action_spell_study )
	    //被攻击
	    call TriggerRegisterAnyUnitEventBJ( trigger_unit_deAttack, EVENT_PLAYER_UNIT_ATTACKED )
    	call TriggerAddAction( trigger_unit_deAttack , function action_unit_beAttack )
	endfunction

endlibrary

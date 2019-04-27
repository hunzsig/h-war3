globals

    integer MEDUSA_NORMAL_binghanzhishi = 'A0DN'
    integer MEDUSA_NORMAL_shuiyaozhibi = 'A08X'
    integer MEDUSA_NORMAL_shuihuazhiwu = 'A08V'
    integer MEDUSA_NORMAL_miwushihua = 'A099'
    integer MEDUSA_NORMAL_shenhaihexin = 'A06K'

    integer MEDUSA_NORMAL_binghanzhijian_arrow = 'o03G'

endglobals

library medusaNormal requires heroBase

	//冰寒之矢
	public function binghanzhishi takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local location loc = GetUnitLoc( u )
	    local location targetLoc = GetSpellTargetLoc()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real hunt = I2R(Attr_Attack[index]) + I2R(level) * 25
	    local real range = 650.00
	    local real speed = 15
	    local real perDeg = 23
	    local real facing = AngleBetweenPoints( loc , targetLoc )
	    local real firstDeg = 0
	    local integer qty = 2 + level
	    local integer i = 0
	    local unit arrow = null
	    local location locStart = null
	    local location locEnd = null
	    set firstDeg = facing - ( perDeg * ((qty-1)/2))
	    set i = 0
	    loop
	        exitwhen i >= qty
	            set locStart = PolarProjectionBJ( loc , 60 , firstDeg + i * perDeg )
	            set locEnd = PolarProjectionBJ( loc , 60 + range , firstDeg + i * perDeg )
	            set arrow = funcs_createUnit ( GetOwningPlayer(u) , MEDUSA_NORMAL_binghanzhijian_arrow, locStart , locEnd )
	            call RemoveLocation( locStart )
	            call funcs_setUnitLife( arrow , range / (speed*45) )
	            call skills_leap( arrow , locEnd , speed , Effect_CrushingWaveDamage , hunt, 75.00 , Effect_OrbOfSeas , false)
	        set i = i + 1
	    endloop
	    call RemoveLocation(loc)
	    call RemoveLocation(targetLoc)
	endfunction

	//水妖之壁
	public function shuiyaozhibi takes nothing returns nothing
		//----see event damaged
	endfunction

	//水花之舞
	public function shuihuazhiwu takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real attackSpeed = 7
	    set Attr_Dynamic_AttackSpeed[index] = Attr_Dynamic_AttackSpeed[index] + attackSpeed
	    call attribute_calculateOne(index)
	endfunction


	//迷雾石化 - 效果
	private function miwushihuaEffect takes nothing returns nothing
	    if( IsUnitEnemy( GetEnumUnit() , Player_Ally_Building ) == true  ) then
	        call skills_punish( GetEnumUnit() , 0.60 , SKILL_PUNISH_TYPE_black )
	    endif
	endfunction

	//迷雾石化 - 回调
	private function miwushihuaCall takes nothing returns nothing
	    local timer t = GetExpiredTimer()
	    local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit  )
	    local real hunt = funcs_getTimerParams_Real( t , Key_Skill_Hunt  )
	    local real range = funcs_getTimerParams_Real( t , Key_Skill_Range  )
	    local integer during = funcs_getTimerParams_Integer( t , Key_Skill_During  )
	    local integer duringInc = funcs_getTimerParams_Integer( t , Key_Skill_DuringInc  )
	    local location loc = null
	    local group g = null

	    if( duringInc > during ) then
	        call funcs_delTimer( t , null )
	    else
	        call funcs_setTimerParams_Integer( t , Key_Skill_DuringInc , duringInc+1 )
	        set loc = GetUnitLoc(u)
	        set g = funcs_getGroupByPoint( loc, range ,function filter_live_disbuild )
	        call ForGroupBJ( g , function miwushihuaEffect )
	        call funcs_huntGroup( g, u , hunt , Effect_DarknessBomb , null , FILTER_ENEMY )
	        call GroupClear(g)
	        call DestroyGroup(g)
	        call RemoveLocation(loc)
	    endif
	endfunction

	//迷雾石化
	public function miwushihua takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real hunt = (I2R(Attr_Skill[index]) + 100 * I2R(level)) * 0.5
	    local real range = 500.00
	    local integer during = 24//12秒
	    local timer t = null
	    set t = funcs_setInterval( 0.5 , function miwushihuaCall )
	    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u )
	    call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt )
	    call funcs_setTimerParams_Real( t , Key_Skill_Range , range )
	    call funcs_setTimerParams_Integer( t , Key_Skill_During , during )
	    call funcs_setTimerParams_Integer( t , Key_Skill_DuringInc , 1 )
	    call attribute_changeAttribute( Tag_Move , index , Attr_Move[index]/2 ,5.00)
	endfunction

	//深海核心
	public function shenhaihexin takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetLearnedSkill())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local integer violence = 1000
	    set Attr_Dynamic_Violence[index] = Attr_Dynamic_Violence[index] + violence
	    call attribute_calculateOne(index)
	endfunction

endlibrary


library medusa requires medusaNormal

	//Action - 释放技能
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		//normal
		if( abilityId == MEDUSA_NORMAL_binghanzhishi ) then
			call medusaNormal_binghanzhishi()
		elseif( abilityId == MEDUSA_NORMAL_miwushihua ) then
			call medusaNormal_miwushihua()
		endif
	endfunction

	//Action - 学习技能
	private function action_spell_study takes nothing returns nothing
		local integer abilityId = GetLearnedSkill()
		//normal
		if( abilityId == MEDUSA_NORMAL_shuihuazhiwu ) then
			call medusaNormal_shuihuazhiwu()
		elseif( abilityId == MEDUSA_NORMAL_shenhaihexin ) then
			call medusaNormal_shenhaihexin()
		endif
	endfunction

	public function init takes nothing returns nothing
		local trigger trigger_medusa_spell_effect = CreateTrigger()
		local trigger trigger_medusa_spell_study = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_medusa_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_medusa_spell_effect , function action_spell_effect )
	    //学习技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_medusa_spell_study, EVENT_PLAYER_HERO_SKILL )
	    call TriggerAddAction( trigger_medusa_spell_study , function action_spell_study )
	endfunction

endlibrary

globals

	trigger m1_Trigger_BeAttacked = null

	integer Attacker_xiaoxingzhadan = 'n00G'	//小型炸弹
	integer Attacker_liericaijue_arrow = 'o00G'	//烈日裁决箭矢

endglobals

library m1BeAttacked requires m1Event

	//小型炸弹
    private function skill_xiaoxingzhadan takes unit sourceUnit,unit beUnit returns nothing
        local location sourceLoc = GetUnitLoc(sourceUnit)
        local location beLoc = GetUnitLoc(beUnit)
        local group g = null
        local real hunt = GetUnitState( sourceUnit , UNIT_STATE_MAX_LIFE ) * 1.50
        set g = funcs_getGroupByPoint(beLoc,150.00,function filter_live)
        call funcs_huntGroup(g,sourceUnit, hunt ,Effect_Explosion,null,FILTER_ENEMY)
        call TerrainDeformationCraterBJ( 0.5, false, beLoc, 100, 32 )
        call DestroyGroup(g)
        call ExplodeUnitBJ( sourceUnit )
        call RemoveLocation(beLoc)
        call RemoveLocation(sourceLoc)
    endfunction
	//烈日裁决 - call
    private function skill_sunGunCall takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit attackUnit = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
        local unit beUnit = funcs_getTimerParams_Unit( t , Key_Skill_TargetUnit )
        local real hunt = funcs_getTimerParams_Real( t , Key_Skill_Hunt )
        local integer during = funcs_getTimerParams_Integer( t , Key_Skill_During )
        local integer duringInc = funcs_getTimerParams_Integer( t , Key_Skill_DuringInc )
        local location loc = null
        local unit temp_unit = null
        local real speed = 15

        if( duringInc > during or IsUnitDeadBJ(beUnit) == true) then
            call funcs_delTimer(t,null)
        else
            call funcs_setTimerParams_Integer( t , Key_Skill_DuringInc , duringInc+1 )
            set loc = GetUnitLoc( attackUnit )
            set temp_unit = funcs_createUnit ( GetOwningPlayer(attackUnit) , Attacker_liericaijue_arrow , loc , loc )
            call skills_jump( temp_unit , beUnit , speed , null , hunt , null )
            call funcs_delUnit( temp_unit , 1.00 )
            call RemoveLocation(loc)
        endif
    endfunction
	//烈日裁决
    public function skill_sunGun takes unit attackUnit , unit beUnit , real hunt ,integer qty returns nothing
        local timer t = funcs_setInterval( 0.3 , function skill_sunGunCall )
        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , attackUnit )
        call funcs_setTimerParams_Unit( t , Key_Skill_TargetUnit , beUnit )
        call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt )
        call funcs_setTimerParams_Integer( t , Key_Skill_During , qty )
        call funcs_setTimerParams_Integer( t , Key_Skill_DuringInc , 1 )
    endfunction

	/*=========================================================*/







	private function actions takes nothing returns nothing
		//攻击触发
		local unit beUnit = GetTriggerUnit()                	//受伤单位
	    local unit attackUnit = GetEventDamageSource()   		//攻击单位
	    local real damage = GetEventDamage()          		//受伤值
	    //---------------------------
	    //玩家档
	    local integer playerIndex = 0
	    local integer attackIndex = GetConvertedPlayerId(GetOwningPlayer(attackUnit))
	    local integer beIndex = GetConvertedPlayerId(GetOwningPlayer(beUnit))
	    local integer avoid = 0
	    local real split = 0
	    local integer knocking = 0
	    local real last_KnockingDamage = 0
	    local boolean isKnocking = false		//是否已触发物暴
	    //---------------------------
	    //技能数据
	    local integer skillLv = 0
	    //---------------------------
	    local integer charges = 0
	    local integer odds_stable = 0    //固有几率
	    local integer odds_gain = 0     //增量几率
	    local location loc = null
	    local group temp_group = null
	    local unit createUnit = null
	    local real val = 0

	    if( damage <=1  or IsUnitAliveBJ(beUnit) == false) then
		    return
	    endif

		if( IsUnitInGroup( beUnit , Group_BeAttack_Fake[attackIndex] ) == true and IsUnitInGroup( attackUnit , Group_Attack_Fake[attackIndex] ) == true) then
			call GroupRemoveUnit( Group_BeAttack_Fake[attackIndex] , beUnit )
			call GroupRemoveUnit( Group_Attack_Fake[attackIndex] , attackUnit )
			//TODO 关闭当前触发器
			call DisableTrigger(GetTriggeringTrigger())

			if( IsUnitAlly(beUnit, Player_Enemy)==true and IsUnitType(attackUnit, UNIT_TYPE_HERO) == true ) then
				set playerIndex = GetConvertedPlayerId(GetOwningPlayer(attackUnit))
		        set knocking = Attr_Knocking[playerIndex]
		        set split = I2R(Attr_Split[playerIndex]) * 0.01
				//------------------分裂------------------------
	            if( split>0 )then
	                set split = split * damage
	                set loc = GetUnitLoc( beUnit )
	                set temp_group = funcs_getGroupByPoint( loc ,200.00,function filter_live_disbuild )
	                call funcs_huntGroup_BreakDefend( temp_group , attackUnit , split ,Effect_Split,null,FILTER_ENEMY)
	                call DestroyGroup( temp_group )
	                call RemoveLocation( loc )
	            endif

				//------------------物暴------------------------
		        if( isKnocking == false and GetRandomInt(1, 100) <= (10+R2I(I2R(knocking)/300)) ) then
			        set last_KnockingDamage = I2R(knocking)/20
			        call funcs_huntByToken( last_KnockingDamage , attackUnit , beUnit )
		            call funcs_floatMsg("|cfff96206暴击"+I2S(R2I(last_KnockingDamage))+"！|r"  , beUnit)
		            set isKnocking = true
		        endif

	            //----------------物品技能-----------
	             //雷石
	            set charges = items_getItemCharges(attackUnit, ITEM_thunder_stone )
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(5,0.50,charges)) then
	                    call skills_thunderLink(attackUnit,beUnit,'A07E')
	                endif
	            endif
	            //雷电之锤
	            set charges = items_getItemCharges(attackUnit, ITEM_thunder_hammer )
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(5,0.50,charges)) then
	                    call skills_thunderLink(attackUnit,beUnit,'A07G')
	                endif
	            endif
	            //鬼道电锤
	            set charges = items_getItemCharges(attackUnit, ITEM_god_thunder_hammer)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(5,0.50,charges)) then
	                    call skills_thunderLink(attackUnit,beUnit,'A013')
	                endif
	            endif

	            //食人鬼巨锤
	            set charges = items_getItemCharges(attackUnit, ITEM_ghost_hammer)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(10,0.25,charges)) then
	                    call skills_swim( beUnit , 1 )
	                endif
	            endif

	            //烽火巨剑
	            set charges = items_getItemCharges(attackUnit, ITEM_fire_sword)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= 13 ) then
	                    call skill_sunGun( attackUnit , beUnit , 150 , 3+charges-1 )
	                endif
	            endif
	            //烈日裁决
	            set charges = items_getItemCharges(attackUnit, ITEM_sun_gun)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= 15 ) then
	                    call skill_sunGun( attackUnit , beUnit , 250 , 3+charges-1 )
	                endif
	            endif

	            //雄狮斩牙刀
	            if( funcs_isOwnItem(attackUnit, ITEM_lion_fire_fight) and IsUnitAliveBJ(beUnit) == true ) then
		            set charges = items_getItemCharges(attackUnit, ITEM_lion_fire_fight)
	                set loc = GetUnitLoc( attackUnit )
	                set temp_group = funcs_getGroupByPoint( loc , 175.00 ,function filter_live_disbuild )
	                call funcs_huntGroup_BreakDefend( temp_group , attackUnit , 125*charges , Effect_red_shatter ,null, FILTER_ENEMY)
	                call DestroyGroup( temp_group )
	                call RemoveLocation( loc )
	            endif

	            //秘 - 绝不恻隐刀
	            if( funcs_isOwnItem(attackUnit, ITEM_mysterious_compassion_blade) and IsUnitAliveBJ(beUnit) == TRUE ) then
		            set charges = items_getItemCharges(attackUnit, ITEM_mysterious_compassion_blade)
	                call attribute_changeAttribute(Tag_Attack,playerIndex,50,3.00*I2R(charges))
	                call attribute_changeAttribute(Tag_Knocking,playerIndex,100,3.00*I2R(charges))
	                call attribute_changeAttribute(Tag_AttackSpeed,playerIndex,20,3.00*I2R(charges))
	            endif

	            //----------------英雄技能-----------
	            //恶魔猎手 - 恨念缠身
	            if( IsUnitInGroup( attackUnit , m1DemonHunter_spell_hennianchanshen_group ) == true ) then
	                set skillLv = GetUnitAbilityLevel( attackUnit , m1DemonHunter_spell_hennianchanshen )
	                if( skillLv > 0 ) then
	                    call funcs_huntBySelf( skillLv * 100 , attackUnit, beUnit )
	                endif
	            endif
	            //恶魔猎手 - 鬼影
	            set skillLv = GetUnitAbilityLevel( attackUnit , m1DemonHunter_spell_guiying )
	            if( skillLv > 0 and m1DemonHunter_spell_guiying_current_qty[playerIndex] < m1DemonHunter_spell_guiying_max_qty and GetRandomInt(1,100) < (skillLv*7) ) then
	                set loc = GetUnitLoc( beUnit )
	                call funcs_effectPoint( Effect_MirrorDemon , loc )
	                if( GetUnitTypeId(attackUnit) == Hero_demon_hunter_sp  ) then
	                    set createUnit = funcs_createUnit( GetOwningPlayer(attackUnit) , m1DemonHunter_spell_guiying_has ,  loc,  loc )
	                else
	                    set createUnit = funcs_createUnit( GetOwningPlayer(attackUnit) , m1DemonHunter_spell_guiying_not ,  loc,  loc )
	                endif
	                set m1DemonHunter_spell_guiying_current_qty[playerIndex] = m1DemonHunter_spell_guiying_current_qty[playerIndex] + 1
	                call m1DemonHunter_guiyingDel( playerIndex , createUnit , 6.00 , true )
	                //神秘附加
				    if( funcs_isOwnItem( attackUnit , ITEM_mysterious_soul_break ) ) then
				        call attribute_copyAttrForShadow( playerIndex , createUnit , 0 , 0.35 , 0.30 , 0.80 )
				    else
				    	call attribute_copyAttrForShadow( playerIndex , createUnit , 0 , 0.20 , 0.30 , 0.80 )
				    endif
	                call SetUnitVertexColorBJ( createUnit , 80 , 80 , 80, 75.00 )
	                call RemoveLocation(loc)
	            endif
	            //山丘之王 - 不凡重击
	            set skillLv = GetUnitAbilityLevel( attackUnit , m1MountainKing_spell_bufanzhongji )
	            if( skillLv > 0 and GetRandomInt(1,100) <= 18 and IsUnitType(beUnit, UNIT_TYPE_STRUCTURE) == true ) then
	                //call funcs_print("山丘之王 - 不凡重击")
	                call skills_punish( beUnit  , 1.00 , 0 )    //僵直
	                call attribute_changeAttribute(Tag_Attack, playerIndex, skillLv * 20 , 7.00)
	                call attribute_changeAttribute(Tag_AttackSpeed, playerIndex , skillLv * 7 , 7.00)
	            endif
            elseif( GetOwningPlayer(beUnit) == Player(PLAYER_NEUTRAL_PASSIVE) ) then
		        //TODO 中立单位情况
		        //none
	        else
		        //TODO 玩家情况
		        //回避判定
	            //如果伤害大于生命35%，回避将被无视
	            if( damage > GetUnitState(beUnit, UNIT_STATE_MAX_LIFE)*0.35 ) then
	                set avoid = 0
	                call funcs_floatMsg( "|cffff0000痛！|r" ,  beUnit  )
	            endif
	            //-----
	            if(GetRandomInt(1, 30000) <= avoid) then
	                call skills_avoid( beUnit )
	                call funcs_floatMsg( "|cffc9ff93回避|r" ,  beUnit  )
                endif

                //Unit - 小型炸弹人
		        if(GetUnitTypeId(attackUnit) == Attacker_xiaoxingzhadan) then
		            call skill_xiaoxingzhadan( attackUnit , beUnit )
		        endif

                //Hero - 被攻击时触发物品事件
		        if((IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == true) and (GetPlayerController(GetOwningPlayer(GetTriggerUnit())) == MAP_CONTROL_USER) ) then

	        	endif
			endif

			//TODO 重新开启此触发
			call EnableTrigger(GetTriggeringTrigger())
		endif

	endfunction

	public function init takes nothing returns nothing
		set m1_Trigger_BeAttacked = CreateTrigger()
	    call TriggerAddAction(m1_Trigger_BeAttacked, function actions )
	endfunction

endlibrary

globals

	trigger m1_Trigger_BeDamaged = null

    integer Buff_System_fantanshanghai = 'B025'        //反弹伤害
    integer Buff_System_yudidaduan = 'B027'        	//御敌打断
    integer Buff_System_yudipoyun = 'B028'        	//御敌破晕
    integer Buff_System_juedifengsheng = 'B029'        //绝地逢生
    integer Buff_System_wushangfantan = 'B026'        //无伤反弹
    integer Buff_System_juebushoushang = 'B024'     	//绝不受伤

endglobals

library m1BeDamaged requires m1BeSpelled

	private function actions takes nothing returns nothing
		local unit beUnit = GetTriggerUnit()                	//受伤单位
	    local unit sourceUnit = GetEventDamageSource()   	//予伤单位
	    local real damage = GetEventDamage()          		//受伤值
	    //---------------------------
	    //玩家档
	    local integer playerIndex = 0
	    local real toughness = 0
	    local real hemophagia = 0
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

		if( damage <=1 or IsUnitAliveBJ(beUnit) == false) then
		    return
	    endif

		//特殊技能
	    if( UnitHasBuffBJ(beUnit, Buff_System_fantanshanghai) ==  TRUE ) then
	        call funcs_huntByToken( damage , beUnit , sourceUnit )
	    endif
	    if( UnitHasBuffBJ(beUnit, Buff_System_yudidaduan) ==  TRUE ) then
	        call skills_break( sourceUnit )
	    endif
	    if( UnitHasBuffBJ(beUnit, Buff_System_yudipoyun) ==  TRUE ) then
	        call skills_swim( sourceUnit , 0.50 )
	    endif
	    if( UnitHasBuffBJ(beUnit, Buff_System_juedifengsheng) ==  TRUE ) then
	        call skills_avoid( beUnit )
	        call skills_addLifeValue( beUnit , damage )
	        return
	    endif
	    if( UnitHasBuffBJ(beUnit, Buff_System_wushangfantan) ==  TRUE ) then
	        call skills_avoid( beUnit )
	        call funcs_huntByToken( damage , beUnit , sourceUnit )
	        return
	    endif
	    if( UnitHasBuffBJ(beUnit, Buff_System_juebushoushang) ==  TRUE ) then
	        call skills_avoid( beUnit )
	        return
	    endif

		//TODO 关闭当前触发器
		call DisableTrigger(GetTriggeringTrigger())

	    if( IsUnitAlly(beUnit, Player_Enemy)==true and IsUnitType(sourceUnit, UNIT_TYPE_HERO) == true) then
	        set playerIndex = GetConvertedPlayerId(GetOwningPlayer(sourceUnit))
	        set hemophagia = I2R(Attr_Hemophagia[playerIndex]) * 0.01
			//TODO ----------------随意触发----------------
	        //吸血
	        if( hemophagia > 0 )then
		        set hemophagia = hemophagia * damage
	            call SetUnitState( sourceUnit , UNIT_STATE_LIFE, (GetUnitState( sourceUnit , UNIT_STATE_LIFE) + hemophagia ) )
	        endif

	        //---------------物品技能-----------
	        //冰石
	        set charges = items_getItemCharges(sourceUnit, ITEM_ice_stone)
	        if(charges > 0) then
	            if(GetRandomReal(1, 100) <= funcs_getOdds(10,0.25,charges)) then
	                set loc = GetUnitLoc( beUnit )
	                call funcs_huntBySelf_BreakDefend( 100.00 , sourceUnit , beUnit )
	                call funcs_effectPoint( Effect_FrostNovaTarget , loc )
	                call RemoveLocation( loc )
	            endif
	        endif
	        //晶体锤
	        set charges = items_getItemCharges(sourceUnit, ITEM_crystal_hammer)
	        if(charges > 0) then
	            if(GetRandomReal(1, 100) <= funcs_getOdds(10,0.25,charges)) then
	                set loc = GetUnitLoc( beUnit )
	                call funcs_huntBySelf_BreakDefend( 150.00 , sourceUnit , beUnit )
	                call funcs_effectPoint( Effect_FrostNovaTarget , loc )
	                call RemoveLocation( loc )
	            endif
	        endif
	        //冰晶三体锤
	        set charges = items_getItemCharges(sourceUnit, ITEM_three_crystal_hammer)
	        if(charges > 0) then
	            if(GetRandomReal(1, 100) <= funcs_getOdds(15,0.25,charges) or UnitHasBuffBJ(sourceUnit, 'B004') == TRUE) then
	                set loc = GetUnitLoc( beUnit )
	                call funcs_huntBySelf_BreakDefend( 250.00 , sourceUnit , beUnit )
	                call funcs_effectPoint( Effect_FrostNovaTarget , loc )
	                call RemoveLocation( loc )
	            endif
	        endif

	        //----------------英雄技能-----------
	        //美杜莎 - 水妖之壁
            set skillLv = GetUnitAbilityLevel( sourceUnit , m1Medusa_spell_shuiyaozhibi )
            if( skillLv > 0 ) then
	            //神秘附加
	            if( funcs_isOwnItem( sourceUnit , ITEM_mysterious_eat_my_tail ) ) then
	                set skillLv = skillLv * 3
	            endif
	            if( GetRandomInt(1,100) <= skillLv ) then
	                set loc = GetUnitLoc( beUnit )
	                call funcs_effectPoint( Effect_NagaDeath, loc )
	                call skills_crashOne( sourceUnit , beUnit , 8 )
	                call funcs_huntBySelf( Attr_Skill[playerIndex] , sourceUnit, beUnit )
	                call RemoveLocation( loc )
	            endif
            endif


	        //----------------神秘----------------
	        //亡者呼声 - 召唤师
	        if( GetUnitTypeId(sourceUnit) == Hero_kael and funcs_isOwnItem(sourceUnit , ITEM_mysterious_ghost_scream) ) then
	            call funcs_huntBySelf( 0.1 * I2R(Attr_SkillDamage[playerIndex]) , sourceUnit, beUnit )
	        endif

	        //霜之哀伤 - 死亡骑士
	        set charges = items_getItemCharges(sourceUnit, ITEM_mysterious_ice_tear)
	        if(charges > 0) then
	            if( GetRandomReal(1, 100) <= 15 ) then
	                set loc = GetUnitLoc( beUnit )
	                call funcs_huntBySelf_BreakDefend( 300.00+150.00*(I2R(charges)-1) , sourceUnit , beUnit )
	                call funcs_effectPoint( Effect_FrostNovaTarget , loc )
	                call RemoveLocation( loc )
	            endif
	        endif
	    elseif( GetOwningPlayer(beUnit) == Player(PLAYER_NEUTRAL_PASSIVE) ) then
	        //TODO 中立单位情况
	    else
	        //TODO 玩家情况
	        if((IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == true) and (GetPlayerController(GetOwningPlayer(GetTriggerUnit())) == MAP_CONTROL_USER) ) then
	        	//TODO Hero - 英雄受伤_回避韧性僵直镜头抖动
	            set playerIndex = GetConvertedPlayerId(GetOwningPlayer(beUnit))
	            set toughness = Attr_Toughness[playerIndex]
	            if( damage * 0.9 - toughness <= 0 ) then
	                set damage  = damage * 0.1
	            else
	                set damage  = damage * 0.1 + (damage * 0.9 - toughness)
	            endif
                //受伤
                //先抵消掉原来的伤害
                call skills_avoid( beUnit )
                if(damage>0.00) then
                    call SetUnitLifeBJ( beUnit , GetUnitStateSwap( UNIT_STATE_LIFE, beUnit )-damage ) //直接扣除计算后血量
                    //镜头抖动
                    if ((GetUnitLifePercent( beUnit ) < 5.00)) then
                        call skills_cameraNoiseSetTarget( GetOwningPlayer( beUnit ), 1.00 , 75.00 )    //摇晃1秒
                    else
                        if (damage> ( 0.10 * GetUnitStateSwap(UNIT_STATE_MAX_LIFE, beUnit )) ) then
                            call skills_cameraNoiseSetEQ( GetOwningPlayer( beUnit ), 0.25 , 2.00 )     //摇晃0.25秒
                        elseif (damage > ( 0.25 * GetUnitStateSwap(UNIT_STATE_MAX_LIFE, beUnit )) ) then
                            call skills_cameraNoiseSetEQ( GetOwningPlayer( beUnit ), 0.30 , 5.00 )
                        elseif (damage > ( 0.50 * GetUnitStateSwap(UNIT_STATE_MAX_LIFE, beUnit )) ) then
                            call skills_cameraNoiseSetEQ( GetOwningPlayer( beUnit ), 0.70 , 10.00 )
                        endif
                    endif
                endif
                //硬直（仅仅只有触发回避时或已经硬直状态，才不减少硬直；即使只受到1点的伤害）
                if(R2I(damage)<1) then
                    set damage = 1.00
                endif
                if( IsUnitPaused(beUnit) == FALSE ) then
                    set Attr_PunishCurrent[playerIndex] = Attr_PunishCurrent[playerIndex] - R2I(damage)
                endif
                if(Attr_PunishCurrent[playerIndex] <= 0 ) then
                    set Attr_PunishCurrent[playerIndex] = Attr_PunishFull[playerIndex]
                    call skills_punish( beUnit , 3.00 , 0 )
                    call funcs_floatMsgWithSize( "|cffc0c0c0僵硬|r", beUnit ,8.00)
                endif
                call attribute_freshStr(playerIndex)

                //TODO Hero - 受伤触发物品事件
	            //镶皮甲
	            set charges = items_getItemCharges(beUnit, ITEM_leather_armor_big)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= 10) then
	                    call attribute_changeAttribute(Tag_LifeBack,playerIndex,2+charges-1,3.00)
	                endif
	            endif
	            //邪骨甲
	            set charges = items_getItemCharges(beUnit, ITEM_leather_armor_born)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= 15) then
	                    call attribute_changeAttribute(Tag_LifeBack,playerIndex,3+charges-1,3.00)
	                endif
	            endif
	            //秘 - 不破盾
	            set charges = items_getItemCharges(beUnit, ITEM_mysterious_kennedy_shield)
	            if(charges > 0) then
	                if(GetUnitLifePercent(beUnit) < 20.00 and GetRandomReal(1, 100) <= funcs_getOdds(50,0.33,charges)) then
	                    call attribute_changeAttribute(Tag_Toughness,playerIndex,100,5.00)
	                endif
	            endif
	            //秘 - 挑衅号角
	            set charges = items_getItemCharges(beUnit, ITEM_mysterious_provoke_horn)
	            if(charges > 0) then
	                call attribute_changeAttribute(Tag_Defend,playerIndex,charges,10.00)
	            endif

	            //TODO Hero - 技能
		        //死亡骑士 - 救赎 - m1
		        if( m1DeathKnight_spell_ghost_soul_status[playerIndex] == true ) then
		            set skillLv = GetUnitAbilityLevel( beUnit , m1DeathKnight_spell_jiushu )
		            if( skillLv > 0 ) then
			            if( m1DeathKnight_spell_ghost_soul[playerIndex] < m1DeathKnight_spell_ghost_soul_limit[playerIndex] ) then
				            //神秘附加
						    if( funcs_isOwnItem( beUnit , ITEM_mysterious_ice_tear ) ) then
						        set val = I2R( skillLv ) * damage * 1.25
						    else
						    	set val = I2R( skillLv ) * damage * 0.25
						    endif
						    if( val < I2R(skillLv*10) ) then
							    set val = I2R(skillLv*10)
						    endif
			                if( m1DeathKnight_spell_ghost_soul[playerIndex]+val >= m1DeathKnight_spell_ghost_soul_limit[playerIndex] ) then
				                call m1DeathKnight_setGhostSoul( playerIndex , m1DeathKnight_spell_ghost_soul_limit[playerIndex] , m1DeathKnight_spell_ghost_soul_limit[playerIndex] )
			                else
			                	call m1DeathKnight_setGhostSoul( playerIndex , m1DeathKnight_spell_ghost_soul[playerIndex] + val , m1DeathKnight_spell_ghost_soul_limit[playerIndex] )
			                endif
			            endif
		            endif
		        endif
		        //死亡骑士 - 反抗命运
		        set skillLv = GetUnitAbilityLevel( beUnit , m1DeathKnight_spell_fankangmingyun )
		        if( skillLv > 0 and GetUnitLifePercent(beUnit) < 30.00 and GetRandomInt(1,100) < (skillLv*4) ) then
		            set val = GetUnitState(beUnit, UNIT_STATE_MAX_LIFE) * 0.01 * I2R(skillLv)
					call SetUnitLifeBJ( beUnit , (GetUnitState(beUnit, UNIT_STATE_LIFE)+val) )
		            if( m1DeathKnight_spell_ghost_soul[playerIndex]+val >= m1DeathKnight_spell_ghost_soul_limit[playerIndex] ) then
			            call m1DeathKnight_setGhostSoul( playerIndex , m1DeathKnight_spell_ghost_soul_limit[playerIndex] , m1DeathKnight_spell_ghost_soul_limit[playerIndex] )
		            else
		            	call m1DeathKnight_setGhostSoul( playerIndex , m1DeathKnight_spell_ghost_soul[playerIndex] + val , m1DeathKnight_spell_ghost_soul_limit[playerIndex] )
		            endif
		        endif
	        endif
		endif

	    //TODO 重新开启此触发
		call EnableTrigger(GetTriggeringTrigger())
	endfunction

	public function init takes nothing returns nothing
		set m1_Trigger_BeDamaged = CreateTrigger()
	    call TriggerAddAction(m1_Trigger_BeDamaged, function actions )
	endfunction

endlibrary


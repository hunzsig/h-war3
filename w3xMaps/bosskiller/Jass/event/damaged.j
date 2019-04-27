globals

    integer Buff_System_fantanshanghai = 'B025'        //反弹伤害
    integer Buff_System_yudidaduan = 'B027'        	//御敌打断
    integer Buff_System_yudipoyun = 'B028'        	//御敌破晕
    integer Buff_System_juedifengsheng = 'B029'        //绝地逢生
    integer Buff_System_wushangfantan = 'B026'        //无伤反弹
    integer Buff_System_juebushoushang = 'B024'     	//绝不受伤

    integer DamageSource_xiaoxingzhadan = 'n00G'  	//Lv1-小型炸弹

    integer Skill_liericaijue_arrow = 'o00G'    			//烈日裁决箭矢

endglobals

library damagedSkill requires skills

    //烈日裁决
    private function sunGunCall takes nothing returns nothing
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
            set temp_unit = funcs_createUnit ( GetOwningPlayer(attackUnit) , Skill_liericaijue_arrow , loc , loc )
            call skills_jump( temp_unit , beUnit , speed , null , hunt , null )
            call funcs_delUnit( temp_unit , 1.00 )
            call RemoveLocation(loc)
        endif
    endfunction

	//烈日裁决
    public function sunGun takes unit attackUnit , unit beUnit , real hunt ,integer qty returns nothing
        local timer t = funcs_setInterval( 0.35 , function sunGunCall )
        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , attackUnit )
        call funcs_setTimerParams_Unit( t , Key_Skill_TargetUnit , beUnit )
        call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt )
        call funcs_setTimerParams_Integer( t , Key_Skill_During , qty )
        call funcs_setTimerParams_Integer( t , Key_Skill_DuringInc , 1 )
    endfunction


endlibrary

function Trig_event_damagedConditions takes nothing returns boolean
    return (  GetEventDamage() > 0.5  and IsUnitAliveBJ(GetTriggerUnit()) == true )
endfunction

function Trig_event_damagedHunt takes nothing returns nothing
	local timer t = GetExpiredTimer()
	local unit fromUnit = funcs_getTimerParams_Unit(t,801)
	local unit beUnit = funcs_getTimerParams_Unit(t,802)
	local real damage = funcs_getTimerParams_Real(t,803)
	local real damage2 = funcs_getTimerParams_Real(t,8032)
	local real oldLife = funcs_getTimerParams_Real(t,804)
	call attribute_addLife(beUnit,-R2I(damage2))
	call SetUnitLifeBJ( beUnit , oldLife )
	//受伤
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

endfunction

//单位受到伤害
//通用触发器
function Trig_event_damagedActions takes nothing returns nothing
    local unit beUnit = GetTriggerUnit()                	//受伤单位
    local unit sourceUnit = GetEventDamageSource()   	//予伤单位
    local real damage = GetEventDamage()          		//受伤值
    local real damage2 = 0
    //---------------------------
    //玩家档
    local integer playerIndex = 0
    local integer attackIndex = 0
    local integer avoid = 0
    local real toughness = 0
    local real hemophagia = 0
    local real split = 0
    local real during = 0
    local integer knocking = 0
    local integer violence = 0
    local real KnockingDamageLv1  = GetEventDamage() * 0.75
    local real KnockingDamageLv2  = GetEventDamage() * 1.50
    local real KnockingDamageLv3  = GetEventDamage() * 3.00
    local real KnockingDamageLvE  = GetEventDamage() * 7.50
    local real ViolenceDamageLv1   = GetEventDamage() * 0.50
    local real ViolenceDamageLv2   = GetEventDamage() * 1.00
    local real ViolenceDamageLv3   = GetEventDamage() * 2.00
    local real ViolenceDamageLvE	= GetEventDamage() * 4.50
    local real last_KnockingDamage = GetEventDamage()	//最终数据
    local real last_ViolenceDamage	= GetEventDamage()	//最终数据
    local boolean isKnocking = false                        //是否已触发物暴
    local boolean isViolence = false                		//是否已触发术暴
    local timer t = null
    //---------------------------
    //技能数据
    local integer skillLv = 0
    //---------------------------
    //攻击触发
    local unit attackUnit = GetEventDamageSource()      //攻击单位
    local integer charges = 0
    local integer odds_stable = 0    //固有几率
    local integer odds_gain = 0     //增量几率
    local location loc = null
    local group temp_group = null
    local unit createUnit = null
    local real val = 0

    //------------------------------------------------------>
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
        call skills_zeroInvulnerable( beUnit )
        call skills_addLifeValue( beUnit , damage )
        set damage = 0
    endif
    if( UnitHasBuffBJ(beUnit, Buff_System_wushangfantan) ==  TRUE ) then
        call skills_zeroInvulnerable( beUnit )
        call funcs_huntByToken( damage , beUnit , sourceUnit )
        set damage = 0
    endif
    if( UnitHasBuffBJ(beUnit, Buff_System_juebushoushang) ==  TRUE ) then
        call skills_zeroInvulnerable( beUnit )
        set damage = 0
    endif

    if( damage <=0 ) then
	    return
    endif

    //TODO 关闭当前触发器
   	call DisableTrigger(GetTriggeringTrigger())

    if( IsUnitAlly(beUnit, Player_Enemy_Building)==true ) then
        //TODO 敌方情况
        if( IsUnitType(sourceUnit, UNIT_TYPE_HERO) == true ) then
	        set playerIndex = GetConvertedPlayerId(GetOwningPlayer(sourceUnit))
	        set attackIndex = GetConvertedPlayerId(GetOwningPlayer(attackUnit))
	        set knocking = Attr_Knocking[playerIndex]
	        set violence = Attr_Violence[playerIndex]
	        set hemophagia = I2R(Attr_Hemophagia[playerIndex]) * 0.01
	        set split = I2R(Attr_Split[playerIndex]) * 0.01

			//TODO ----------------随意触发----------------

	        //吸血
	        if( hemophagia > 0 )then
		        set hemophagia = hemophagia * damage
	            call SetUnitState( sourceUnit , UNIT_STATE_LIFE, (GetUnitState( sourceUnit , UNIT_STATE_LIFE) + hemophagia ) )
	        endif

	        //---------------物品技能-----------
	        //冰晶三体锤
	        set charges = items_getItemCharges(sourceUnit, ITEM_three_crystal_hammer)
	        if(charges > 0) then
	            if(GetRandomReal(1, 100) <= funcs_getOdds(10,0.33,charges) or UnitHasBuffBJ(sourceUnit, 'B004') == TRUE) then
	                set loc = GetUnitLoc( beUnit )
	                call funcs_huntBySelf_BreakDefend( 200.00 , sourceUnit , beUnit )
	                call funcs_effectPoint( Effect_FrostNovaTarget , loc )
	                call RemoveLocation( loc )
	            endif
	        endif

	        //----------------英雄技能-----------
	        //美杜莎 - 水妖之壁 - normal
            set skillLv = GetUnitAbilityLevel( sourceUnit , MEDUSA_NORMAL_shuiyaozhibi )
            if( skillLv > 0 ) then
	            //神秘附加
	            if( funcs_isOwnItem( sourceUnit , ITEM_mysterious_wind_sound ) ) then
	                set skillLv = skillLv * 2
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
	            if( GetRandomReal(1, 100) <= funcs_getOdds(15,0.75,charges) ) then
	                set loc = GetUnitLoc( beUnit )
	                call funcs_huntBySelf_BreakDefend( 250.00 , sourceUnit , beUnit )
	                call funcs_effectPoint( Effect_FrostNovaTarget , loc )
	                call RemoveLocation( loc )
	            endif
	        endif

			set attackIndex = GetConvertedPlayerId(GetOwningPlayer(attackUnit))
			if( IsUnitInGroup( beUnit , Group_BeAttack_Fake[attackIndex] ) == true and IsUnitInGroup( attackUnit , Group_Attack_Fake[attackIndex] ) == true) then
				call GroupRemoveUnit( Group_BeAttack_Fake[attackIndex] , beUnit )
				call GroupRemoveUnit( Group_Attack_Fake[attackIndex] , attackUnit )

		        //TODO ----------------需要攻击触发----------------

	            //------------------分裂------------------------
	            if( split>0 )then
	                set split = split * damage
	                set loc = GetUnitLoc( beUnit )
	                set temp_group = funcs_getGroupByPoint( loc ,200.00,function filter_live_disbuild )
	                call funcs_huntGroup_BreakDefend( temp_group , sourceUnit , split ,Effect_Split,null,FILTER_ENEMY)
	                call DestroyGroup( temp_group )
	                call RemoveLocation( loc )
	            endif

				//------------------物暴------------------------
		        if( isKnocking == false and knocking > 20000 and GetRandomInt(1, 100) <= 5) then
	                call funcs_huntByToken( KnockingDamageLvE, sourceUnit , beUnit )
	                call funcs_floatMsg("|cffff0000极致一击"+I2S(R2I(KnockingDamageLvE))+"!！|r"  , beUnit)
	                set last_KnockingDamage = KnockingDamageLvE
	                set loc = GetUnitLoc( beUnit )
	                call funcs_effectPoint( Effect_red_shatter , loc )
	                call RemoveLocation(loc)
	                set isKnocking = true
		        endif
		        if( isKnocking == false and knocking > 7500 and GetRandomInt(7500, 20000) <= knocking) then
		            call funcs_huntByToken( KnockingDamageLv3, sourceUnit , beUnit )
		            call funcs_floatMsg("|cffff0000绝击"+I2S(R2I(KnockingDamageLv3))+"!！|r"  , beUnit)
		            set last_KnockingDamage = KnockingDamageLv3
		            set isKnocking = true
		        endif
		        if( isKnocking == false and knocking > 3000 and GetRandomInt(3000, 7500) <= knocking ) then
		            call funcs_huntByToken( KnockingDamageLv2, sourceUnit , beUnit )
		            call funcs_floatMsg("|cffff0000爆击"+I2S(R2I(KnockingDamageLv2))+"！|r"  , beUnit)
		            set last_KnockingDamage = KnockingDamageLv2
		            set isKnocking = true
		        endif
		        if( isKnocking == false and GetRandomInt(1, 3000) <= knocking ) then
			        call funcs_huntByToken( KnockingDamageLv1, sourceUnit , beUnit )
		            call funcs_floatMsg("|cfff96206暴击"+I2S(R2I(KnockingDamageLv1))+"！|r"  , beUnit)
		            set last_KnockingDamage = KnockingDamageLv1
		            set isKnocking = true
		        endif

	            //----------------物品技能-----------
	             //雷石
	            set charges = items_getItemCharges(attackUnit, ITEM_thunder_stone )
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(3,0.33,charges)) then
	                    call skills_thunderLink(attackUnit,beUnit,Skill_ThunderLink_3_150)
	                endif
	            endif
	            //雷电之锤
	            set charges = items_getItemCharges(attackUnit, ITEM_thunder_hammer )
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(3,0.33,charges)) then
	                    call skills_thunderLink(attackUnit,beUnit,Skill_ThunderLink_3_250)
	                endif
	            endif
	            //雷霆之锤
	            set charges = items_getItemCharges(attackUnit, ITEM_super_thunder_hammer)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(5,0.33,charges)) then
	                    call skills_thunderLink(attackUnit,beUnit,Skill_ThunderLink_5_350)
	                endif
	            endif
	            //雷神之锤
	            set charges = items_getItemCharges(attackUnit, ITEM_god_thunder_hammer)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(7,0.33,charges)) then
	                    call skills_thunderLink(attackUnit,beUnit,Skill_ThunderLink_7_450)
	                endif
	            endif
	            //圣枪
	            set charges = items_getItemCharges(attackUnit, ITEM_holy_spear)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(7,0.33,charges)) then
	                    call attribute_changeAttribute(Tag_Attack,playerIndex,200,5.00)
	                endif
	            endif
	            //夺命枪
	            set charges = items_getItemCharges(attackUnit, ITEM_deadly_spear)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(15,0.33,charges)) then
	                    call attribute_changeAttribute(Tag_Attack,playerIndex,325,5.00)
	                endif
	            endif
	            //激爆刃
	            set charges = items_getItemCharges(attackUnit, ITEM_burst_dagger )
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(5,0.33,charges)) then
	                    call funcs_huntBySelf_BreakDefend( 125.00 , attackUnit , beUnit )
	                    set loc = GetUnitLoc( beUnit )
	                    call funcs_effectPoint( Effect_red_shatter , loc )
	                    call RemoveLocation(loc)
	                endif
	            endif
	            //激爆炸裂
	            set charges = items_getItemCharges(attackUnit, ITEM_crazy_burst_dagger)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(7,0.33,charges)) then
	                    call funcs_huntBySelf_BreakDefend( 300.00 , attackUnit , beUnit )
	                    set loc = GetUnitLoc( beUnit )
	                    call funcs_effectPoint( Effect_red_shatter , loc )
	                    call RemoveLocation(loc)
	                endif
	            endif
	            //猛犸之锤
	            set charges = items_getItemCharges(attackUnit, ITEM_mammoth_hammer)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(5,0.33,charges)) then
	                    call skills_swim( beUnit , 0.5 )
	                endif
	            endif
	            //猛犸巨岩锤
	            set charges = items_getItemCharges(attackUnit, ITEM_mammoth_earth_hammer)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(10,0.33,charges)) then
	                    call skills_swim( beUnit , 1 )
	                endif
	            endif
	            //血鬼爪牙
	            if( funcs_isOwnItem(attackUnit, ITEM_blood_ghost_paw) and IsUnitAliveBJ(beUnit) == TRUE ) then
	                call attribute_changeAttribute(Tag_Hemophagia,playerIndex,1,20.00)
	            endif

	            //绝不恻隐刀
	            if( funcs_isOwnItem(attackUnit, ITEM_mysterious_compassion_blade) and IsUnitAliveBJ(beUnit) == TRUE ) then
	                call attribute_changeAttribute(Tag_Attack,playerIndex,50,12.00)
	                call attribute_changeAttribute(Tag_Knocking,playerIndex,100,12.00)
	                call attribute_changeAttribute(Tag_AttackSpeed,playerIndex,20,12.00)
	            endif
	            //灭世魔刀
	            if( funcs_isOwnItem(attackUnit, ITEM_mix_demon_sword) and IsUnitAliveBJ(beUnit) == TRUE ) then
	            	set charges = items_getItemCharges(attackUnit, ITEM_mix_demon_sword)
	                call attribute_changeAttribute(Tag_Quick,playerIndex,25,funcs_getOdds(4,0.50,charges))
	            endif
	            //狮狂大剑
	            if( funcs_isOwnItem(attackUnit, ITEM_lion_big_sword) and IsUnitAliveBJ(beUnit) == TRUE ) then
	            	set charges = items_getItemCharges(attackUnit, ITEM_lion_big_sword)
	                set loc = GetUnitLoc( attackUnit )
	                set temp_group = funcs_getGroupByPoint( loc ,150.00,function filter_live_disbuild )
	                call funcs_huntGroup_BreakDefend( temp_group , sourceUnit , 50*I2R(charges) , Effect_red_shatter ,null, FILTER_ENEMY)
	                call DestroyGroup( temp_group )
	                call RemoveLocation( loc )
	            endif
	            //雄狮斩火刀
	            if( funcs_isOwnItem(attackUnit, ITEM_lion_fire_fight) and IsUnitAliveBJ(beUnit) == TRUE ) then
	            	set charges = items_getItemCharges(attackUnit, ITEM_lion_fire_fight)
	                set loc = GetUnitLoc( attackUnit )
	                set temp_group = funcs_getGroupByPoint( loc , 200.00 ,function filter_live_disbuild )
	                call funcs_huntGroup_BreakDefend( temp_group , sourceUnit , 235*I2R(charges) , Effect_red_shatter ,null, FILTER_ENEMY)
	                call DestroyGroup( temp_group )
	                call RemoveLocation( loc )
	            endif
	            //烈日裁决
	            set charges = items_getItemCharges(attackUnit, ITEM_sun_gun)
	            if(charges > 0) then
	                if(GetRandomReal(1, 100) <= funcs_getOdds(12,0.25,charges) ) then
	                    call damagedSkill_sunGun( attackUnit , beUnit , 150 , 3 )
	                endif
	            endif

	            //----------------英雄技能-----------
	            //恶魔猎手 - 恨念缠身
	            if( IsUnitInGroup( sourceUnit , DEMONHUNTER_NORMAL_hennianchanshen_group ) == true ) then
	                set skillLv = GetUnitAbilityLevel( attackUnit , DEMONHUNTER_NORMAL_hennianchanshen )
	                if( skillLv > 0 ) then
	                    call funcs_huntBySelf( skillLv * 300 , attackUnit, beUnit )
	                endif
	            endif
	            //恶魔猎手 - 鬼影
	            set skillLv = GetUnitAbilityLevel( attackUnit , DEMONHUNTER_NORMAL_guiying )
	            if( skillLv > 0 and DEMONHUNTER_NORMAL_guiying_current_qty[playerIndex] < DEMONHUNTER_NORMAL_guiying_max_qty and GetRandomInt(1,100) < (skillLv*10) ) then
	                set loc = GetUnitLoc( beUnit )
	                call funcs_effectPoint( Effect_MirrorDemon , loc )
	                if( GetUnitTypeId(attackUnit) == Hero_demon_hunter_sp  ) then
	                    set createUnit = funcs_createUnit( GetOwningPlayer(attackUnit) , DEMONHUNTER_NORMAL_guiying_has ,  loc,  loc )
	                else
	                    set createUnit = funcs_createUnit( GetOwningPlayer(attackUnit) , DEMONHUNTER_NORMAL_guiying_not ,  loc,  loc )
	                endif
	                set DEMONHUNTER_NORMAL_guiying_current_qty[playerIndex] = DEMONHUNTER_NORMAL_guiying_current_qty[playerIndex] + 1
	                call demonHunterNormal_guiyingDel( playerIndex , createUnit , 6.00 , true )
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
	            set skillLv = GetUnitAbilityLevel( attackUnit , MOUNTAINKING_NORMAL_bufanzhongji )
	            if( skillLv > 0 and GetRandomInt(1,100) <= 18 and IsUnitType(beUnit, UNIT_TYPE_STRUCTURE) != true ) then
	                call skills_punish( beUnit  , 2.50 , 0 )    //僵直
	                call attribute_changeAttribute(Tag_Attack, playerIndex, skillLv * 50 , 10.00)
	                call attribute_changeAttribute(Tag_AttackSpeed, playerIndex , skillLv * 15 , 10.00)
	            endif
	            //蝠王 - 伏夜
	            set skillLv = GetUnitAbilityLevel( attackUnit , batKing_ab_fuye )
	            if( skillLv > 0 and IsUnitType(beUnit, UNIT_TYPE_STRUCTURE) != true ) then
	            	set during = 60 + I2R(skillLv)*30
	            	//神秘附加
				    if( funcs_isOwnItem( attackUnit , ITEM_mysterious_moon_stone) ) then
				        set during = during + 20
				    endif
	                call attribute_changeAttribute(Tag_Attack, playerIndex, 5 , during)
	                call attribute_changeAttribute(Tag_AttackSpeed, playerIndex , 1 , during)
	                call attribute_changeAttribute(Tag_Move, playerIndex , 1 , during)
	                call attribute_changeAttribute(Tag_Hemophagia, playerIndex , 1 , during)
	                call attribute_changeAttribute(Tag_Split, playerIndex , 1 , during)
	            endif

			else

				//TODO ----------------需要非攻击触发----------------

				//------------------术暴------------------------
		        if( isViolence == false and violence > 15000 and GetRandomInt(1, 100) == 77) then
	                call funcs_huntByToken( ViolenceDamageLvE, sourceUnit , beUnit )
	                call funcs_floatMsg("|cff8080ff惊天奇术"+I2S(R2I(ViolenceDamageLvE))+"!！|r"  , beUnit)
	                set last_ViolenceDamage = ViolenceDamageLvE
	                set loc = GetUnitLoc( beUnit )
	                call funcs_effectPoint( Effect_ManaFlareBoltImpact , loc )
	                call RemoveLocation(loc)
	                set isViolence = true
		        endif
		        if( isViolence == false and violence > 7500 and GetRandomInt(7500, 15000) <= violence) then
		            call funcs_huntByToken( ViolenceDamageLv3, sourceUnit , beUnit )
		            call funcs_floatMsg("|cff8080ff爆击"+I2S(R2I(ViolenceDamageLv3))+"!！|r"  , beUnit)
		            set last_ViolenceDamage = ViolenceDamageLv3
		            set isViolence = true
		        endif
		        if( isViolence == false and violence > 3000 and GetRandomInt(3000, 7500) <= violence ) then
		            call funcs_huntByToken( ViolenceDamageLv2, sourceUnit , beUnit )
		            call funcs_floatMsg("|cff00ffff暴击"+I2S(R2I(ViolenceDamageLv2))+"！|r"  , beUnit)
		            set last_ViolenceDamage = ViolenceDamageLv2
		            set isViolence = true
		        endif
		        if( isViolence == false and GetRandomInt(1, 3000) <= violence ) then
			        call funcs_huntByToken( ViolenceDamageLv1, sourceUnit , beUnit )
		            call funcs_floatMsg("|cff80ffff暴击"+I2S(R2I(ViolenceDamageLv1))+"！|r"  , beUnit)
		            set last_ViolenceDamage = ViolenceDamageLv1
		            set isViolence = true
		        endif

	        endif

        endif

    elseif( GetOwningPlayer(beUnit) == Player(PLAYER_NEUTRAL_PASSIVE) ) then
        //TODO 中立单位情况
    else
        //TODO 玩家情况
        //Unit - 小型炸弹人
        if(GetUnitTypeId(sourceUnit) == DamageSource_xiaoxingzhadan) then
            call eventDamagedAction_xiaoxingzhadan( sourceUnit , beUnit )
        endif
        //Hero - 英雄受伤_回避韧性僵直镜头抖动
        if((IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == true) and (GetPlayerController(GetOwningPlayer(GetTriggerUnit())) == MAP_CONTROL_USER) ) then
            set playerIndex = GetConvertedPlayerId(GetOwningPlayer(beUnit))
            set avoid = Attr_Avoid[playerIndex]
            set toughness = Attr_Toughness[playerIndex]
            if( damage * 0.9 - toughness <= 0 ) then
                set damage  = damage * 0.1
            else
                set damage  = damage * 0.1 + (damage * 0.9 - toughness)
            endif

            //回避 75%
            if (avoid > 10000) then
                set avoid = 10000
            endif

            //如果伤害大于生命35%，回避将被无视
            if( damage > GetUnitState(beUnit, UNIT_STATE_MAX_LIFE)*0.35 ) then
                set avoid = 0
                call funcs_floatMsg( "|cffff0000痛击！|r" ,  beUnit  )
            endif
            //-----
            if(GetRandomInt(1, 13334) <= avoid) then
                set damage = 0.000
                call funcs_floatMsg( "|cffc9ff93回避|r" ,  beUnit  )
            endif

            call attribute_addLife(beUnit,R2I(damage2))
			set t = funcs_setTimeout(0,function Trig_event_damagedHunt)
			call funcs_setTimerParams_Unit(t,801,sourceUnit)
			call funcs_setTimerParams_Unit(t,802,beUnit)
			call funcs_setTimerParams_Real(t,803,damage)
			call funcs_setTimerParams_Real(t,8032,damage2)
			call funcs_setTimerParams_Real(t,804,GetUnitStateSwap( UNIT_STATE_LIFE, beUnit ))

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
        endif
        //Hero - 受伤触发物品事件
        if((IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == true) and (GetPlayerController(GetOwningPlayer(GetTriggerUnit())) == MAP_CONTROL_USER) ) then
            set playerIndex = GetConvertedPlayerId(GetOwningPlayer(beUnit))
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
                call attribute_changeAttribute(Tag_Defend,playerIndex,1,10.00)
            endif
        endif
        //-------Hero - 技能-------
        //死亡骑士 - 救赎
        if( DEATHKNIGHT_NORMAL_ghost_soul_status[playerIndex] == true ) then
            set skillLv = GetUnitAbilityLevel( beUnit , DEATHKNIGHT_NORMAL_jiushu )
            if( skillLv > 0 ) then
	            if( DEATHKNIGHT_NORMAL_ghost_soul[playerIndex] < DEATHKNIGHT_NORMAL_ghost_soul_limit[playerIndex] ) then
		            //神秘附加
				    if( funcs_isOwnItem( beUnit , ITEM_mysterious_ice_tear ) ) then
				        set val = I2R( skillLv ) * damage * 1.25
				    else
				    	set val = I2R( skillLv ) * damage * 0.25
				    endif
				    if( val < I2R(skillLv*20) ) then
					    set val = I2R(skillLv*20)
				    endif
	                if( DEATHKNIGHT_NORMAL_ghost_soul[playerIndex]+val >= DEATHKNIGHT_NORMAL_ghost_soul_limit[playerIndex] ) then
		                call deathKnightNormal_setGhostSoul( playerIndex , DEATHKNIGHT_NORMAL_ghost_soul_limit[playerIndex] , DEATHKNIGHT_NORMAL_ghost_soul_limit[playerIndex] )
	                else
	                	call deathKnightNormal_setGhostSoul( playerIndex , DEATHKNIGHT_NORMAL_ghost_soul[playerIndex] + val , DEATHKNIGHT_NORMAL_ghost_soul_limit[playerIndex] )
	                endif
	            endif
            endif
        endif
        //死亡骑士 - 反抗命运
        set skillLv = GetUnitAbilityLevel( beUnit , DEATHKNIGHT_NORMAL_fankangmingyun )
        if( skillLv > 0 and GetUnitLifePercent(beUnit) < 30.00 and GetRandomInt(1,100) < (skillLv*4) ) then
            set val = GetUnitState(beUnit, UNIT_STATE_MAX_LIFE) * 0.01 * I2R(skillLv)
			call SetUnitLifeBJ( beUnit , (GetUnitState(beUnit, UNIT_STATE_LIFE)+val) )
            if( DEATHKNIGHT_NORMAL_ghost_soul[playerIndex]+val >= DEATHKNIGHT_NORMAL_ghost_soul_limit[playerIndex] ) then
	            call deathKnightNormal_setGhostSoul( playerIndex , DEATHKNIGHT_NORMAL_ghost_soul_limit[playerIndex] , DEATHKNIGHT_NORMAL_ghost_soul_limit[playerIndex] )
            else
            	call deathKnightNormal_setGhostSoul( playerIndex , DEATHKNIGHT_NORMAL_ghost_soul[playerIndex] + val , DEATHKNIGHT_NORMAL_ghost_soul_limit[playerIndex] )
            endif
        endif
    endif

    //TODO 重新开启此触发
	call EnableTrigger(GetTriggeringTrigger())

endfunction

//===========================================================================
function InitTrig_event_damaged takes nothing returns nothing
    set gg_trg_event_damaged = CreateTrigger()
    call TriggerAddCondition(gg_trg_event_damaged, Condition(function Trig_event_damagedConditions))
    call TriggerAddAction(gg_trg_event_damaged, function Trig_event_damagedActions)
endfunction


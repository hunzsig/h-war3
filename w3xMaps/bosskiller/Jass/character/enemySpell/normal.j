globals

	trigger Boss_Spell_Trigger_Normal = CreateTrigger()

	trigger Boss_Spell_Trigger_Normal_Bombs = CreateTrigger()

endglobals

library characterEnemySpellNormal requires characterEnemySpellAbstract

	//炸弹 - 回调
	private function action_Bombs takes nothing returns nothing
		local unit bomb = GetTriggerUnit()
		local unit killer = GetKillingUnit()
	    local location loc = null
	    local group g = null
	    local real hunt = 0
	    local unit u = null
	    if( killer == null ) then
		    set loc = GetUnitLoc( bomb )
			call funcs_effectPoint( Effect_NewMassiveEX , loc )
		    call funcs_effectPoint( Effect_ImpaleTargetDust , loc )
		    set g = funcs_getGroupByPoint( loc , 145.00 , function filterTrigger_enemy_live_disbuild )
		    call RemoveLocation( loc )
		    loop
	            exitwhen(IsUnitGroupEmptyBJ(g) == true)
	                set u = FirstOfGroup(g)
	                call GroupRemoveUnit( g , u )
	                set loc = GetUnitLoc(u)
	                set hunt = GetUnitState( u , UNIT_STATE_MAX_LIFE) * 0.25
					call funcs_huntBySelf( hunt , bomb ,u)
	                call funcs_effectPoint(Effect_Incinerate,loc)
	                call RemoveLocation(loc)
	        endloop
		    call GroupClear(g)
		    call DestroyGroup(g)
		endif
	    call RemoveUnit(bomb)
	endfunction

	//受伤判定
	private function action takes nothing returns nothing
		local unit boss = GetTriggerUnit()
	    local unit damageSource = GetEventDamageSource()
	    local real damage = GetEventDamage()
	    local integer i = 0
	    local location loc = null
	    local location targetLoc = null
	    local integer damageSourceIndex = GetConvertedPlayerId(GetOwningPlayer(damageSource))
	    local real bossLifeRate = GetUnitState(boss, UNIT_STATE_LIFE) / GetUnitState(boss, UNIT_STATE_MAX_LIFE)
	    local real bossDamegeBase = GetUnitState(damageSource, UNIT_STATE_MAX_LIFE) + Attr_Toughness[damageSourceIndex] * 0.75
	    local real punishMax = GetUnitState(boss, UNIT_STATE_MAX_LIFE) * 0.40
	    local integer avoidInt = R2I(1/bossLifeRate)

		//->技能不触发<-
		//#伤害不足30时
		//#是镜像时
		//#被硬直
		//#已死亡
	    if( damage < 30 or IsUnitIllusionBJ(boss) == true or IsUnitPaused(boss) == true or IsUnitAliveBJ(boss) == false ) then
		    return
		endif
		//#伤害来源是建筑
		if( IsUnitType(damageSource, UNIT_TYPE_STRUCTURE) == true ) then
			return
		endif
		//#伤害来源非玩家单位能触发
		if((GetPlayerController(GetOwningPlayer(damageSource)) != MAP_CONTROL_USER) or (GetPlayerSlotState(GetOwningPlayer(damageSource)) != PLAYER_SLOT_STATE_PLAYING)) then
			return
		endif

		//硬直
		call characterEnemySpellAbstract_punish( boss , damage , punishMax )

		//共享技能
		if( GetUnitTypeId(boss) == Enemy_Config_Last_Final_boss ) then
			//TODO最终boss时
			//@绝对无视召唤物
		    if(IsUnitType(damageSource, UNIT_TYPE_SUMMONED) == true) then
		        call KillUnit( damageSource )
		    endif
			//@90%几率触发无敌，冷却60，持续8.0
		    if( GetRandomInt(1,100) <= 90 ) then
				call characterEnemySpellAbstract_invincible( 60 , boss , 8.00 )
		    endif
			//@<90%>几率回避，冷却0.1秒
			if( GetUnitTypeId(damageSource) == Unit_Token_Hunt_Not_Avoid ) then
	            //如果伤害的单位是无视回避类，则不计算
	        elseif( bossLifeRate > 0.8 ) then
	           //如果BOSS血量在80%以上则不计算回避
	        elseif( damage > GetUnitState(boss, UNIT_STATE_MAX_LIFE)*0.35 ) then
	            //如果伤害大于生命35%，回避将被无视
	            call funcs_floatMsg( "|cffff0000嗷！好痛！|r" ,  boss  )
	        else
	        	call characterEnemySpellAbstract_avoid ( 0.05 , boss , 99 )
        	endif
			//@25%几率晕破吼，冷却6.5秒，范围1000，伤害750
			if( GetRandomInt(1,100) <= 25 and IsUnitType(damageSource, UNIT_TYPE_HERO) == true ) then
				call characterEnemySpellAbstract_breakHowl ( 6.5 , boss , 1000 , 750 )
			endif
			//@召唤小弟，30秒，内部分发
			call characterEnemySpellAbstract_callBrother ( 30 , boss )
		else
			//TODO 其他单位
			//@对召唤物造成20%生命伤害
		    if(IsUnitType(damageSource, UNIT_TYPE_SUMMONED) == true) then
		        call SetUnitLifeBJ( damageSource , GetUnitState(damageSource, UNIT_STATE_LIFE) - (I2R(DIFF)*0.2*GetUnitState(damageSource, UNIT_STATE_MAX_LIFE)))
		    endif
			//@75%几率触发无敌，冷却45，持续3.5
		    if( GetRandomInt(1,100) <= 75 ) then
				call characterEnemySpellAbstract_invincible( 45 , boss , 3.50 )
		    endif
		    //@70%几率回避，冷却0.25秒
		    if( GetUnitTypeId(damageSource) == Unit_Token_Hunt_Not_Avoid ) then
	            //如果伤害的单位是无视回避类，则不计算
	        elseif( bossLifeRate > 0.8 ) then
	            //如果BOSS血量在80%以上则不计算回避
	        elseif( damage > GetUnitState(boss, UNIT_STATE_MAX_LIFE)*0.25 ) then
	            //如果伤害大于生命25%，回避将被无视
	            call funcs_floatMsg( "|cffff0000嗷！好痛！|r" ,  boss  )
	        else
	        	call characterEnemySpellAbstract_avoid ( 0.20 , boss , 85 )
        	endif
		    //@15%几率晕破吼，冷却10.0秒，范围600，伤害350
		    if( GetRandomInt(1,100) <= 15 and IsUnitType(damageSource, UNIT_TYPE_HERO) == true ) then
				call characterEnemySpellAbstract_breakHowl ( 10.0 , boss , 600 , 350 )
			endif
			//@召唤小弟，40秒，内部分发
			call characterEnemySpellAbstract_callBrother ( 40 , boss )
		endif

		/* 特殊技能 - 只有英雄会触发 */
		if( IsUnitType(damageSource, UNIT_TYPE_HERO) == true ) then
			//LAST
			if( GetUnitTypeId(boss) == 'n02Q' ) then		//锯裂机车
				//@30%几率触发锯裂机车JUMP，冷却10
			    if( GetRandomInt(1,100) <= 30 ) then
					call characterEnemySpellAbstract_jump( 10 , boss , damageSource , 20 , Effect_ImpaleTargetDust , bossDamegeBase*0.43 , Effect_red_shatter )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02U' ) then	//守卫强暴者
				//@10%几率触发炸弹，冷却15 ， 数量7
			    if( GetRandomInt(1,100) <= 10 ) then
					call characterEnemySpellAbstract_summon( 10 , boss , 'n02V' , 7 , 125 , 5.00 , Boss_Spell_Trigger_Normal_Bombs )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02R' ) then	//死神
				//@9%几率触发穿梭，冷却75 , 30次
			    if( GetRandomInt(1,100) <= 9 ) then
					call characterEnemySpellAbstract_shuttle( 75 , boss , 1000 , 45 , 30 , null , bossDamegeBase*0.08 , Effect_ReplenishManaCaster )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02T' ) then	//无冕帝王
			elseif( GetUnitTypeId(boss) == 'n02S' ) then	//DarkEle
				//@5%几率触发DarkEle踏，冷却75，30个影子
			    if( GetRandomInt(1,100) <= 5 ) then
					call characterEnemySpellAbstract_canyingta( 75 , boss , 30 , 'o00S' , bossDamegeBase*0.24)
			    endif
			endif
			//BOSS
			if( GetUnitTypeId(boss) == 'n004' ) then		//巨石人
				//@9%几率触发巨石残影踏，冷却45，15个影子
			    if( GetRandomInt(1,100) <= 9 ) then
					call characterEnemySpellAbstract_canyingta( 45 , boss ,15 , 'o00N' , bossDamegeBase*0.09)
			    endif
			elseif( GetUnitTypeId(boss) == 'n00M' ) then	//怖残像狼
				//@9%几率触发狼咬，冷却20
			    if( GetRandomInt(1,100) <= 9 ) then
					call characterEnemySpellAbstract_leap(20 , boss , damageSource , 350 , 30 , null , bossDamegeBase*0.45 , Effect_Boold_Cut , false)
			    endif
			elseif( GetUnitTypeId(boss) == 'n03K' ) then	//提灯白牛
				//@7%几率触发白牛JUMP，冷却35
			    if( GetRandomInt(1,100) <= 7 ) then
					call characterEnemySpellAbstract_jump( 35 , boss , damageSource , 13 , Effect_CrushingWhiteRing , bossDamegeBase*0.45 , Effect_DarkLightningNova )
			    endif
			elseif( GetUnitTypeId(boss) == 'n01O' ) then	//军统领
				//@7%几率触发光明炮，8道，冷却60，距离1600，速度13，不重叠伤害
			    if( GetRandomInt(1,100) <= 7 ) then
					call characterEnemySpellAbstract_multiLeap(60, 'o00O' , boss , damageSource , 1600 , 13 , null , 8 , 45 , bossDamegeBase*0.48 , Effect_LightStrikeArray , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n01K' ) then	//食人大佬
				//@7%几率触发鬼巨人撞击，冷却65
			    if( GetRandomInt(1,100) <= 7 ) then
					call characterEnemySpellAbstract_charge(65 , boss , damageSource , SKILL_CHARGE_CRASH , 600 , 25 , Effect_ImpaleTargetDust , bossDamegeBase*0.80 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n005' ) then	//群暴食尸鬼
				//@9%几率触发尸鬼冲击，冷却27
			    if( GetRandomInt(1,100) <= 9 ) then
					call characterEnemySpellAbstract_leap(27 , boss , damageSource , 350 , 45 , null , bossDamegeBase*0.50 , Effect_Boold_Cut , false)
			    endif
			elseif( GetUnitTypeId(boss) == 'n020' ) then	//鬼巨人
				//@9%几率触发鬼巨人撞击，冷却60
			    if( GetRandomInt(1,100) <= 9 ) then
					call characterEnemySpellAbstract_charge(60 , boss , damageSource , SKILL_CHARGE_FLY , 500 , 20 , Effect_ImpaleTargetDust , bossDamegeBase*0.65 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n03Z' ) then	//疯狂大炮
				//@5%几率触发大炮冲击，冷却80
			    if( GetRandomInt(1,100) <= 5 ) then
					call characterEnemySpellAbstract_chargeToken(80 , boss , 'o00R' , damageSource , SKILL_CHARGE_DRAG , 1500 , 25 , null , bossDamegeBase*0.75 , Effect_ExplosionBIG , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n00K' ) then	//炸弹魔
				//@10%几率触发炸弹，冷却12 ， 数量4
			    if( GetRandomInt(1,100) <= 10 ) then
					call characterEnemySpellAbstract_summon( 12 , boss , 'n02V' , 4 , 125 , 5.00 , Boss_Spell_Trigger_Normal_Bombs )
			    endif
			elseif( GetUnitTypeId(boss) == 'n01Y' ) then	//奇美拉
				//@10%几率触发炸弹，冷却50 ， 数量9
			    if( GetRandomInt(1,100) <= 10 ) then
					call characterEnemySpellAbstract_summon( 50 , boss , 'u00Z' , 9 , 135 , 12.00 , null )
			    endif
			elseif( GetUnitTypeId(boss) == 'n00N' ) then	//鬼狼蛛
				//@15%几率触发狼蛛JUMP，冷却7
			    if( GetRandomInt(1,100) <= 15 ) then
					call characterEnemySpellAbstract_jump( 15 , boss , damageSource , 20 , Effect_HydraCorrosiveGroundEffect , bossDamegeBase*0.16 , Effect_GreatElderHydraAcidSpew )
			    endif
			elseif( GetUnitTypeId(boss) == 'n03G' ) then	//狮鹫
				//@10%几率触发乱锤阵，冷却55 ， 数量25
			    if( GetRandomInt(1,100) <= 10 ) then
					call characterEnemySpellAbstract_summon( 55 , boss , 'u00Y' , 25 , 50 , 10.00 , null )
			    endif
			elseif( GetUnitTypeId(boss) == 'n040' ) then	//外道魔导师
				//@9%几率触发龙卷风，冷却19
			    if( GetRandomInt(1,100) <= 9 ) then
					call characterEnemySpellAbstract_chargeToken(19 , boss , 'o00T' , damageSource , SKILL_CHARGE_DRAG , 800 , 35 , null , bossDamegeBase*0.2 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02C' ) then	//狂斩刺客
				//@9%几率触发穿梭，冷却50 ， 15次
			    if( GetRandomInt(1,100) <= 9 ) then
					call characterEnemySpellAbstract_shuttle( 50 , boss , 1000 , 25 , 15 , null , bossDamegeBase*0.20 , Effect_ShadowAssault )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02B' ) then	//飞蛇
				//@9%几率触发穿梭，冷却50 ，7次
			    if( GetRandomInt(1,100) <= 9 ) then
					call characterEnemySpellAbstract_shuttle( 50 , boss , 1000 , 20 , 7 , null , bossDamegeBase*0.2 , Effect_CrushingWaveBrust )
			    endif
			elseif( GetUnitTypeId(boss) == 'n03F' ) then	//深海海民
				//@9%几率触发海民冲击，冷却40
			    if( GetRandomInt(1,100) <= 9 ) then
					call characterEnemySpellAbstract_charge(40 , boss , damageSource , SKILL_CHARGE_DRAG , 800 , 6 , Effect_CrushingWaveDamage , bossDamegeBase*0.65 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02D' ) then	//破坏猛犸王
				//@9%几率触发猛犸王冲击，冷却35
			    if( GetRandomInt(1,100) <= 9 ) then
					call characterEnemySpellAbstract_charge(35 , boss , damageSource , SKILL_CHARGE_DRAG , 1000 , 11 , Effect_ImpaleTargetDust , bossDamegeBase*0.65 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02N' ) then	//尖毛猪
				//@9%几率触发尖毛猪残影踏，冷却7，3个影子
			    if( GetRandomInt(1,100) <= 9 ) then
					call characterEnemySpellAbstract_canyingta( 7 , boss ,3 , 'o00P' , bossDamegeBase*0.10)
			    endif
			elseif( GetUnitTypeId(boss) == 'n03Y' ) then	//腐蚀邪鬼
				//@9%几率触发腐蚀冲击，冷却25
			    if( GetRandomInt(1,100) <= 9 ) then
					call characterEnemySpellAbstract_charge(25 , boss , damageSource , SKILL_CHARGE_DRAG , 400 , 15 , Effect_UndeadDissipate , bossDamegeBase*0.30 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02P' ) then	//灰沙蝎王
				//@9%几率触发蝎王冲击，冷却55
			    if( GetRandomInt(1,100) <= 9 ) then
					call characterEnemySpellAbstract_charge(55 , boss , damageSource , SKILL_CHARGE_DRAG , 1750 , 16 , Effect_ImpaleTargetDust , bossDamegeBase*0.80 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02O' ) then	//骷髅杀手
				//@12%几率触发丧命魂魄，10道，冷却60，距离700，速度2，重叠伤害
			    if( GetRandomInt(1,100) <= 12 ) then
					call characterEnemySpellAbstract_multiLeap(60 , 'o00U' , boss , damageSource , 600 , 2 , null , 10 , 36 , bossDamegeBase*0.03 , Effect_Explosion , true)
			    endif
			endif
			//DRAGON
			if( GetUnitTypeId(boss) == 'n013' ) then		//红龙
				//@12%几率触发火焰旋风，7道，冷却55，距离700，速度2，重叠伤害
			    if( GetRandomInt(1,100) <= 12 ) then
					call characterEnemySpellAbstract_multiLeap(55, 'o00M' , boss , damageSource , 700 , 2 , null , 7 , 40 , bossDamegeBase*0.07 , Effect_Explosion , true)
			    endif
			elseif( GetUnitTypeId(boss) == 'n014' ) then	//黑龙
				//@12%几率触发殛寒领域，冷却60，范围650，持续3秒
			    if( GetRandomInt(1,100) <= 12 ) then
					call characterEnemySpellAbstract_multiPunish(60, boss, Effect_IceStomp , 650 , 3.00 , SKILL_PUNISH_TYPE_blue , bossDamegeBase*0.32 , Effect_FrostNovaTarget )
			    endif
			endif
		endif

	endfunction

	//初始化
	public function init takes nothing returns nothing
    	call TriggerAddAction( Boss_Spell_Trigger_Normal , function action )
    	call TriggerAddAction( Boss_Spell_Trigger_Normal_Bombs , function action_Bombs )
	endfunction

endlibrary

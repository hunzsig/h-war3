globals

	trigger m1TriggerEnemyBossSpellAction = CreateTrigger()

endglobals

library m1Spell requires m1Shop

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
	    local real punishMax = GetUnitState(boss, UNIT_STATE_MAX_LIFE) * 0.32
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
		call m1AbstractSchedule_punish( boss , damage , punishMax )

		//TODO 共享技能
		//@对召唤物造成15%生命伤害
	    if(IsUnitType(damageSource, UNIT_TYPE_SUMMONED) == true) then
	        call SetUnitLifeBJ( damageSource , GetUnitState(damageSource, UNIT_STATE_LIFE) - 0.15*GetUnitState(damageSource, UNIT_STATE_MAX_LIFE))
	    endif
		//@75%几率触发无敌，冷却45，持续2.5
	    if( GetRandomInt(1,100) <= 75 ) then
			call m1AbstractSchedule_invincible( 45 , boss , 2.50 )
	    endif
	    //@65%几率回避，冷却0.25秒
	    if( GetUnitTypeId(damageSource) == Unit_Token_Hunt_Not_Avoid ) then
            //如果伤害的单位是无视回避类，则不计算
        elseif( bossLifeRate > 0.75 ) then
            //如果BOSS血量在75%以上则不计算回避
        elseif( damage > GetUnitState(boss, UNIT_STATE_MAX_LIFE)*0.1 ) then
            //如果伤害大于生命10%，英雄将无视回避
            call funcs_floatMsg( "|cffff0000嗷！好痛！|r" ,  boss  )
        else
        	call m1AbstractSchedule_avoid ( 0.25 , boss , 65 )
    	endif
	    //@15%几率晕破吼，冷却10.0秒，范围600，伤害300
	    if( GetRandomInt(1,100) <= 15 and IsUnitType(damageSource, UNIT_TYPE_HERO) == true ) then
			call m1AbstractSchedule_breakHowl ( 10.0 , boss , 600 , 300 )
		endif





		/* 特殊技能 - 只有特定单位会触发 */
		/*
		//@召唤小弟，45秒，内部分发
		//call m1AbstractSchedule_callBrother ( 45 , boss )

		if( IsUnitType(damageSource, UNIT_TYPE_HERO) == true ) then
			//LAST
			if( GetUnitTypeId(boss) == 'n02Q' ) then		//锯裂机车
				//@20%几率触发锯裂机车JUMP，冷却15
			    if( GetRandomInt(1,100) <= 20 ) then
					call m1AbstractSchedule_jump( 15 , boss , damageSource , 20 , Effect_ImpaleTargetDust , bossDamegeBase*0.23 , Effect_red_shatter )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02U' ) then	//守卫强暴者
				//@10%几率触发炸弹，冷却15 ， 数量7
			    if( GetRandomInt(1,100) <= 15 ) then
					call m1AbstractSchedule_summon( 15 , boss , 'n02V' , 7 , 125 , 5.00 , M1_boss_spell_trigger_Bombs )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02R' ) then	//死神
				//@9%几率触发穿梭，冷却75 , 30次
			    if( GetRandomInt(1,100) <= 9 ) then
					call m1AbstractSchedule_shuttle( 75 , boss , 1000 , 45 , 30 , null , bossDamegeBase*0.06 , Effect_ReplenishManaCaster )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02T' ) then	//无冕帝王
			elseif( GetUnitTypeId(boss) == 'n02S' ) then	//DarkEle
				//@5%几率触发DarkEle踏，冷却75，30个影子
			    if( GetRandomInt(1,100) <= 5 ) then
					call m1AbstractSchedule_canyingta( 75 , boss , 30 , 'o00S' , bossDamegeBase*0.11)
			    endif
			endif
			//BOSS
			if( GetUnitTypeId(boss) == 'n004' ) then		//巨石人
				//@9%几率触发巨石残影踏，冷却45，15个影子
			    if( GetRandomInt(1,100) <= 9 ) then
					call m1AbstractSchedule_canyingta( 45 , boss ,15 , 'o00N' , bossDamegeBase*0.07)
			    endif
			elseif( GetUnitTypeId(boss) == 'n00M' ) then	//怖残像狼
				//@9%几率触发狼咬，冷却20
			    if( GetRandomInt(1,100) <= 9 ) then
					call m1AbstractSchedule_leap(20 , boss , damageSource , 350 , 30 , null , bossDamegeBase*0.35 , Effect_Boold_Cut , false)
			    endif
			elseif( GetUnitTypeId(boss) == 'n03K' ) then	//提灯白牛
				//@7%几率触发白牛JUMP，冷却35
			    if( GetRandomInt(1,100) <= 7 ) then
					call m1AbstractSchedule_jump( 35 , boss , damageSource , 13 , Effect_CrushingWhiteRing , bossDamegeBase*0.35 , Effect_DarkLightningNova )
			    endif
			elseif( GetUnitTypeId(boss) == 'n01O' ) then	//军统领
				//@7%几率触发光明炮，8道，冷却60，距离1600，速度13，不重叠伤害
			    if( GetRandomInt(1,100) <= 7 ) then
					call m1AbstractSchedule_multiLeap(60, 'o00O' , boss , damageSource , 1600 , 13 , null , 8 , 45 , bossDamegeBase*0.38 , Effect_LightStrikeArray , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n01K' ) then	//食人大佬
				//@7%几率触发鬼巨人撞击，冷却65
			    if( GetRandomInt(1,100) <= 7 ) then
					call m1AbstractSchedule_charge(65 , boss , damageSource , SKILL_CHARGE_CRASH , 600 , 25 , Effect_ImpaleTargetDust , bossDamegeBase*0.60 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n005' ) then	//群暴食尸鬼
				//@9%几率触发尸鬼冲击，冷却27
			    if( GetRandomInt(1,100) <= 9 ) then
					call m1AbstractSchedule_leap(27 , boss , damageSource , 350 , 45 , null , bossDamegeBase*0.40 , Effect_Boold_Cut , false)
			    endif
			elseif( GetUnitTypeId(boss) == 'n020' ) then	//鬼巨人
				//@9%几率触发鬼巨人撞击，冷却60
			    if( GetRandomInt(1,100) <= 9 ) then
					call m1AbstractSchedule_charge(60 , boss , damageSource , SKILL_CHARGE_FLY , 500 , 20 , Effect_ImpaleTargetDust , bossDamegeBase*0.55 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n03Z' ) then	//疯狂大炮
				//@5%几率触发大炮冲击，冷却80
			    if( GetRandomInt(1,100) <= 5 ) then
					call m1AbstractSchedule_chargeToken(80 , boss , 'o00R' , damageSource , SKILL_CHARGE_DRAG , 1500 , 25 , null , bossDamegeBase*0.68 , Effect_ExplosionBIG , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n00K' ) then	//炸弹魔
				//@10%几率触发炸弹，冷却12 ， 数量4
			    if( GetRandomInt(1,100) <= 10 ) then
					call m1AbstractSchedule_summon( 12 , boss , 'n02V' , 4 , 125 , 5.00 , M1_boss_spell_trigger_Bombs )
			    endif
			elseif( GetUnitTypeId(boss) == 'n01Y' ) then	//奇美拉
				//@10%几率触发炸弹，冷却50 ， 数量9
			    if( GetRandomInt(1,100) <= 10 ) then
					call m1AbstractSchedule_summon( 50 , boss , 'u00Z' , 9 , 135 , 12.00 , null )
			    endif
			elseif( GetUnitTypeId(boss) == 'n00N' ) then	//鬼狼蛛
				//@15%几率触发狼蛛JUMP，冷却7
			    if( GetRandomInt(1,100) <= 15 ) then
					call m1AbstractSchedule_jump( 15 , boss , damageSource , 20 , Effect_HydraCorrosiveGroundEffect , bossDamegeBase*0.12 , Effect_GreatElderHydraAcidSpew )
			    endif
			elseif( GetUnitTypeId(boss) == 'n03G' ) then	//狮鹫
				//@10%几率触发乱锤阵，冷却55 ， 数量25
			    if( GetRandomInt(1,100) <= 10 ) then
					call m1AbstractSchedule_summon( 55 , boss , 'u00Y' , 25 , 50 , 10.00 , null )
			    endif
			elseif( GetUnitTypeId(boss) == 'n040' ) then	//外道魔导师
				//@9%几率触发龙卷风，冷却19
			    if( GetRandomInt(1,100) <= 9 ) then
					call m1AbstractSchedule_chargeToken(19 , boss , 'o00T' , damageSource , SKILL_CHARGE_DRAG , 800 , 35 , null , bossDamegeBase*0.14 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02C' ) then	//狂斩刺客
				//@9%几率触发穿梭，冷却50 ， 15次
			    if( GetRandomInt(1,100) <= 9 ) then
					call m1AbstractSchedule_shuttle( 50 , boss , 1000 , 25 , 15 , null , bossDamegeBase*0.10 , Effect_ShadowAssault )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02B' ) then	//飞蛇
				//@9%几率触发穿梭，冷却50 ，7次
			    if( GetRandomInt(1,100) <= 9 ) then
					call m1AbstractSchedule_shuttle( 50 , boss , 1000 , 20 , 7 , null , bossDamegeBase*0.18 , Effect_CrushingWaveBrust )
			    endif
			elseif( GetUnitTypeId(boss) == 'n03F' ) then	//深海海民
				//@9%几率触发海民冲击，冷却40
			    if( GetRandomInt(1,100) <= 9 ) then
					call m1AbstractSchedule_charge(40 , boss , damageSource , SKILL_CHARGE_DRAG , 800 , 6 , Effect_CrushingWaveDamage , bossDamegeBase*0.55 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02D' ) then	//破坏猛犸王
				//@9%几率触发猛犸王冲击，冷却35
			    if( GetRandomInt(1,100) <= 9 ) then
					call m1AbstractSchedule_charge(35 , boss , damageSource , SKILL_CHARGE_DRAG , 1000 , 11 , Effect_ImpaleTargetDust , bossDamegeBase*0.45 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02N' ) then	//尖毛猪
				//@9%几率触发尖毛猪残影踏，冷却7，3个影子
			    if( GetRandomInt(1,100) <= 9 ) then
					call m1AbstractSchedule_canyingta( 7 , boss ,3 , 'o00P' , bossDamegeBase*0.10)
			    endif
			elseif( GetUnitTypeId(boss) == 'n03Y' ) then	//腐蚀邪鬼
				//@9%几率触发腐蚀冲击，冷却25
			    if( GetRandomInt(1,100) <= 9 ) then
					call m1AbstractSchedule_charge(25 , boss , damageSource , SKILL_CHARGE_DRAG , 400 , 15 , Effect_UndeadDissipate , bossDamegeBase*0.30 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02P' ) then	//灰沙蝎王
				//@9%几率触发蝎王冲击，冷却55
			    if( GetRandomInt(1,100) <= 9 ) then
					call m1AbstractSchedule_charge(55 , boss , damageSource , SKILL_CHARGE_DRAG , 1750 , 16 , Effect_ImpaleTargetDust , bossDamegeBase*0.80 , null , false )
			    endif
			elseif( GetUnitTypeId(boss) == 'n02O' ) then	//骷髅杀手
				//@12%几率触发丧命魂魄，10道，冷却60，距离700，速度2，重叠伤害
			    if( GetRandomInt(1,100) <= 12 ) then
					call m1AbstractSchedule_multiLeap(60 , 'o00U' , boss , damageSource , 600 , 2 , null , 10 , 36 , bossDamegeBase*0.03 , Effect_Explosion , true)
			    endif
			endif
			//DRAGON
			if( GetUnitTypeId(boss) == 'n013' ) then		//红龙
				//@12%几率触发火焰旋风，7道，冷却55，距离700，速度2，重叠伤害
			    if( GetRandomInt(1,100) <= 12 ) then
					call m1AbstractSchedule_multiLeap(55, 'o00M' , boss , damageSource , 700 , 2 , null , 7 , 40 , bossDamegeBase*0.04 , Effect_Explosion , true)
			    endif
			elseif( GetUnitTypeId(boss) == 'n014' ) then	//黑龙
				//@12%几率触发殛寒领域，冷却60，范围650，持续3秒
			    if( GetRandomInt(1,100) <= 12 ) then
					call m1AbstractSchedule_multiPunish(60, boss, Effect_IceStomp , 650 , 3.00 , SKILL_PUNISH_TYPE_blue , bossDamegeBase*0.25 , Effect_FrostNovaTarget )
			    endif
			endif
		endif
		*/

	endfunction

	//绑定触发
	public function bind takes unit boss returns nothing
		call eventRegist_unitDamaged( m1TriggerEnemyBossSpellAction , boss ) //受伤事件
	endfunction

	//初始化
	public function init takes nothing returns nothing
    	call TriggerAddAction( m1TriggerEnemyBossSpellAction , function action )
	endfunction


endlibrary

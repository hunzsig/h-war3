globals
    // 地形

endglobals
struct hSet

    private static group bosses
	private static integer currentChengqu = 0
    private static trigger heroDeadTg = null
    private static trigger emptyDeadTg = null
    private static trigger destructableDeadTg = null
    private static trigger luckyDrawTg = null
    private static unit array icesBlockUnits

    private static method onHeroDead takes nothing returns nothing
		local unit u = GetTriggerUnit()
        local unit u2 = null
		local unit killer = hevt.getLastDamageUnit(u)
        local integer terrain = GetTerrainType(GetUnitX(u),GetUnitY(u))
		call hmsg.echo(GetUnitName(u)+" 被 "+GetUnitName(killer)+" 狠狠地打死了！")
        call hunit.rebornAtXY(u,GetLocationX(Loc_C),GetLocationY(Loc_C),3.00)
        set inDungeons[hplayer.index(GetOwningPlayer(u))] = false
        /**
         * 雪地 Agrs Xbtl Xblm
         * 火炎 Yblm Ywmb
         * 城砖 Arck Alvd Ybtl
         * 荒地 Adrt Adrd
         */
        if(terrain == 'Agrs' or terrain == 'Xbtl' or terrain == 'Xblm')then // 雪地
            set u2 = hunit.createUnitXYFacing(player_passive,'o00A',GetUnitX(u),GetUnitY(u),GetUnitFacing(u))
        elseif(terrain == 'Yblm' or terrain == 'Ywmb')then // 火炎
            set u2 = hunit.createUnitXYFacing(player_passive,'o00C',GetUnitX(u),GetUnitY(u),GetUnitFacing(u))
        elseif(terrain == 'Arck' or terrain == 'Alvd' or terrain == 'Ybtl')then // 城砖
            set u2 = hunit.createUnitXYFacing(player_passive,'o00D',GetUnitX(u),GetUnitY(u),GetUnitFacing(u))
        elseif(terrain == 'Adrt' or terrain == 'Adrd')then // 荒地
            set u2 = hunit.createUnitXYFacing(player_passive,'o00B',GetUnitX(u),GetUnitY(u),GetUnitFacing(u))
        else
            set u2 = hunit.createUnitXYFacing(player_passive,'o00E',GetUnitX(u),GetUnitY(u),GetUnitFacing(u))
        endif
        call hunit.del(u2,300)
	endmethod
    private static method onHeroPick takes nothing returns nothing
        local unit u = hevt.getTriggerUnit()
        local integer uid = GetUnitTypeId(u)
        local string t = hhero.getHeroType(uid)
        call TriggerRegisterUnitEvent( heroDeadTg, u, EVENT_UNIT_DEATH )
        //检测英雄类别
        if(t == "str")then
            call hattr.addLife(u,300,0)
            call hattr.addAttackPhysical(u,20,0)
        elseif(t == "agi")then
            call hattr.addLife(u,200,0)
            call hattr.addAttackPhysical(u,30,0)
        elseif(t == "int")then
            call hattr.addLife(u,100,0)
            call hattr.addAttackPhysical(u,10,0)
            call hattr.addAttackMagic(u,20,0)
        endif
        if(uid == 'H001')then //绿剑圣
            call hattr.addAttackPhysical(u,10,0)
            call hattr.addMove(u,500,0)
        endif
    endmethod

    // 刷兵机制
    private static method onEmptyDead takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local unit killer = hevt.getLastDamageUnit(u)
		local integer ulv = GetUnitLevel(u)
		local group belong = LoadGroupHandle(hash_unit,GetHandleId(u),1116)
		local integer exp = 0
		local integer gold = 0
        local real x = GetUnitX(u)
        local real y = GetUnitY(u)
        local integer uid = GetUnitTypeId(u)
		if(belong!=null)then
			call GroupRemoveUnit(belong,u)
		endif
		if(ulv<1)then
			set ulv = 1
		endif
		set exp = R2I(I2R(ulv) * 5 + hattr.getLife(u) * 0.05)
		set gold = R2I(I2R(ulv) * 2 + hattr.getLife(u) * 0.03)
		if(killer!=null)then
			call haward.forUnit(killer,exp,gold,0)
		endif
		call hunit.del(u,3.00)
        // buff
        if(GetRandomInt(1,100)>65)then
            call hitem.toXY(momentItems[GetRandomInt(1,7)],ulv,x,y,30.00)
        endif
        //检测环境
        if(uid == 'n020')then //城堡黑色雕像
            call hitem.toXY('I012',10,x,y,30.00)
        elseif(uid == 'n01Z')then //城堡白色雕像
            call hitem.toXY('I011',10,x,y,30.00)
        elseif(uid == 'n021')then //原木
            call hitem.toXY('I00L',10,x,y,30.00)
        endif
        //检测单位的类型掉不同的东东
        if(GetRandomInt(1,100)>50)then
            if(uid == 'n004')then //海龟
                call hitem.toXY('I014',1,x,y,30.00)
            elseif(uid == 'n005')then //大海龟
                call hitem.toXY('I015',1,x,y,30.00)
            elseif(uid == 'n00G' or uid == 'n00J' or uid == 'n00H')then //虾
            endif
        endif
	endmethod
    private static method onEmptyIn takes unit u,group belong returns nothing
		local integer uid = GetUnitTypeId(u)
		local integer ulv = GetUnitLevel(u)
		local unit hero = null
		local integer heroAttack = 0
		local integer heroLife = 0
		local integer heroMove = 0
		call GroupAddUnit(belong,u)
		call SaveGroupHandle(hash_unit,GetHandleId(u),1116,belong)
		call TriggerRegisterUnitEvent( emptyDeadTg, u, EVENT_UNIT_DEATH )
		if(ulv<1)then
			set ulv = 1
		endif
		set hero = hplayer.getDandomUnit()
		set heroAttack = R2I((hattr.getAttackPhysical(hero)+hattr.getAttackMagic(hero)) / 18)
		set heroLife = R2I(I2R(ulv) * hattr.getLife(hero) / 12)
		set heroMove = R2I(I2R(ulv) * hattr.getMove(hero) / 45)
        if(heroMove>50)then
            set heroMove = 50
        endif
        call hattr.addLife(u,heroAttack,0)
        call hattr.addAttackPhysical(u,heroLife,0)
        call hattr.addMove(u,heroMove,0)
	endmethod
	public static method goEmpty takes nothing returns nothing
		local integer i = 0
		local integer j = 0
		local timer t = GetExpiredTimer()
		local unit u = null
		local boolean isdo = true
		local group g = null
		local hFilter filter
		local real range = 1000
		call htime.delTimer(t)
		set filter = hFilter.create()
		call filter.isHero(true)
		call filter.isAlive(true)

		//! textmacro goEmptyItem takes N1,T1,T2
        if(isdo)then
			set i = g_loc_$N1$_count
			loop
				exitwhen isdo==false or i<=0
					set g = hgroup.createByLoc(g_loc_$N1$[i],range,function hFilter.get) //检测点内有无玩家英雄
					if(hgroup.count(g)>0)then
					    //有则刷怪
						if(g_g_$N1$[i] == null)then
							set g_g_$N1$[i] = CreateGroup()
						endif
						if(hgroup.count(g_g_$N1$[i])<=0)then
							set j = GetRandomInt(g_build_min_$N1$,g_build_max_$N1$)
							call hmsg.echo("$T1$"+I2S(j)+"$T2$")
							loop
								exitwhen j<=0
									set u = hempty.createUnit(g_mon_$N1$[GetRandomInt(1,g_mon_$N1$_count)],g_loc_$N1$[i])
									call onEmptyIn(u,g_g_$N1$[i])
								set j=j-1
							endloop
							set isdo = false
							call PingMinimapLocForForceEx( GetPlayersAll(), g_loc_$N1$[i] , 1, bj_MINIMAPPINGSTYLE_FLASHY, 100, 100, 100 )
						endif
					else
						//没有则看看是否之前刷过怪，把它们删除
						if(hgroup.count(g_g_$N1$[i])>0)then
							call hgroup.clear(g_g_$N1$[i],false,true)
						endif
					endif
					call GroupClear(g)
					call DestroyGroup(g)
					set g = null
				set i = i-1
			endloop
		endif
        //! endtextmacro

        //! runtextmacro goEmptyItem("yequ","附近岸边传来|cffff8080 ","阵 |r动静，要不去查探一下？")
        //! runtextmacro goEmptyItem("guqu","隔壁山谷有|cffff8080 ","股 |r声响，可能豺狼野猪出没了")
        //! runtextmacro goEmptyItem("chengqu","城市冒出|cffff8080 ","名战士 |r攻击我们，对于城市里面的居民来说，我方才是侵略者吧")
        //! runtextmacro goEmptyItem("shanjian","风继续吹～|cffff8080 ","阵 |r恶寒，在山上遇到怪物可不是好事")
        //! runtextmacro goEmptyItem("bingyuan","冰层中爬出|cffff8080 ","只 |r大物，冷得有点发抖")
        //! runtextmacro goEmptyItem("lianyu","火焰变幻成|cffff8080 ","个 |r妖物，风风火火来一战")
		
		call htime.setTimeout(7.00,function thistype.goEmpty)
	endmethod

	// boss机制
	private static method onBossCityDead takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local integer i = currentChengqu+1
		if(i>10)then
			call DisableTrigger( GetTriggeringTrigger() )
    		call DestroyTrigger( GetTriggeringTrigger() )
			return
		endif
		set currentChengqu = i
		call SetUnitInvulnerable( chengquBossUnit[i], false )
		call SetUnitVertexColor( chengquBossUnit[i], 255, 255, 255, 255 )
		call SetUnitTimeScale( chengquBossUnit[i], 100.00 )
		call PauseUnit( chengquBossUnit[i], false )
		call PingMinimapLocForForceEx( GetPlayersAll(),g_loc_boss_chengqu,1, bj_MINIMAPPINGSTYLE_FLASHY, 100, 0, 0 )
		call hmsg.echo("|cffffff80下一个城区守护者解开了封印！|r")
	endmethod
	private static method onBossDead takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local unit killer = hevt.getLastDamageUnit(u)
		local integer ulv = GetUnitLevel(u)
		local integer exp = 0
		local integer gold = 0
		local integer i = 0
		call GroupRemoveUnit(bosses,u)
		if(ulv<1)then
			set ulv = 1
		endif
		set exp = R2I(I2R(ulv) * 100 + hattr.getLife(u) * 0.10)
		set gold = R2I(I2R(ulv) * 50 + hattr.getLife(u) * 0.06)
		if(killer!=null)then
			call haward.forUnit(killer,exp,gold,1)
		endif
		set i = 1
		loop
			exitwhen i > (10 + ulv)
				set hxy.x = GetUnitX(u)
        		set hxy.y = GetUnitY(u)
				set hxy = hlogic.polarProjection(hxy,i*5,i*10)
				call hitem.toXY(momentItems[GetRandomInt(1,8)],ulv,hxy.x,hxy.y,60.00)
			set i = i+1
		endloop
		call hunit.del(u,3.00)
		if(hgroup.count(bosses)<=0)then
			call DisableTrigger( GetTriggeringTrigger() )
    		call DestroyTrigger( GetTriggeringTrigger() )
			call hmsg.echo("win!")
		endif
	endmethod
	public static method goBoss takes nothing returns nothing
		local integer i = 0
		local timer t = GetExpiredTimer()
		local unit u = null
		local trigger tg = null
		local trigger tg2 = null

		call htime.delTimer(t)
		set bosses = CreateGroup()
		set tg = CreateTrigger()
		set tg2 = CreateTrigger()
    	call TriggerAddAction(tg, function thistype.onBossDead)
    	call TriggerAddAction(tg2, function thistype.onBossCityDead)

		// sp
		call hempty.createUnitFacing('n01S',g_loc_sp_bingyuan,170)

		set u = hempty.createUnitFacing('n01O',g_loc_boss_shanjian,270)
		call GroupAddUnit(bosses,u)
		call TriggerRegisterUnitEvent( tg, u, EVENT_UNIT_DEATH )
		set u = hempty.createUnitFacing('n016',g_loc_boss_lianyu,90)
		call GroupAddUnit(bosses,u)
		call TriggerRegisterUnitEvent( tg, u, EVENT_UNIT_DEATH )
		set u = hempty.createUnitFacing('n01P',g_loc_boss_bingyuan,180)
		call GroupAddUnit(bosses,u)
		call TriggerRegisterUnitEvent( tg, u, EVENT_UNIT_DEATH )

		// 湖泊
		set u = hempty.createUnitFacing('n017',g_loc_boss_hupo,180)
		call GroupAddUnit(bosses,u)
		call TriggerRegisterUnitEvent( tg, u, EVENT_UNIT_DEATH )
		call SetUnitInvulnerable( u, true )
		call SetUnitVertexColor( u, 45, 45, 45, 255 )
		call SetUnitTimeScale( u, 0.00 )
		call PauseUnit( u, true )

	    // 城区
		set currentChengqu = 1
		set i = 10
		loop
			exitwhen i<=0
				set u = hempty.createUnitFacing(chengquBoss[i],g_loc_boss_chengqu,90)
				set chengquBossUnit[i] = u
				call GroupAddUnit(bosses,u)
				call TriggerRegisterUnitEvent( tg, u, EVENT_UNIT_DEATH )
				call TriggerRegisterUnitEvent( tg2, u, EVENT_UNIT_DEATH )
				if(i!=1)then
					call SetUnitInvulnerable( u, true )
					call SetUnitVertexColor( u, 45, 45, 45, 255 )
					call SetUnitTimeScale( u, 0.00 )
					call PauseUnit( u, true )
				endif
			set i=i-1
		endloop

		//警告
		call PingMinimapLocForForceEx( GetPlayersAll(),g_loc_boss_shanjian,3, bj_MINIMAPPINGSTYLE_FLASHY, 100, 0, 0 )
		call PingMinimapLocForForceEx( GetPlayersAll(),g_loc_boss_lianyu,3, bj_MINIMAPPINGSTYLE_FLASHY, 100, 0, 0 )
		call PingMinimapLocForForceEx( GetPlayersAll(),g_loc_boss_chengqu,3, bj_MINIMAPPINGSTYLE_FLASHY, 100, 0, 0 )
		call PingMinimapLocForForceEx( GetPlayersAll(),g_loc_boss_bingyuan,3, bj_MINIMAPPINGSTYLE_FLASHY, 100, 0, 0 )
		call PingMinimapLocForForceEx( GetPlayersAll(),g_loc_sp_bingyuan,3, bj_MINIMAPPINGSTYLE_FLASHY, 100, 0, 0 )
		call PingMinimapLocForForceEx( GetPlayersAll(),g_loc_boss_hupo,3, bj_MINIMAPPINGSTYLE_FLASHY, 100, 0, 0 )
		call hmedia.soundPlay(gg_snd_CreepSleepLoop1)
		call hmsg.echo("|cffffff80 多条 恶龙 于世现灵！剿灭他们 平天下！|r")
	endmethod

    // 环境生成删除
    private static method onEnvIn takes unit u returns nothing
		local unit hero = null
		local integer heroAttack = 0
		local integer heroLife = 0
		local integer heroMove = 0
		set hero = hplayer.getDandomUnit()
		set heroAttack = R2I((hattr.getAttackPhysical(hero)+hattr.getAttackMagic(hero)) / 18)
		set heroLife = R2I(hattr.getLife(hero) / 12)
        call hattr.addLife(u,heroAttack,0)
        call hattr.addAttackPhysical(u,heroLife,0)
	endmethod
	public static method goEnv takes nothing returns nothing
		local integer i = 0
		local timer t = GetExpiredTimer()
		local integer isdo = 0
		local group g = null
		local hFilter filter
		local real range = 1500
		call htime.delTimer(t)
		set filter = hFilter.create()
		call filter.isHero(true)
		call filter.isAlive(true)
        set i = g_env_count
        loop
            exitwhen isdo>7 or i<=0
                set g = hgroup.createByLoc(g_loc_env[i],range,function hFilter.get) //检测点内有无玩家英雄
                if(hgroup.count(g)>0)then
                    //没刷过这个单位则刷
                    if(g_u_env[i] == null)then
                        set g_u_env[i] = hempty.createUnit(g_env[i],g_loc_env[i])
                        call onEnvIn(g_u_env[i])
                        set isdo = isdo+1
                    endif
                else
                    //没有则看看是否之前刷过，把它们删除
                    if(g_u_env[i] != null)then
                        call hunit.del(g_u_env[i],0)
                    endif
                endif
                call GroupClear(g)
                call DestroyGroup(g)
                set g = null
            set i = i-1
        endloop
		call htime.setTimeout(3.00,function thistype.goEnv)
	endmethod

    // 可破坏物
    private static method doDestructableReborn takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local destructable d = htime.getDestructable(t,1)
        call htime.delTimer(t)
        call DestructableRestoreLife( d, GetDestructableMaxLife(d), true )
    endmethod
    private static method onDestructableDead takes nothing returns nothing
        local destructable d = GetTriggerDestructable()
        local integer did = GetDestructableTypeId(d)
        local timer t = null
        local integer maxLow = 11
        local integer maxHigh = 4
        local integer percentLow = 30
        local integer percentHigh = 3
        local real x = GetDestructableX(d)
        local real y = GetDestructableY(d)
        set t = htime.setTimeout(GetRandomReal(12,25),function thistype.doDestructableReborn)
        call htime.setDestructable(t,1,d)
        // 低级材料
        if(GetRandomInt(1,100)<percentLow)then
            if(did == 'LTlt' or did == 'WTtw' or did == 'YTct' or did == 'FTtw')then // 叶子树木
                if(GetRandomInt(1,100)<80)then
                    call hitem.toXY('I00X',GetRandomInt(1,maxLow),x,y,60.00)
                endif
                if(GetRandomInt(1,100)<80)then
                    call hitem.toXY('I00W',GetRandomInt(1,maxLow),x,y,60.00)
                endif
                if(GetRandomInt(1,100)<70)then
                    call hitem.toXY('I00Y',GetRandomInt(1,maxLow),x,y,60.00)
                endif
            elseif(did == 'KTtw' or did == 'DTsh' or did == 'NTtw')then // 无叶树木
                call hitem.toXY('I00W',GetRandomInt(1,maxLow),x,y,60.00)
                if(GetRandomInt(1,100)<70)then
                    call hitem.toXY('I00Y',GetRandomInt(1,maxLow),x,y,60.00)
                endif
            elseif(did == 'WTst')then // 有雪树木
                if(GetRandomInt(1,100)<80)then
                    call hitem.toXY('I00W',GetRandomInt(1,maxLow),x,y,60.00)
                endif
                if(GetRandomInt(1,100)<70)then
                    call hitem.toXY('I01U',GetRandomInt(1,maxLow),x,y,60.00)
                endif
                if(GetRandomInt(1,100)<70)then
                    call hitem.toXY('I00Y',GetRandomInt(1,maxLow),x,y,60.00)
                endif
            elseif(did == 'BTsc' or did == 'LTbs' or did == 'LTbr' or did == 'LTbx' or did == 'LTcr' or did == 'LTba')then // 支撑柱 木桶 木箱 路障
                call hitem.toXY('I00K',GetRandomInt(1,maxLow),x,y,60.00)
            elseif(did == 'LOcg')then // 牢笼
                call hitem.toXY('I00K',GetRandomInt(1,maxLow),x,y,60.00)
                if(GetRandomInt(1,100)<50)then
                    call hitem.toXY('I013',GetRandomInt(1,maxLow),x,y,60.00)
                endif
            elseif(did == 'LTex')then // 炸药桶
                call hitem.toXY('I00K',GetRandomInt(1,maxLow),x,y,60.00)
                call hitem.toXY('I01M',GetRandomInt(1,maxLow),x,y,60.00)
            elseif(did == 'ITg1')then // 门
                call hitem.toXY('I00K',GetRandomInt(1,maxLow),x,y,60.00)
                call hitem.toXY('I00Z',GetRandomInt(1,maxLow),x,y,60.00)
            elseif(did == 'DTrc')then // 石头红
                call hitem.toXY('I010',GetRandomInt(1,maxLow),x,y,60.00)
            elseif(did == 'DTsp')then // 石头灰
                call hitem.toXY('I00Z',GetRandomInt(1,maxLow),x,y,60.00)
            endif
        endif
        // 高级材料
        if(GetRandomInt(1,100)<percentHigh)then
            if(did == 'LTlt' or did == 'WTtw' or did == 'YTct' or did == 'FTtw')then // 叶子树木
                call hitem.toXY('I01P',GetRandomInt(1,maxHigh),x,y,60.00)
            elseif(did == 'KTtw' or did == 'DTsh' or did == 'NTtw')then // 无叶树木
                call hitem.toXY('I01P',GetRandomInt(1,maxHigh),x,y,60.00)
            elseif(did == 'WTst')then // 有雪树木
                call hitem.toXY('I01P',GetRandomInt(1,maxHigh),x,y,60.00)
            elseif(did == 'BTsc' or did == 'LTbs' or did == 'LTbr' or did == 'LTbx' or did == 'LTcr' or did == 'LTba')then // 支撑柱 木桶 木箱 路障
                call hitem.toXY('I00L',GetRandomInt(1,maxHigh),x,y,60.00)
            elseif(did == 'LOcg')then // 牢笼
                call hitem.toXY('I013',GetRandomInt(1,maxHigh),x,y,60.00)
                call hitem.toXY('I01S',GetRandomInt(1,maxHigh),x,y,60.00)
            elseif(did == 'LTex')then // 炸药桶
                call hitem.toXY('I01L',GetRandomInt(1,maxHigh),x,y,60.00)
            elseif(did == 'ITg1')then // 门
                call hitem.toXY('I011',GetRandomInt(1,maxHigh),x,y,60.00)
            elseif(did == 'DTrc')then // 石头红
                call hitem.toXY('I012',GetRandomInt(1,maxHigh),x,y,60.00)
            elseif(did == 'DTsp')then // 石头灰
                call hitem.toXY('I011',GetRandomInt(1,maxHigh),x,y,60.00)
            endif
        endif
    endmethod
    private static method goDestructable takes nothing returns nothing
        call TriggerRegisterDeathEvent( destructableDeadTg, GetEnumDestructable() )
    endmethod

    // 注册瞬逝型物品
    private static method registerItemMonentCall takes nothing returns nothing
        local unit u = hevt.getTriggerUnit()
        local integer id = hevt.getId()
        local real charges = hevt.getValue()
        local real min = 0
        local real max = 0
        if (id == 'o002') then // 金币
            set min = 10 * charges
            set max = min * 4
            call haward.forUnitGold(u,GetRandomInt(R2I(min),R2I(max)))
        elseif (id == 'o003') then // 木材
            set min = 1 * charges
            set max = min * 2
            call haward.forUnitLumber(u,GetRandomInt(R2I(min),R2I(max)))
        elseif (id == 'o004') then // 生命
            set min = hunit.getMaxLife(u) * 0.03 * charges
            set max = min * 5
            call hunit.addLife(u,GetRandomReal(min,max))
        elseif (id == 'o005') then // 腐蚀
            set min = 1 * charges
            set max = min * 3
            call hattrEffect.addCorrosionVal(u,GetRandomReal(min,max),10)
            set min = 3 * charges
            set max = min * 2
            call hattrEffect.addCorrosionDuring(u,GetRandomReal(min,max),10)
        elseif (id == 'o006') then // 经验3
            set min = 120 * charges
            set max = min * 3
            call haward.forUnitExp(u,GetRandomInt(R2I(min),R2I(max)))
        elseif (id == 'o007') then // 伤害增幅
            set min = 30 * charges
            set max = min * 3
            call hattr.addHuntAmplitude(u,GetRandomReal(min,max),10)
        elseif (id == 'o008') then // 经验
            set min = 40 * charges
            set max = min * 3
            call haward.forUnitExp(u,GetRandomInt(R2I(min),R2I(max)))
        elseif (id == 'o009') then // 极速
            set min = 20 * charges
            set max = min * 3
            call hattr.addMove(u,GetRandomReal(min,max),10)
        endif
    endmethod
    private static method registerItemMonent takes nothing returns nothing
        local hItemBean hitembean
        //! textmacro registerItemMonentMacro takes ID
        set hitembean = hItemBean.create()
        set hitembean.item_type = HITEM_TYPE_MOMENT
		set hitembean.item_id = '$ID$'
		call hitem.format(hitembean)
		call hitembean.destroy()
        call hitem.onMoment('$ID$',function thistype.registerItemMonentCall)
        //! endtextmacro
        //! runtextmacro registerItemMonentMacro("o002")
        //! runtextmacro registerItemMonentMacro("o003")
        //! runtextmacro registerItemMonentMacro("o004")
        //! runtextmacro registerItemMonentMacro("o005")
        //! runtextmacro registerItemMonentMacro("o006")
        //! runtextmacro registerItemMonentMacro("o007")
        //! runtextmacro registerItemMonentMacro("o008")
        //! runtextmacro registerItemMonentMacro("o009")
    endmethod

    private static method registerItemDrop takes nothing returns nothing
        local hItemBean hitembean
        local integer array itemId
        local integer array itemGold
        local string array itemIcon
        local integer i = 0
        local integer count = 37
        set itemId[1] = 'I01C'
        set itemId[2] = 'I01F'
        set itemId[3] = 'I00K'
        set itemId[4] = 'I00W'
        set itemId[5] = 'I01U'
        set itemId[6] = 'I01M'
        set itemId[7] = 'I01E'
        set itemId[8] = 'I00Z'
        set itemId[9] = 'I017'
        set itemId[10] = 'I01J'
        set itemId[11] = 'I019'
        set itemId[12] = 'I018'
        set itemId[13] = 'I013'
        set itemId[14] = 'I01I'
        set itemId[15] = 'I00Y'
        set itemId[16] = 'I01D'
        set itemId[17] = 'I00X'
        set itemId[18] = 'I016'
        set itemId[19] = 'I01A'
        set itemId[20] = 'I01H'
        set itemId[21] = 'I010'
        set itemId[22] = 'I01G'
        set itemId[23] = 'I014'
        set itemId[24] = 'I01P'
        set itemId[25] = 'I01O'
        set itemId[26] = 'I015'
        set itemId[27] = 'I01B'
        set itemId[28] = 'I01N'
        set itemId[29] = 'I01T'
        set itemId[30] = 'I01K'
        set itemId[31] = 'I011'
        set itemId[32] = 'I01Q'
        set itemId[33] = 'I00L'
        set itemId[34] = 'I012'
        set itemId[35] = 'I01R'
        set itemId[36] = 'I01S'
        set itemId[37] = 'I01L'
        set itemGold[1] = 20
        set itemGold[2] = 30
        set itemGold[3] = 20
        set itemGold[4] = 3
        set itemGold[5] = 2
        set itemGold[6] = 60
        set itemGold[7] = 25
        set itemGold[8] = 30
        set itemGold[9] = 40
        set itemGold[10] = 90
        set itemGold[11] = 35
        set itemGold[12] = 10
        set itemGold[13] = 50
        set itemGold[14] = 90
        set itemGold[15] = 30
        set itemGold[16] = 35
        set itemGold[17] = 2
        set itemGold[18] = 5
        set itemGold[19] = 30
        set itemGold[20] = 60
        set itemGold[21] = 45
        set itemGold[22] = 40
        set itemGold[23] = 5
        set itemGold[24] = 45
        set itemGold[25] = 200
        set itemGold[26] = 50
        set itemGold[27] = 110
        set itemGold[28] = 55
        set itemGold[29] = 100
        set itemGold[30] = 150
        set itemGold[31] = 100
        set itemGold[32] = 160
        set itemGold[33] = 50
        set itemGold[34] = 120
        set itemGold[35] = 110
        set itemGold[36] = 200
        set itemGold[37] = 50
        set itemIcon[1] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[2] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[3] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[4] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[5] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[6] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[7] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[8] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[9] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[10] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[11] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[12] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[13] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[14] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[15] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[16] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[17] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[18] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[19] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[20] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[21] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[22] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[23] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[24] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[25] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[26] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[27] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[28] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[29] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[30] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[31] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[32] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[33] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[34] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[35] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[36] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set itemIcon[37] = "ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp"
        set i = 1
        loop
            exitwhen i>37
                set hitembean = hItemBean.create()
                set hitembean.item_type = HITEM_TYPE_FOREVER
                set hitembean.item_id = itemId[i]
                set hitembean.item_overlay = 999
                set hitembean.item_gold = itemGold[i] * 2
                set hitembean.item_weight = 0.01
                set hitembean.item_icon = itemIcon[i]
                call hitem.format(hitembean)
                call hitembean.destroy()
            set i=i+1
        endloop
    endmethod

    // 抽奖对话框
	private static method onLuckyDrawDialog takes nothing returns nothing
		local dialog d = GetClickedDialog()
		local button b = GetClickedButton()
        local integer gameResult = LoadInteger(hash_item,GetHandleId(d),1)
        local unit u = LoadUnitHandle(hash_item,GetHandleId(d),2)
        local integer successGold = LoadInteger(hash_item,GetHandleId(d),3)
        local integer successLumber = LoadInteger(hash_item,GetHandleId(d),4)
		local integer index = LoadInteger(hash_item,GetHandleId(b),1)
		call DialogClear( d )
		call DialogDestroy( d )
		call DisableTrigger(GetTriggeringTrigger())
		call DestroyTrigger(GetTriggeringTrigger())
		set d = null
        if(gameResult == index)then
            call hmedia.soundPlay(gg_snd_audio_jushiwushuang)
            call haward.forUnit(u,0,successGold,successLumber)
            if(successGold>0)then
                call hmsg.echo("哇! |cffffff80"+GetPlayerName(GetOwningPlayer(u))+"|r 运气奇佳！惊为天人！中了 "+I2S(successGold)+" 黄金")
            elseif(successLumber>0)then
                call hmsg.echo("哇! |cffffff80"+GetPlayerName(GetOwningPlayer(u))+"|r 运气奇佳！简直碉堡！中了 "+I2S(successLumber)+" 木头")
            endif
            if(GetRandomInt(1,500) == 325)then
                call haward.forUnit(u,GetUnitLevel(u)*500,10000,0)
                call hmsg.echo("齐天大奖！! |cffffff80"+GetPlayerName(GetOwningPlayer(u))+"|r 天选之人！额外送TA 10000 黄金及巨量经验")
            endif
        else
            call hmedia.soundPlay2Player(gg_snd_audio_deda,GetOwningPlayer(u))
            call hmsg.echoTo(GetOwningPlayer(u),"|cffffff80可惜啊猜错了～欢迎再来啊|r",0)
            call hmsg.style(hmsg.ttg2Unit(u,"可惜啊猜错了～欢迎再来啊",6.00,"ffff80",0,2.50,50.00) ,"scale",0,0.05)
        endif
	endmethod
    // 抽奖
    public static method onLuckyDraw takes nothing returns nothing
        local unit u = hevt.getTargetUnit() // buyer
        local item it = hevt.getTriggerItem()
        local integer itid = GetItemTypeId(it)
        local integer successGold = 0
        local integer successLumber = 0
        local integer game = 0
        local integer gameResult = 0
        local dialog d = null
        local button b = null
        local trigger dtg = null
        if(u==null or it==null)then
            return
        endif
        if(itid == 'I00E')then // 100G
            set successGold = 888
        elseif(itid == 'I00F')then // 1000G
            set successGold = 8888
        elseif(itid == 'I00G')then // 10000G
            set successGold = 88888
        elseif(itid == 'I00H')then // 100000G
            set successGold = 888888
        elseif(itid == 'I00D')then // 1L
            set successLumber = 10
        elseif(itid == 'I00C')then // 10L
            set successLumber = 100
        elseif(itid == 'I00I')then // 100L
            set successLumber = 1000
        elseif(itid == 'I00J')then // 1000L
            set successLumber = 10000
        else
            return
        endif
        set game = GetRandomInt(1,100)
        set d = DialogCreate()
        if(game >= 50 and game < 53)then // 大小
            set gameResult = GetRandomInt(1,3)
            call DialogSetMessage( d, "来来来～猜大小～猜中拿奖" )
            set b = DialogAddButton(d,"大",0)
            call SaveInteger(hash_item,GetHandleId(b),1,1)
            set b = DialogAddButton(d,"小",0)
            call SaveInteger(hash_item,GetHandleId(b),1,2)
        elseif(game >= 53 and game < 60)then // 包剪锤
            set gameResult = GetRandomInt(1,4)
            call DialogSetMessage( d, "出手了～来！" )
            set b = DialogAddButton(d,"包",0)
            call SaveInteger(hash_item,GetHandleId(b),1,1)
            set b = DialogAddButton(d,"剪",0)
            call SaveInteger(hash_item,GetHandleId(b),1,2)
            set b = DialogAddButton(d,"锤",0)
            call SaveInteger(hash_item,GetHandleId(b),1,3)
        elseif(game >= 60 and game < 70)then // 扑克花色
            set gameResult = GetRandomInt(1,5)
            call DialogSetMessage( d, "唰唰唰～发牌了～猜花色～" )
            set b = DialogAddButton(d,"黑桃",0)
            call SaveInteger(hash_item,GetHandleId(b),1,1)
            set b = DialogAddButton(d,"红桃",0)
            call SaveInteger(hash_item,GetHandleId(b),1,2)
            set b = DialogAddButton(d,"梅花",0)
            call SaveInteger(hash_item,GetHandleId(b),1,3)
            set b = DialogAddButton(d,"方块",0)
            call SaveInteger(hash_item,GetHandleId(b),1,4)
        elseif(game >= 70 and game < 85)then // 骰子
            set gameResult = GetRandomInt(1,6)
            call DialogSetMessage( d, "咯咯咯～猜骰子～1到6哦～" )
            set b = DialogAddButton(d,"点数 1",0)
            call SaveInteger(hash_item,GetHandleId(b),1,1)
            set b = DialogAddButton(d,"点数 2",0)
            call SaveInteger(hash_item,GetHandleId(b),1,2)
            set b = DialogAddButton(d,"点数 3",0)
            call SaveInteger(hash_item,GetHandleId(b),1,3)
            set b = DialogAddButton(d,"点数 4",0)
            call SaveInteger(hash_item,GetHandleId(b),1,4)
            set b = DialogAddButton(d,"点数 5",0)
            call SaveInteger(hash_item,GetHandleId(b),1,5)
            set b = DialogAddButton(d,"点数 6",0)
            call SaveInteger(hash_item,GetHandleId(b),1,6)
         else // 麻将
            set gameResult = GetRandomInt(1,9)
            call DialogSetMessage( d, "猜猜这张麻将是什么牌？" )
            set b = DialogAddButton(d,"东南西北",0)
            call SaveInteger(hash_item,GetHandleId(b),1,1)
            set b = DialogAddButton(d,"红中",0)
            call SaveInteger(hash_item,GetHandleId(b),1,2)
            set b = DialogAddButton(d,"发财",0)
            call SaveInteger(hash_item,GetHandleId(b),1,3)
            set b = DialogAddButton(d,"白板",0)
            call SaveInteger(hash_item,GetHandleId(b),1,4)
            set b = DialogAddButton(d,"春夏秋冬",0)
            call SaveInteger(hash_item,GetHandleId(b),1,5)
            set b = DialogAddButton(d,"梅兰竹菊",0)
            call SaveInteger(hash_item,GetHandleId(b),1,6)
            set b = DialogAddButton(d,"万子",0)
            call SaveInteger(hash_item,GetHandleId(b),1,7)
            set b = DialogAddButton(d,"筒子",0)
            call SaveInteger(hash_item,GetHandleId(b),1,8)
            set b = DialogAddButton(d,"索子",0)
            call SaveInteger(hash_item,GetHandleId(b),1,9)
        endif
        call SaveInteger(hash_item,GetHandleId(d),1,gameResult)
        call SaveUnitHandle(hash_item,GetHandleId(d),2,u)
        call SaveInteger(hash_item,GetHandleId(d),3,successGold)
        call SaveInteger(hash_item,GetHandleId(d),4,successLumber)
        set dtg = CreateTrigger()
        call TriggerAddAction(dtg, function thistype.onLuckyDrawDialog)
        call TriggerRegisterDialogEvent( dtg , d )
        call DialogDisplay( GetOwningPlayer(u),d, true )
        call hmedia.soundPlay2Player(gg_snd_audio_deda,GetOwningPlayer(u))
    endmethod

    // 环境触发
    private static method tgZhizhu takes nothing returns nothing
        local unit triggerUnit = hevt.getTriggerUnit()
        local integer index = GetUnitUserData(triggerUnit)
        local unit u = null
        local integer percentHigh = 50
        if(icesBlockUnits[index]!=null)then
            call hmedia.soundPlay(gg_snd_audio_effect_3)
            call PingMinimapEx( GetUnitX(triggerUnit),GetUnitY(triggerUnit), 5.00, 255, 0, 0, true )
            call PingMinimapEx( GetUnitX(icesBlockUnits[index]),GetUnitY(icesBlockUnits[index]), 5.00, 255, 0, 0, true )
            call hitem.toXY('I026',3,GetUnitX(triggerUnit),GetUnitY(triggerUnit),30.00)
            // 高级材料
            if(GetRandomInt(1,100)<percentHigh)then
                call hitem.toXY('I028',2,GetUnitX(triggerUnit),GetUnitY(triggerUnit),30.00)
            endif
            call hunit.del(icesBlockUnits[index],0)
            set icesBlockUnits[index] = null
            call hunit.del(triggerUnit,0)
        endif
    endmethod

    public static method setInit takes nothing returns nothing
        local unit u = null
        local integer qty = 0
        set heroDeadTg = CreateTrigger()
        set emptyDeadTg = CreateTrigger()
        set destructableDeadTg = CreateTrigger()
        set luckyDrawTg = CreateTrigger()
        call TriggerAddAction(emptyDeadTg,function thistype.onEmptyDead)
        call TriggerAddAction(heroDeadTg,function thistype.onHeroDead)
        call TriggerAddAction(destructableDeadTg,function thistype.onDestructableDead)
        call TriggerAddAction(luckyDrawTg,function thistype.onLuckyDraw)
        call EnumDestructablesInRectAll( GetPlayableMapRect(), function thistype.goDestructable)

        call hevt.onPickHero(function thistype.onHeroPick)

        // item
        call registerItemMonent()
        call registerItemDrop()

        // shop
        set u = hunit.createUnitXY(player_passive,'n006',1324,2367) // 赌徒
        call hitem.initShop(u)
        call hevt.onItemSell(u,function thistype.onLuckyDraw)
        set u = hunit.createUnitXY(player_passive,'n01W',894,2300) // 小鬼
        call hitem.initShop(u)
        call hevt.onItemSell(u,function thistype.onLuckyDraw)

        // 机巧
		set u = hempty.createUnitXYFacing('n01X',2375,6573,15) //蜘蛛
        call SetUnitUserData(u,1)
        call hevt.onDead(u,function thistype.tgZhizhu)
		set u = hempty.createUnitXYFacing('n01X',4750,5806,65)
         call SetUnitUserData(u,2)
        call hevt.onDead(u,function thistype.tgZhizhu)
		set u = hempty.createUnitXYFacing('n01Y',6490,6583,294)
         call SetUnitUserData(u,3)
        call hevt.onDead(u,function thistype.tgZhizhu)
		set u = hempty.createUnitXYFacing('n01Y',5398,2136,97.5)
         call SetUnitUserData(u,4)
        call hevt.onDead(u,function thistype.tgZhizhu)
		set u = hempty.createUnitXYFacing('n01Y',7087,4339,214)
         call SetUnitUserData(u,5)
        call hevt.onDead(u,function thistype.tgZhizhu)
        set icesBlockUnits[1] = hunit.createUnitXY(hempty.getEmptyPlayer(), 'n022', 3324, 6854)
        set icesBlockUnits[2] = hunit.createUnitXY(hempty.getEmptyPlayer(), 'n022', 6714, 6038)
        set icesBlockUnits[3] = hunit.createUnitXY(hempty.getEmptyPlayer(), 'n022', 4564, 2716)
        set icesBlockUnits[4] = hunit.createUnitXY(hempty.getEmptyPlayer(), 'n022', 6520, 5199)
        set icesBlockUnits[5] = hunit.createUnitXY(hempty.getEmptyPlayer(), 'n022', 6257, 3353)

        set u = hempty.createUnitXYFacing('n020',-185,-439,0) //城堡黑色雕像
		call TriggerRegisterUnitEvent( emptyDeadTg, u, EVENT_UNIT_DEATH )
        set u = hempty.createUnitXYFacing('n020',1611,-503,180)
		call TriggerRegisterUnitEvent( emptyDeadTg, u, EVENT_UNIT_DEATH )

        set u = hempty.createUnitXYFacing('n01Z',-405,-1080,309.5) //城堡白色雕像
		call TriggerRegisterUnitEvent( emptyDeadTg, u, EVENT_UNIT_DEATH )
        set u = hempty.createUnitXYFacing('n01Z',1498,-1003,216.8)
		call TriggerRegisterUnitEvent( emptyDeadTg, u, EVENT_UNIT_DEATH )
        set u = hempty.createUnitXYFacing('n01Z',-761,-3427,38.36)
		call TriggerRegisterUnitEvent( emptyDeadTg, u, EVENT_UNIT_DEATH )
        set u = hempty.createUnitXYFacing('n01Z',1162,-3445,135)
		call TriggerRegisterUnitEvent( emptyDeadTg, u, EVENT_UNIT_DEATH )

        set u = hempty.createUnitXY('n021',-2145,4254)
		call TriggerRegisterUnitEvent( emptyDeadTg, u, EVENT_UNIT_DEATH )
        set u = hempty.createUnitXY('n021',-1440,3680)
		call TriggerRegisterUnitEvent( emptyDeadTg, u, EVENT_UNIT_DEATH )
        set u = hempty.createUnitXY('n021',223,4892)
		call TriggerRegisterUnitEvent( emptyDeadTg, u, EVENT_UNIT_DEATH )

    endmethod

endstruct

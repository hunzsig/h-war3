struct hSchedule

	private static method bgmDayByDay takes nothing returns nothing
		local integer i = player_max_qty
		loop
			exitwhen i<=0
				if(inDungeons[i] == false)then
					if(his.day() and hmedia.bgmCurrent[i] != gg_snd_day)then
						call hmedia.bgm2Player(gg_snd_day,players[i])
					elseif(his.night() and hmedia.bgmCurrent[i] != gg_snd_night)then
						call hmedia.bgm2Player(gg_snd_night,players[i])
					endif
				endif
			set i = i-1
		endloop
	endmethod

	private static method jump2Yama takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local player p = GetOwningPlayer(u)
		local integer i = hplayer.index(p)
		call SetUnitPosition( u, GetRectCenterX(rectJumpA2), GetRectCenterY(rectJumpA2) )
		set inDungeons[i] = true
		call hmedia.bgm2Player(gg_snd_yama,p)
		call hmsg.echoTo(p,"你闯进了"+"|cffffff80 山涧！|r小心！",0)
	endmethod
	private static method jump2Last takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local player p = GetOwningPlayer(u)
		local integer i = hplayer.index(p)
		call SetUnitPosition( u, GetRectCenterX(rectJumpB2), GetRectCenterY(rectJumpB2) )
		set inDungeons[i] = true
		call hmedia.bgm2Player(gg_snd_last,p)
		call hmsg.echoTo(p,"你误闯进了"+"|cffff8080 炼狱！！|r万分警惕",0)
	endmethod
	private static method jump2Ice takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local player p = GetOwningPlayer(u)
		local integer i = hplayer.index(p)
		call SetUnitPosition( u, GetRectCenterX(rectJumpI2), GetRectCenterY(rectJumpI2) )
		set inDungeons[i] = true
		call hmedia.bgm2Player(gg_snd_ice,p)
		call hmsg.echoTo(p,"你已临近"+"|cff80ffff 冰川！！|r注意周围的环境",0)
	endmethod
	private static method jump2randomHole takes nothing returns nothing
		local rect rc = null
		local unit u = null
		local integer i = 0
		if(randomHoleAllow == false)then
			set rc = hevt.getTriggerRect()
			set u = hevt.getTriggerUnit()
			set i = LoadInteger(hash_hrect,GetHandleId(rc),1)
			call hconsole.warning("randomHoleIndexi=="+I2S(randomHoleIndex))
			call hconsole.warning("i=="+I2S(i))
			call hconsole.warning("irandomHole[randomHoleIndex]=="+I2S(randomHole[randomHoleIndex]))
			if(i == randomHole[randomHoleIndex])then
				if(randomHoleIndex == 3)then
					set randomHoleAllow = true
					call SetUnitPosition( u, -2647, 6768 )
					call hmedia.soundPlay2Player(gg_snd_audio_gandepiaoliang,GetOwningPlayer(u))
					call hmsg.echo(GetPlayerName(GetOwningPlayer(u))+"|cff80ffff 首个通过山涧迷洞！！|r")
					set randomHoleIndex = 1
				else
					call hmedia.soundPlay2Player(gg_snd_Switch,GetOwningPlayer(u))
					call SetUnitPosition( u, -1516, 6015 )
					set randomHoleIndex = randomHoleIndex+1
				endif
			else
				call hmedia.soundPlay2Player(gg_snd_audio_deda,GetOwningPlayer(u))
				set randomHoleIndex = 1
				call SetUnitPosition( u, -1516, 6015 )
			endif
		else
			call SetUnitPosition( u, -2647, 6768 )
		endif
	endmethod

	public static method run takes nothing returns nothing
		local integer i = 0
		local unit u = null
		local timer t = null
		local trigger tg = null
		local real chooseTime = 30.0
		
		set player_max_qty = 1
		//设定玩家不在Dungeons
		set i = player_max_qty
		loop
			exitwhen i<=0
				set inDungeons[i] = false
			set i = i-1
		endloop
		//设定作为敌人的电脑玩家
		call hempty.setEmptyPlayer(players[10])
		call hempty.setEmptyPlayer(players[11])
		call hempty.setEmptyPlayer(players[12])
		//hSet
		call hSet.setInit()
		//BGM走起
		call hmedia.bgm(gg_snd_night)
		//白天黑夜BGM
		call htime.setInterval(10.00,function thistype.bgmDayByDay)
		//生成初始地补血火炬
		set hxy.x = GetLocationX(Loc_C)
		set hxy.y = GetLocationY(Loc_C)
		set i = 1
		loop
			exitwhen i>5
				set u = hempty.createUnithXY('n01T',hlogic.polarProjection(hxy,130,i*360/5))
				call hAttrEffect.addFireVal(u,-5.00,0)
				call hAttrEffect.addFireDuring(u,3.00,0)
				call hAttrEffect.addDryVal(u,-5.00,0)
				call hAttrEffect.addDryDuring(u,3.00,0)
			set i=i+1
		endloop
		//将英雄类型写进酒馆，并生成选英雄
		set i = 1
		loop
			exitwhen i>g_hero_count
				call hhero.push(g_hero[i])
			set i=i+1
		endloop
		call hhero.setPlayerAllowQty(1)
		call hhero.setDrunkeryID('n01V')
		call hhero.setBornXY(GetLocationX(Loc_C),GetLocationY(Loc_C))
		call hhero.setBuildXY(1660,2045)
		call hhero.setBuildDistance(100.00)
		call hhero.buildDrunkery(chooseTime)

		//开启刷兵机制
		call htime.setTimeout(chooseTime+7.00,function hSet.goEmpty)
		call htime.setTimeout(chooseTime+180.00,function hSet.goBoss)
		//开启环境
		call htime.setTimeout(chooseTime+3.00,function hSet.goEnv)

		//矩形飞
		set tg = CreateTrigger()
		call TriggerRegisterEnterRectSimple( tg, rectJumpA1 )
		call TriggerAddAction(tg, function thistype.jump2Yama)
		set tg = CreateTrigger()
		call TriggerRegisterEnterRectSimple( tg, rectJumpB1 )
		call TriggerAddAction(tg, function thistype.jump2Last)
		set tg = CreateTrigger()
		call TriggerRegisterEnterRectSimple( tg, rectJumpI1 )
		call TriggerAddAction(tg, function thistype.jump2Ice)

		//随机洞穴
        set randomHoleIndex = 1
        set randomHole[1] = GetRandomInt(1,3)
        set randomHole[2] = GetRandomInt(1,3)
        set randomHole[3] = GetRandomInt(1,3)
        //随机洞穴设定三个矩形
		set rectShanjianL = hrect.createInLoc(-2214,5824,120,120)
		call SaveInteger(hash_hrect,GetHandleId(rectShanjianL),1,1)
		set rectShanjianM = hrect.createInLoc(-1471,6564,120,120)
		call SaveInteger(hash_hrect,GetHandleId(rectShanjianM),1,2)
		set rectShanjianR = hrect.createInLoc(-836,5708,120,120)
		call SaveInteger(hash_hrect,GetHandleId(rectShanjianR),1,3)
		call hevt.onEnterRect( rectShanjianL,function thistype.jump2randomHole )
		call hevt.onEnterRect( rectShanjianM,function thistype.jump2randomHole )
		call hevt.onEnterRect( rectShanjianR,function thistype.jump2randomHole )

	endmethod

endstruct

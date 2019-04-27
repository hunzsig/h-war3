globals
	trigger sommonDeadTg = null
	trigger sommonLevelupTg = null
endglobals
struct hSet

	private static integer currentChengqu = 0
    private static trigger heroDeadTg = null
    private static trigger emptyDeadTg = null
    private static trigger bossDeadTg = null
    private static trigger destructableDeadTg = null
    private static trigger luckyDrawTg = null

	private static method fusuzhiguang takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit u = htime.getUnit(t,1)
		call htime.delTimer(t)
		if(hgroup.isIn(u,sk_group_fusuzhiguang) == true)then
			call hgroup.out(u,sk_group_fusuzhiguang)
		endif
		set t = null
		set u = null
	endmethod
	private static method onHeroSkillHappen takes nothing returns nothing
		local unit triggerUnit = hevt.getTriggerUnit()
		local integer skillid = hevt.getTriggerSkill()
		local location loc = null
		local location loc2 = null
		local hAttrHuntBean bean
		local group g = null
		local player p = null
		local unit u = null
		local integer i = 0
		local hFilter hf
		local timer t = null
		if(skillid == 'A05K')then // 逸风 - 一刹
			call SetUnitAnimation( triggerUnit, "attack slam" )
			set loc = hevt.getTargetLoc()
			set bean = hAttrHuntBean.create()
            set bean.damage = 3 * hattr.getAttackPhysical(triggerUnit)
            set bean.fromUnit = triggerUnit
            set bean.huntEff = "Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl"
            set bean.huntKind = "attack"
            set bean.huntType = "physicalwind"
            call hskill.leap(triggerUnit,loc,50,"Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl",75,false,bean)
            call bean.destroy()
		elseif(skillid == 'A05L')then // 逸风 - 无影斩
			call SetUnitVertexColorBJ( triggerUnit, 100, 100, 100, 75.00 )
			set bean = hAttrHuntBean.create()
            set bean.damage = hattr.getAttackPhysical(triggerUnit)
            set bean.fromUnit = triggerUnit
            set bean.huntEff = "Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl"
            set bean.huntKind = "attack"
            set bean.huntType = "physicalwind"
            call hskill.shuttleToUnit(triggerUnit,hevt.getTargetUnit(),300,20,30,5,50,null,"attack",'A06K',bean)
            call bean.destroy()
		endif
		if(skillid == 'A05M')then // 赤血 - 狂暴
			call hattr.addAttackSpeed(triggerUnit,100,10)
			call hattr.addMove(triggerUnit,100,10)
		elseif(skillid == 'A05N')then // 赤血 - 剑刃风暴
			call hattr.addHuntAmplitude(triggerUnit,I2R(GetUnitLevel(triggerUnit)) * 1, 10)
			call hattr.addKnocking(triggerUnit,I2R(GetUnitLevel(triggerUnit)) * 50, 10)
		endif
		if(skillid == 'A05I')then // 暗影猎手 - 恩典
			set hf = hFilter.create()
			call hf.isAlive(true)
			call hf.isBuilding(false)
			call hf.isAlly(true,triggerUnit)
			set g = hgroup.createByUnit(triggerUnit,600,function hFilter.get)
			call hf.destroy()
			if(hgroup.count(g)>0)then
				loop
				exitwhen(IsUnitGroupEmptyBJ(g) == true)
					set u = FirstOfGroup(g)
					call GroupRemoveUnit( g , u )
					call hattr.addAttackPhysical(u,I2R(GetUnitLevel(triggerUnit)) * 2,30)
					call heffect.toUnitLoc("war3mapImported\\CallOfAggression.mdx",u,1.00)
					set u = null
				endloop
			endif
			call GroupClear(g)
			call DestroyGroup(g)
			set g = null
		elseif(skillid == 'A05O')then // 暗影猎手 - 蛇棒
			set loc = hevt.getTargetLoc()
			set loc2 = GetUnitLoc(triggerUnit)
			set i = 1
			loop
				exitwhen i > 3
					set u = hunit.createUnitFacing(GetOwningPlayer(triggerUnit),'n04R',loc,hlogic.getDegBetweenLoc(loc2,loc))
					call hunit.setPeriod(u,60)
					call hattr.addLife(u,I2R(GetUnitLevel(triggerUnit)) * 15,59.9)
					call hattr.addAttackPhysical(u,hattr.getAttackMagic(triggerUnit),0)
					set u = null
				set i=i+1
			endloop
			call RemoveLocation(loc)
			call RemoveLocation(loc2)
		endif
		if(skillid == 'A04H')then // 大魔法师 - 召唤水元素
			set hxy.x = GetUnitX(triggerUnit)
			set hxy.y = GetUnitY(triggerUnit)
			set hxy = hlogic.polarProjection(hxy,125.0,GetUnitFacing(triggerUnit))
			set i = 1
			loop
				exitwhen i > 2
					set u = hunit.createUnithXY(GetOwningPlayer(triggerUnit),'n04U',hxy)
					call hunit.setPeriod(u,45)
					call hattr.addAttackHuntType(u,"water",0)
					call hattr.addLife(u,I2R(GetUnitLevel(triggerUnit)) * 15,44.9)
					call hattrNatural.addWaterOppose(u,50,0)
					call hattrNatural.addFireOppose(u,50,0)
					call hattr.addAttackMagic(u,hattr.getAttackMagic(triggerUnit),0)
				set i=i+1
			endloop
		elseif(skillid == 'A06J')then // 大魔法师 - 魔窍
			call hattr.addMana(hevt.getTargetUnit(),100,10)
			call hattr.addManaBack(hevt.getTargetUnit(),3.0,10)
			call hattr.addAttackHuntType(hevt.getTargetUnit(),"ice",10)
		elseif(skillid == 'A04G')then // 大魔法师 - 暴风雪
			call hattr.addAttackHuntType(triggerUnit,"waterice",10.0)
		endif
		if(skillid == 'A06O')then // 圣骑士 - 神圣护甲
			call hattr.setLifeBack(triggerUnit,hattr.getLife(triggerUnit)*0.1,5)
		elseif(skillid == 'A06Q')then // 圣骑士 - 闪爆
		elseif(skillid == 'A06R')then // 圣骑士 - 复苏之光
			set hf = hFilter.create()
			call hf.isAlive(true)
			call hf.isBuilding(false)
			call hf.isAlly(true,triggerUnit)
			set g = hgroup.createByUnit(hevt.getTargetUnit(),275,function hFilter.get)
			call hf.destroy()
			if(hgroup.count(g)>0)then
				loop
				exitwhen(IsUnitGroupEmptyBJ(g) == true)
					set u = FirstOfGroup(g)
					call GroupRemoveUnit( g , u )
					if(hgroup.isIn(u,sk_group_fusuzhiguang) == false)then
						call hgroup.in(u,sk_group_fusuzhiguang)
						call hattr.addAttackHuntType(u,"light",15.0)
						call heffect.toUnit("war3mapImported\\HolyAurora.mdx",u,"origin",13.50)
						set t = htime.setTimeout(15.00,function thistype.fusuzhiguang)
						call htime.setUnit(t,1,u)
					endif
					set u = null
				endloop
			endif
			call GroupClear(g)
			call DestroyGroup(g)
			set g = null
		endif
		if(skillid == 'A06X')then // 魔剑士 - 冰钢之军
			set hf = hFilter.create()
			call hf.isAlive(true)
			call hf.isBuilding(false)
			call hf.isAlly(true,triggerUnit)
			set g = hgroup.createByUnit(triggerUnit,600,function hFilter.get)
			call hf.destroy()
			if(hgroup.count(g)>0)then
				loop
				exitwhen(IsUnitGroupEmptyBJ(g) == true)
					set u = FirstOfGroup(g)
					call GroupRemoveUnit( g , u )
					call hattr.addDefend(u,I2R(GetUnitLevel(triggerUnit)),10)
					call hattrNatural.addIceOppose(u,30,10)
					set u = null
				endloop
			endif
			call GroupClear(g)
			call DestroyGroup(g)
			set g = null
		elseif(skillid == 'A06Y')then // 魔剑士 - 光焰冲锋
			call SetUnitAnimation( triggerUnit, "attack" )
			set loc = hevt.getTargetLoc()
			set bean = hAttrHuntBean.create()
            set bean.damage = 4 * hattr.getAttackMagic(triggerUnit)
            set bean.fromUnit = triggerUnit
            set bean.huntEff = "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl"
            set bean.huntKind = "skill"
            set bean.huntType = "magicfire"
            call hskill.leap(triggerUnit,loc,25,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl",125,false,bean)
            call bean.destroy()
		endif
		if(skillid == 'A072')then // 森林老鹿 - 森林庇护
			set hf = hFilter.create()
			call hf.isAlive(true)
			call hf.isBuilding(false)
			call hf.isAlly(true,triggerUnit)
			set g = hgroup.createByUnit(triggerUnit,600,function hFilter.get)
			call hf.destroy()
			if(hgroup.count(g)>0)then
				loop
				exitwhen(IsUnitGroupEmptyBJ(g) == true)
					set u = FirstOfGroup(g)
					call GroupRemoveUnit( g , u )
					call hattr.addLifeBack(u,3.0 * I2R(GetUnitLevel(triggerUnit)),30)
					call hattr.addToughness(u,1.5 * I2R(GetUnitLevel(triggerUnit)),30)
					set u = null
				endloop
			endif
			call GroupClear(g)
			call DestroyGroup(g)
			set g = null
		elseif(skillid == 'A073')then // 森林老鹿 - 缠绕
			call hattrNatural.addWood(triggerUnit,1.0 * I2R(GetUnitLevel(triggerUnit)),60)
		endif
		if(skillid == 'A074')then // 巫妖 - 冽冰鬼盾
			call hattr.addToughness(hevt.getTargetUnit(),2.0 * I2R(GetUnitLevel(triggerUnit)),20)
			call hattr.addPunish(hevt.getTargetUnit(),50.0 * I2R(GetUnitLevel(triggerUnit)),20)
			call hattrNatural.addIceOppose(hevt.getTargetUnit(),75,20)
		elseif(skillid == 'A075')then // 巫妖 - 阴骨
			call hattr.addAttackHuntType(hevt.getTargetUnit(),"ice",15)
			call hattrNatural.addIce(hevt.getTargetUnit(),50.0,15)
		elseif(skillid == 'A076')then // 巫妖 - 霜冻凝结
			call hattr.subMove(hevt.getTargetUnit(),300.0,3)
			call hattr.subAttackSpeed(hevt.getTargetUnit(),80.0,3)
		elseif(skillid == 'A077')then // 巫妖 - 冰封
			call hAttrEffect.addColdVal(triggerUnit,10.0,6)
			call hAttrEffect.addColdDuring(triggerUnit,3.0,6)
			call hAttrEffect.addFreezeVal(triggerUnit,10.0,6)
			call hAttrEffect.addFreezeDuring(triggerUnit,3.0,6)
			call hattrNatural.addIce(triggerUnit,1.0 * I2R(GetUnitLevel(triggerUnit)),6)
		endif
		if(skillid == 'A08H')then // 操火师 - 点燃
			if(his.ally(triggerUnit,hevt.getTargetUnit()))then
				call hattr.addAttackHuntType(hevt.getTargetUnit(),"fire",15)
				call hattrNatural.addFire(hevt.getTargetUnit(),75.0,15)
			else
				call hattrNatural.subFire(hevt.getTargetUnit(),75.0,15)
			endif
		endif
		if(skillid == 'A07E')then // 黑游 - 黑暗之箭
			call hattrNatural.addDark(triggerUnit,3.0 * I2R(GetUnitLevel(triggerUnit)),11)
		elseif(skillid == 'A07A')then // 黑游 - 寡言
			call hattr.addAttackSpeed(triggerUnit,150.0,11)
			call hAttrEffect.addSilentOdds(triggerUnit,100.0,11)
			call hAttrEffect.addSilentDuring(triggerUnit,2.50,11)
		elseif(skillid == 'A07B')then // 黑游 - 邪魅
			call hattrNatural.addDark(triggerUnit,50,13)
			call SetUnitAnimation( triggerUnit, "spell" )
			set loc = hevt.getTargetLoc()
			set bean = hAttrHuntBean.create()
            set bean.damage = 5 * hattr.getAttackPhysical(triggerUnit)
            set bean.fromUnit = triggerUnit
            set bean.huntEff = "Abilities\\Spells\\NightElf\\shadowstrike\\shadowstrike.mdl"
            set bean.huntKind = "attack"
            set bean.huntType = "magicdark"
            call hskill.leap(triggerUnit,loc,70,"Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdl",75,false,bean)
            call bean.destroy()
		endif
		if(skillid == 'A078')then // 炼金 - 黄金之力
			set p = GetOwningPlayer(triggerUnit)
			call hattr.addAttackPhysical(hevt.getTargetUnit(),hplayer.getTotalGoldCost(p) * 0.004,10)
			call hattr.addAttackSpeed(hevt.getTargetUnit(),hplayer.getTotalGoldCost(p) * 0.0001,10)
		elseif(skillid == 'A07F')then // 炼金 - 看透生德
			call hplayer.subGoldRatio(GetOwningPlayer(triggerUnit),15.0,50.00)
			call hplayer.addExpRatio(GetOwningPlayer(triggerUnit),30.0,50.00)
			call hplayer.addSellRatio(GetOwningPlayer(triggerUnit),20.0,50.00)
		endif
		set triggerUnit = null
		set loc = null
		set loc2 = null
		set g = null
		set p = null
		set u = null
		set t = null
	endmethod
	private static method onHeroLevelUp takes nothing returns nothing
		local unit u = hevt.getTriggerUnit()
		local integer uid = GetUnitTypeId(u)
		local integer lv = GetHeroLevel(u)
		local real diffLv = I2R(lv - hhero.getHeroPrevLevel(u))
		call hattr.addLife(u,diffLv*20,0)
		call hattr.addPunish(u,diffLv*50,0)
		if(uid == 'H00I')then //赤血
            call hattr.addHemophagia(u,diffLv*0.5,0)
        endif
		if(uid == 'H00K')then // 暗影猎手
			call hattrEffect.addToxicVal(u,diffLv*0.3,0)
		endif
		if(uid == 'H00M')then // 大魔法师
			call hattrNatural.addWater(u,diffLv*0.01,0)
		endif
		if(uid == 'H00X')then //操火师
			call hattrNatural.addFire(u,diffLv*1,0)
		endif
		if(uid == 'H00P')then //森林老鹿
			call hattrEffect.addBombVal(u,diffLv*30,0)
		endif
		set u = null
	endmethod
    private static method onHeroDead takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local unit killer = hevt.getLastDamageUnit(u)
		local player p = GetOwningPlayer(u)
		local unit tempu = null
		local real rebornTime = REBORN_HERO
		if(hgroup.isIn(u,sk_group_fusuzhiguang) == true)then
			set rebornTime = 0
		else
			call hmsg.echo(GetUnitName(u)+" 被 "+GetUnitName(killer)+" 狠狠地打死了！"+I2S(R2I(rebornTime))+" 秒后在原地复活～")
			set tempu = hunit.createUnitXYFacing(p,'n05A',GetUnitX(u),GetUnitY(u),270)
			call SetUnitVertexColor(tempu, 255, 255, 0, 200)
			call hunit.shadow(GetUnitTypeId(u),GetUnitX(u),GetUnitY(u),270,100,0,75,120,rebornTime)
			if(rebornTime>0)then
				call SetUnitTimeScalePercent(tempu, 1000.0 / rebornTime)
			endif
			call hunit.del(tempu,rebornTime)
			set g_thisturn_hero_dead_qty = g_thisturn_hero_dead_qty + 1
		endif
        call hunit.rebornAtXY(u,GetUnitX(u),GetUnitY(u),rebornTime,5.00)
		set u = null
		set killer = null
		set p = null
		set tempu = null
	endmethod
	private static method onHeroKill takes nothing returns nothing
		local unit killer = hevt.getKiller()
		local unit bekiller = hevt.getTargetUnit()
		local unit u = null
		if(GetUnitAbilityLevel(killer,'A079') >= 1)then // 黑游 - 黑奴
			call hattr.addAttackSpeed(killer,20,5.00)
			set u = hunit.createUnitXY(GetOwningPlayer(killer),'n04W',GetUnitX(bekiller),GetUnitY(bekiller))
			call hunit.setPeriod(u,5.00)
			call hattr.addAttackHuntType(u,"dark",0)
			call hattr.addLife(u,I2R(GetUnitLevel(killer)) * 10,0)
			call hattrNatural.addDarkOppose(u,90,0)
			call hattr.addAttackPhysical(u,hattr.getAttackPhysical(killer),0)
		endif
		if(GetUnitAbilityLevel(killer,'A07D') >= 1)then // 炼金 - 好运
			call hplayer.addGold(GetOwningPlayer(killer),GetUnitLevel(killer)*4)
		endif
		set u = null
		set killer = null
		set bekiller = null
	endmethod
    private static method onHeroPick takes nothing returns nothing
        local unit u = hevt.getTriggerUnit()
        local integer uid = GetUnitTypeId(u)
        local string t = hhero.getHeroType(uid)
        call TriggerRegisterUnitEvent( heroDeadTg, u, EVENT_UNIT_DEATH )
		call hunit.setOpenPunish(u,true)
		call hevt.onSkillHappen(u,function thistype.onHeroSkillHappen)
		call hevt.onLevelUp(u,function thistype.onHeroLevelUp)
		call hevt.onKill(u,function thistype.onHeroKill)
		call UnitAddAbility(u,'A082') // reborn
        //检测英雄类别
        if(t == "str")then
			call hattr.addMove(u,200,0)
            call hattr.addLife(u,150,0)
			call hattr.addMana(u,80,0)
			call hattr.addManaBack(u,0.50,0)
            call hattr.addAttackPhysical(u,15,0)
        elseif(t == "agi")then
			call hattr.addMove(u,220,0)
            call hattr.addLife(u,130,0)
			call hattr.addMana(u,80,0)
			call hattr.addManaBack(u,1.00,0)
            call hattr.addAttackPhysical(u,25,0)
        elseif(t == "int")then
			call hattr.addMove(u,180,0)
            call hattr.addLife(u,100,0)
            call hattr.addMana(u,120,0)
            call hattr.addManaBack(u,2.00,0)
            call hattr.addAttackMagic(u,20,0)
        endif
        if(uid == 'H001')then //逸风
            call hattr.addAvoid(u,25,0)
            call hattr.addAttackHuntType(u,"wind",0)
            call hattrEffect.addAttackSpeedVal(u,3,0)
            call hattrEffect.addAttackSpeedDuring(u,15,0)
        endif
        if(uid == 'H00I')then //赤血
            call hattr.addHemophagia(u,0.5,0)
			call hattrEffect.addSplitVal(u,5,0)
            call hattrEffect.addSplitDuring(u,7,0)
        endif
        if(uid == 'H00K')then //暗影猎手
            call hattrEffect.addToxicVal(u,0.3,0)
            call hattrEffect.addToxicDuring(u,3,0)
        endif
        if(uid == 'H00M')then //大魔法师
            call hattr.addManaBack(u,3.5,0)
			call hattrNatural.addWater(u,0.01,0)
        endif
        if(uid == 'H00N')then //圣骑士
			if(sk_group_fusuzhiguang == null)then
				set sk_group_fusuzhiguang = CreateGroup()
			endif
            call hattr.addDefend(u,20.0,0)
			call hattrNatural.addFireOppose(u,10.0,0)
			call hattrNatural.addSoilOppose(u,10.0,0)
			call hattrNatural.addWaterOppose(u,10.0,0)
			call hattrNatural.addIceOppose(u,10.0,0)
			call hattrNatural.addWindOppose(u,10.0,0)
			call hattrNatural.addLightOppose(u,10.0,0)
			call hattrNatural.addDarkOppose(u,10.0,0)
			call hattrNatural.addWoodOppose(u,10.0,0)
			call hattrNatural.addThunderOppose(u,10.0,0)
			call hattrNatural.addPoisonOppose(u,10.0,0)
			call hattrNatural.addMetalOppose(u,10.0,0)
			call hattrNatural.addGhostOppose(u,10.0,0)
			call hattrNatural.addDragonOppose(u,10.0,0)
        endif
		if(uid == 'H00O')then //魔剑士
			call hattr.addInvincible(u,10.0,0)
			call hattrEffect.addFreezeVal(u,10.0,0)
			call hattrEffect.addFreezeDuring(u,5.0,0)
			call hattrEffect.addColdVal(u,20.0,0)
			call hattrEffect.addColdDuring(u,5.0,0)
		endif
		if(uid == 'H00X')then //操火师
			call hattr.addAttackHuntType(u,"fire",0)
			call hattrNatural.addFire(u,1.0,0)
		endif
		if(uid == 'H00P')then //森林老鹿
			call hattr.addAttackHuntType(u,"wood",0)
			call hattrNatural.addWoodOppose(u,50.0,0)
			call hattrEffect.setBombOdds(u,100,0)
			call hattrEffect.setBombVal(u,30,0)
			call hattrEffect.setBombRange(u,50,0)
			call hattrEffect.setBombModel(u,"Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl")
		endif
		if(uid == 'H00S')then //黑游
			call hattr.addAttackHuntType(u,"dark",0)
		endif
		if(uid == 'H00R')then //炼金
			call hattr.addAttackHuntType(u,"metal",0)
			call hplayer.addGoldRatio(GetOwningPlayer(u),25,0)
		endif
		set u = null
		set t = null
    endmethod

    private static method removeEnumDestructable takes nothing returns nothing
		call RemoveDestructable( GetEnumDestructable() )
	endmethod

	private static method randomEnv takes nothing returns nothing
		local integer randomIndex = GetRandomInt(1,9)
		local integer i = 0
		local integer rectQty = GetRandomInt(16,16)
		local integer rectArea = 0
		local real x = 2000.0
		local real y = 2000.0
		local rect tempRect = null
		local hWeatherBean wb = 0
		local integer weatherIndex = GetRandomInt(1,3)
		call EnumDestructablesInRectAll(rectBattle, function thistype.removeEnumDestructable )
		call henv.clearUnits()
		call SetTerrainType( GetRectCenterX(rectBattle) , GetRectCenterY(rectBattle), 'Adrd', -1, 21, 1 )
		call SetTerrainType( GetRectCenterX(rectBattle) , GetRectCenterY(rectBattle), 'Agrd', -1, 9, 0 )
		call SetTerrainType( GetRectCenterX(rectBattle) , GetRectCenterY(rectBattle), 'Avin', -1, 3, 0 )
		if (rectWeathereffect != null) then
			call hweather.del(rectWeathereffect)
		endif
		set i = 1
		loop
			exitwhen i>rectQty
				set rectArea = GetRandomInt(100,450)
				set hxy.x = GetRandomReal(GetRectMinX(rectBattleInner)+rectArea, GetRectMaxX(rectBattleInner)-rectArea)
				set hxy.y = GetRandomReal(GetRectMinY(rectBattleInner)+rectArea, GetRectMaxY(rectBattleInner)-rectArea)
				if(hxy.x > GetRectCenterX(rectBattle)-x/2 and hxy.x < GetRectCenterX(rectBattle)+x/2 and hxy.y > GetRectCenterY(rectBattle)-y/2 and hxy.y < GetRectCenterY(rectBattle)+y/2)then
					// nothing
				else 
					set tempRect = hrect.createInLoc(hxy.x,hxy.y,rectArea,rectArea)
					set wb = hWeatherBean.create()
					set wb.x = 2048
					set wb.y = 2048
					set wb.width = spaceDistance
					set wb.height = spaceDistance
					if (randomIndex == 1) then
						call henv.randomSummer(tempRect,x,y,true)
						if (weatherIndex == 1) then
							set rectWeathereffect = hweather.rain(wb)
							set rectWeatherString = "rain"
						elseif (weatherIndex == 2) then
							set rectWeathereffect = hweather.rainstorm(wb)
							set rectWeatherString = "rainstorm"
						endif
					elseif (randomIndex == 2) then
						call henv.randomAutumn(tempRect,x,y,true)
						if (weatherIndex == 1) then
							set rectWeathereffect = hweather.rain(wb)
							set rectWeatherString = "rain"
						elseif (weatherIndex == 2) then
							set rectWeathereffect = hweather.wind(wb)
							set rectWeatherString = "wind"
						endif
					elseif (randomIndex == 3) then
						call henv.randomWinter(tempRect,x,y,true)
						if (weatherIndex == 1) then
							set rectWeathereffect = hweather.snow(wb)
							set rectWeatherString = "snow"
						elseif (weatherIndex == 2) then
							set rectWeathereffect = hweather.wind(wb)
							set rectWeatherString = "wind"
						endif
					elseif (randomIndex == 4) then
						call henv.randomWinterShow(tempRect,x,y,true)
						if (weatherIndex == 1) then
							set rectWeathereffect = hweather.snowstorm(wb)
							set rectWeatherString = "snowstorm"
						elseif (weatherIndex == 2) then
							set rectWeathereffect = hweather.windstorm(wb)
							set rectWeatherString = "windstorm"
						endif
					elseif (randomIndex == 5) then
						call henv.randomDark(tempRect,x,y,true)
						if (weatherIndex == 1) then
							set rectWeathereffect = hweather.rain(wb)
							set rectWeatherString = "rain"
						elseif (weatherIndex == 2) then
							set rectWeathereffect = hweather.mistblue(wb)
							set rectWeatherString = "mistblue"
						endif
					elseif (randomIndex == 6) then
						call henv.randomPoor(tempRect,x,y,true)
						if (weatherIndex == 1) then
							set rectWeathereffect = hweather.wind(wb)
							set rectWeatherString = "wind"
						elseif (weatherIndex == 2) then
							set rectWeathereffect = hweather.windstorm(wb)
							set rectWeatherString = "windstorm"
						endif
					elseif (randomIndex == 7) then
						call henv.randomRuins(tempRect,x,y,true)
						if (weatherIndex == 1) then
							set rectWeathereffect = hweather.rain(wb)
							set rectWeatherString = "rain"
						elseif (weatherIndex == 2) then
							set rectWeathereffect = hweather.rainstorm(wb)
							set rectWeatherString = "rainstorm"
						elseif (weatherIndex == 3) then
							set rectWeathereffect = hweather.mistgreen(wb)
							set rectWeatherString = "mistgreen"
						endif
					elseif (randomIndex == 8) then
						call henv.randomFire(tempRect,x,y,true)
						if (weatherIndex == 1) then
							set rectWeathereffect = hweather.mistred(wb)
							set rectWeatherString = "mistred"
						endif
					elseif (randomIndex == 9) then
						call henv.randomUnderground(tempRect,x,y,true)
						if (weatherIndex == 1) then
							set rectWeathereffect = hweather.shield(wb)
							set rectWeatherString = "shield"
						endif
					endif
					set tempRect = null
					call wb.destroy()
					set i=i+1
				endif
		endloop
	endmethod

	public static method failEnv takes nothing returns nothing
		local integer i = 0
		local integer j = 0
		local integer rectArea = 0
		local real x = 1300.0
		local real y = 1300.0
		local rect tempRect = null
		local hWeatherBean wb = 0
		call EnumDestructablesInRectAll(rectBattle, function thistype.removeEnumDestructable )
		call henv.clearUnits()
		call SetTerrainType( GetRectCenterX(rectBattle) , GetRectCenterY(rectBattle), 'Adrd', -1, 4, 0 )
		call SetBlight( player_aggressive, GetRectCenterX(rectBattle) , GetRectCenterY(rectBattle), 3200, true )
		if (rectWeathereffect != null) then
			call hweather.del(rectWeathereffect)
		endif
		set i = 1
		loop
			exitwhen i>16
				set rectArea = GetRandomInt(0,470)
				set hxy.x = GetRandomReal(GetRectMinX(rectBattleInner)+rectArea, GetRectMaxX(rectBattleInner))
				set hxy.y = GetRandomReal(GetRectMinY(rectBattleInner)+rectArea, GetRectMaxY(rectBattleInner))
				if(hxy.x > GetRectCenterX(rectBattle)-x/2 and hxy.x < GetRectCenterX(rectBattle)+x/2 and hxy.y > GetRectCenterY(rectBattle)-y/2 and hxy.y < GetRectCenterY(rectBattle)+y/2)then
					// nothing
				else 
					set tempRect = hrect.createInLoc(hxy.x,hxy.y,rectArea,rectArea)
					set wb = hWeatherBean.create()
					set wb.x = rectArea
					set wb.y = rectArea
					set wb.width = spaceDistance
					set wb.height = spaceDistance
					call henv.randomDark(tempRect,x,y,true)
					set rectWeathereffect = hweather.rainstorm(wb)
					set tempRect = null
				endif
				call hunit.createUnithXY(player_passive,'n00N',hxy)
			set i = i+1
		endloop
		set tempRect = null
	endmethod

	private static method winEnv takes nothing returns nothing
		local integer i = 0
		local integer j = 0
		local integer rectArea = 0
		local real x = 1300.0
		local real y = 1300.0
		local rect tempRect = null
		local hWeatherBean wb = 0
		local string txt = null
		local unit u = null
		call hmedia.bgm(gg_snd_bgm_xy_gts_dspadpcm)
		call SetUnitTimeScalePercent( u_timering, 0.00 )
		call ForGroupBJ( g_gp_summon, function thistype.allowSommons )
		call EnumDestructablesInRectAll(rectBattle, function thistype.removeEnumDestructable )
		call henv.clearUnits()
		call SetTerrainType( GetRectCenterX(rectBattle) , GetRectCenterY(rectBattle), 'Agrd', -1, 15, 0 )
		if (rectWeathereffect != null) then
			call hweather.del(rectWeathereffect)
		endif
		set i = 1
		loop
			exitwhen i>16
				set rectArea = GetRandomInt(0,470)
				set hxy.x = GetRandomReal(GetRectMinX(rectBattleInner)+rectArea, GetRectMaxX(rectBattleInner))
				set hxy.y = GetRandomReal(GetRectMinY(rectBattleInner)+rectArea, GetRectMaxY(rectBattleInner))
				if(hxy.x > GetRectCenterX(rectBattle)-x/2 and hxy.x < GetRectCenterX(rectBattle)+x/2 and hxy.y > GetRectCenterY(rectBattle)-y/2 and hxy.y < GetRectCenterY(rectBattle)+y/2)then
					// nothing
				else 
					set tempRect = hrect.createInLoc(hxy.x,hxy.y,rectArea,rectArea)
					set wb = hWeatherBean.create()
					set wb.x = 2500
					set wb.y = 2500
					set wb.width = spaceDistance
					set wb.height = spaceDistance
					call henv.randomSummer(tempRect,x,y,true)
					set rectWeathereffect = hweather.sun(wb)
				endif
				set j = GetRandomInt(1,5)
				if(j == 1)then
					call hunit.createUnithXY(player_passive,'n018',hxy)
				elseif(j == 2)then
					call hunit.createUnithXY(player_passive,'n019',hxy)
				elseif(j == 3)then
					call hunit.createUnithXY(player_passive,'n01A',hxy)
				elseif(j == 4)then
					call hunit.createUnithXY(player_passive,'n01B',hxy)
				elseif(j == 5)then
					call hunit.createUnithXY(player_passive,'n01C',hxy)
				endif
			set i = i+1
		endloop
		//生成长老/魔兽
		call hunit.createUnitXYFacing(player_ally,'n002',2330,2551, 270)
		call hunit.createUnitXY(player_ally,'n012',2086,4689)
		set u = hempty.createUnitXYFacing(last_boss_uid,2086,4689, 270)
		call hattr.setMove(u,0,0)
		call hattr.setLife(u,5000000,0)
		call hattr.setLifeBack(u,20000,0)
		// 任务F9提醒
		call hmark.display(null,"war3mapImported\\win.blp",1.0,10.0,100.0,100.0)
		set txt = ""
		set txt = txt + "冒险者感谢你！"
		set txt = txt + "|n时空境域恢复了原来的生气，看村民都出来游玩了"
		set txt = txt + "|n谢谢你，你可以继续留在这里游玩，也可以回到你的世界～"
		set txt = txt + "|n而混沌魔兽的老大被锁住作为警示了，你也可以去看看"
		set txt = txt + "|n再次感激！"
		call QuestMessageBJ( playerForce, bj_QUESTMESSAGE_DISCOVERED, "守住了！胜利了！冒险者！" )
		call QuestSetCompleted( CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "通关！胜利！",txt, "ReplaceableTextures\\CommandButtons\\BTNStarWand.blp" ), true )
		set tempRect = null
		set wb = 0
		set txt = null
		set u = null
	endmethod

	private static method checkGGPmon takes nothing returns nothing
		if(hgroup.count(g_gp_mon) <= 0)then
			call htime.delTimer(GetExpiredTimer())
			call thistype.nextWave(90)
		endif
	endmethod

	// 刷兵机制
    private static method onEmptyDead takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local unit killer = hevt.getLastDamageUnit(u)
		local integer exp = 0
		local integer gold = 0
        local real x = GetUnitX(u)
        local real y = GetUnitY(u)
        local integer uid = GetUnitTypeId(u)
		call hGlobals.emptyDeadDrop(u)
		if(g_gp_mon != null)then
			call GroupRemoveUnit(g_gp_mon,u)
		endif
		set exp = R2I(I2R(g_wave) * 15 * g_game_speed)
		set gold = R2I(I2R(g_wave) * 2 * g_game_speed)
		if(killer != null)then
			call haward.forGroup(killer,exp,0,0)
		endif
		call hunit.del(u,2.00)
        // gold
		if (gold<1)then
			set gold = 1
		endif
		call hitem.toXY(momentItems[1],gold,x,y,90.00)
		if(GetRandomInt(1,100) == 44)then
			call hitem.toXY(momentItems[3],g_wave*100,x,y,120.00)
		endif
		set u = null
		set killer = null
	endmethod
    
	public static method createEmpty takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer i = htime.getInteger(t,1)
		local integer rand = GetRandomInt(1,spaceDegQty)
		local location loc = null
		local unit u = null
		if(i >= R2I(g_gp_max / g_game_speed))then
			call htime.delTimer(t)
			set t = null
			if(g_mon_isrunning != false)then
				if(hlogic.imod(g_wave+1,g_boss_mod) == 0 or g_wave+1 >= g_max_wave)then
					call htime.setInterval(3.00,function thistype.checkGGPmon)
				else
					call thistype.nextWave(0)
				endif
			endif
			return
		endif
		if(hgroup.count(g_gp_mon) >= 60)then
			return
		endif
		call htime.setInteger(t,1,1+i)
		set loc = Location(spaceDegX[rand],spaceDegY[rand])
		set u = hempty.createUnitAttackToLoc(g_mon[g_wave],loc,Loc_C)
		call RemoveLocation(loc)
		call GroupAddUnit(g_gp_mon,u)
		call TriggerRegisterUnitEvent( emptyDeadTg, u, EVENT_UNIT_DEATH )
        call hattr.setLife(u,g_mon_life[g_wave],0)
        call hattr.setDefend(u,g_mon_defend[g_wave],0)
		call hattr.setMove(u,g_mon_move[g_wave],0)
        call hattr.setAttackPhysical(u,g_mon_attackPhysical[g_wave],0)
		call hGlobals.emptyBuilt(u)
		set t = null
		set u = null
		set loc = null
	endmethod

	private static method onBossDead takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local unit killer = hevt.getLastDamageUnit(u)
		local integer exp = 0
		local integer gold = 0
		local integer i = 0
		call hGlobals.bossDeadDrop(u)
		call hmedia.soundPlay(gg_snd_audio_gandepiaoliang)
		call hmsg.echo("|cffffff80"+GetUnitName(u)+"|r被狠狠地打死了～|r")
		if(g_gp_mon != null)then
			call GroupRemoveUnit(g_gp_mon,u)
		endif
		set exp = g_wave * 3000
		set gold = g_wave * 70
		if(killer!=null)then
			call haward.forUnit(killer,exp,0,0)
		endif
		call hitem.toXY(momentItems[2],1,GetUnitX(u),GetUnitY(u),90.00)
		set i = 1
		loop
			exitwhen i > 20
				set hxy.x = GetUnitX(u)
        		set hxy.y = GetUnitY(u)
				set hxy = hlogic.polarProjection(hxy,i*10,i*10)
				call hitem.toXY(momentItems[1],gold,hxy.x,hxy.y,90.00)
				if(GetRandomInt(1,50) == 33)then
					call hitem.toXY(momentItems[3],g_wave*1000,hxy.x,hxy.y,90.00)
				endif
			set i = i+1
		endloop
		call hunit.del(u,5)
		call hmedia.bgm(gg_snd_gyq_battle)
		set u = null
		set killer = null
	endmethod

	public static method createBoss takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local unit u = null
        local location loc = null
		local integer bossIndex = g_wave / g_boss_mod
		local integer rand = GetRandomInt(1,spaceDegQty)
		local real bossPercent = 0
		local real bossPercentLittle = 0
		local real bossPercentTiny = 0
		call htime.delTimer(t)
		set loc = Location(spaceDegX[rand],spaceDegY[rand])
		set u = hempty.createUnitAttackToLoc(g_boss[bossIndex],loc,Loc_C)
		set last_boss_uid = g_boss[bossIndex]
		call GroupAddUnit(g_gp_mon,u)
		call TriggerRegisterUnitEvent( bossDeadTg, u, EVENT_UNIT_DEATH )
		set bossPercent = I2R(bossIndex) * 5
		set bossPercentLittle = I2R(bossIndex) * 4
		set bossPercentTiny = I2R(bossIndex) * 3
		if(bossPercent > 90)then
			set bossPercent = 90
		endif
		if(bossPercentLittle > 75)then
			set bossPercentLittle = 75
		endif
		if(bossPercentTiny > 60)then
			set bossPercentTiny = 60
		endif
        call hattr.setLife(u,g_boss_life[bossIndex],0)
        call hattr.setDefend(u,g_boss_defend[bossIndex],0)
		call hattr.setMove(u,g_boss_move[bossIndex],0)
        call hattr.setAttackPhysical(u,g_boss_attackPhysical[bossIndex],0)
        call hattr.setAttackSpeed(u,I2R(bossIndex) * 1,0)
        call hattr.setLifeBack(u,I2R(bossIndex) * 10.0,0)
        call hattr.setAim(u,bossPercent,0)
        call hattr.setAvoid(u,bossPercentLittle,0)
		call hattr.setInvincible(u,bossPercent,0)
        call hattr.setSwimOppose(u,bossPercent,0)
        call hattr.setSilentOppose(u,bossPercent,0)
        call hattr.setUnarmOppose(u,bossPercent,0)
        call hattr.setFetterOppose(u,bossPercent,0)
        call hattr.setBombOppose(u,bossPercentTiny,0)
        call hattr.setCrackFlyOppose(u,bossPercentLittle,0)
        call hattr.setKnockingOppose(u,I2R(bossIndex) * 1000,0)
        call hattr.setViolenceOppose(u,I2R(bossIndex) * 1500,0)
		call hGlobals.bossBuilt(u)
		//警告
		call PingMinimapLocForForceEx( GetPlayersAll(),loc,3, bj_MINIMAPPINGSTYLE_FLASHY, 100, 0, 0 )
		call RemoveLocation(loc)
		call hmedia.bgm(gg_snd_eddyliu_menu_bgm)
		call hmedia.soundPlay(gg_snd_audio_buyaohuang)
		call hmsg.echo("|cffffff80"+GetUnitName(u)+"|r现身！！|cffffff80注意防范！|r")
		set t = null
		set u = null
		set loc = null
	endmethod

	private static method stopSommons takes nothing returns nothing
		set g_waving = true
		call hattr.setMove( GetEnumUnit(), 0, 0 )
		call UnitRemoveAbility(GetEnumUnit(),'A03W')
		call UnitAddAbility(GetEnumUnit(),'A044')
		call IssueImmediateOrder(GetEnumUnit(), "holdposition" )
	endmethod

	private static method allowSommons takes nothing returns nothing
		set g_waving = false
		if(GetUnitTypeId(GetEnumUnit()) != 'H00Y')then
			call hattr.setMove( GetEnumUnit(), 522, 0 )
		endif
		call UnitRemoveAbility(GetEnumUnit(),'A044')
		call UnitAddAbility(GetEnumUnit(),'A03W')
	endmethod

    private static method mildDirect takes nothing returns nothing
		local timer t = null
		set t = htime.setInterval(0.40,function thistype.createEmpty)
		call htime.setInteger(t,1,0)
		if (hlogic.imod(g_wave,g_boss_mod) == 0) then
			set t = htime.setTimeout(0.40*0.6*(g_gp_max / g_game_speed),function thistype.createBoss)
		endif
		set t = null
	endmethod
    private static method mild takes nothing returns nothing
		local timer t = GetExpiredTimer()
		call htime.delTimer(t)
		call hmedia.bgm(gg_snd_gyq_battle)
		call hmedia.soundPlay(gg_snd_audio_effect_4)
		call SetUnitTimeScalePercent( u_timering, 100.00 )
		call ForGroupBJ( g_gp_summon, function thistype.stopSommons )
		set t = htime.setInterval(0.40,function thistype.createEmpty)
		call htime.setInteger(t,1,0)
		if (hlogic.imod(g_wave,g_boss_mod) == 0) then
			set t = htime.setTimeout(0.40*0.6*(g_gp_max / g_game_speed),function thistype.createBoss)
		endif
		set t = null
	endmethod

	private static method enemyDebug takes nothing returns nothing
		local integer i = 0
		local integer waveBoss = 0
		call GroupPointOrderLoc( g_gp_mon , "attack", Loc_C )
		//记录
		set waveBoss = R2I((I2R(g_wave)/5)) * 5
		set i = player_max_qty
		loop
			exitwhen i<=0
				if(GetPlayerServerValueSuccess(players[i]) == true)then
					if(DzAPI_Map_GetStoredInteger(players[i], "wavelevel") < waveBoss)then
						call DzAPI_Map_StoreInteger(players[i], "wavelevel", waveBoss )
						call DzAPI_Map_Stat_SetStat(players[i], "wavelevel", I2S(waveBoss) )
					endif
				endif
			set i = i-1
		endloop
	endmethod

	// 计算出怪点
	private static method readyWave takes real holdon returns nothing
		local location loc = null
		local integer i = 0
		local timer t = null
		if (holdon <= 0) then
			call hmsg.echo("|cffffff00Lv."+I2S(g_wave)+" 来袭！来袭！|r")
			call mildDirect()
		else
			call thistype.randomEnv()
			if(g_wave < 8)then
				set spaceDegQty = 3
			elseif(g_wave < 28)then
				set spaceDegQty = 4
			elseif(g_wave < 64)then
				set spaceDegQty = 5
			elseif(g_wave < 88)then
				set spaceDegQty = 6
			elseif(g_wave < 128)then
				set spaceDegQty = 7
			else
				set spaceDegQty = 8
			endif
			set spaceDegQty = spaceDegQty + player_current_qty
			set i = spaceDegQty
			loop
				exitwhen(i<=0)
					set hxy.x = GetLocationX(Loc_C)
					set hxy.y = GetLocationY(Loc_C)
					set hxy = hlogic.polarProjection(hxy,spaceDistance/2-GetRandomReal(0,1600),GetRandomReal(0,360))
					set spaceDegX[i] = hxy.x
					set spaceDegY[i] = hxy.y
					set t = htime.setTimeout(1,function thistype.nextWaveClearEnv)
					call htime.setReal(t,1,hxy.x)
					call htime.setReal(t,2,hxy.y)
					set loc = Location(hxy.x,hxy.y)
					call hunit.kill(hunit.createUnitXY(player_ally,'n012',hxy.x,hxy.y),holdon)
					call PingMinimapLocForForceEx( GetPlayersAll(),loc,20, bj_MINIMAPPINGSTYLE_FLASHY, 100, 0, 0 )
					call RemoveLocation(loc)
					set loc = null
				set i = i-1
			endloop 
			set g_timer_wave = htime.setTimeout( holdon ,function thistype.mild)
			call SetUnitTimeScalePercent( u_timering, 0.00 )
			call hattr.addLife(u_timering,500,0)
			call hattr.addDefend(u_timering,0.50,0)
			call hattr.addResistance(u_timering,1.0,0)
			call hattr.addLifeBack(u_timering,0.60,0)
			call ForGroupBJ( g_gp_summon, function thistype.allowSommons )
			if (hlogic.imod(g_wave,g_boss_mod) == 0) then
				call hmark.display(null,"war3mapImported\\warning.blp",1.0,5.0,100.0,100.0)
				call hmedia.bgm(gg_snd_dangerComing)
				call htime.setDialog(g_timer_wave, g_mon_label[g_wave] +"※"+ g_boss_label[g_wave/g_boss_mod])
				// 创建boss的关卡时候，增加总敌军数 20
				set g_gp_max = g_gp_max + 20 * player_current_qty
				if(spaceDegQty > 1)then
					call hmsg.echo("时空炸裂！小心狡猾敌人！|cffff8080"+g_boss_label[g_wave/g_boss_mod]+"|r 在 "+I2S(spaceDegQty)+" 个混沌之门里，哪一个出现呢？！")
				else
					call hmsg.echo("时空炸裂！！小心！|cffff8080"+g_boss_label[g_wave/g_boss_mod]+"|r 要来了～")
				endif
			else
				call hmedia.bgm(gg_snd_ready)
				call htime.setDialog(g_timer_wave, g_mon_label[g_wave])
				if(spaceDegQty > 1)then
					call hmsg.echo("时空暴乱！敌人更狡猾了！注意进攻的 "+I2S(spaceDegQty)+" 个方向安排作战～")
				else
					call hmsg.echo("时空震荡！！小心！注意敌人进攻的方向安排作战～")
				endif
			endif
			//记录
			set i = player_max_qty
			loop
				exitwhen i<=0
					if(GetPlayerServerValueSuccess(players[i]) == true)then
						if(DzAPI_Map_GetStoredInteger(players[i], "wavelevel") < g_wave)then
							call DzAPI_Map_StoreInteger(players[i], "wavelevel", g_wave )
							call DzAPI_Map_Stat_SetStat(players[i], "wavelevel", I2S(g_wave) )
						endif
					endif
				set i = i-1
			endloop
		endif
		set t = null
		set loc = null
	endmethod

	public static method firstWave takes nothing returns nothing
		if (g_wave == g_first_wave)then
			call hmedia.bgm(gg_snd_ready)
			set g_wave = g_first_wave+1
			// 开启一个N秒一次的debug
			call htime.setInterval(15,function thistype.enemyDebug)
			call thistype.readyWave(g_first_ready_time)
		endif
	endmethod

	private static method nextWaveClearEnv takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local real x = htime.getReal(t,1)
		local real y = htime.getReal(t,2)
		call htime.delTimer(t)
		call henv.removeInRange(x,y,375,375)
		set t=null
	endmethod
	
	public static method nextWave takes real holdon returns nothing
		local integer i = 0
		if(g_mon_isrunning == false)then
			return
		endif
		set g_wave = g_wave+1
		if(g_wave > g_max_wave)then
			call SetUnitInvulnerable(u_timering, true )
			call thistype.winEnv()
			return
		endif
		// 测试胜利
		//call thistype.winEnv()
		//return
		
		call thistype.readyWave(holdon)
	endmethod

    // 注册瞬逝型物品
    private static method registerItemMonentCall takes nothing returns nothing
        local unit u = hevt.getTriggerUnit()
        local integer id = hevt.getId()
        local real charges = hevt.getValue()
        if (id == 'o002') then // 金币
            call haward.forUnitGold(u,2*R2I(charges))
        elseif (id == 'o003') then // 木材
            call haward.forUnitLumber(u,R2I(charges))
        elseif (id == 'o004') then // 经验
            call haward.forGroupExp(u,R2I(charges))
        elseif (id == 'o005') then // 时轮之力G
            call haward.forPlayerGold(u,R2I(charges))
        elseif (id == 'o006') then // 时轮之力L
            call haward.forPlayerLumber(u,R2I(charges))
        elseif (id == 'o007') then // 时轮之力E
            call haward.forGroupExp(u,R2I(charges))
        endif
		set u = null
    endmethod
    private static method registerItemMonent takes nothing returns nothing
        local hItemBean hitembean
		local integer i = 0
		loop
			exitwhen i>momentItems_count
				set hitembean = hItemBean.create()
				set hitembean.item_type = HITEM_TYPE_MOMENT
				set hitembean.item_id = momentItems[i]
				call hitem.format(hitembean)
				call hitembean.destroy()
				call hitem.onMoment(momentItems[i],function thistype.registerItemMonentCall)
			set i=i+1
		endloop
    endmethod



	private static method onSommonDead takes nothing returns nothing
		call hGlobals.deadSummon(GetTriggerUnit())
	endmethod
	private static method onSommonLevelup takes nothing returns nothing
		call hGlobals.upgradeSummon(GetTriggerUnit())
	endmethod
	private static method onConstructFinish takes nothing returns nothing
		call hGlobals.initSummon(GetTriggerUnit())
	endmethod

    public static method setInit takes nothing returns nothing
        local unit u = null
        local integer qty = 0
        set heroDeadTg = CreateTrigger()
        set sommonDeadTg = CreateTrigger()
        set emptyDeadTg = CreateTrigger()
        set bossDeadTg = CreateTrigger()
        set sommonLevelupTg = CreateTrigger()
        call TriggerAddAction(emptyDeadTg,function thistype.onEmptyDead)
        call TriggerAddAction(bossDeadTg,function thistype.onBossDead)
        call TriggerAddAction(heroDeadTg,function thistype.onHeroDead)
        call TriggerAddAction(sommonDeadTg,function thistype.onSommonDead)
        call TriggerAddAction(sommonLevelupTg,function thistype.onSommonLevelup)

        call hevt.onPickHero(function thistype.onHeroPick)

        // item
        call registerItemMonent()

		// build
		call hevt.onConstructFinish(function thistype.onConstructFinish)
		set u = null
    endmethod

endstruct

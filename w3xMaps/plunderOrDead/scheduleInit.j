globals

	group Group_All_Solider = null
	trigger Trigger_Building = null

	integer HERO_GET_GOLD_FROM_CITY = 20
	integer DEFAULT_PLAYER_GOLD_AWARD = 5
	integer DEFAULT_CENTER_GOLD_AWARD = 300
	integer DEFAULT_CENTER_GOLD_DURING = 90
	integer DEFAULT_UNGRADE_DURING = 300
	real DEFAULT_UNIT_ATTACK_SPEED = 0
	real DEFAULT_UNIT_MOVE = 0
	integer array Player_gold_award
	integer hash_player_Bind = 6668
	integer hash_player_Real = 6669

	integer array st_human
	integer array st_orc
	integer array st_undead
	integer array st_nightelf
	integer array stu_human
	integer array stu_orc
	integer array stu_undead
	integer array stu_nightelf
	integer array stupgrade_human
	integer array stupgrade_orc
	integer array stupgrade_undead
	integer array stupgrade_nightelf
	integer array pricet_human
	integer array pricet_orc
	integer array pricet_undead
	integer array pricet_nightelf
	integer array priceupgrade_human
	integer array priceupgrade_orc
	integer array priceupgrade_undead
	integer array priceupgrade_nightelf

	boolean array Player_sound_tips
	integer array Player_isSelected
	integer array Player_city_beHunt
	integer array Player_tower_Qty
	unit array Player_city
	unit array Player_soldiers
	unit array Player_arrow
	unit array Player_casern
	unit array Player_lab
	location array Player_City_Loc
	location array Player_Arrow_Loc
	location array Player_Target_Loc
	location array Player_Soldier_Loc
	location array Player_Casern_Loc
	location array Player_Lab_Loc
	integer array Player_Golder
	integer array Player_Target
	texttag array Player_Target_ttg
	texttag array Player_Gold_ttg

endglobals

struct m1AbstractSchedule

	//真假玩家转换
	private static method getRealPlayer takes player whichPlayer returns player
		return LoadPlayerHandle( hash_player , GetHandleId(whichPlayer) , hash_player_Real )
	endmethod

	private static method getTeamPlayer takes player whichPlayer returns player
		return LoadPlayerHandle( hash_player , GetHandleId(whichPlayer) , hash_player_Bind )
	endmethod

	/* 单位死亡 */
	private static method triggerSoulDeath takes nothing returns nothing
		local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
		local integer killerOwnerIndex = GetUnitUserData(GetTriggerUnit())
	endmethod
	//英雄死亡复活
	private static method triggerHeroDeathAction takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer index = htime.getInteger( t , 542 )
		if( hplayer.getStatus(players[index])=="谋掠中" and hplayer.getHero(players[index]) != null ) then
			call ReviveHeroLoc( hplayer.getHero(players[index]) , Player_Arrow_Loc[index] , true )
		endif
		call htime.delTimer( t )
	endmethod
	private static method triggerUnitDeath takes nothing returns nothing
		local unit u = hevt.getTriggerUnit()
		local unit killer = hevt.getKiller()
		local unit tempUnit = null
		local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
		local integer uTypeId = GetUnitTypeId(u)
		local integer killerOwnerIndex = GetConvertedPlayerId(GetOwningPlayer(killer))
		local timer t = null
		local integer exp = 0
		local integer gold = 0
		local integer lumber = 0
		local location loc = null
		local group tempGroup = null
		local hFilter hf = 0
		local hAttrHuntBean huntBean = 0
		if( IsUnitType(u, UNIT_TYPE_HERO) == true ) then
			set exp = 100 * GetUnitLevel(u)
			set gold = 50 * GetUnitLevel(u)
			set lumber = 25
			set t = htime.setTimeout( 20.00 , function thistype.triggerHeroDeathAction )
			call htime.setInteger( t , 542 , index )
			if(his.computer(players[killerOwnerIndex]) == true)then
				call IssuePointOrderLoc( killer , "move", Player_City_Loc[killerOwnerIndex] )
			endif
		elseif( uTypeId == 'o003' or uTypeId == 'o007' or uTypeId == 'o008' or uTypeId == 'o009' )then
			//如果是偷金小贼,掉落金币
			set loc = GetUnitLoc(u)
			set tempUnit = hunit.createUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE) , 'o00A' , loc )
			call SetUnitUserData(tempUnit, GetUnitUserData(u))
			set tempUnit = null
			call RemoveLocation(loc)
			set loc = null
		elseif( Group_All_Solider != null and IsUnitInGroup( u , Group_All_Solider) ) then
			set exp = 15
			set gold = 5
			set lumber = 2
			call GroupRemoveUnit( Group_All_Solider , u)
			//如果是自爆兵
			if( uTypeId == 'n009' ) then
				set loc = GetUnitLoc(u)
				set hf = hFilter.create()
				call hf.isAlive(true)
				set tempGroup = hgroup.createByUnit( u , 135 , function hFilter.get )
				call hf.destroy()
				set huntBean = hAttrHuntBean.create()
				set huntBean.fromUnit = u
				set huntBean.whichGroup = tempGroup
				set huntBean.huntEff = Effect_Boold_Cut
				set huntBean.damage = 15
				set huntBean.huntKind = "skill"
				set huntBean.huntType = "physical"
				set huntBean.isNoAvoid = true
				set huntBean.whichGroupHuntEff = Effect_ExplosionBIG
				set huntBean.whichGroupHuntEffLoc = loc
				call hAttrHunt.huntGroup(huntBean)
				call huntBean.destroy()
				call GroupClear(tempGroup)
				call DestroyGroup(tempGroup)
				call RemoveLocation(loc)
				set tempGroup = null
				set loc = null
			endif
			//如果是冤魂
			if( uTypeId == 'n01C' ) then
				set hf = hFilter.create()
				call hf.isAlive(true)
				call hf.isBuilding(false)
				set tempGroup = hgroup.createByUnit( u , 150 , function hFilter.get )
				call hf.destroy()
				loop
		            exitwhen(IsUnitGroupEmptyBJ(tempGroup) == true)
		                //must do
		                set tempUnit = FirstOfGroup(tempGroup)
		                call GroupRemoveUnit( tempGroup , tempUnit )

		                set loc = GetUnitLoc(tempUnit)
		                call heffect.toLoc(Effect_ReplenishManaCaster,loc,0.5)
		                call SetUnitLifePercentBJ( tempUnit, GetUnitLifePercent(tempUnit)*0.5 )
						set tempUnit = null
						call RemoveLocation(loc)
						set loc = null
		        endloop
				call GroupClear(tempGroup)
				call DestroyGroup(tempGroup)
				set tempGroup = null
			endif
			if( killerOwnerIndex >=9 and killerOwnerIndex <=12 ) then
				set killerOwnerIndex = GetConvertedPlayerId(getRealPlayer(GetOwningPlayer(killer)))
			endif
			if( index >=9 and index <=12 ) then
				set index = GetConvertedPlayerId(getRealPlayer(GetOwningPlayer(u)))
			endif
		endif
		call haward.forUnit(Player_city[killerOwnerIndex],0,gold,lumber)
		call haward.forUnit(hplayer.getHero(players[killerOwnerIndex]),exp,0,0)
	endmethod

	//get set SType
	private static method setItemSType takes integer it ,integer itup,integer itgold,integer itupgold, integer unitid returns nothing
		call SaveInteger( hash_item , it , 57342 , unitid )
		call SaveInteger( hash_item , it , 57343 , itup )
		call SaveInteger( hash_item , unitid , 57344 , itgold )
		call SaveInteger( hash_item , unitid , 57345 , itupgold )
	endmethod
	private static method getItemSType takes integer it returns integer
		return LoadInteger( hash_item , it , 57342 )
	endmethod
	private static method getItemSTypeUp takes integer it returns integer
		return LoadInteger( hash_item , it , 57343 )
	endmethod
	private static method getItemSGold takes integer unitid returns integer
		return LoadInteger( hash_item , unitid , 57344 )
	endmethod
	private static method getItemSGoldUp takes integer unitid returns integer
		return LoadInteger( hash_item , unitid , 57345 )
	endmethod

	//get set 士兵数量/等级
	private static method setPMaxQty takes integer playerIndex , integer maxqty returns nothing
		call SaveInteger( hash_player , playerIndex , 3413 , maxqty )
	endmethod
	private static method getPMaxQty takes integer playerIndex  returns integer
		return LoadInteger( hash_player , playerIndex , 3413 )
	endmethod
	private static method setPQty takes integer playerIndex , integer qty returns nothing
		call SaveInteger( hash_player , playerIndex , 3414 , qty )
	endmethod
	private static method getPQty takes integer playerIndex  returns integer
		return LoadInteger( hash_player , playerIndex , 3414 )
	endmethod
	private static method getSTQty takes integer playerIndex , integer unitid returns integer
		return LoadInteger( hash_player , unitid , playerIndex*667 )
	endmethod
	private static method setSTQty takes integer playerIndex , integer unitid , integer qty returns nothing
		if( qty>getSTQty(playerIndex,unitid) ) then
			if(getPQty(playerIndex) < getPMaxQty(playerIndex))then
				call setPQty(playerIndex , getPQty(playerIndex)+(qty-getSTQty(playerIndex,unitid)) )
				call SaveInteger( hash_player , unitid , playerIndex*667 , qty )
				call hplayer.addTotalGoldCost(players[playerIndex],getItemSGold(unitid))
			else
				call hplayer.addGold( players[playerIndex] , getItemSGold(unitid)*(qty-getSTQty(playerIndex,unitid)) )
				call hmsg.echoTo( players[playerIndex] , "|cffff0000已达最大布兵数目，您可以双击已派遣的兵种减少数目|r",0,0,0 )
			endif
		elseif( qty<getSTQty(playerIndex,unitid) ) then
			call setPQty(playerIndex , getPQty(playerIndex)+(qty-getSTQty(playerIndex,unitid)) )
			call SaveInteger( hash_player , unitid , playerIndex*667 , qty )
			call hplayer.addTotalGoldCost(players[playerIndex],getItemSGold(unitid))
		endif
	endmethod
	private static method getSTLevel takes integer playerIndex , integer unitid returns integer
		return LoadInteger( hash_player , unitid , playerIndex*668 )
	endmethod
	private static method setSTLevel takes integer playerIndex , integer unitid , integer level returns nothing
		call SaveInteger( hash_player , unitid , playerIndex*668 , level )
	endmethod
	private static method setSLevelAttr takes unit u , integer playerIndex returns nothing
		local integer unitid = GetUnitTypeId(u)
		local real level = I2R(getSTLevel(playerIndex,unitid))
		call hattr.addAttackSpeed(u,DEFAULT_UNIT_ATTACK_SPEED,0)
		call hattr.addMove(u,DEFAULT_UNIT_MOVE,0)
		if(unitid == 'n00G')then //剑侠
			call hattrEffect.setAttackSpeed(u,10,0)
			call hattrEffect.setAttackSpeedDuring(u,5.00,0)
			call hattrEffect.setMove(u,15,0)
			call hattrEffect.setMoveDuring(u,5.00,0)
		elseif(unitid == 'n003')then
			call hattrEffect.setSwim(u,80,0)
			call hattrEffect.setSwimDuring(u,2,0)
		elseif(unitid == 'n00I')then 	//黑龙
			call hattrEffect.setCorrosion(u,2,0)
			call hattrEffect.setCorrosionDuring(u,3.00,0)
		elseif(unitid == 'n00L')then
			call hattrEffect.setPoison(u,1.5,0)
			call hattrEffect.setPoisonDuring(u,3.00,0)
		elseif(unitid == 'n00M')then
			call hattrEffect.setSwim(u,75,0)
			call hattrEffect.setSwimDuring(u,2,0)
		elseif(unitid == 'n00N')then
			call hattrEffect.setCold(u,30,0)
			call hattrEffect.setColdDuring(u,3.00,0)
		elseif(unitid == 'n00P')then
			call hattrExt.addSplit(u,25,0)
		elseif(unitid == 'n017')then
			call hattrExt.addHemophagia(u,10,0)
		elseif(unitid == 'n01A')then
			call hattrEffect.setCorrosion(u,1,0)
		elseif(unitid == 'n01E')then
			call hattrExt.addHemophagia(u,20,0)
		elseif(unitid == 'n01G')then
			call hattrEffect.setPoison(u,3,0)
			call hattrEffect.setPoisonDuring(u,3.00,0)
		elseif(unitid == 'n00W')then 	//树人
			call hattrExt.addLifeBack(u,2,0)
		elseif(unitid == 'n013')then
			call hattrExt.addLifeBack(u,4,0)
		elseif(unitid == 'n014')then
			call hattrEffect.setCorrosion(u,1,0)
			call hattrEffect.setCorrosionDuring(u,3.00,0)
		elseif(unitid == 'n015')then
			call hattrExt.addSplit(u,20,0)
		elseif(unitid == 'n00Y')then
			call hattrEffect.setPoison(u,3,0)
			call hattrEffect.setPoisonDuring(u,3.00,0)
		elseif(unitid == 'n016')then
			call hattrEffect.setSwim(u,100,0)
			call hattrEffect.setSwimDuring(u,2,0)
		endif
		if(level>=1)then
			//human
			if(unitid == 'n005')then
				call hattr.addDefend(u,1*level,0)
			elseif(unitid == 'n001')then
				call hattr.addDefend(u,1*level,0)
				call hattr.addAttackPhysical(u,1*level,0)
			elseif(unitid == 'n00A')then
				call hattr.addLife(u,3*level,0)
				call hattr.addAttackPhysical(u,1*level,0)
				call hattr.addAttackSpeed(u,3*level,0)
			elseif(unitid == 'n002')then
				call hattr.addLife(u,5*level,0)
				call hattr.addAttackPhysical(u,1*level,0)
				call hattr.addAttackSpeed(u,4*level,0)
			elseif(unitid == 'n00D')then
				call hattr.addLife(u,5*level,0)
				call hattr.addMove(u,3*level,0)
			elseif(unitid == 'n00C')then
				call hattr.addLife(u,10*level,0)
				call hattr.addAttackPhysical(u,1*level,0)
			elseif(unitid == 'n00E')then
				call hattr.addLife(u,5*level,0)
				call hattr.addAttackPhysical(u,1*level,0)
			elseif(unitid == 'n008')then
				call hattr.addLife(u,10*level,0)
				call hattr.addAttackPhysical(u,4*level,0)
			elseif(unitid == 'n00G')then
				call hattr.addLife(u,10*level,0)
				call hattr.addAttackPhysical(u,2*level,0)
				call hattrEffect.addAttackSpeed(u,5*level,0)
				call hattrEffect.addMove(u,5*level,0)
			elseif(unitid == 'n003')then
				call hattr.addLife(u,15*level,0)
				call hattr.addDefend(u,level,0)
				call hattr.addAttackPhysical(u,5*level,0)
			elseif(unitid == 'n00H')then
				call hattr.addLife(u,15*level,0)
				call hattr.addDefend(u,level,0)
				call hattr.addAttackPhysical(u,3*level,0)
			elseif(unitid == 'n00I')then
				call hattr.addLife(u,25*level,0)
				call hattr.addDefend(u,level,0)
				call hattr.addAttackPhysical(u,5*level,0)
				call hattr.addAttackSpeed(u,10*level,0)
			endif
			//orc
			if(unitid == 'n009')then
				call hattr.addLife(u,level,0)
				call hattr.addAttackPhysical(u,level,0)
			elseif(unitid == 'n004')then
				call hattr.addLife(u,3*level,0)
				call hattr.addAttackPhysical(u,level,0)
			elseif(unitid == 'n00K')then
				call hattr.addLife(u,3*level,0)
				call hattr.addAttackPhysical(u,level,0)
				call hattr.addMove(u,5*level,0)
			elseif(unitid == 'n00S')then
				call hattr.addLife(u,5*level,0)
				call hattr.addMove(u,3*level,0)
			elseif(unitid == 'n00T')then
				call hattr.addLife(u,5*level,0)
				call hattr.addAttackPhysical(u,2*level,0)
			elseif(unitid == 'n00L')then
				call hattr.addLife(u,5*level,0)
				call hattr.addAttackPhysical(u,level,0)
			elseif(unitid == 'n00U')then
				call hattr.addLife(u,15*level,0)
				call hattr.addDefend(u,level,0)
			elseif(unitid == 'n00M')then
				call hattr.addLife(u,10*level,0)
				call hattr.addAttackPhysical(u,level,0)
			elseif(unitid == 'n00N')then
				call hattr.addLife(u,15*level,0)
				call hattr.addAttackPhysical(u,2*level,0)
			elseif(unitid == 'n00P')then
				call hattr.addLife(u,25*level,0)
				call hattr.addAttackPhysical(u,2*level,0)
			elseif(unitid == 'n00Q')then
				call hattr.addLife(u,20*level,0)
				call hattr.addAttackPhysical(u,4*level,0)
			elseif(unitid == 'n00R')then
				call hattr.addLife(u,20*level,0)
				call hattr.addAttackPhysical(u,8*level,0)
				call hattr.addAttackSpeed(u,10*level,0)
			endif
			//undead
			if(unitid == 'n017')then
				call hattr.addLife(u,2*level,0)
				call hattr.addAttackPhysical(u,level,0)
			elseif(unitid == 'n018')then
				call hattr.addLife(u,3*level,0)
				call hattr.addAttackPhysical(u,level,0)
			elseif(unitid == 'n019')then
				call hattr.addLife(u,6*level,0)
			elseif(unitid == 'n01C')then
				call hattr.addLife(u,5*level,0)
				call hattr.addMove(u,3*level,0)
			elseif(unitid == 'n01A')then
				call hattr.addLife(u,10*level,0)
				call hattrEffect.addCorrosion(u,level*0.5,0)
			elseif(unitid == 'n0AD')then
				call hattr.addLife(u,10*level,0)
				call hattr.addAttackPhysical(u,level,0)
			elseif(unitid == 'n01E')then
				call hattr.addLife(u,10*level,0)
				call hattr.addAttackPhysical(u,level,0)
			elseif(unitid == 'n01F')then
				call hattr.addLife(u,10*level,0)
				call hattr.addAttackPhysical(u,2*level,0)
			elseif(unitid == 'n01G')then
				call hattr.addLife(u,15*level,0)
				call hattr.addAttackPhysical(u,2*level,0)
			elseif(unitid == 'n01H')then
				call hattr.addLife(u,25*level,0)
				call hattr.addAttackPhysical(u,level,0)
			elseif(unitid == 'n01I')then
				call hattr.addLife(u,20*level,0)
				call hattr.addAttackPhysical(u,3*level,0)
			elseif(unitid == 'n01B')then
				call hattr.addLife(u,20*level,0)
				call hattr.addAttackSpeed(u,15*level,0)
				call hattr.addDefend(u,3*level,0)
				call hattr.addMove(u,10*level,0)
			endif
			//nightelf
			if(unitid == 'n00W')then
				call hattr.addLife(u,3*level,0)
				call hattr.addAttackPhysical(u,level,0)
			elseif(unitid == 'n010')then
				call hattr.addLife(u,2*level,0)
				call hattr.addAttackPhysical(u,level,0)
			elseif(unitid == 'n007')then
				call hattr.addLife(u,3*level,0)
				call hattr.addMove(u,3*level,0)
			elseif(unitid == 'n00Z')then
				call hattr.addLife(u,5*level,0)
				call hattr.addAttackPhysical(u,level,0)
			elseif(unitid == 'n011')then
				call hattr.addLife(u,5*level,0)
				call hattr.addAttackPhysical(u,2*level,0)
			elseif(unitid == 'n012')then
				call hattr.addLife(u,5*level,0)
				call hattr.addAttackPhysical(u,2*level,0)
			elseif(unitid == 'n013')then
				call hattr.addLife(u,10*level,0)
				call hattrExt.addLifeBack(u,0.5*level,0)
				call hattr.addAttackPhysical(u,2*level,0)
			elseif(unitid == 'n00X')then
				call hattr.addLife(u,10*level,0)
				call hattr.addAttackPhysical(u,level,0)
			elseif(unitid == 'n014')then
				call hattr.addLife(u,15*level,0)
				call hattr.addAttackPhysical(u,3*level,0)
				call hattr.addMove(u,5*level,0)
			elseif(unitid == 'n015')then
				call hattr.addLife(u,25*level,0)
				call hattr.addAttackPhysical(u,4*level,0)
			elseif(unitid == 'n00Y')then
				call hattr.addLife(u,20*level,0)
				call hattr.addAttackPhysical(u,3*level,0)
				call hattr.addAttackSpeed(u,10*level,0)
			elseif(unitid == 'n016')then
				call hattr.addLife(u,30*level,0)
				call hattr.addDefend(u,level,0)
				call hattr.addAttackPhysical(u,6*level,0)
			endif
		endif
	endmethod
	private static method setSTTips takes integer playerIndex returns nothing
		local texttag ttg = null
		local integer i = 0
		local integer number = 0
		local race r = GetPlayerRace(players[playerIndex])
		local integer phid = GetHandleId(players[playerIndex])
		local integer qty = 0
		local integer level = 0
		local integer tempUidType = 0
		local real x = 0
		local real y = 0
		local location loc = null
		set i = 1
		loop
			exitwhen i>12
				if(r == RACE_HUMAN)then
					set tempUidType = stu_human[i]
				elseif(r == RACE_ORC)then
					set tempUidType = stu_orc[i]
				elseif(r == RACE_UNDEAD)then
					set tempUidType = stu_undead[i]
				elseif(r == RACE_NIGHTELF)then
					set tempUidType = stu_nightelf[i]
				endif
				set qty = getSTQty(playerIndex,tempUidType)
				set level = getSTLevel(playerIndex,tempUidType)
				if(qty>0)then
					set ttg = LoadTextTagHandle(hash_player, phid, i)
					if(ttg == null) then
						set ttg = CreateTextTag()
						call SaveTextTagHandle(hash_player, phid, i , ttg)
						call SetTextTagPermanent( ttg, true )
						if(i<=6)then
							set x = GetLocationX(Player_Soldier_Loc[playerIndex])+(i-1)*128
							set y = GetLocationY(Player_Soldier_Loc[playerIndex])
						else
							set x = GetLocationX(Player_Soldier_Loc[playerIndex])+(i-7)*128
							set y = GetLocationY(Player_Soldier_Loc[playerIndex])-128
						endif
						call SetTextTagPos(ttg, x, y , 160)
						set loc = Location(x, y)
						set Player_soldiers[playerIndex*100+i] = hunit.createUnitFacing( Player(PLAYER_NEUTRAL_PASSIVE) , tempUidType , loc , bj_UNIT_FACING )
						call SetUnitUserData(Player_soldiers[playerIndex*100+i], playerIndex)
						call SetUnitInvulnerable( Player_soldiers[playerIndex*100+i] , true )
						call setSLevelAttr(Player_soldiers[playerIndex*100+i],playerIndex)
						call RemoveLocation(loc)
						set loc = null
						if( GetUnitAbilityLevel(Player_soldiers[playerIndex*100+i], 'A03C')>=1 )then
							call UnitRemoveAbility( Player_soldiers[playerIndex*100+i], 'A03C' )
						endif
						if( GetUnitAbilityLevel(Player_soldiers[playerIndex*100+i], 'A03F')>=1 )then
							call UnitRemoveAbility( Player_soldiers[playerIndex*100+i], 'A03F' )
						endif
						if( GetUnitAbilityLevel(Player_soldiers[playerIndex*100+i], 'A037')>=1 )then
							call UnitRemoveAbility( Player_soldiers[playerIndex*100+i], 'A037' )
						endif
					endif
        			call SetTextTagTextBJ(ttg, "|cffffff80"+I2S(qty)+"|r"+"|cffff8080_Lv"+I2S(level)+"|r" , 8.00)
        			set ttg = null
        		else
        			set ttg = LoadTextTagHandle(hash_player, phid, i)
        			call DestroyTextTag(ttg)
        			call SaveTextTagHandle(hash_player, phid, i , null)
        			call hunit.del(Player_soldiers[playerIndex*100+i],0)
        			set Player_soldiers[playerIndex*100+i] = null
				endif
			set i = i+1
		endloop
	endmethod

	private static method getWeakestGold takes nothing returns integer
		local integer i = 1
		local integer index = 0
		local integer gold = 100000
		loop
	        exitwhen i > player_max_qty
	        	if( hplayer.getStatus(players[i]) == "谋掠中" ) then
					if(hplayer.getGold(players[i]) < gold) then
						set index = i
						set gold = hplayer.getGold(players[i])
					endif
				endif
	        set i = i + 1
        endloop
        return index
	endmethod

	private static method getStrongestGold takes nothing returns integer
		local integer i = 1
		local integer index = 0
		local integer gold = 0
		loop
	        exitwhen i > player_max_qty
	        	if( hplayer.getStatus(players[i]) == "谋掠中" ) then
					if(hplayer.getGold(players[i]) > gold) then
						set index = i
						set gold = hplayer.getGold(players[i])
					endif
				endif
	        set i = i + 1
        endloop
        return index
	endmethod

	//电脑AI
	private static method superAI takes nothing returns nothing
		local integer i = 1
		local integer j = 1
		local integer rand = 0
		local integer weakIndex = getWeakestGold()
		local integer strongIndex = getStrongestGold()
		local integer weakGold = hplayer.getGold(players[weakIndex])
		local integer strongGold = hplayer.getGold(players[strongIndex])
		local integer tempTargetIndex = 0
		local race whichRace = null
		loop
	        exitwhen i > player_max_qty
	        	set whichRace = GetPlayerRace(players[i])
        		if( hplayer.getStatus(players[i]) == "谋掠中" and his.computer(players[i]) ) then
		        	//增强英雄50%升1级，50%不生效
					set rand = GetRandomInt(1,100)
					if(rand < 20)then
						call hattr.addAttackPhysical( hplayer.getHero(players[i]) , 7 , 0 )
					elseif(rand >= 20 and rand < 30)then
						call hattr.addAttackSpeed( hplayer.getHero(players[i]) , 7 , 0 )
					elseif(rand >= 30 and rand < 60)then
						call hattr.addLife( hplayer.getHero(players[i]) , 30 , 0 )
					elseif(rand >= 60 and rand < 75)then
						call hattr.addMove( hplayer.getHero(players[i]) , 10 , 0 )
					endif
					if( getPQty(i)>=getPMaxQty(i) and hplayer.getGold(players[i])>3500 and hplayer.getLumber(players[i])>10)then
						call setPMaxQty(i,getPMaxQty(i)+1)
						set Player_gold_award[i] = Player_gold_award[i]+4
						call hplayer.addGold(players[i],-3500)
						call hplayer.addLumber(players[i],-10)
					elseif( hplayer.getGold(players[i])>=2000 and hplayer.getLumber(players[i])>=5 and rand < 75)then
						set Player_gold_award[i] = Player_gold_award[i]+8
						call hplayer.addGold(players[i],-2000)
						call hplayer.addLumber(players[i],-5)
					elseif( hplayer.getGold(players[i])>=1000 and hplayer.getLumber(players[i])>=5 and rand < 60)then
						set Player_gold_award[i] = Player_gold_award[i]+4
						call hplayer.addGold(players[i],-1000)
						call hplayer.addLumber(players[i],-5)
					elseif( hplayer.getGold(players[i])>=500 and hplayer.getLumber(players[i])>=5 and rand < 40)then
						set Player_gold_award[i] = Player_gold_award[i]+2
						call hplayer.addGold(players[i],-500)
						call hplayer.addLumber(players[i],-5)
					elseif( hplayer.getGold(players[i])>=250 and hplayer.getLumber(players[i])>=5 and rand < 25)then
						set Player_gold_award[i] = Player_gold_award[i]+1
						call hplayer.addGold(players[i],-250)
						call hplayer.addLumber(players[i],-5)
					endif
					//基地
					if( hplayer.getLumber(players[i])>100 and rand < 50)then
						call hattr.addDefend( Player_city[i] , 3 , 0 )
						call hattr.addLife( Player_city[i] , 500 , 0 )
						call hattr.addAttackPhysical( Player_city[i] , 5 , 0 )
						call hplayer.addLumber(players[i],-100)
					endif
					//战略
					if( hplayer.getLumber(players[i])>50 and rand < 32 and his.alive(hplayer.getHero(players[i])))then
						if(rand<=8)then
							call UnitAddItem(hplayer.getHero(players[i]), CreateItem('I04A',0,0))
						elseif(rand>8 and rand <=16)then
							call UnitAddItem(hplayer.getHero(players[i]), CreateItem('I03X',0,0))
						elseif(rand>16 and rand <=24)then
							call UnitAddItem(hplayer.getHero(players[i]), CreateItem('I005',0,0))
						else
							call UnitAddItem(hplayer.getHero(players[i]), CreateItem('I04C',0,0))
						endif
						call hplayer.addLumber(players[i],-50)
					endif

					if(rand < 90)then
						if( whichRace == RACE_HUMAN )then
			            	set j = 12
							loop
								exitwhen(j<1)
									if( getPQty(i)<getPMaxQty(i) and hplayer.getGold(players[i]) > pricet_human[j] and GetRandomInt(1,100) <= 60 )then
										call setSTQty(i,stu_human[j],getSTQty(i,stu_human[j])+1)
										call hplayer.addGold(players[i],-pricet_human[j])
									endif
									if( hplayer.getGold(players[i]) > priceupgrade_human[j] and getSTQty(i,stu_human[j])>0 and GetRandomInt(1,100) <= 80)then
										call setSTLevel(i,stu_human[j],getSTLevel(i,stu_human[j])+1)
										call hplayer.addGold(players[i],-priceupgrade_human[j])
									endif
								set j = j-1
							endloop
						elseif (whichRace == RACE_ORC ) then
							set j = 12
							loop
								exitwhen(j<1)
									if( getPQty(i)<getPMaxQty(i) and hplayer.getGold(players[i]) > pricet_orc[j] and GetRandomInt(1,100) <= 60 )then
										call setSTQty(i,stu_orc[j],getSTQty(i,stu_orc[j])+1)
										call hplayer.addGold(players[i],-pricet_orc[j])
									endif
									if( hplayer.getGold(players[i]) > priceupgrade_orc[j] and getSTQty(i,stu_orc[j])>0 and GetRandomInt(1,100) <= 80)then
										call setSTLevel(i,stu_orc[j],getSTLevel(i,stu_orc[j])+1)
										call hplayer.addGold(players[i],-priceupgrade_orc[j])
									endif
								set j = j-1
							endloop
		    			elseif (whichRace == RACE_UNDEAD ) then
		    				set j = 12
							loop
								exitwhen(j<1)
									if( getPQty(i)<getPMaxQty(i) and hplayer.getGold(players[i]) > pricet_undead[j] and GetRandomInt(1,100) <= 60 )then
										call setSTQty(i,stu_undead[j],getSTQty(i,stu_undead[j])+1)
										call hplayer.addGold(players[i],-pricet_undead[j])
									endif
									if( hplayer.getGold(players[i]) > priceupgrade_undead[j] and getSTQty(i,stu_undead[j])>0 and GetRandomInt(1,100) <= 80)then
										call setSTLevel(i,stu_undead[j],getSTLevel(i,stu_undead[j])+1)
										call hplayer.addGold(players[i],-priceupgrade_undead[j])
									endif
								set j = j-1
							endloop
		    			elseif (whichRace == RACE_NIGHTELF ) then
		    				set j = 12
							loop
								exitwhen(j<1)
									if( getPQty(i)<getPMaxQty(i) and hplayer.getGold(players[i]) > pricet_nightelf[j] and GetRandomInt(1,100) <= 60 )then
										call setSTQty(i,stu_nightelf[j],getSTQty(i,stu_nightelf[j])+1)
										call hplayer.addGold(players[i],-pricet_nightelf[j])
									endif
									if( hplayer.getGold(players[i]) > priceupgrade_nightelf[j] and getSTQty(i,stu_nightelf[j])>0 and GetRandomInt(1,100) <= 80)then
										call setSTLevel(i,stu_nightelf[j],getSTLevel(i,stu_nightelf[j])+1)
										call hplayer.addGold(players[i],-priceupgrade_nightelf[j])
									endif
								set j = j-1
							endloop
			            endif
					endif
					//75%几率根据战况指定战略
					if( GetRandomInt(1,100) <= 75 )then
						if( weakIndex != i and strongIndex != i )then
							//如果最弱最强都不是我
							//如果最弱的已经快要死了，那么打最强的并且多派兵，否则70%打最强30%打最弱
							if( weakGold < 100 )then
								set tempTargetIndex = strongIndex
							else
								if( GetRandomInt(1,100) <= 70 )then
									set tempTargetIndex = strongIndex
						        else
						        	set tempTargetIndex = weakIndex
								endif
							endif
					    elseif( weakIndex == i and strongIndex !=i )then
					    	//如果最弱是我，那么打最强的
					    	set tempTargetIndex = strongIndex
					    elseif( strongIndex == i and weakIndex !=i )then
					    	//如果最强是我，那么打最弱的
					    	set tempTargetIndex = weakIndex
						endif
					endif
					//综合行动
					if(tempTargetIndex>0 and i != tempTargetIndex )then
						set Player_Target_Loc[i] = Player_City_Loc[tempTargetIndex]
						set Player_Target[i] = tempTargetIndex
						call SetUnitFacing( Player_arrow[i] , AngleBetweenPoints(Player_Arrow_Loc[i], Player_Arrow_Loc[tempTargetIndex]) )
				        call SetTextTagTextBJ(Player_Target_ttg[i], "目标："+GetPlayerName(players[Player_Target[i]]) , 10.00)
					endif
					call setSTTips(i)
	        	endif
	        set i = i + 1
        endloop
	endmethod

	/* 玩家挂了 */
    private static method triggerPlayerFailFilter takes nothing returns nothing
        call RemoveUnit( GetEnumUnit() )
	endmethod

	private static method playerFail takes player triggerPlayer returns nothing
		local integer i = 0
		local integer j = 0
		local boolean isFind = false
	    local integer triggerPlayerIndex = GetConvertedPlayerId( triggerPlayer )
	    local group dropGroup = null
	    local integer fightingQty = 0
	    local group g = null
	    local integer phid = GetHandleId(triggerPlayer)
	    set player_current_qty = player_current_qty - 1
	    set Player_Target[triggerPlayerIndex] = 0
	    set Player_tower_Qty[triggerPlayerIndex] = 0
	    call hunit.del( hplayer.getHero(players[triggerPlayerIndex]) , 0 )
	    set i = 1
	    loop
	        exitwhen i > 12
	            if ( Player_soldiers[triggerPlayerIndex*100+i] != null ) then
	                call hunit.del( Player_soldiers[triggerPlayerIndex*100+i] , 0 )
	            endif
	        set i = i + 1
	    endloop
	    call hunit.del( Player_arrow[triggerPlayerIndex] , 0 )
	    call DestroyTextTag( Player_Target_ttg[triggerPlayerIndex] )
	    call DestroyTextTag( Player_Gold_ttg[triggerPlayerIndex] )
	    set i = 1
	    loop
	    	exitwhen i > 12
	    		if(LoadTextTagHandle(hash_player, phid, i)!=null)then
	    			call DestroyTextTag(LoadTextTagHandle(hash_player, phid, i))
					call SaveTextTagHandle(hash_player, phid, i , null)
	    		endif
			set i = i + 1
		endloop
	    call heffect.toLoc( Effect_ExplosionBIG , Player_City_Loc[triggerPlayerIndex],0 )
	    call heffect.toLoc( Effect_ExplosionBIG , Player_Arrow_Loc[triggerPlayerIndex],0 )
	    call heffect.toLoc( Effect_ExplosionBIG , Player_Soldier_Loc[triggerPlayerIndex],0 )
	    //删除玩家所有的单位
	    set dropGroup = GetUnitsInRectOfPlayer(GetEntireMapRect(), triggerPlayer)
	    call ForGroupBJ( dropGroup, function thistype.triggerPlayerFailFilter )
	    call GroupClear( dropGroup )
	    call DestroyGroup( dropGroup )
	    //删除玩家团队的单位
	    set dropGroup = GetUnitsInRectOfPlayer(GetEntireMapRect(), getTeamPlayer(triggerPlayer))
	    call ForGroupBJ( dropGroup, function thistype.triggerPlayerFailFilter )
	    call GroupClear( dropGroup )
	    call DestroyGroup( dropGroup )
	    //检查是否击杀全部玩家
	    set i = 1
	    loop
	        exitwhen i > player_max_qty
	            if ( hplayer.getStatus(players[i]) == "谋掠中" ) then
	                set fightingQty = fightingQty + 1
	            endif
	        set i = i + 1
	    endloop
	    if( fightingQty <= 1 ) then
		    //TODO 结束游戏
			call DisableTrigger( GetTriggeringTrigger() )
			call ForceCinematicSubtitles( true )
			call StartSound(gg_snd_audio_jushiwushuang)
			call PolledWait(2.00)
			set i = 1
		    loop
		        exitwhen i > player_max_qty
		            if ( hplayer.getStatus(players[i]) == "谋掠中" ) then
		                call CustomVictoryBJ( players[i] , true, true )
	                else
	                	call CustomDefeatBJ( players[i] , "战败！" )
		            endif
		        set i = i + 1
		    endloop
		else
			//TODO 由于有玩家离开，所以要将指向他的目标转去默认
			set i = 1
		    loop
		        exitwhen i > player_max_qty
		        	set isFind = false
		        	if ( hplayer.getStatus(players[i]) == "谋掠中" and Player_Target[i] == triggerPlayerIndex ) then
			        	//----------
						set j = i
					    loop
					        exitwhen j > player_max_qty or isFind==true
								if( i !=j and hplayer.getStatus(players[j]) == "谋掠中" ) then
									set isFind = true
									set Player_Target_Loc[i] = Player_City_Loc[j]
									set Player_Target[i] = j
									call SetUnitFacing( Player_arrow[i] , AngleBetweenPoints(Player_Arrow_Loc[i], Player_Arrow_Loc[j]) )
									call hmsg.echoTo( players[i] , "你的新目标："+GetPlayerName(players[Player_Target[i]]),0,0,0 )
							        call SetTextTagTextBJ(Player_Target_ttg[i], "目标："+GetPlayerName(players[Player_Target[i]]) , 10.00)
								endif
					        set j = j + 1
				        endloop
				        //----------
				        if(isFind == false) then
					        set j = 1
						    loop
						        exitwhen j > i or isFind==true
									if( i !=j and hplayer.getStatus(players[j]) == "谋掠中" ) then
										set isFind = true
										set Player_Target_Loc[i] = Player_City_Loc[j]
										set Player_Target[i] = j
										call SetUnitFacing( Player_arrow[i] , AngleBetweenPoints(Player_Arrow_Loc[i], Player_Arrow_Loc[j]) )
										call hmsg.echoTo( players[i] , "你的新目标："+GetPlayerName(players[Player_Target[i]]),0,0,0)
								        call SetTextTagTextBJ(Player_Target_ttg[i], "目标："+GetPlayerName(players[Player_Target[i]]) , 10.00)
									endif
						        set j = j + 1
					        endloop
				        endif
	        		endif
		        set i = i + 1
		    endloop
	    endif
	endmethod

	/* 傻逼玩家离线 - 执行 */
    private static method triggerPlayerOfflineActions takes nothing returns nothing
		local player triggerPlayer  = GetTriggerPlayer()
	    //设置玩家状态为【傻逼】
	    call hplayer.setStatus( triggerPlayer,"逃走弱鸡" )
	    call hmsg.echo( GetPlayerName(triggerPlayer)+"被狠狠挫败了！弱鸡逃离了战场"  )
	    call playerFail(triggerPlayer)
    endmethod

	//开始战斗
	private static method startBattleCall3 takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer playerIndex = htime.getInteger( t , 542 )
		local integer currentQty = htime.getInteger( t , 544 )
		local integer currentIndex = htime.getInteger( t , 653 )
		local unit u = null
		local race whichRace = null
		local integer i = 0
		local integer qty = 0
		local integer whichUnitId = 0
		if( hplayer.getStatus(players[playerIndex]) != "谋掠中") then
			call htime.delTimer( t )
			return
		endif
		if( hplayer.getStatus(players[playerIndex]) == "谋掠中" ) then
			set whichRace = GetPlayerRace(players[playerIndex])
			//出兵 找兵种
            set i = currentIndex
			if( whichRace == RACE_HUMAN )then
				loop
	            	exitwhen(i>12)
	            		set qty = getSTQty(playerIndex , stu_human[i] )
	            		if(qty<=0 or currentQty>=qty)then
	            			set currentQty = 0
	            			if(i==12)then
	            				call htime.delTimer( t )
	            			endif
	            		elseif(currentQty<qty) then
	            			set whichUnitId = stu_human[i]
	            			set currentQty = currentQty + 1
	            			set currentIndex = i
	            			call DoNothing() YDNL exitwhen true
	            		endif
	            	set i = i+1
	            endloop
			elseif (whichRace == RACE_ORC ) then
				loop
	            	exitwhen(i>12)
	            		set qty = getSTQty(playerIndex , stu_orc[i] )
	            		if(qty<=0 or currentQty>=qty)then
	            			set currentQty = 0
	            			if(i==12)then
	            				call htime.delTimer( t )
	            			endif
	            		elseif(currentQty<qty) then
	            			set whichUnitId = stu_orc[i]
	            			set currentQty = currentQty + 1
	            			set currentIndex = i
	            			call DoNothing() YDNL exitwhen true
	            		endif
	            	set i = i+1
	            endloop
			elseif (whichRace == RACE_UNDEAD ) then
				loop
	            	exitwhen(i>12)
	            		set qty = getSTQty(playerIndex , stu_undead[i] )
	            		if(qty<=0 or currentQty>=qty)then
	            			set currentQty = 0
	            			if(i==12)then
	            				call htime.delTimer( t )
	            			endif
	            		elseif(currentQty<qty) then
	            			set whichUnitId = stu_undead[i]
	            			set currentQty = currentQty + 1
	            			set currentIndex = i
	            			call DoNothing() YDNL exitwhen true
	            		endif
	            	set i = i+1
	            endloop
			elseif (whichRace == RACE_NIGHTELF ) then
				loop
	            	exitwhen(i>12)
	            		set qty = getSTQty(playerIndex , stu_nightelf[i] )
	            		if(qty<=0 or currentQty>=qty)then
	            			set currentQty = 0
	            			if(i==12)then
	            				call htime.delTimer( t )
	            			endif
	            		elseif(currentQty<qty) then
	            			set whichUnitId = stu_nightelf[i]
	            			set currentQty = currentQty + 1
	            			set currentIndex = i
	            			call DoNothing() YDNL exitwhen true
	            		endif
	            	set i = i+1
	            endloop
            endif
            call htime.setInteger( t , 544 , currentQty )
			call htime.setInteger( t , 653 , currentIndex )
            if(whichUnitId!=0)then
            	set u = hunit.createUnitAttackToLoc( whichUnitId , getTeamPlayer(players[playerIndex]) , Player_City_Loc[playerIndex] , Player_Target_Loc[playerIndex] )
				call hevt.onDead(u,function thistype.triggerUnitDeath)
				call SetUnitUserData( u , Player_Target[playerIndex] )
				call SetUnitColor( u , GetPlayerColor(players[playerIndex]) )
				call GroupAddUnit( Group_All_Solider , u )
				//士兵科技升级
				call setSLevelAttr(u,playerIndex)
            endif
            set whichRace = null
		endif
		set u = null
	endmethod
	private static method startBattleCall2 takes integer playerIndex returns nothing
		local timer t = null
    	if( hplayer.getStatus(players[playerIndex]) == "谋掠中" ) then
	    	if( Group_All_Solider == null ) then
				set Group_All_Solider = CreateGroup()
			endif
			set t = htime.setInterval( 0.3 , function thistype.startBattleCall3 )
			call htime.setInteger( t , 542 , playerIndex )
			call htime.setInteger( t , 544 , 0 )
			call htime.setInteger( t , 653 , 1 )
    	endif
	endmethod
	private static method startBattleCall1 takes nothing returns nothing
		local integer i = 1
		call superAI()	//开启超级AI
		call hmsg.echo( "|cffff0000回合战斗开始！|r" )
        set i = 1
        loop
	         exitwhen i > player_max_qty
	         	call startBattleCall2(i)
	         set i = i + 1
        endloop
	endmethod
	private static method startBattle takes nothing returns nothing
		local timer t = null
		local timerdialog td = null
		set t = htime.setInterval( CurrentGameModelCycle , function thistype.startBattleCall1 )
		call htime.setDialog( t , "距离下一回合" )
		call StartSound(gg_snd_audio_effect_3)
	endmethod

	/* 玩家双击设定目标 */
	private static method triggerDoubleClickCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer index = htime.getInteger( t , 542 )
		set Player_isSelected[index] = 0
		call htime.delTimer( t )
	endmethod
	private static method triggerPlayerSelectActions takes nothing returns nothing
		local player whichPlayer = GetTriggerPlayer()
		local integer index = GetConvertedPlayerId(whichPlayer)
		local integer unitType = GetUnitTypeId(GetTriggerUnit())
		local integer targerIndex = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
		local race whichRace = GetPlayerRace(whichPlayer)
		local integer soliderIndex = GetUnitUserData(GetTriggerUnit())
		local timer t = null
		//双击
		if( Player_isSelected[index] == 0 ) then
			set Player_isSelected[index] = targerIndex
			set t = htime.setTimeout( 0.2 , function thistype.triggerDoubleClickCall )
			call htime.setInteger( t , 542 , index )
		elseif( Player_isSelected[index] == targerIndex ) then
			if( (unitType == 'e000' or unitType == 'e002' or unitType == 'e003' or unitType == 'e004') and targerIndex!=index ) then //基地
				if( hplayer.getStatus(players[index])=="谋掠中" ) then
					set Player_isSelected[index] = 0
					set Player_Target_Loc[index] = Player_City_Loc[targerIndex]
					set Player_Target[index] = targerIndex
					call SetUnitFacing( Player_arrow[index] , AngleBetweenPoints(Player_Arrow_Loc[index], Player_Arrow_Loc[targerIndex]) )
					call hmsg.echoTo( players[index] , "你的新目标："+GetPlayerName(players[Player_Target[index]]),0,0,0 )
			        call SetTextTagTextBJ(Player_Target_ttg[index], "目标："+GetPlayerName(players[Player_Target[index]]) , 10.00)
				else
					call hmsg.echoTo( players[index] , "请耐心观战，您可以随意跟战斗的玩家聊天，使他们相互争斗",0,0,0 )
				endif
			elseif (getSTQty(soliderIndex,unitType)>0 and GetOwningPlayer(GetTriggerUnit())==Player(PLAYER_NEUTRAL_PASSIVE)) then
				if(soliderIndex == index)then
					call setSTQty(soliderIndex,unitType,getSTQty(soliderIndex,unitType)-1)
					call hplayer.addGold( players[soliderIndex] , getItemSGold(unitType)/2)
					call hmsg.echoTo( players[soliderIndex] , "1个士兵已解甲归田，得到 |cffffff00"+I2S(getItemSGold(unitType)/2)+"|r G",0,0,0 )
					call setSTTips(soliderIndex)
				else
					call hmsg.echoTo( players[soliderIndex] , "这不是你的部队，别搞事情",0,0,0 )
				endif
			endif
		endif
	endmethod


	/* 基地爆炸 */
	private static method triggerCityDeathAction takes nothing returns nothing
		local unit killer = hevt.getKiller()
		local player killerPlayer = GetOwningPlayer(killer)
		local player trggerPlayer = GetOwningPlayer(GetTriggerUnit())
		local integer killerOwnerIndex = GetConvertedPlayerId(killerPlayer)
		if( killerOwnerIndex >=9 and killerOwnerIndex <=12 ) then
			set killerOwnerIndex = GetConvertedPlayerId(getRealPlayer(killerPlayer))
		endif
		//分钱
		call hplayer.addGold(killerPlayer,hplayer.getGold(trggerPlayer)/3)
		//设置玩家状态为【战败】
	    call hplayer.setStatus( trggerPlayer, "已战败" )
	    call hmsg.echo( "|cffffff80"+GetPlayerName(players[killerOwnerIndex])+"|r 奋勇出击! "+GetPlayerName(trggerPlayer)+" 的基地爆炸啦！！"  )
	    call hmsg.echoTo( trggerPlayer , "你已经被击败，可以选择观战或离开战场",0,0,0 )
	    call playerFail(trggerPlayer)
	endmethod

	/* 基地被攻击，给予奖励 */
	private static method sound_tips_clear takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer index = htime.getInteger(t,1)
		set Player_sound_tips[index] = false
	endmethod
	private static method triggerCityBeHuntAction takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
		local unit source = GetEventDamageSource()
		local integer sourceIndex = GetConvertedPlayerId(GetOwningPlayer(source))
		local integer sourceTypeId = GetUnitTypeId(source)
		local integer i = 0
		local timer t = null
		local unit tempUnit = null
		local location loc = null
		if( index == sourceIndex ) then
			return
		endif
		//隐形
		if(Player_sound_tips[index]==false and GetUnitAbilityLevel(source, 'A03F')>0)then
			set Player_sound_tips[index] = true
			call hmedia.soundPlay2Player(gg_snd_audio_direnyinxing,players[index])
			set t = htime.setTimeout(8.00,function thistype.sound_tips_clear)
			call htime.setInteger(t,1,index)
		endif
		//空军
		if(Player_sound_tips[index]==false and hunit.getLifePercent(u)<70 and his.flying(source))then
			set Player_sound_tips[index] = true
			call hmedia.soundPlay2Player(gg_snd_audio_direnkongjun,players[index])
			set t = htime.setTimeout(8.00,function thistype.sound_tips_clear)
			call htime.setInteger(t,1,index)
		endif
		//陆地
		if(Player_sound_tips[index]==false and hunit.getLifePercent(u)<70 and his.ground(source))then
			set Player_sound_tips[index] = true
			call hmedia.soundPlay2Player(gg_snd_audio_direnlujun,players[index])
			set t = htime.setTimeout(8.00,function thistype.sound_tips_clear)
			call htime.setInteger(t,1,index)
		endif
		if(GetEventDamage() > 0) then
			if( sourceTypeId == 'o003' or sourceTypeId == 'o007' or sourceTypeId == 'o008' or sourceTypeId == 'o009' )then
				//偷金小贼
				set i = GetConvertedPlayerId(getRealPlayer(GetOwningPlayer(source)))
				call hmsg.echoTo( getRealPlayer(GetOwningPlayer(source)) , "小偷为你带回了 "+I2S(GetUnitUserData(source))+" 黄金",0,0,0)
				call hunit.del(source,0)
				call haward.forUnit(Player_city[i],0,GetUnitUserData(source),0)
				call hunit.setLife(Player_city[i],hunit.getLife(Player_city[i])+1)
			endif
			set Player_city_beHunt[index] = Player_city_beHunt[index] + 1
			if( his.hero(source) == true ) then
				//如果是英雄攻击，会召唤偷金小兵，返回基地
				call haward.forUnit(Player_city[index],0,-GetUnitLevel(source)*HERO_GET_GOLD_FROM_CITY,0)
				set tempUnit = hunit.createUnitAttackToLoc( Player_Golder[sourceIndex] , getTeamPlayer(GetOwningPlayer(source)) , Player_City_Loc[index] , Player_City_Loc[sourceIndex] )
				call SetUnitUserData(tempUnit, GetUnitLevel(source)*HERO_GET_GOLD_FROM_CITY)
				call hevt.onDead(tempUnit,function thistype.triggerUnitDeath)
				set tempUnit = null
				if( hplayer.getGold(players[index])-HERO_GET_GOLD_FROM_CITY<=0 )then
					call hplayer.setGold(players[index],0)
					call UnitDamageTargetBJ(Player_city[sourceIndex],Player_city[index],GetUnitLevel(source)*HERO_GET_GOLD_FROM_CITY, ATTACK_TYPE_MELEE, DAMAGE_TYPE_ENHANCED )
				endif
			endif
		endif
	endmethod

	/* 建筑 */
	private static method triggerBuildingSellItemAction takes nothing returns nothing
		local item it = GetSoldItem()
		local integer itType = GetItemTypeId(it)
		local unit u = GetSellingUnit()
		local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
		local location loc = GetUnitLoc(u)
		call heffect.toLoc( Effect_AIamTarget , loc , 0 )
		call RemoveLocation(loc)
		set loc = null
		if( itType == 'I006' )then //建筑 - 拆除
			call hplayer.addGold( GetOwningPlayer(u) , 100 )
			call ExplodeUnitBJ( u )
		elseif( itType == 'I007' )then //建筑 - 攻击加强
			call hattr.addAttackPhysical( u , 5 , 0 )
		elseif( itType == 'I043' )then //建筑 - 攻击加强
			call hattr.addAttackPhysical( u , 20 , 0 )
		elseif( itType == 'I045' )then //建筑 - 野兽力量
			call hattr.addAttackPhysical( u , 7 , 0 )
		elseif( itType == 'I046' )then //建筑 - 狂兽力量
			call hattr.addAttackPhysical( u , 25 , 0 )
		elseif( itType == 'I00A' )then //建筑 - 射速提升
			call hattr.addAttackSpeed( u , 7 , 0 )
		elseif( itType == 'I042' )then //建筑 - 射速速升
			call hattr.addAttackSpeed( u , 30 , 0 )
		elseif( itType == 'I009' )then //建筑 - 结构加固
			call hattr.addDefend( u , 1 , 0 )
		elseif( itType == 'I047' )then //建筑 - 铁壁城墙
			call hattr.addDefend( u , 2 , 0 )
		elseif( itType == 'I00B' )then //建筑 - 耐久加固
			call hattr.addLife( u , 50 , 0 )
		elseif( itType == 'I049' )then //建筑 - 冰晶之魂
			call hattr.addLife( u , 60 , 0 )
			call hattr.addAttackSpeed( u , 5 , 0 )
		elseif( itType == 'I00C' )then //建筑 - 维修保养
			call hattrExt.addLifeBack( u , 1 , 0 )
		elseif( itType == 'I048' )then //建筑 - 生命奇迹
			call hattrExt.addLifeBack( u , 3 , 0 )
		elseif( itType == 'I044' )then //建筑 - 连锁反应
			call hattrExt.addPunish( u , 100 , 0 )
		endif
	endmethod
	//建筑死亡
	private static method triggerBuildingDeathAction takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
		set Player_tower_Qty[index] = Player_tower_Qty[index] - 1
	endmethod
	//任意单位完成建筑
	private static method triggerBuildingCall takes nothing returns nothing
		local unit u = GetConstructedStructure()
		local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
		local trigger triggerUnitSellItem = CreateTrigger()
		local trigger triggerUnitDead = CreateTrigger()
		set Player_tower_Qty[index] = Player_tower_Qty[index] + 1
		call TriggerRegisterUnitEvent( triggerUnitSellItem , u , EVENT_UNIT_SELL_ITEM )
		call TriggerRegisterUnitEvent( triggerUnitDead , u , EVENT_UNIT_DEATH )
		call TriggerAddAction(triggerUnitSellItem, function thistype.triggerBuildingSellItemAction )
		call TriggerAddAction(triggerUnitDead, function thistype.triggerBuildingDeathAction )
	endmethod

	/* 英雄获得物品 */
	private static method triggerUnitPickItemAction takes nothing returns nothing
		local item it = GetManipulatedItem()
		local integer itType = GetItemTypeId(it)
		local unit u = GetTriggerUnit()
		local player whichPlayer = GetOwningPlayer(u)
		local race whichRace = GetPlayerRace(whichPlayer)
		local integer playerIndex = GetConvertedPlayerId(whichPlayer)
		local group tempGroup = null
		local unit tempUnit = null
		local integer i = 0
		//TODO 战略
		if( itType == 'I03S' )then	//战略 - 升级采金1
			set Player_gold_award[playerIndex] = Player_gold_award[playerIndex]+1
			call hplayer.addTotalGoldCost(players[playerIndex],250)
			call hplayer.addTotalLumberCost(players[playerIndex],5)
		elseif( itType == 'I03T' )then	//战略 - 升级采金2
			set Player_gold_award[playerIndex] = Player_gold_award[playerIndex]+2
			call hplayer.addTotalGoldCost(players[playerIndex],500)
			call hplayer.addTotalLumberCost(players[playerIndex],5)
		elseif( itType == 'I03V' )then	//战略 - 升级采金3
			set Player_gold_award[playerIndex] = Player_gold_award[playerIndex]+4
			call hplayer.addTotalGoldCost(players[playerIndex],1000)
			call hplayer.addTotalLumberCost(players[playerIndex],5)
		elseif( itType == 'I03U' )then	//战略 - 升级采金4
			set Player_gold_award[playerIndex] = Player_gold_award[playerIndex]+8
			call hplayer.addTotalGoldCost(players[playerIndex],2500)
			call hplayer.addTotalLumberCost(players[playerIndex],5)
		elseif( itType == 'I03W' )then	//战略 - 征战钟声
			call setPMaxQty( playerIndex , getPMaxQty(playerIndex)+1)
			call hplayer.addTotalGoldCost(players[playerIndex],2000)
			call hplayer.addTotalLumberCost(players[playerIndex],50)
		elseif( itType == 'I041' )then	//战略 - 坚固城墙
			call hattr.addDefend( Player_city[playerIndex] , 5 , 0 )
			call hplayer.addTotalLumberCost(players[playerIndex],100)
		elseif( itType == 'I04B' )then	//战略 - 城镇扩充
			call hattr.addLife( Player_city[playerIndex] , 500 , 0 )
			call hplayer.addTotalLumberCost(players[playerIndex],100)
		elseif( itType == 'I04A' )then	//战略 - 攻击要领
			call hattr.addAttackPhysical( Player_city[playerIndex] , 10 , 0 )
			call hplayer.addTotalLumberCost(players[playerIndex],100)
		elseif( itType == 'I03X' )then	//战略 - 疯狂之军
			call hplayer.addTotalLumberCost(players[playerIndex],50)
			if( Group_All_Solider != null )then
				set tempGroup = CreateGroup()
				call GroupAddGroup( Group_All_Solider , tempGroup )
				loop
		            exitwhen(IsUnitGroupEmptyBJ(tempGroup) == true)
		                //must do
		                set tempUnit = FirstOfGroup(tempGroup)
		                call GroupRemoveUnit( tempGroup , tempUnit )
		                if( GetOwningPlayer(tempUnit)== getTeamPlayer(whichPlayer) ) then
		                	call hattr.addAttackSpeed( tempUnit , 100 , 10.00 )
		                endif
						set tempUnit = null
		        endloop
		        call GroupClear( tempGroup )
		        call DestroyGroup( tempGroup )
		        set tempGroup = null
			endif
			call hmsg.echo( "|cff80ff80"+GetPlayerName(players[playerIndex])+"发动了|r|cffff0000[势如破竹]|r" )
			call hmsg.echoTo( players[playerIndex] , "士兵已打鸡血，攻击飞快！！奋勇杀敌！！",0,0,0 )
			call StartSound(gg_snd_audio_shirupozhu)
		elseif( itType == 'I005' )then	//战略 - 不死之军
			call hplayer.addTotalLumberCost(players[playerIndex],50)
			if( Group_All_Solider != null )then
				set tempGroup = CreateGroup()
				call GroupAddGroup( Group_All_Solider , tempGroup )
				loop
		            exitwhen(IsUnitGroupEmptyBJ(tempGroup) == true)
		                //must do
		                set tempUnit = FirstOfGroup(tempGroup)
		                call GroupRemoveUnit( tempGroup , tempUnit )
		                if( GetOwningPlayer(tempUnit)== getTeamPlayer(whichPlayer) ) then
		                	call hattr.addDefend( tempUnit , 999 , 10.00 )
			                call hattrExt.addPunish( tempUnit , 9999 , 10.00 )
		                endif
						set tempUnit = null
		        endloop
		        call GroupClear( tempGroup )
		        call DestroyGroup( tempGroup )
		        set tempGroup = null
			endif
			call hmsg.echo( "|cff80ff80"+GetPlayerName(players[playerIndex])+"发动了|r|cffff0000[无坚不摧]|r" )
			call hmsg.echoTo( players[playerIndex] , "士兵已固若金汤，不会疼痛！！坚强杀敌！！",0,0,0 )
			call StartSound(gg_snd_audio_wujianbucui)
		elseif( itType == 'I04C' )then	//战略 - 极速之军
			call hplayer.addTotalLumberCost(players[playerIndex],50)
			if( Group_All_Solider != null )then
				set tempGroup = CreateGroup()
				call GroupAddGroup( Group_All_Solider , tempGroup )
				loop
		            exitwhen(IsUnitGroupEmptyBJ(tempGroup) == true)
		                //must do
		                set tempUnit = FirstOfGroup(tempGroup)
		                call GroupRemoveUnit( tempGroup , tempUnit )
		                if( GetOwningPlayer(tempUnit)== getTeamPlayer(whichPlayer) ) then
		                	call hattr.addMove( tempUnit , 100 , 10.00 )
		                endif
						set tempUnit = null
		        endloop
		        call GroupClear( tempGroup )
		        call DestroyGroup( tempGroup )
		        set tempGroup = null
			endif
			call hmsg.echo( "|cff80ff80"+GetPlayerName(players[playerIndex])+"发动了|r|cffff0000[铲平]|r" )
			call hmsg.echoTo( players[playerIndex] , "冲啊！士兵突击！！",0,0,0 )
			call StartSound(gg_snd_audio_chanping)
		elseif( itType == 'I04D' )then	//战略 - 勇猛之军
			call hplayer.addTotalLumberCost(players[playerIndex],50)
			if( Group_All_Solider != null )then
				set tempGroup = CreateGroup()
				call GroupAddGroup( Group_All_Solider , tempGroup )
				loop
		            exitwhen(IsUnitGroupEmptyBJ(tempGroup) == true)
		                //must do
		                set tempUnit = FirstOfGroup(tempGroup)
		                call GroupRemoveUnit( tempGroup , tempUnit )
		                if( GetOwningPlayer(tempUnit)== getTeamPlayer(whichPlayer) ) then
		                	call hattr.addAttackPhysical( tempUnit , 20 , 10.00 )
		                endif
						set tempUnit = null
		        endloop
		        call GroupClear( tempGroup )
		        call DestroyGroup( tempGroup )
		        set tempGroup = null
			endif
			call hmsg.echo( "|cff80ff80"+GetPlayerName(players[playerIndex])+"发动了|r|cffff0000[完爆]|r" )
			call hmsg.echoTo( players[playerIndex] , "士兵已力量爆发，发动更强力的攻击！！",0,0,0 )
			call StartSound(gg_snd_audio_wanbao)
		endif
		//TODO 派遣/升级
		if( whichRace == RACE_HUMAN )then
			set i = 1
			loop
				exitwhen(i>12)
					if(itType == st_human[i])then
						call setSTQty(playerIndex,stu_human[i],getSTQty(playerIndex,stu_human[i])+1)
						call setSTTips(playerIndex)
						call DoNothing() YDNL exitwhen true
					elseif(itType == stupgrade_human[i])then
						if(getSTQty(playerIndex,stu_human[i])>0)then
							call setSTLevel(playerIndex,stu_human[i],getSTLevel(playerIndex,stu_human[i])+1)
							call setSTTips(playerIndex)
							call hplayer.addTotalGoldCost(players[playerIndex],priceupgrade_human[i])
							call DoNothing() YDNL exitwhen true
						else
							call hplayer.addGold( players[playerIndex] , priceupgrade_human[i])
							call hmsg.echoTo( players[playerIndex] , "请先派遣该部队",0,0,0 )
						endif
					endif
				set i = i+1
			endloop
		elseif( whichRace == RACE_ORC )then
			set i = 1
			loop
				exitwhen(i>12)
					if(itType == st_orc[i])then
						call setSTQty(playerIndex,stu_orc[i],getSTQty(playerIndex,stu_orc[i])+1)
						call setSTTips(playerIndex)
						call DoNothing() YDNL exitwhen true
					elseif(itType == stupgrade_orc[i])then
						if(getSTQty(playerIndex,stu_orc[i])>0)then
							call setSTLevel(playerIndex,stu_orc[i],getSTLevel(playerIndex,stu_orc[i])+1)
							call setSTTips(playerIndex)
							call hplayer.addTotalGoldCost(players[playerIndex],priceupgrade_orc[i])
							call DoNothing() YDNL exitwhen true
						else
							call hplayer.addGold( players[playerIndex] , priceupgrade_orc[i])
							call hmsg.echoTo( players[playerIndex] , "请先派遣该部队",0,0,0 )
						endif
					endif
				set i = i+1
			endloop
		elseif( whichRace == RACE_UNDEAD )then
			set i = 1
			loop
				exitwhen(i>12)
					if(itType == st_undead[i])then
						call setSTQty(playerIndex,stu_undead[i],getSTQty(playerIndex,stu_undead[i])+1)
						call setSTTips(playerIndex)
						call DoNothing() YDNL exitwhen true
					elseif(itType == stupgrade_undead[i])then
						if(getSTQty(playerIndex,stu_undead[i])>0)then
							call setSTLevel(playerIndex,stu_undead[i],getSTLevel(playerIndex,stu_undead[i])+1)
							call setSTTips(playerIndex)
							call hplayer.addTotalGoldCost(players[playerIndex],priceupgrade_undead[i])
							call DoNothing() YDNL exitwhen true
						else
							call hplayer.addGold( players[playerIndex] , priceupgrade_undead[i])
							call hmsg.echoTo( players[playerIndex] , "请先派遣该部队",0,0,0 )
						endif
					endif
				set i = i+1
			endloop
		elseif( whichRace == RACE_NIGHTELF )then
			set i = 1
			loop
				exitwhen(i>12)
					if(itType == st_nightelf[i])then
						call setSTQty(playerIndex,stu_nightelf[i],getSTQty(playerIndex,stu_nightelf[i])+1)
						call setSTTips(playerIndex)
						call DoNothing() YDNL exitwhen true
					elseif(itType == stupgrade_nightelf[i])then
						if(getSTQty(playerIndex,stu_nightelf[i])>0)then
							call setSTLevel(playerIndex,stu_nightelf[i],getSTLevel(playerIndex,stu_nightelf[i])+1)
							call setSTTips(playerIndex)
							call hplayer.addTotalGoldCost(players[playerIndex],priceupgrade_nightelf[i])
							call DoNothing() YDNL exitwhen true
						else
							call hplayer.addGold( players[playerIndex] , priceupgrade_nightelf[i])
							call hmsg.echoTo( players[playerIndex] , "请先派遣该部队",0,0,0 )
						endif
					endif
				set i = i+1
			endloop
		endif
	endmethod

	/* 英雄学习技能 */
	private static method triggerUnitHeroSkillAction takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local integer skillId = GetLearnedSkill()
		//call hattr.showAttr(u)
		if( skillId == 'A07Z' ) then
			call hattr.addAttackPhysical( u , 5 , 0 )
		elseif( skillId == 'A007' ) then
			call hattr.addAttackSpeed( u , 5 , 0 )
		elseif( skillId == 'A009' ) then
			call hattr.addLife( u , 25 , 0 )
		elseif( skillId == 'A00O' ) then
			call hattr.addMove( u , 10 , 0 )
		endif
	endmethod

	/* 英雄释放技能 */
	private static method triggerUnitSpellEffectAction takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local integer skillId = GetSpellAbilityId()
		local unit targetUnit = GetSpellTargetUnit()
		local group g = null
		local unit tempUnit = null
		local hFilter hf = 0
		local hAttrHuntBean huntBean = 0
		//human
		if( skillId == 'A016' ) then

			set hf = hFilter.create()
			call hf.setUnit(u)
			call hf.isEnemy(true)
			call hf.isAlive(true)
			call hf.isBuilding(false)
			set g = hgroup.createByUnit( u, 250 , function hFilter.get )
			call hf.destroy()

			set huntBean = hAttrHuntBean.create()
			set huntBean.fromUnit = u
			set huntBean.huntEff = Effect_Boold_Cut
			set huntBean.damage = I2R(GetUnitLevel(u)+15)
			set huntBean.huntKind = "skill"
			set huntBean.huntType = "physical"
			set huntBean.isNoAvoid = false
			set huntBean.whichGroup = g
			call hAttrHunt.huntGroup(huntBean)
			call huntBean.destroy()

			call GroupClear(g)
			call DestroyGroup(g)
		elseif( skillId == 'A01H' ) then
			call hattr.addAttackPhysical( u , I2R(GetUnitLevel(u)+10) , 6 )
		elseif( skillId == 'A019' ) then
			call hattr.addAttackSpeed( u , I2R(GetUnitLevel(u)+10) , 6 )
		endif
		//orc
		if( skillId == 'A02R' ) then
			set hf = hFilter.create()
			call hf.setUnit(u)
			call hf.isAlly(true)
			call hf.isAlive(true)
			call hf.isBuilding(false)
			set g = hgroup.createByUnit( u, 500 , function hFilter.get )
			call hf.destroy()
			loop
	            exitwhen(IsUnitGroupEmptyBJ(g) == true)
	                set tempUnit = FirstOfGroup(g)
	                call GroupRemoveUnit( g , tempUnit )
	                call hattr.addAttackPhysical( tempUnit , I2R(GetUnitLevel(u)+5) , 8 )
					set tempUnit = null
	        endloop
			call GroupClear(g)
			call DestroyGroup(g)
		endif
		//undead
		if( skillId == 'A031' ) then

			set huntBean = hAttrHuntBean.create()
			set huntBean.fromUnit = u
			set huntBean.toUnit = targetUnit
			set huntBean.damage = I2R(GetUnitLevel(u)+15)
			set huntBean.huntKind = "skill"
			set huntBean.huntType = "magic"
			call hAttrHunt.huntUnit(huntBean)
			call huntBean.destroy()

		elseif( skillId == 'A032' ) then
			call hattrExt.addHemophagia( u , I2R(GetUnitLevel(u)+10) , 10 )
		elseif( skillId == 'A033' ) then
			call hattr.addDefend( targetUnit , I2R(GetUnitLevel(u)) , 30 )
		endif
		//nightelf
		if( skillId == 'A03V' ) then
			call hattr.addAttackSpeed( targetUnit , 50 , 5 )
			call hattr.addMove( targetUnit , 50 , 5 )
		endif
	endmethod

	/* 英雄自动（AI）释放技能 */
	private static method triggerHeroBeHuntAction takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local integer i = GetConvertedPlayerId(GetOwningPlayer(u))
		local unit enemyu = GetEventDamageSource()
		local integer sourceTypeId = GetUnitTypeId(enemyu)
		local integer uType = GetUnitTypeId(u)
		local integer rand = 0
		local location loc = null
		if(GetEventDamage() > 0) then
			if( sourceTypeId == 'o00A' and GetUnitUserData(enemyu)>0) then //金币
				call haward.forUnit(hplayer.getHero(players[i]),0,GetUnitUserData(enemyu),0)
				call SetUnitUserData(enemyu, 0)
				set loc = GetUnitLoc(enemyu)
				call heffect.toLoc(Effect_PileofGold,loc,1.00)
				call RemoveLocation(loc)
				call hunit.del(enemyu,0)
				if( his.computer(players[i]) ) then
					call IssuePointOrderLoc( u , "move", Player_City_Loc[i] )
				endif
			endif
			if( his.computer(players[i]) ) then
				set rand = GetRandomInt(1,100)
				if( rand<50 and GetUnitStateSwap(UNIT_STATE_LIFE,u)<45 ) then
					call IssuePointOrderLoc( u , "move", Player_City_Loc[i] )
				endif
				if(uType == 'H00M')then
					if(rand<20 and GetUnitStateSwap(UNIT_STATE_LIFE,u)<30 ) then
						call IssueImmediateOrder( u, "divineshield" )
					elseif(rand>=20 and rand<30) then
					    call IssueImmediateOrder( u, "thunderclap" )
				    elseif(rand>=30 and rand<40) then
					    call IssueImmediateOrder( u, "berserk" )
				    elseif(rand>=40 and rand<50) then
					    call IssueImmediateOrder( u, "fanofknives" )
					endif
				elseif(uType == 'H008')then
					if(rand<30) then
						call IssueImmediateOrder( u, "roar" )
					elseif(rand>=30 and rand<45) then
						set loc = GetUnitLoc(enemyu)
					    call IssuePointOrderLoc( u, "thunderclap" ,loc)
					    call RemoveLocation(loc)
				    elseif(rand>=45 and rand<60 and GetUnitStateSwap(UNIT_STATE_LIFE,u)<50 ) then
					    call IssueImmediateOrder( u, "windwalk" )
					    call IssuePointOrderLoc( u , "move", Player_City_Loc[i] )
					endif
				elseif(uType == 'H00A')then
					if(rand<30) then
						call IssueImmediateOrder( u, "scout" )
				    elseif(rand>=30 and rand<60) then
					    call IssueImmediateOrder( u, "starfall" )
					endif
				elseif(uType == 'H009')then
					if(rand<25) then
						call IssueTargetOrder( u, "frostnova" , enemyu )
				    elseif(rand>=25 and rand<45) then
					    call IssueImmediateOrder( u, "berserk" )
				    elseif(rand>=45 and rand<60) then
					    call IssueTargetOrder( u, "frostarmor", enemyu )
					endif
				endif
			endif	
		endif
	endmethod

	/* 英雄升级 */
	private static method triggerUnitHeroLevelAction takes nothing returns nothing
		call hplayer.addLumber( GetOwningPlayer(GetTriggerUnit()) , 25 )
		call hmsg.echoTo( GetOwningPlayer(GetTriggerUnit()) , "|cffff0000将军|r升级！你获得了|cffff0000 25 |r点战略点。",0,0,0 )
	endmethod

	//初始化玩家
	private static method initPlayer takes nothing returns nothing
		local integer i = 1
		local race whichRace = null
		local integer tempInt = 0
		local integer type_city = 0
		local integer type_arrow = 0
		local integer type_unit = 0
		local integer type_casern = 0
		local integer type_lab = 0
		local string avatar = ""
		local trigger triggerPlayerOffline = CreateTrigger()
		local trigger triggerPlayerSelect = CreateTrigger()
		local trigger triggerCityBeHunt = CreateTrigger()
		local trigger triggerUnitPickItem = CreateTrigger()
		local trigger triggerUnitHeroSkill = CreateTrigger()
		local trigger triggerUnitSpellEffect = CreateTrigger()
		local trigger triggerHeroBeHunt = CreateTrigger()
		local trigger triggerUnitHeroLevel = CreateTrigger()
		local timer t = null
		//玩家触发
	    call TriggerAddAction(triggerPlayerOffline, function thistype.triggerPlayerOfflineActions)		//掉线
	    call TriggerAddAction(triggerPlayerSelect, function thistype.triggerPlayerSelectActions)			//选目标
	    call TriggerAddAction(triggerCityBeHunt, function thistype.triggerCityBeHuntAction)				//基地被打
	    call TriggerAddAction(triggerUnitPickItem, function thistype.triggerUnitPickItemAction)			//使用物品
	    call TriggerAddAction(triggerUnitHeroSkill, function thistype.triggerUnitHeroSkillAction)		//学习技能
	    call TriggerAddAction(triggerUnitSpellEffect, function thistype.triggerUnitSpellEffectAction) 	//释放技能
	    call TriggerAddAction(triggerHeroBeHunt, function thistype.triggerHeroBeHuntAction)//AI释放技能
	    call TriggerAddAction(triggerUnitHeroLevel, function thistype.triggerUnitHeroLevelAction)  		//英雄升级
	    set i = 1
	    loop
	        exitwhen i > player_max_qty
	        	set player_current_qty = player_current_qty + 1
	        	set Player_city_beHunt[i] = 0
	        	set Player_tower_Qty[i] = 0
	        	set Player_gold_award[i] = DEFAULT_PLAYER_GOLD_AWARD
	        	call setPMaxQty(i,10)
	        	call SetPlayerName( players[i+8] , GetPlayerName(players[i]) )
				call SavePlayerHandle( hash_player , GetHandleId(players[i]) , hash_player_Bind , players[i+8] )
				call SavePlayerHandle( hash_player , GetHandleId(players[i+8]) , hash_player_Real , players[i] )
				//
				call TriggerRegisterPlayerEventLeave( triggerPlayerOffline , players[i] )
	            call TriggerRegisterPlayerSelectionEventBJ( triggerPlayerSelect , players[i] , true )

	            //创建每位玩家的堡垒/军机处/英雄
	            //获取种族
	            set whichRace = GetPlayerRace(players[i])
	            if( whichRace == ConvertRace(0) )then
	            	set tempInt = GetRandomInt(1,4)
            		if(tempInt == 1)then
            			set whichRace = RACE_HUMAN
        			elseif (tempInt == 2) then
            			set whichRace = RACE_ORC
        			elseif (tempInt == 3) then
            			set whichRace = RACE_UNDEAD
        			elseif (tempInt == 4) then
            			set whichRace = RACE_NIGHTELF
	            	endif
	            endif
	            if( whichRace == RACE_HUMAN )then
	            	set type_city = 'e000'
	            	set type_casern = 'e001'
	            	set type_unit = 'H00M'
					set type_arrow = 'o002'
					set type_lab = 'e005'
					set Player_Golder[i] = 'o003'
					set avatar = "ReplaceableTextures\\CommandButtons\\BTNGarithos.blp"
				elseif (whichRace == RACE_ORC ) then
					set type_city = 'e002'
	            	set type_casern = 'e006'
	            	set type_unit = 'H008'
					set type_arrow = 'o000'
					set type_lab = 'e008'
					set Player_Golder[i] = 'o007'
					set avatar = "ReplaceableTextures\\CommandButtons\\BTNThrall.blp"
    			elseif (whichRace == RACE_UNDEAD ) then
    				set type_city = 'e004'
	            	set type_casern = 'e007'
	            	set type_unit = 'H009'
					set type_arrow = 'o005'
					set type_lab = 'e009'
					set Player_Golder[i] = 'o008'
					set avatar = "ReplaceableTextures\\CommandButtons\\BTNHeroDeathKnight.blp"
    			elseif (whichRace == RACE_NIGHTELF ) then
    				set type_city = 'e003'
	            	set type_casern = 'e00A'
	            	set type_unit = 'H00A'
					set type_arrow = 'o006'
					set type_lab = 'e00B'
					set Player_Golder[i] = 'o009'
					set avatar = "ReplaceableTextures\\CommandButtons\\BTNPriestessOfTheMoon.blp"
	            endif
	            //基地
				set Player_city[i] = hunit.createUnitFacing( players[i] , type_city , Player_City_Loc[i] , bj_UNIT_FACING )
				call SetUnitPathing( Player_city[i] , false )
				call TriggerRegisterUnitEvent( triggerCityBeHunt , Player_city[i] , EVENT_UNIT_DAMAGED )
				call hevt.onDead(Player_city[i],function thistype.triggerCityDeathAction)
				//出兵场
				set Player_casern[i] = hunit.createUnitFacing( players[i] , type_casern , Player_Casern_Loc[i] , bj_UNIT_FACING )
				//训练场
				set Player_lab[i] = hunit.createUnitFacing( players[i] , type_lab , Player_Lab_Loc[i] , bj_UNIT_FACING )
				//默认指向
				if (i==player_max_qty) then
					set Player_arrow[i] = hunit.createUnit( Player(PLAYER_NEUTRAL_PASSIVE) , type_arrow , Player_Arrow_Loc[i] )
					set Player_Target_Loc[i] = Player_City_Loc[1]
					set Player_Target[i] = 1
				else
					set Player_arrow[i] = hunit.createUnitLookAt( Player(PLAYER_NEUTRAL_PASSIVE) , type_arrow , Player_Arrow_Loc[i] , Player_Arrow_Loc[i+1] )
					set Player_Target_Loc[i] = Player_City_Loc[i+1]
					set Player_Target[i] = i+1
				endif
				//漂浮字
				set Player_Target_ttg[i] = CreateTextTag()
		        call SetTextTagTextBJ(Player_Target_ttg[i], "目标："+GetPlayerName(players[Player_Target[i]]) , 10.00)
		        call SetTextTagPos(Player_Target_ttg[i], GetLocationX(Player_Arrow_Loc[i]), GetLocationY(Player_Arrow_Loc[i]) , 170)
		        call SetTextTagColorBJ(Player_Target_ttg[i], 100.00, 100.00, 100.00, 0)
		        call SetTextTagPermanent( Player_Target_ttg[i], true )

		        set Player_Gold_ttg[i] = CreateTextTag()
		        call SetTextTagTextBJ(Player_Gold_ttg[i], "|cffffff80"+I2S(hplayer.getGold(players[i]))+"|r" , 10.00)
		        call SetTextTagPos(Player_Gold_ttg[i], GetLocationX(Player_City_Loc[i]), GetLocationY(Player_City_Loc[i]) , 350)
		        call SetTextTagPermanent( Player_Gold_ttg[i], true )
		        //英雄
				call hplayer.setHero(players[i],hunit.createUnitFacing( players[i] , type_unit , Player_Arrow_Loc[i] , bj_UNIT_FACING ),avatar)
				call hattrExt.addPunish(hplayer.getHero(players[i]),200,0)
				call SetUnitPathing( hplayer.getHero(players[i]) , false )
				call hevt.onDead(hplayer.getHero(players[i]),function thistype.triggerUnitDeath)
				call TriggerRegisterUnitEvent( triggerUnitPickItem , hplayer.getHero(players[i]) , EVENT_UNIT_PICKUP_ITEM )
				call TriggerRegisterUnitEvent( triggerUnitHeroSkill , hplayer.getHero(players[i]) , EVENT_UNIT_HERO_SKILL )
				call TriggerRegisterUnitEvent( triggerUnitSpellEffect , hplayer.getHero(players[i]) , EVENT_UNIT_SPELL_EFFECT )
				call TriggerRegisterUnitEvent( triggerUnitHeroLevel , hplayer.getHero(players[i]) , EVENT_UNIT_HERO_LEVEL )
				call TriggerRegisterUnitEvent( triggerHeroBeHunt , hplayer.getHero(players[i]) , EVENT_UNIT_DAMAGED )
	        set i = i + 1
	    endloop
	endmethod

	private static method warPlusGold takes nothing returns nothing
		local integer i = 1
		loop
	        exitwhen i > player_max_qty
	        	if( hplayer.getStatus(players[i]) == "谋掠中" ) then
					call hplayer.addGold(players[i],Player_gold_award[i])
					call SetTextTagTextBJ(Player_Gold_ttg[i], "|cffffff80"+I2S(hplayer.getGold(players[i]))+"|r" , 10.00)
				endif
	        set i = i + 1
        endloop
	endmethod

	//攻击debug
	private static method attackDebug takes nothing returns nothing
		local group tempGroup = null
		local unit tempUnit = null
		local integer target = 0
		if( Group_All_Solider != null )then
			set tempGroup = CreateGroup()
			call GroupAddGroup( Group_All_Solider , tempGroup )
			loop
	            exitwhen(IsUnitGroupEmptyBJ(tempGroup) == true)
	                //must do
	                set tempUnit = FirstOfGroup(tempGroup)
	                call GroupRemoveUnit( tempGroup , tempUnit )
	                set target = GetUnitUserData(tempUnit)
	                if( hplayer.getStatus(players[target]) == "谋掠中" ) then
		                call IssuePointOrderLoc( tempUnit , "attack", Player_City_Loc[target] )
		            else
		            	call SetUnitUserData( tempUnit , Player_Target[GetConvertedPlayerId(getRealPlayer(GetOwningPlayer(tempUnit)))] )
		            	set target = GetUnitUserData(tempUnit)
		            	call IssuePointOrderLoc( tempUnit , "attack", Player_City_Loc[target] )
	                endif
					set tempUnit = null
	        endloop
	        call GroupClear( tempGroup )
	        call DestroyGroup( tempGroup )
	        set tempGroup = null
		endif
	endmethod

	private static method upgrade takes nothing returns nothing
		local integer i = 1
		set DEFAULT_UNIT_ATTACK_SPEED = DEFAULT_UNIT_ATTACK_SPEED + 25
		set DEFAULT_UNIT_MOVE = DEFAULT_UNIT_MOVE + 25
		loop
	        exitwhen i > player_max_qty
	        	if( hplayer.getStatus(players[i]) == "谋掠中" ) then
					call hattr.addAttackPhysical(hplayer.getHero(players[i]),10,0)
					call hattr.addAttackSpeed(hplayer.getHero(players[i]),15,0)
					call hattr.addMove(hplayer.getHero(players[i]),10,0)
				endif
	        set i = i + 1
        endloop
		call hmsg.echo( "|cffff0000士兵战意越发高昂，全军能力大增！|r" )
	endmethod

	private static method centerGold takes nothing returns nothing
		local integer i = 1
		local location loc = PolarProjectionBJ(Loc_C, GetRandomReal(0, 1600), GetRandomReal(0, 360))
		local unit tempUnit = hunit.createUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE) , 'o00A' , loc )
		call PingMinimapLocForForceEx( GetPlayersAll(), loc, 3.00, bj_MINIMAPPINGSTYLE_FLASHY, 100, 100, 100 )
		call SetUnitUserData(tempUnit, DEFAULT_CENTER_GOLD_AWARD+GetRandomInt(1, 200))
		set tempUnit = null
		call hmsg.echo( "|cffff80c0一个金币从天而降|r" )
		set DEFAULT_CENTER_GOLD_AWARD = DEFAULT_CENTER_GOLD_AWARD + 150
		loop
	        exitwhen i > player_max_qty
	        	if( his.alive(hplayer.getHero(players[i])) and hplayer.getStatus(players[i]) == "谋掠中" and his.computer(players[i]) and GetRandomInt(1,100)<70 ) then
					call IssuePointOrderLoc( hplayer.getHero(players[i]) , "move", loc )
				endif
	        set i = i + 1
        endloop
        call RemoveLocation(loc)
        set loc = null
	endmethod

	public static method run takes nothing returns nothing

		local integer i = 0

		//设定区域和点
		set Player_City_Loc[1] 		= Location(	-512	,2048)
		set Player_City_Loc[2] 		= Location(	2048	,-512)
		set Player_City_Loc[3] 		= Location(	4608	,2048)
		set Player_City_Loc[4] 		= Location(	2048	,4608)

		set Player_Arrow_Loc[1] 	= Location(	-128	,2048)
		set Player_Arrow_Loc[2] 	= Location(	2048	,-128)
		set Player_Arrow_Loc[3] 	= Location(	4224	,2048)
		set Player_Arrow_Loc[4] 	= Location(	2048	,4224)

		set Player_Casern_Loc[1] 	= Location(	-768	,2304)
		set Player_Casern_Loc[2] 	= Location(	1792	,-768)
		set Player_Casern_Loc[3] 	= Location(	4864	,1792)
		set Player_Casern_Loc[4] 	= Location(	2304	,4864)

		set Player_Lab_Loc[1] 		= Location(	-768	,1792)
		set Player_Lab_Loc[2] 		= Location(	2304	,-768)
		set Player_Lab_Loc[3] 		= Location(	4864	,2304)
		set Player_Lab_Loc[4] 		= Location(	1792	,4864)

		set Player_Soldier_Loc[1] 	= Location(	-832	,1345)
		set Player_Soldier_Loc[2] 	= Location(	2752	,-448)
		set Player_Soldier_Loc[3] 	= Location(	4288	,2880)
		set Player_Soldier_Loc[4] 	= Location(	704		,4672)

		set st_human[1] = 'I00Y' //剑侠
		set st_human[2] = 'I000' //骑兵
		set st_human[3] = 'I03E' //步兵
		set st_human[4] = 'I003' //火枪手
		set st_human[5] = 'I00L' //破魔导师
		set st_human[6] = 'I00X' //女巫
		set st_human[7] = 'I004' //牧师
		set st_human[8] = 'I002' //坦克
		set st_human[9] = 'I00J' //炮兵
		set st_human[10] = 'I001' //飞机
		set st_human[11] = 'I00W' //狮鹫
		set st_human[12] = 'I00Z' //黑龙
		set pricet_human[1] = 3500
		set pricet_human[2] = 260
		set pricet_human[3] = 200
		set pricet_human[4] = 500
		set pricet_human[5] = 650
		set pricet_human[6] = 1250
		set pricet_human[7] = 875
		set pricet_human[8] = 4800
		set pricet_human[9] = 1650
		set pricet_human[10] = 600
		set pricet_human[11] = 6000
		set pricet_human[12] = 7500
		set stupgrade_human[1] = 'I026'
		set stupgrade_human[2] = 'I02M'
		set stupgrade_human[3] = 'I029'
		set stupgrade_human[4] = 'I02A'
		set stupgrade_human[5] = 'I02K'
		set stupgrade_human[6] = 'I028'
		set stupgrade_human[7] = 'I02C'
		set stupgrade_human[8] = 'I027'
		set stupgrade_human[9] = 'I02B'
		set stupgrade_human[10] = 'I02L'
		set stupgrade_human[11] = 'I02J'
		set stupgrade_human[12] = 'I02Q'
		set priceupgrade_human[1] = 700
		set priceupgrade_human[2] = 52
		set priceupgrade_human[3] = 40
		set priceupgrade_human[4] = 100
		set priceupgrade_human[5] = 130
		set priceupgrade_human[6] = 250
		set priceupgrade_human[7] = 175
		set priceupgrade_human[8] = 960
		set priceupgrade_human[9] = 330
		set priceupgrade_human[10] = 120
		set priceupgrade_human[11] = 1250
		set priceupgrade_human[12] = 1500
		set stu_human[1] = 'n00G'
		set stu_human[2] = 'n001'
		set stu_human[3] = 'n005'
		set stu_human[4] = 'n00A'
		set stu_human[5] = 'n00D'
		set stu_human[6] = 'n00E'
		set stu_human[7] = 'n00C'
		set stu_human[8] = 'n003'
		set stu_human[9] = 'n008'
		set stu_human[10] = 'n002'
		set stu_human[11] = 'n00H'
		set stu_human[12] = 'n00I'

		set st_orc[1] = 'I014' //赤兽步兵
		set st_orc[2] = 'I017' //科多兽
		set st_orc[3] = 'I00H' //兽人步兵
		set st_orc[4] = 'I00K' //自爆工兵
		set st_orc[5] = 'I010' //双角狼骑
		set st_orc[6] = 'I019' //牛头人
		set st_orc[7] = 'I018' //灵魂行者
		set st_orc[8] = 'I016' //巫术士
		set st_orc[9] = 'I013' //粉碎机
		set st_orc[10] = 'I01A' //恶魔巫师
		set st_orc[11] = 'I011' //虚无飞龙
		set st_orc[12] = 'I012' //飞龙骑士
		set pricet_orc[1] = 4500
		set pricet_orc[2] = 1100
		set pricet_orc[3] = 220
		set pricet_orc[4] = 50
		set pricet_orc[5] = 350
		set pricet_orc[6] = 3000
		set pricet_orc[7] = 1550
		set pricet_orc[8] = 900
		set pricet_orc[9] = 5600
		set pricet_orc[10] = 8000
		set pricet_orc[11] = 525
		set pricet_orc[12] = 650
		set stupgrade_orc[1] = 'I035'
		set stupgrade_orc[2] = 'I02X'
		set stupgrade_orc[3] = 'I02R'
		set stupgrade_orc[4] = 'I030'
		set stupgrade_orc[5] = 'I02S'
		set stupgrade_orc[6] = 'I02W'
		set stupgrade_orc[7] = 'I02V'
		set stupgrade_orc[8] = 'I02T'
		set stupgrade_orc[9] = 'I02Z'
		set stupgrade_orc[10] = 'I02U'
		set stupgrade_orc[11] = 'I031'
		set stupgrade_orc[12] = 'I03F'
		set priceupgrade_orc[1] = 900
		set priceupgrade_orc[2] = 220
		set priceupgrade_orc[3] = 44
		set priceupgrade_orc[4] = 10
		set priceupgrade_orc[5] = 70
		set priceupgrade_orc[6] = 600
		set priceupgrade_orc[7] = 310
		set priceupgrade_orc[8] = 180
		set priceupgrade_orc[9] = 1120
		set priceupgrade_orc[10] = 1600
		set priceupgrade_orc[11] = 105
		set priceupgrade_orc[12] = 130
		set stu_orc[1] = 'n00P'
		set stu_orc[2] = 'n00U'
		set stu_orc[3] = 'n004'
		set stu_orc[4] = 'n009'
		set stu_orc[5] = 'n00K'
		set stu_orc[6] = 'n00N'
		set stu_orc[7] = 'n00M'
		set stu_orc[8] = 'n00L'
		set stu_orc[9] = 'n00Q'
		set stu_orc[10] = 'n00R'
		set stu_orc[11] = 'n00S'
		set stu_orc[12] = 'n00T'

		set st_undead[1] = 'I01O' //僵尸
		set st_undead[2] = 'I01S' //骷髅大兵
		set st_undead[3] = 'I01W' //憎恶
		set st_undead[4] = 'I01X' //食尸鬼
		set st_undead[5] = 'I01U' //冤魂
		set st_undead[6] = 'I01N' //腐尸甲虫
		set st_undead[7] = 'I01R' //痛苦少女
		set st_undead[8] = 'I01V' //穴居蜘蛛
		set st_undead[9] = 'I01Q' //骷髅射手
		set st_undead[10] = 'I01P' //绞肉车
		set st_undead[11] = 'I01T' //石像鬼
		set st_undead[12] = 'I01M' //冰骨巨龙
		set pricet_undead[1] = 5000
		set pricet_undead[2] = 1200
		set pricet_undead[3] = 275
		set pricet_undead[4] = 200
		set pricet_undead[5] = 500
		set pricet_undead[6] = 6500
		set pricet_undead[7] = 1800
		set pricet_undead[8] = 425
		set pricet_undead[9] = 2400
		set pricet_undead[10] = 3300
		set pricet_undead[11] = 850
		set pricet_undead[12] = 15000
		set stupgrade_undead[1] = 'I035'
		set stupgrade_undead[2] = 'I024'
		set stupgrade_undead[3] = 'I00G'
		set stupgrade_undead[4] = 'I023'
		set stupgrade_undead[5] = 'I00E'
		set stupgrade_undead[6] = 'I022'
		set stupgrade_undead[7] = 'I01Y'
		set stupgrade_undead[8] = 'I020'
		set stupgrade_undead[9] = 'I025'
		set stupgrade_undead[10] = 'I021'
		set stupgrade_undead[11] = 'I01Z'
		set stupgrade_undead[12] = 'I00F'
		set priceupgrade_undead[1] = 1000
		set priceupgrade_undead[2] = 240
		set priceupgrade_undead[3] = 55
		set priceupgrade_undead[4] = 40
		set priceupgrade_undead[5] = 100
		set priceupgrade_undead[6] = 1300
		set priceupgrade_undead[7] = 360
		set priceupgrade_undead[8] = 85
		set priceupgrade_undead[9] = 480
		set priceupgrade_undead[10] = 660
		set priceupgrade_undead[11] = 170
		set priceupgrade_undead[12] = 3000
		set stu_undead[1] = 'n01H'
		set stu_undead[2] = 'n01D'
		set stu_undead[3] = 'n018'
		set stu_undead[4] = 'n017'
		set stu_undead[5] = 'n01C'
		set stu_undead[6] = 'n01I'
		set stu_undead[7] = 'n01E'
		set stu_undead[8] = 'n019'
		set stu_undead[9] = 'n01F'
		set stu_undead[10] = 'n01G'
		set stu_undead[11] = 'n01A'
		set stu_undead[12] = 'n01B'

		set st_nightelf[1] = 'I01L' //远古守护者
		set st_nightelf[2] = 'I01J' //山岭巨人
		set st_nightelf[3] = 'I01I' //巨熊
		set st_nightelf[4] = 'I01G' //熊德鲁伊
		set st_nightelf[5] = 'I01B' //树人
		set st_nightelf[6] = 'I00I' //隐伏刺客
		set st_nightelf[7] = 'I01C' //精灵弓手
		set st_nightelf[8] = 'I01F' //树妖
		set st_nightelf[9] = 'I01D' //露娜
		set st_nightelf[10] = 'I01H' //投刃车
		set st_nightelf[11] = 'I01E' //角鹰弓骑士
		set st_nightelf[12] = 'I01K' //奇美拉
		set pricet_nightelf[1] = 10000
		set pricet_nightelf[2] = 4800
		set pricet_nightelf[3] = 3500
		set pricet_nightelf[4] = 1750
		set pricet_nightelf[5] = 160
		set pricet_nightelf[6] = 400
		set pricet_nightelf[7] = 230
		set pricet_nightelf[8] = 1000
		set pricet_nightelf[9] = 700
		set pricet_nightelf[10] = 2600
		set pricet_nightelf[11] = 800
		set pricet_nightelf[12] = 6250
		set stupgrade_nightelf[1] = 'I03P'
		set stupgrade_nightelf[2] = 'I03H'
		set stupgrade_nightelf[3] = 'I03I'
		set stupgrade_nightelf[4] = 'I03M'
		set stupgrade_nightelf[5] = 'I03K'
		set stupgrade_nightelf[6] = 'I03Q'
		set stupgrade_nightelf[7] = 'I03N'
		set stupgrade_nightelf[8] = 'I03L'
		set stupgrade_nightelf[9] = 'I03R'
		set stupgrade_nightelf[10] = 'I03J'
		set stupgrade_nightelf[11] = 'I03O'
		set stupgrade_nightelf[12] = 'I03G'
		set priceupgrade_nightelf[1] = 2000
		set priceupgrade_nightelf[2] = 960
		set priceupgrade_nightelf[3] = 800
		set priceupgrade_nightelf[4] = 350
		set priceupgrade_nightelf[5] = 32
		set priceupgrade_nightelf[6] = 80
		set priceupgrade_nightelf[7] = 46
		set priceupgrade_nightelf[8] = 200
		set priceupgrade_nightelf[9] = 140
		set priceupgrade_nightelf[10] = 520
		set priceupgrade_nightelf[11] = 160
		set priceupgrade_nightelf[12] = 1250
		set stu_nightelf[1] = 'n016'
		set stu_nightelf[2] = 'n015'
		set stu_nightelf[3] = 'n014'
		set stu_nightelf[4] = 'n013'
		set stu_nightelf[5] = 'n00W'
		set stu_nightelf[6] = 'n007'
		set stu_nightelf[7] = 'n010'
		set stu_nightelf[8] = 'n012'
		set stu_nightelf[9] = 'n00Z'
		set stu_nightelf[10] = 'n00X'
		set stu_nightelf[11] = 'n011'
		set stu_nightelf[12] = 'n00Y'

		//记录物品与兵种的对应关系
		set i = 1
		loop
			exitwhen i>12
			call setItemSType( st_human[i],stupgrade_human[i],pricet_human[i],priceupgrade_human[i],stu_human[i] )
			set i = i+1
		endloop
		set i = 1
		loop
			exitwhen i>12
			call setItemSType( st_orc[i],stupgrade_orc[i],pricet_orc[i],priceupgrade_orc[i],stu_orc[i] )
			set i = i+1
		endloop
		set i = 1
		loop
			exitwhen i>12
			call setItemSType( st_undead[i],stupgrade_undead[i],pricet_undead[i],priceupgrade_undead[i],stu_undead[i] )
			set i = i+1
		endloop
		set i = 1
		loop
			exitwhen i>12
			call setItemSType( st_nightelf[i],stupgrade_nightelf[i],pricet_nightelf[i],priceupgrade_nightelf[i],stu_nightelf[i] )
			set i = i+1
		endloop

		set Trigger_Building = CreateTrigger()

		call TriggerRegisterAnyUnitEventBJ( Trigger_Building, EVENT_PLAYER_UNIT_CONSTRUCT_FINISH )

		call TriggerAddAction(Trigger_Building,function thistype.triggerBuildingCall)

		call initPlayer()

		call startBattle()
		call centerGold()

		call htime.setInterval( 5.00 ,function thistype.attackDebug )
		call htime.setInterval( DEFAULT_UNGRADE_DURING ,function thistype.upgrade )
		call htime.setInterval( DEFAULT_CENTER_GOLD_DURING ,function thistype.centerGold )

		call htime.setInterval( 0.3 ,function thistype.warPlusGold )

	endmethod


endstruct

library m1ItemSkill requires m1Event

	//救世者条件
	public function itemJesusCondition takes nothing returns boolean
	    return ((GetUnitTypeId(GetFilterUnit()) ==  Unit_Tomb))
	endfunction

	//炸弹
	public function itemBombActions takes nothing returns nothing
	    local timer t = GetExpiredTimer()
	    local unit zhadan =  funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local real range = funcs_getTimerParams_Real( t , Key_Skill_Range )
	    local real hunt = funcs_getTimerParams_Real( t , Key_Skill_Hunt )
	    local location loc = GetUnitLoc(zhadan)
	    local group g = null
	    if( IsUnitAliveBJ(zhadan) == true ) then
	        set g = funcs_getGroupByPoint( loc , range , function filter_live )
	        call funcs_huntGroup( g, zhadan , hunt, Effect_Explosion, null , FILTER_ALL )
	        call funcs_effectPoint( Effect_NewGroundEX , loc )
	        call ExplodeUnitBJ( zhadan )
	        call GroupClear(g)
	        call DestroyGroup(g)
	    endif
	    call RemoveLocation(loc)
	    call funcs_delTimer( t ,null )
	endfunction

	/* 通用使用 */
	public function itemUse takes integer itTypeId , unit u , integer playerIndex returns nothing
		local location loc = null
		local unit createUnit = null
		local group whichGroup = null
		local timer t = null
		//TODO 药物
	    if (itTypeId == ITEM_life_water_lv2 ) then
		    //大生命药水
	        call attribute_changeAttribute(Tag_LifeBack,playerIndex,40,8.00)
	    elseif(itTypeId == ITEM_life_water_lv1 ) then
	    	//小生命药水
	        call attribute_changeAttribute(Tag_LifeBack,playerIndex,20,10.00)
	    elseif(itTypeId == ITEM_life_water_lv3) then
	    	//超生命药水
	        call attribute_changeAttribute(Tag_LifeBack,playerIndex,100,6.00)
	    elseif (itTypeId == ITEM_mana_water_lv2 ) then
	    	//大魔法药水
	        call attribute_changeAttribute(Tag_ManaBack,playerIndex,50,5.00)
	    elseif(itTypeId == ITEM_mana_water_lv1) then
	    	//小魔法药水
	        call attribute_changeAttribute(Tag_ManaBack,playerIndex,30,6.00)
	    elseif(itTypeId == ITEM_mana_water_lv3) then
	    	//超魔法药水
	        call attribute_changeAttribute(Tag_ManaBack,playerIndex,80,4.00)
	    elseif(itTypeId == ITEM_isee ) then
	    	//督视猫头鹰
	        set loc = GetUnitLoc(u)
	        set createUnit = funcs_createUnitFacing( GetOwningPlayer(u) , 'n039'  , loc , GetRandomReal(0,360))
	        call funcs_setUnitLife(createUnit,100.00)
	        call RemoveLocation(loc)
	    endif
	    //TODO 一般装备
	    if(itTypeId == ITEM_fly_boot) then
		     //飞靴
	        call attribute_changeAttribute(Tag_Move,playerIndex,50,5.00)
	        call attribute_changeAttribute(Tag_Avoid,playerIndex,300,5.00)
	    elseif(itTypeId == ITEM_leather_armor_born) then
	    	//邪骨甲
	        call attribute_changeAttribute(Tag_Toughness,playerIndex,50,10.00)
	    elseif(itTypeId == ITEM_tank_boot) then
	    	//先锋靴
	        call attribute_changeAttribute(Tag_Defend,playerIndex,10,5.00)
	        call attribute_changeAttribute(Tag_LifeBack,playerIndex,15,5.00)
	    elseif(itTypeId == ITEM_crystal_boot) then
	    	//冰魔靴
	        call attribute_changeAttribute(Tag_ManaBack,playerIndex,30,15.00)
	    elseif(itTypeId == ITEM_ghost_hell) then
	    	//鬼堕狱
	        call attribute_changeAttribute(Tag_Attack,playerIndex,300,10.00)
	        call attribute_changeAttribute(Tag_Hemophagia,playerIndex,20,10.00)
	    elseif(itTypeId == ITEM_ghost_hammer) then
	    	//食人鬼巨锤
	        call attribute_changeAttribute(Tag_Attack,playerIndex,75,10.00)
	    elseif(itTypeId == ITEM_bloodiness_spear) then
	    	//血枪
	        call attribute_changeAttribute(Tag_Hemophagia,playerIndex,35,10.00)
	    elseif(itTypeId == ITEM_fire_axe_crazy) then
	    	//狂焚
	        call attribute_changeAttribute(Tag_Split,playerIndex,30,10.00)
	    elseif(itTypeId == ITEM_wind_dagger) then
	    	//疾风之刃
	        call attribute_changeAttribute(Tag_AttackSpeed,playerIndex,150,10.00)
	    elseif(itTypeId == ITEM_tank_shield) then
	    	//先锋盾
	        call attribute_changeAttribute(Tag_Defend,playerIndex,15,8.00)
	    elseif(itTypeId == ITEM_ghoul_gloves) then
	    	//食人鬼手套
	        call attribute_changeAttribute(Tag_Attack,playerIndex,50,10.00)
	    elseif(itTypeId == ITEM_spear) then
	    	//钢枪
	        call attribute_changeAttribute(Tag_Hemophagia,playerIndex,30,10.00)
	    elseif( itTypeId == ITEM_saviour ) then
	    	//救世者
	        set whichGroup = GetUnitsInRectMatching(GetPlayableMapRect(), Condition(function itemJesusCondition))
	        if(not skills_jumpRamdomUnit(u,whichGroup,true)) then
	            call funcs_printTo(GetOwningPlayer(u),"没有碑塔目标")
	        else
	            call funcs_soundPlay(gg_snd_WispEntangleMine01,u)
	            set loc = GetUnitLoc(u)
	            call funcs_effectPoint( "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl",loc )
	            call RemoveLocation(loc)
	        endif
	        set whichGroup = null
        endif
	    //TODO 神秘
	    if(itTypeId == ITEM_mysterious_assassin_role) then
		    //刺客信条
	        call attribute_changeAttribute(Tag_Attack,playerIndex,150,10.00)
	    elseif(itTypeId == ITEM_mysterious_god_tree) then
	    	//神木
	        set loc = GetUnitLoc(u)
	        set createUnit = funcs_createUnitFacing( GetOwningPlayer(u) , 'u00L'  , loc , GetRandomReal(0,360))
	        call funcs_setUnitLife(createUnit, 30.00)
	        call SetUnitVertexColorBJ( createUnit , 100, 100, 100, 70.00 )
	        call RemoveLocation(loc)
	    elseif(itTypeId == ITEM_mysterious_power_totem) then
	    	//蛮力图腾
	        call attribute_changeAttribute(Tag_Knocking,playerIndex , Attr_Power[playerIndex] , 20.00)
	    endif
	endfunction

endlibrary

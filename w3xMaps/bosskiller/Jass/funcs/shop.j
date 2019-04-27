
library shop requires items

	/**
	 * 马甲同步英雄物品栏
	 */
	private function tokenSynchronization2Hero takes integer index returns nothing
		local integer i = 0
		local integer itemId = 0
		local integer itemCharges = 1
		local item it = null
		local unit token = Shop_tokens[index]
		local unit hero = Player_heros[index]
        set i = 0
        loop
	        exitwhen i > 5
	        	call RemoveItem( UnitItemInSlot(token, i) )
	        	if( UnitItemInSlot(hero, i) != null ) then
		        	set itemId = GetItemTypeId(UnitItemInSlot(hero, i))
	        		set itemCharges = GetItemCharges(UnitItemInSlot(hero, i))
					call UnitAddItemToSlotById( token , itemId , i )
					set it = UnitItemInSlot(token, i)
					call SetItemCharges( it , itemCharges )
	        	endif
	        set i = i + 1
    	endloop
	endfunction

	/**
	 * 切换商店Action
	 */
	private function shop_shiftAction takes nothing returns nothing
		local integer itTypeId = GetItemTypeId( GetSoldItem() )
		local unit triggerUnit = GetBuyingUnit()
		local player triggerPlayer = GetOwningPlayer(triggerUnit)
		local integer index = GetConvertedPlayerId(triggerPlayer)
		local unit chooseUnit = null
		if( itTypeId == Shop_Item_baoshishangren ) then
			set chooseUnit = Shop_Unit_baoshishangren
		elseif( itTypeId == Shop_Item_zahuodian ) then
			set chooseUnit = Shop_Unit_zahuodian
		elseif( itTypeId == Shop_Item_shujingxiaofan ) then
			set chooseUnit = Shop_Unit_shujingxiaofan
		elseif( itTypeId == Shop_Item_wuqimofang ) then
			set chooseUnit = Shop_Unit_wuqimofang
		elseif( itTypeId == Shop_Item_lieshouren ) then
			set chooseUnit = Shop_Unit_lieshouren
		elseif( itTypeId == Shop_Item_shenmodaoshikanong ) then
			set chooseUnit = Shop_Unit_shenmodaoshikanong
		elseif( itTypeId == Shop_Item_hanwu ) then
			set chooseUnit = Shop_Unit_hanwu
		elseif( itTypeId == Shop_Item_duanzaojianhaosilisi ) then
			set chooseUnit = Shop_Unit_duanzaojianhaosilisi
		elseif( itTypeId == Shop_Item_fangjuwu ) then
			set chooseUnit = Shop_Unit_fangjuwu
		elseif( itTypeId == Shop_Item_cangbaoge ) then
			set chooseUnit = Shop_Unit_cangbaoge
		elseif( itTypeId == Shop_Item_heishi ) then
			set chooseUnit = Shop_Unit_heishi[index]
		endif
		if(chooseUnit != null ) then
			set Shop_system_esc_status[index] = Shop_esc_status_chooes
			call SelectUnitForPlayerSingle( chooseUnit , triggerPlayer )
		endif

	endfunction

	/**
	 * 商店售卖商品Action
	 */
	private function shop_sell_itemAction takes nothing returns nothing
		local item it = GetSoldItem()
	    local integer itTypeId = GetItemTypeId( it )
	    local integer itemId = items_getItemIdByReelId(itTypeId)
	    local integer itemCharges = GetItemCharges( it )
	    local integer itemGold = items_getGoldByItemId( itemId )
	    local integer itemLumber = items_getLumberByItemId( itemId )
	    local integer itemTotalGold = itemGold * itemCharges
	    local integer itemTotalLumber = itemLumber * itemCharges
	    local unit seller = GetTriggerUnit()
	    local unit buyer = GetBuyingUnit()
	    local player witchPlayer = GetOwningPlayer( buyer )
	    local integer playerGold = funcs_getGold(witchPlayer)
	    local integer playerLumber = funcs_getLumber(witchPlayer)
	    local boolean canBuy = true
	    local integer index = GetConvertedPlayerId(witchPlayer)
	    local integer i = 0

		if( GetItemType(it) == ITEM_TYPE_ARTIFACT ) then
		    if( playerGold < itemTotalGold ) then
		        set canBuy = false
		        call funcs_floatMsg("|cffffcc00金币不够啦~|r"  , Player_heros[index] )
		    endif
		    if( playerLumber < itemTotalLumber ) then
		        set canBuy = false
		        call funcs_floatMsg("|cffffcc00斗魂水晶不够啦~|r"  , Player_heros[index] )
		    endif
		    if( canBuy==false ) then
		        call RemoveItem( it )
		    else
		        call funcs_addGold( witchPlayer , 0-itemTotalGold )
		        call funcs_addLumber( witchPlayer , 0-itemTotalLumber )
		        if( GetUnitTypeId( buyer ) == Shop_token ) then
			        call RemoveItem( it )											//删除真实物品
			        call UnitAddItemByIdSwapped( itTypeId , Player_heros[index] )	//虚拟一个同类物品给英雄
			        call tokenSynchronization2Hero(index)							//同步马甲英雄
		        endif
		    endif
		endif
	endfunction

	/**
	 * 单位召唤商店Action
	 */
	private function shop_chooseAction takes nothing returns nothing
		local unit triggerUnit = GetTriggerUnit()
		local player triggerPlayer = GetOwningPlayer(triggerUnit)
		local integer index = GetConvertedPlayerId(triggerPlayer)
		local integer openId = GetSpellAbilityId()
		if( Shop_system_hero_isInit[index] == false ) then
			set Shop_system_hero_isInit[index] = true
			call TriggerRegisterPlayerEventEndCinematic( shop_esc_trigger , triggerPlayer )	//注册ESC按键
			call TriggerRegisterPlayerSelectionEventBJ( shop_choose_unit_trigger , triggerPlayer,true )	//注册选择单位复位
		endif
		if( openId == Shop_system_open ) then
			set Shop_system_esc_status[index] = Shop_esc_status_open
			call tokenSynchronization2Hero(index)	//同步马甲英雄
			call SelectUnitForPlayerSingle( Shop_Unit_grey_forest , triggerPlayer )
		endif
	endfunction


	//TODO 黑市
	private function shop_set_item_dark_market takes integer playerIndex , integer step returns nothing
		local integer currentPage = LoadInteger( HASH_Player , 1523 , playerIndex )
		local unit darkMarket = Shop_Unit_heishi[playerIndex]
		local integer firstPageNum = 1
		local integer endPageNum = items_getMixPageNum( 10 )
		local integer nextPage = currentPage+step
		local integer i = 0
		local integer ii = 0
		if( nextPage < 1 ) then
			set nextPage = endPageNum
		elseif( nextPage > endPageNum ) then
			set nextPage = 1
		endif

		//删除旧货
		set i = (currentPage-1) * 100 + 10
		set ii= currentPage * 100 + 10
		loop
            exitwhen (i >= ii or ITEM_MIX[i] <= 0 or i<0)
				call RemoveItemFromStockBJ( ITEM_MIX[i] , darkMarket )
            set i = i + 10
        endloop

        //加入新货
		set i = (nextPage-1) * 100 + 10
		set ii= nextPage * 100 + 10
		loop
            exitwhen (i >= ii or ITEM_MIX[i] <= 0 or i<0)
				call AddItemToStockBJ( ITEM_MIX[i] , darkMarket , 0, 1 )
            set i = i + 10
        endloop
		call SaveInteger( HASH_Player , 1523 , playerIndex , nextPage )
	endfunction

	/**
	 * 商店售卖商品Action ( 黑市 )
	 */
	private function shop_sell_item_dark_marketAction takes nothing returns nothing
		local item it = GetSoldItem()
	    local integer itTypeId = GetItemTypeId( it )
	    local integer itemId = items_getItemIdByReelId(itTypeId)
	    local integer itemCharges = GetItemCharges( it )
	    local integer itemGold = items_getGoldByItemId( itemId )
	    local integer itemLumber = items_getLumberByItemId( itemId )
	    local integer itemTotalGold = itemGold * itemCharges * 10
	    local integer itemTotalLumber = itemLumber * itemCharges * 10
	    local unit seller = GetTriggerUnit()
	    local unit buyer = GetBuyingUnit()
	    local player witchPlayer = GetOwningPlayer( buyer )
	    local integer playerGold = funcs_getGold(witchPlayer)
	    local integer playerLumber = funcs_getLumber(witchPlayer)
	    local boolean canBuy = true
	    local integer index = GetConvertedPlayerId(witchPlayer)
	    local integer i = 0
	    if( GetItemType(it) == ITEM_TYPE_POWERUP ) then
		    if( itTypeId == Shop_Page_heishi_prev ) then
			    call shop_set_item_dark_market (index , -1 )
			elseif( itTypeId == Shop_Page_heishi_next ) then
				call shop_set_item_dark_market (index , 1 )
		    endif
		elseif( GetItemType(it) == ITEM_TYPE_ARTIFACT ) then
			//100W debug
			if( itemTotalGold > 1000000 )then
				set itemTotalGold = 1000000
			endif
		    if( playerGold < itemTotalGold ) then
		        set canBuy = false
		        call funcs_floatMsg("|cffffcc00黑市欢迎有钱人!|r"  , Player_heros[index] )
		    endif
		    if( playerLumber < itemTotalLumber ) then
		        set canBuy = false
		        call funcs_floatMsg("|cffffcc00没水晶也敢逛黑市?|r"  , Player_heros[index] )
		    endif
		    if( canBuy==false ) then
		        call RemoveItem( it )
		    else
		    	if( itemTotalGold >= 1000000 )then
		    		call funcs_floatMsg("|cffff0000获得百万神器！!|r"  , Player_heros[index] )
		    	else
		    		call funcs_floatMsg("|cffff0000谢谢土豪，欢迎再来！|r"  , Player_heros[index] )
		    	endif
		        call funcs_addGold( witchPlayer , 0-itemTotalGold )
		        call funcs_addLumber( witchPlayer , 0-itemTotalLumber )
		        if( GetUnitTypeId( buyer ) == Shop_token ) then
			        call RemoveItem( it )											//删除真实物品
			        call UnitAddItemByIdSwapped( itTypeId , Player_heros[index] )	//虚拟一个同类物品给英雄
			        call tokenSynchronization2Hero(index)							//同步马甲英雄
		        endif
		    endif
		endif
	endfunction

	/**
	 * 商店售卖商品Action ( 导师 )
	 */
	private function shop_sell_item_teacherAction takes nothing returns nothing
		local item it = GetSoldItem()
	    local integer itTypeId = GetItemTypeId( it )
	    local string skillTag = ""
	    local integer skillId = 0
	    local integer skillIdBase = 0
	    local integer itemTotalGold = 0
	    local unit seller = GetTriggerUnit()
	    local player witchPlayer = GetOwningPlayer( GetBuyingUnit() )
	    local integer playerGold = funcs_getGold(witchPlayer)
	    local integer index = GetConvertedPlayerId(witchPlayer)
	    local unit hero = Player_heros[index]
	    local integer heroSkillLv = 0
	    local integer heroSkillLvMax = 20
	    local boolean isStudy = false
	    local integer i = 0
		if( itTypeId == ITEM_Talent_Eagle_Eye ) then
			set skillId = SPELL_Talent_Eagle_Eye
			set skillTag = "F"
		elseif( itTypeId == ITEM_Talent_Charge ) then
			set skillId = SPELL_Talent_Charge
			set skillTag = "F"
		elseif( itTypeId == ITEM_Talent_Jump ) then
			set skillId = SPELL_Talent_Jump
			set skillTag = "F"
		elseif( itTypeId == ITEM_Talent_Ghost_Walk ) then
			set skillId = SPELL_Talent_Ghost_Walk
			set skillTag = "F"
		elseif( itTypeId == ITEM_Talent_Heroic_Swordsmen ) then
			set skillId = SPELL_Talent_Heroic_Swordsmen
			set skillTag = "C"
		elseif( itTypeId == ITEM_Talent_Aim ) then
			set skillId = SPELL_Talent_Aim
			set skillTag = "C"
		elseif( itTypeId == ITEM_Talent_Aura_Leaf ) then
			set skillId = SPELL_Talent_Aura_Leaf
			set skillTag = "C"
		elseif( itTypeId == ITEM_Talent_Source_Vitality ) then
			set skillId = SPELL_Talent_Source_Vitality
			set skillTag = "C"
		elseif( itTypeId == ITEM_Talent_Hepatoenteral_Fracture ) then
			set skillId = SPELL_Talent_Hepatoenteral_Fracture
			set skillTag = "V"
		elseif( itTypeId == ITEM_Talent_Holy_Sword ) then
			set skillId = SPELL_Talent_Holy_Sword
			set skillTag = "V"
		elseif( itTypeId == ITEM_Talent_Crusade ) then
			set skillId = SPELL_Talent_Crusade
			set skillTag = "V"
		elseif( itTypeId == ITEM_Talent_Snow_Frost ) then
			set skillId = SPELL_Talent_Snow_Frost
			set skillTag = "V"
		endif
		if( skillId <= 0 ) then
			return
		endif
		if( skillTag == "F" ) then
			set skillIdBase = SPELL_Talent_F
		elseif( skillTag == "C" ) then
			set skillIdBase = SPELL_Talent_C
		elseif( skillTag == "V" ) then
			set skillIdBase = SPELL_Talent_V
		endif
		//--
		set itemTotalGold = 2500
		if( GetUnitAbilityLevel( hero , skillIdBase ) > 0 ) then
			if( itemTotalGold > playerGold ) then
				call funcs_floatMsg("|cffffcc00学习天赋需要 "+I2S(itemTotalGold)+" 金币|r"  , Player_heros[index] )
			else
				call UnitRemoveAbility( hero , skillIdBase )
				call UnitAddAbility( hero , skillId )
				call UnitMakeAbilityPermanent( hero , true, skillId )
				call funcs_addGold( witchPlayer , 0-itemTotalGold )
				call funcs_printTo( witchPlayer , "你学习了|cffffcc00"+GetAbilityName(skillId)+"|r天赋!" )
				if( skillTag == "F" ) then
					set SPELL_Talent_F_isLearn[index] = true
				elseif( skillTag == "C" ) then
					set SPELL_Talent_C_isLearn[index] = true
				elseif( skillTag == "V" ) then
					set SPELL_Talent_V_isLearn[index] = true
				endif
				set isStudy = true
			endif
		else
			set heroSkillLv = GetUnitAbilityLevel( hero , skillId )
			set itemTotalGold = 2500 + heroSkillLv * 2500
			if( itemTotalGold > playerGold ) then
				call funcs_floatMsg("|cffffcc00升级天赋需要 "+I2S(itemTotalGold)+" 金币|r"  , Player_heros[index] )
			else
				if( heroSkillLv <= 0 ) then
					call funcs_printTo( witchPlayer , "|cffc0c0c0你已经选择了其他天赋!|r" )
				elseif( heroSkillLv >= heroSkillLvMax ) then
					call funcs_printTo( witchPlayer , "|cff80ffff此天赋已惊人!|r" )
				else
					call SetUnitAbilityLevel( hero , skillId , heroSkillLv+1 )
					call funcs_addGold( witchPlayer , 0-itemTotalGold )
					call funcs_printTo( witchPlayer , "你升级了|cffffcc00"+GetAbilityName(skillId)+"|r天赋!("+I2S(heroSkillLv+1)+")" )
					set isStudy = true
				endif
			endif
		endif
		if( isStudy == true ) then
			if( itTypeId == ITEM_Talent_Heroic_Swordsmen ) then
				set Attr_Dynamic_Attack[index] = Attr_Dynamic_Attack[index] + 22
				set Attr_Dynamic_AttackSpeed[index] = Attr_Dynamic_AttackSpeed[index] + 7
			elseif( itTypeId == ITEM_Talent_Aim ) then
				set Attr_Dynamic_Knocking[index] = Attr_Dynamic_Knocking[index] + 225
				set Attr_Dynamic_Hemophagia[index] = Attr_Dynamic_Hemophagia[index] + 10
			elseif( itTypeId == ITEM_Talent_Aura_Leaf ) then
				set Attr_Dynamic_SkillDamage[index] = Attr_Dynamic_SkillDamage[index] + 550
			elseif( itTypeId == ITEM_Talent_Source_Vitality ) then
				set Attr_Dynamic_Life[index] = Attr_Dynamic_Life[index] + 250
				set Attr_Dynamic_LifeBack[index] = Attr_Dynamic_LifeBack[index] + 15
			elseif( itTypeId == ITEM_Talent_Hepatoenteral_Fracture ) then
				set Attr_Dynamic_Life[index] = Attr_Dynamic_Life[index] - 200
				set Attr_Dynamic_LifeBack[index] = Attr_Dynamic_LifeBack[index] - 7
				set Attr_Dynamic_Attack[index] = Attr_Dynamic_Attack[index] + 45
				set Attr_Dynamic_Hemophagia[index] = Attr_Dynamic_Hemophagia[index] + 15
			elseif( itTypeId == ITEM_Talent_Holy_Sword ) then
				set Attr_Dynamic_Power[index] = Attr_Dynamic_Power[index] + 12
				set Attr_Dynamic_Toughness[index] = Attr_Dynamic_Toughness[index] + 10
				set Attr_Dynamic_Defend[index] = Attr_Dynamic_Defend[index] + 2
			elseif( itTypeId == ITEM_Talent_Crusade ) then
				set Attr_Dynamic_PunishFull[index] = Attr_Dynamic_PunishFull[index] + 500
				set Attr_Dynamic_Defend[index] = Attr_Dynamic_Defend[index] + 3
				set Attr_Dynamic_Avoid[index] = Attr_Dynamic_Avoid[index] + 175
			elseif( itTypeId == ITEM_Talent_Snow_Frost ) then
				set Attr_Dynamic_Skill[index] = Attr_Dynamic_Skill[index] + 10
				set Attr_Dynamic_Violence[index] = Attr_Dynamic_Violence[index] + 300
			endif
			call attribute_calculateOne(index)
		endif
	endfunction





	/**
	 * 玩家商店ESC按键切换
	 */
	private function shop_escAction takes nothing returns nothing
		local player whichPlayer = GetTriggerPlayer()
		local integer index = GetConvertedPlayerId(whichPlayer)
		if( Shop_system_esc_status[index] == Shop_esc_status_chooes ) then
			set Shop_system_esc_status[index] = Shop_esc_status_open
			call SelectUnitForPlayerSingle( Shop_Unit_grey_forest , whichPlayer )
		elseif( Shop_system_esc_status[index] == Shop_esc_status_open ) then
			set Shop_system_esc_status[index] = Shop_esc_status_close
			call SelectUnitForPlayerSingle( Player_heros[index] , whichPlayer )
		endif
	endfunction

	/**
	 * 玩家选择单位退出商城
	 */
	private function shop_choose_unitAction takes nothing returns nothing
		local player whichPlayer = GetTriggerPlayer()
		local integer index = GetConvertedPlayerId(whichPlayer)
		if( IsUnitInGroup( GetTriggerUnit(), Shop_Group ) == false ) then
			set Shop_system_esc_status[index] = Shop_esc_status_close
		endif
	endfunction

	//初始化
	public function init takes nothing returns nothing

		local integer i = 0

		local trigger shop_shift_trigger = CreateTrigger()					//商店切换触发
		local trigger shop_choose_trigger = CreateTrigger()					//商店选择触发
		local trigger shop_sell_item_trigger = CreateTrigger()				//商店售卖触发
		local trigger shop_sell_item_dark_market_trigger = CreateTrigger()	//黑市商店售卖触发（10倍）
		local trigger shop_sell_item_teacher_trigger = CreateTrigger()		//导师商店售卖触发

		call TriggerAddAction( shop_shift_trigger , function shop_shiftAction )
		call TriggerAddAction( shop_choose_trigger , function shop_chooseAction )
		call TriggerAddAction( shop_esc_trigger , function shop_escAction )
		call TriggerAddAction( shop_choose_unit_trigger , function shop_choose_unitAction )
		call TriggerAddAction( shop_sell_item_trigger , function shop_sell_itemAction )
		call TriggerAddAction( shop_sell_item_dark_market_trigger , function shop_sell_item_dark_marketAction )
		call TriggerAddAction( shop_sell_item_teacher_trigger , function shop_sell_item_teacherAction )

		//创建商店
		set Shop_Unit_grey_forest = CreateUnitAtLoc( Player_Ally_Building , Shop_grey_forest , Center_Shop , bj_UNIT_FACING )
	    set Shop_Unit_baoshishangren = CreateUnitAtLoc( Player_Ally_Building , Shop_baoshishangren , Center_Shop , bj_UNIT_FACING )
	    set Shop_Unit_zahuodian = CreateUnitAtLoc( Player_Ally_Building , Shop_zahuodian , Center_Shop , bj_UNIT_FACING )
	    set Shop_Unit_shujingxiaofan = CreateUnitAtLoc( Player_Ally_Building , Shop_shujingxiaofan , Center_Shop , bj_UNIT_FACING )
	    set Shop_Unit_wuqimofang = CreateUnitAtLoc( Player_Ally_Building , Shop_wuqimofang , Center_Shop , bj_UNIT_FACING )
	    set Shop_Unit_lieshouren = CreateUnitAtLoc( Player_Ally_Building , Shop_lieshouren , Center_Shop , bj_UNIT_FACING )
	    set Shop_Unit_shenmodaoshikanong = CreateUnitAtLoc( Player_Ally_Building , Shop_shenmodaoshikanong , Center_Shop , bj_UNIT_FACING )
	    set Shop_Unit_hanwu = CreateUnitAtLoc( Player_Ally_Building , Shop_hanwu , Center_Shop , bj_UNIT_FACING )
	    set Shop_Unit_duanzaojianhaosilisi = CreateUnitAtLoc( Player_Ally_Building , Shop_duanzaojianhaosilisi , Center_Shop , bj_UNIT_FACING )
	    set Shop_Unit_fangjuwu = CreateUnitAtLoc( Player_Ally_Building , Shop_fangjuwu , Center_Shop , bj_UNIT_FACING )
	    set Shop_Unit_cangbaoge = CreateUnitAtLoc( Player_Ally_Building , Shop_cangbaoge , Center_Shop , bj_UNIT_FACING )
	    set i = 1
	    loop
		    exitwhen i > Max_Player_num
		    	set Shop_tokens[i] = CreateUnitAtLoc( Players[i] , Shop_token , Center_Shop , bj_UNIT_FACING )
	    	set i = i + 1
	    endloop
	    call GroupAddUnit( Shop_Group , Shop_Unit_grey_forest )
	    call GroupAddUnit( Shop_Group , Shop_Unit_baoshishangren )
	    call GroupAddUnit( Shop_Group , Shop_Unit_zahuodian )
	    call GroupAddUnit( Shop_Group , Shop_Unit_shujingxiaofan )
	    call GroupAddUnit( Shop_Group , Shop_Unit_wuqimofang )
	    call GroupAddUnit( Shop_Group , Shop_Unit_lieshouren )
	    call GroupAddUnit( Shop_Group , Shop_Unit_shenmodaoshikanong )
	    call GroupAddUnit( Shop_Group , Shop_Unit_hanwu )
	    call GroupAddUnit( Shop_Group , Shop_Unit_duanzaojianhaosilisi )
	    call GroupAddUnit( Shop_Group , Shop_Unit_fangjuwu )
	    call GroupAddUnit( Shop_Group , Shop_Unit_cangbaoge )

		//商店切换触发
		call TriggerRegisterUnitEvent( shop_shift_trigger , Shop_Unit_grey_forest , EVENT_UNIT_SELL_ITEM )

		//商店售卖触发
	    call TriggerRegisterUnitEvent( shop_sell_item_trigger , Shop_Unit_baoshishangren , EVENT_UNIT_SELL_ITEM )
	    call TriggerRegisterUnitEvent( shop_sell_item_trigger , Shop_Unit_zahuodian , EVENT_UNIT_SELL_ITEM )
	    call TriggerRegisterUnitEvent( shop_sell_item_trigger , Shop_Unit_shujingxiaofan , EVENT_UNIT_SELL_ITEM )
	    call TriggerRegisterUnitEvent( shop_sell_item_trigger , Shop_Unit_wuqimofang , EVENT_UNIT_SELL_ITEM )
	    call TriggerRegisterUnitEvent( shop_sell_item_trigger , Shop_Unit_lieshouren , EVENT_UNIT_SELL_ITEM )
	    call TriggerRegisterUnitEvent( shop_sell_item_teacher_trigger , Shop_Unit_shenmodaoshikanong , EVENT_UNIT_SELL_ITEM )
	    call TriggerRegisterUnitEvent( shop_sell_item_trigger , Shop_Unit_hanwu , EVENT_UNIT_SELL_ITEM )
	    call TriggerRegisterUnitEvent( shop_sell_item_trigger , Shop_Unit_duanzaojianhaosilisi , EVENT_UNIT_SELL_ITEM )
	    call TriggerRegisterUnitEvent( shop_sell_item_trigger , Shop_Unit_fangjuwu , EVENT_UNIT_SELL_ITEM )
	    call TriggerRegisterUnitEvent( shop_sell_item_trigger , Shop_Unit_cangbaoge , EVENT_UNIT_SELL_ITEM )

	    //商店选择触发
	    call TriggerRegisterAnyUnitEventBJ( shop_choose_trigger , EVENT_PLAYER_UNIT_SPELL_CHANNEL )

	    //TODO 黑市 - SP
		set i = 1
	    loop
		    exitwhen i > Max_Player_num
		    	if ((GetPlayerController(Players[i]) == MAP_CONTROL_USER) and (GetPlayerSlotState(Players[i]) == PLAYER_SLOT_STATE_PLAYING)) then
			    	set Shop_Unit_heishi[i] = CreateUnitAtLoc( Players[i] , Shop_heishi , Center_Shop , bj_UNIT_FACING )
			    	call shop_set_item_dark_market( i , 1 )
		    		call GroupAddUnit( Shop_Group , Shop_Unit_heishi[i] )
		    		call TriggerRegisterUnitEvent( shop_sell_item_dark_market_trigger , Shop_Unit_heishi[i] , EVENT_UNIT_SELL_ITEM )
	    		endif
	    	set i = i + 1
	    endloop

	endfunction

endlibrary

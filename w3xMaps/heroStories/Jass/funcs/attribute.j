globals
    integer Key_Attr_Tag = 0
    integer Key_Attr_Index = 1
    integer Key_Attr_Data = 2

    //默认攻击速度，除以100等于各个英雄的初始速度，用于计算攻击速度显示文本
    integer Attribute_Default_AttackSpeed = 150

    hashtable HASH_Attribute	//属性哈希表
    boolean array Attribute_ISCD

endglobals

library attribute requires items

    /**
     * 漂浮文字 - 重设置
     *  ttg 漂浮文字
     *  u 某单位
     *  textSize 字体大小
     */
    public function punishTexttagReSet takes integer index , string msg, real textSize returns nothing
        if( Player_heros[index] == null and SKILL_PUNISH_texttag[index] != null) then
            set SKILL_PUNISH_texttag[index] = null
        else
            call SetTextTagTextBJ( SKILL_PUNISH_texttag[index] , msg , textSize )
        endif
    endfunction

	/**
	 * 设置硬直漂浮字
	 */
    private function punishTexttag takes integer index , real val ,real limit returns nothing
		local string ttgStr = ""
		local real percent = 0
		local integer block = 0
		local integer blockMax = 25
		local real textSize = 5.00
		local real textZOffset = TEXTTAG_HEIGHT_Lv1
		local real textOpacity = 0.10
		local real textXOffset = -(textSize*blockMax*0.5)
		local string font = "■"
		local integer i = 0
        //计算字符串
        if( limit > 0 ) then
            set percent = val * 100 / limit
            set block = R2I(percent / I2R(100/blockMax))
            if( val >= limit ) then
                set block = blockMax
            endif
            set i = 1
            loop
                exitwhen i > blockMax
                    if( i <= block ) then
                        set ttgStr = ttgStr + "|cffffff80"+font+"|r"
                    else
                        set ttgStr = ttgStr + "|cff000000"+font+"|r"
                    endif
                set i = i + 1
            endloop
        endif
        if( Player_heros[index] != null and SKILL_PUNISH_texttag[index] == null ) then
            set SKILL_PUNISH_texttag[index] = funcs_floatMsgWithSizeAutoBind( ttgStr , Player_heros[index] , textSize , textZOffset , textOpacity , textXOffset )
        else
            call punishTexttagReSet( index , ttgStr , textSize )
        endif
	endfunction

    /**
     * 刷新属性文本
     */
    public function freshStr takes integer playerIndex returns nothing
        local string color_normal   = "|cffffffff"
        local string color_add      = "|cff80ff80"
        local string color_reduce   = "|cffff6060"
        local string color_head
        local string color_tail     = "|r"
        local string tempStr

        if(Attr_Dynamic_Life[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Life[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Life[playerIndex] = color_head + I2S(Attr_Life[playerIndex]) + color_tail

        if(Attr_Dynamic_Mana[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Mana[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Mana[playerIndex] = color_head + I2S(Attr_Mana[playerIndex])+ color_tail

        if(Attr_Dynamic_LifeBack[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_LifeBack[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_LifeBack[playerIndex]      = color_head + R2S(Attr_LifeBack[playerIndex])                                      + color_tail

        if(Attr_Dynamic_ManaBack[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_ManaBack[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_ManaBack[playerIndex]      = color_head + R2S(Attr_ManaBack[playerIndex])                                        + color_tail

        if(Attr_Dynamic_Power[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Power[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Power[playerIndex]         = color_head + I2S(Attr_Power[playerIndex])                                                 + color_tail

        if(Attr_Dynamic_Quick[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Quick[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Quick[playerIndex]         = color_head + I2S(Attr_Quick[playerIndex])                                                 + color_tail

        if(Attr_Dynamic_Skill[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Skill[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Skill[playerIndex]         = color_head + I2S(Attr_Skill[playerIndex])                                                 + color_tail

        if(Attr_Dynamic_SkillDamage[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_SkillDamage[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_SkillDamage[playerIndex]   = color_head + I2S(Attr_SkillDamage[playerIndex])                                           + color_tail

        if(Attr_Dynamic_Move[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Move[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Move[playerIndex]          = color_head + I2S(Attr_Move[playerIndex])                                                  + color_tail

        if(Attr_Dynamic_Defend[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Defend[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Defend[playerIndex]        = color_head + I2S(Attr_Defend[playerIndex])                                                + color_tail

        if(Attr_Dynamic_Attack[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Attack[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Attack[playerIndex]        = color_head + I2S(Attr_Attack[playerIndex])                                                + color_tail

		if(Attr_AttackSpeed[playerIndex]<0)then
            set color_head = color_reduce
            set tempStr = color_head+R2S( Attribute_Default_AttackSpeed / (100+Attr_AttackSpeed[playerIndex]))+ color_tail
        elseif(Attr_Dynamic_AttackSpeed[playerIndex]<0)then
            set color_head = color_reduce
            set tempStr = color_head+R2S( Attribute_Default_AttackSpeed / (100+Attr_AttackSpeed[playerIndex]))+ color_tail
        elseif(Attr_Dynamic_AttackSpeed[playerIndex]>0)then
            set color_head = color_add
            set tempStr = color_head+R2S( Attribute_Default_AttackSpeed / (100+Attr_AttackSpeed[playerIndex]))+ color_tail
        else
            set color_head = color_normal
            set tempStr = color_head+R2S( Attribute_Default_AttackSpeed / (100+Attr_AttackSpeed[playerIndex]))+ color_tail
        endif
        set Attr_Str_AttackSpeed[playerIndex] = tempStr

        if(Attr_Dynamic_Toughness[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Toughness[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Toughness[playerIndex]     = color_head + R2S(Attr_Toughness[playerIndex])                                             + color_tail

        if(Attr_Dynamic_Avoid[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Avoid[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Avoid[playerIndex]         = color_head + I2S(Attr_Avoid[playerIndex])                                                 + color_tail

        if(Attr_Dynamic_Knocking[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Knocking[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Knocking[playerIndex]      = color_head + I2S(Attr_Knocking[playerIndex])                                              + color_tail

        if(Attr_Dynamic_Violence[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Violence[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Violence[playerIndex]      = color_head + I2S(Attr_Violence[playerIndex])                                              + color_tail

        if(Attr_Dynamic_PunishFull[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_PunishFull[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Punish[playerIndex]        = color_head +I2S(Attr_PunishFull[playerIndex])   + color_tail

        if(Attr_Dynamic_Help[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Help[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Help[playerIndex]          = color_head + I2S(Attr_Help[playerIndex])                                                  + color_tail

        if(Attr_Dynamic_Hemophagia[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Hemophagia[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Hemophagia[playerIndex] = color_head + I2S(Attr_Hemophagia[playerIndex]) + color_tail

        if(Attr_Dynamic_Split[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Split[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Split[playerIndex] = color_head + I2S(Attr_Split[playerIndex]) + color_tail

        if(Attr_Dynamic_Weight[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_Weight[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_Weight[playerIndex] = color_head + R2S(Attr_WeightCurrent[playerIndex])+"/"+R2S(Attr_Weight[playerIndex])  + color_tail

        if(Attr_Dynamic_GoldRatio[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_GoldRatio[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_GoldRatio[playerIndex] = color_head + I2S(R2I(Attr_GoldRatio[playerIndex])) + color_tail

        if(Attr_Dynamic_LumberRatio[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_LumberRatio[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_LumberRatio[playerIndex] = color_head + I2S(R2I(Attr_LumberRatio[playerIndex])) + color_tail

        if(Attr_Dynamic_ExpRatio[playerIndex]>0)then
            set color_head = color_add
        elseif(Attr_Dynamic_ExpRatio[playerIndex]<0)then
            set color_head = color_reduce
        else
            set color_head = color_normal
        endif
        set Attr_Str_ExpRatio[playerIndex] = color_head + I2S(R2I(Attr_ExpRatio[playerIndex])) + color_tail

        call punishTexttag ( playerIndex , I2R(Attr_PunishCurrent[playerIndex]) , I2R(Attr_PunishFull[playerIndex]) )

    endfunction

    private function calculateOneBase takes integer playerIndex returns nothing
    	local integer i
        local item it        //缓存物品
        local integer itId      //缓存物品类型ID
        local integer itCharges //缓存物品使用次数
        local unit hero = Player_heros[playerIndex]
        local integer strength
        local integer agility
        local integer intelligence

        local integer WhitePower
        local integer WhiteQuick
        local integer WhiteSkill

        local integer temp_life
        local integer temp_mana
        local integer temp_defend
        local integer temp_attack
        local real temp_attackSpeed
        local integer temp_power
        local integer temp_quick
        local integer temp_skill
        local integer qty = 0

        //0）debug
        if(hero == null) then
            return
        endif

        //1）属性重置化（默认初始值）
        set WhitePower = GetHeroStr(hero, false)
        set WhiteQuick = GetHeroAgi(hero, false)
        set WhiteSkill = GetHeroInt(hero, false)
        set Attr_Life[playerIndex]          = 500
        set Attr_Mana[playerIndex]          = 200
        set Attr_LifeBack[playerIndex]      = 1.00
        set Attr_ManaBack[playerIndex]      = 1.00
        set Attr_Move[playerIndex]          = 0
        set Attr_Defend[playerIndex]        = 0
        set Attr_Attack[playerIndex]        = 10
        set Attr_AttackSpeed[playerIndex]   = 0.00
        set Attr_Power[playerIndex]         = WhitePower
        set Attr_Quick[playerIndex]         = WhiteQuick
        set Attr_Skill[playerIndex]         = WhiteSkill
        set Attr_Toughness[playerIndex]     = 0.00
        set Attr_Avoid[playerIndex]         = 0
        set Attr_Knocking[playerIndex]      = 0
        set Attr_Violence[playerIndex]      = 0
        set Attr_PunishFull[playerIndex]    = 1000
        set Attr_SkillDamage[playerIndex]   = 0
        set Attr_Help[playerIndex]          = 100 + 2 * (GetHeroLevel(hero)-1)
        set Attr_Hemophagia[playerIndex]    = 0
        set Attr_Split[playerIndex]         = 0
        set Attr_Weight[playerIndex]     = 10.00 + 0.25 * I2R(GetHeroLevel(hero)-1)
        set Attr_GoldRatio[playerIndex]	= 100.00
        set Attr_LumberRatio[playerIndex]	= 100.00
        set Attr_ExpRatio[playerIndex]	= 100.00

        //技能初始化
        //正
        call SetUnitAbilityLevel(  hero,Ability_defend_1,       1 )
        call SetUnitAbilityLevel(  hero,Ability_defend_10,      1 )
        call SetUnitAbilityLevel(  hero,Ability_defend_100,     1 )
        call SetUnitAbilityLevel(  hero,Ability_defend_1000,    1 )
        call SetUnitAbilityLevel(  hero,Ability_attack_1,       1 )
        call SetUnitAbilityLevel(  hero,Ability_attack_10,      1 )
        call SetUnitAbilityLevel(  hero,Ability_attack_100,     1 )
        call SetUnitAbilityLevel(  hero,Ability_attack_1000,    1 )
        call SetUnitAbilityLevel(  hero,Ability_attack_10000,    1 )
        call SetUnitAbilityLevel(  hero,Ability_attackSpeed_1,  1 )
        call SetUnitAbilityLevel(  hero,Ability_attackSpeed_10, 1 )
        call SetUnitAbilityLevel(  hero,Ability_attackSpeed_100,1 )
        call SetUnitAbilityLevel(  hero,Ability_power_1,        1 )
        call SetUnitAbilityLevel(  hero,Ability_power_10,       1 )
        call SetUnitAbilityLevel(  hero,Ability_power_100,      1 )
        call SetUnitAbilityLevel(  hero,Ability_power_1000,     1 )
        call SetUnitAbilityLevel(  hero,Ability_quick_1,        1 )
        call SetUnitAbilityLevel(  hero,Ability_quick_10,       1 )
        call SetUnitAbilityLevel(  hero,Ability_quick_100,      1 )
        call SetUnitAbilityLevel(  hero,Ability_quick_1000,     1 )
        call SetUnitAbilityLevel(  hero,Ability_skill_1,        1 )
        call SetUnitAbilityLevel(  hero,Ability_skill_10,       1 )
        call SetUnitAbilityLevel(  hero,Ability_skill_100,      1 )
        call SetUnitAbilityLevel(  hero,Ability_skill_1000,     1 )
        //负
        call SetUnitAbilityLevel(  hero,Ability_defend_FU_1,       1 )
        call SetUnitAbilityLevel(  hero,Ability_defend_FU_10,      1 )
        call SetUnitAbilityLevel(  hero,Ability_defend_FU_100,     1 )
        call SetUnitAbilityLevel(  hero,Ability_defend_FU_1000,    1 )
        call SetUnitAbilityLevel(  hero,Ability_attack_FU_1,       1 )
        call SetUnitAbilityLevel(  hero,Ability_attack_FU_10,      1 )
        call SetUnitAbilityLevel(  hero,Ability_attack_FU_100,     1 )
        call SetUnitAbilityLevel(  hero,Ability_attack_FU_1000,    1 )
        call SetUnitAbilityLevel(  hero,Ability_attack_FU_10000,    1 )
        call SetUnitAbilityLevel(  hero,Ability_attackSpeed_FU_1,  1 )
        call SetUnitAbilityLevel(  hero,Ability_attackSpeed_FU_10, 1 )
        call SetUnitAbilityLevel(  hero,Ability_attackSpeed_FU_100,1 )
        call SetUnitAbilityLevel(  hero,Ability_power_FU_1,        1 )
        call SetUnitAbilityLevel(  hero,Ability_power_FU_10,       1 )
        call SetUnitAbilityLevel(  hero,Ability_power_FU_100,      1 )
        call SetUnitAbilityLevel(  hero,Ability_power_FU_1000,     1 )
        call SetUnitAbilityLevel(  hero,Ability_quick_FU_1,        1 )
        call SetUnitAbilityLevel(  hero,Ability_quick_FU_10,       1 )
        call SetUnitAbilityLevel(  hero,Ability_quick_FU_100,      1 )
        call SetUnitAbilityLevel(  hero,Ability_quick_FU_1000,     1 )
        call SetUnitAbilityLevel(  hero,Ability_skill_FU_1,        1 )
        call SetUnitAbilityLevel(  hero,Ability_skill_FU_10,       1 )
        call SetUnitAbilityLevel(  hero,Ability_skill_FU_100,      1 )
        call SetUnitAbilityLevel(  hero,Ability_skill_FU_1000,     1 )

        //2）+锻造加成
        set Attr_Life[playerIndex]       		= Attr_Life[playerIndex]        + ForgeLv_Life[playerIndex] * 45
        set Attr_Mana[playerIndex]          = Attr_Mana[playerIndex]        + ForgeLv_Mana[playerIndex] * 35
        set Attr_LifeBack[playerIndex]      	= Attr_LifeBack[playerIndex]    + ForgeLv_LifeBack[playerIndex] * 1.0
        set Attr_ManaBack[playerIndex]   	= Attr_ManaBack[playerIndex]    + ForgeLv_ManaBack[playerIndex] * 0.8
        set Attr_Move[playerIndex]          = Attr_Move[playerIndex]        + ForgeLv_Move[playerIndex] * 7
        set Attr_Defend[playerIndex]    	= Attr_Defend[playerIndex]      + ForgeLv_Defend[playerIndex] * 1
        set Attr_Attack[playerIndex]        	= Attr_Attack[playerIndex]      + ForgeLv_Attack[playerIndex] * 6
        set Attr_AttackSpeed[playerIndex] 	= Attr_AttackSpeed[playerIndex] + ForgeLv_AttackSpeed[playerIndex] * 3.00
        set Attr_Power[playerIndex]    		= Attr_Power[playerIndex]       + ForgeLv_Power[playerIndex] * 5
        set Attr_Quick[playerIndex]         	= Attr_Quick[playerIndex]       + ForgeLv_Quick[playerIndex] * 5
        set Attr_Skill[playerIndex]         	= Attr_Skill[playerIndex]       + ForgeLv_Skill[playerIndex] * 5
        set Attr_Toughness[playerIndex]     = Attr_Toughness[playerIndex]   + 0
        set Attr_Avoid[playerIndex]         	= Attr_Avoid[playerIndex]       + 0
        set Attr_Knocking[playerIndex]  	= Attr_Knocking[playerIndex]    + 0
        set Attr_Violence[playerIndex]      	= Attr_Violence[playerIndex]    + 0
        set Attr_PunishFull[playerIndex]    	= Attr_PunishFull[playerIndex]  + 0
        set Attr_SkillDamage[playerIndex]  	= Attr_SkillDamage[playerIndex] + 0
        set Attr_Help[playerIndex]          	= Attr_Help[playerIndex]        + ForgeLv_Help[playerIndex] * 75
        set Attr_Hemophagia[playerIndex]  	= Attr_Hemophagia[playerIndex]  + 0
        set Attr_Split[playerIndex]         	= Attr_Split[playerIndex]       + 0
        set Attr_Weight[playerIndex]         = Attr_Weight[playerIndex] + 0
        set Attr_GoldRatio[playerIndex]		= Attr_GoldRatio[playerIndex] + 0
        set Attr_LumberRatio[playerIndex]  	= Attr_LumberRatio[playerIndex] + 0
        set Attr_ExpRatio[playerIndex]    	= Attr_ExpRatio[playerIndex] + 0

        //3）+物品加成
        //物品的全局判断计算
        //注意需要计算次数
        set i = 1
        set Attr_WeightCurrent[playerIndex] = 0.00
        loop
            exitwhen i > 6  //6格物品栏
                set it = UnitItemInSlot(hero, i-1)
                set itId = GetItemTypeId(it)
                set itCharges = GetItemCharges(it)
                //负重
                set Attr_WeightCurrent[playerIndex] = Attr_WeightCurrent[playerIndex] + items_getWeightByItemId( itId ) * I2R(itCharges)

/*--------------------------------COPY--------------------------------*/


if(true==false) then
    //nothing
elseif(itId == ITEM_life_water_lv1) then
    //小生命药水
elseif(itId == ITEM_mana_water_lv1) then
    //小魔法药水
elseif(itId == ITEM_life_water_lv2) then
    //大生命药水
elseif(itId == ITEM_mana_water_lv2) then
    //大魔法药水
elseif(itId == ITEM_isee) then
    //督视猫头鹰
elseif(itId == ITEM_portal_scroll) then
    //传送卷轴
elseif(itId == ITEM_transparent_drug) then
    //隐身药水
elseif(itId == ITEM_life_water_lv3) then
    //超生命药水
elseif(itId == ITEM_mana_water_lv3) then
    //超魔法药水
elseif(itId == ITEM_iron_branch) then
    //铁皮树枝
    set Attr_Power[playerIndex] = Attr_Power[playerIndex]+(1*itCharges)
    set Attr_Quick[playerIndex] = Attr_Quick[playerIndex]+(1*itCharges)
    set Attr_Skill[playerIndex] = Attr_Skill[playerIndex]+(1*itCharges)
elseif(itId == ITEM_life_stone) then
    //生命石
    set Attr_LifeBack[playerIndex] = Attr_LifeBack[playerIndex]+(2.00*I2R(itCharges))
elseif(itId == ITEM_mana_stone) then
    //魔法石
    set Attr_ManaBack[playerIndex] = Attr_ManaBack[playerIndex]+(3.00*I2R(itCharges))
elseif(itId == ITEM_paw) then
    //攻击之爪
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(3*itCharges)
elseif(itId == ITEM_retaining_ring) then
    //护环
    set Attr_Defend[playerIndex] = Attr_Defend[playerIndex]+(1*itCharges)
elseif(itId == ITEM_speed_glove) then
    //加速手套
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(10*I2R(itCharges))
elseif(itId == ITEM_mana_amulet) then
    //魔法护身符
    set Attr_Mana[playerIndex] = Attr_Mana[playerIndex]+(500*itCharges)
    set Attr_ManaBack[playerIndex] = Attr_ManaBack[playerIndex]+(4.00*I2R(itCharges))
elseif(itId == ITEM_life_amulet) then
    //生命护身符
    set Attr_Life[playerIndex] = Attr_Life[playerIndex]+(600*itCharges)
    set Attr_Defend[playerIndex] = Attr_Defend[playerIndex]+(1*itCharges)
elseif(itId == ITEM_boot) then
    //速度之靴
    set Attr_Move[playerIndex] = Attr_Move[playerIndex]+(30*itCharges)
elseif(itId == ITEM_helmet) then
    //钢盔
    set Attr_Defend[playerIndex] = Attr_Defend[playerIndex]+(6*itCharges)
elseif(itId == ITEM_sword) then
    //短剑
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(21*itCharges)
elseif(itId == ITEM_axe) then
    //铁斧
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(23*itCharges)
    set Attr_Split[playerIndex] = Attr_Split[playerIndex]+(5*itCharges)
endif
if(true==false) then
    //nothing
elseif(itId == ITEM_hammer) then
    //铁锤
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(32*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(-10*I2R(itCharges))
    set Attr_Knocking[playerIndex] = Attr_Knocking[playerIndex]+(80*itCharges)
elseif(itId == ITEM_stick) then
    //杖棍
    set Attr_LifeBack[playerIndex] = Attr_LifeBack[playerIndex]+(4.00*I2R(itCharges))
    set Attr_ManaBack[playerIndex] = Attr_ManaBack[playerIndex]+(4.00*I2R(itCharges))
    set Attr_SkillDamage[playerIndex] = Attr_SkillDamage[playerIndex]+(100*itCharges)
    set Attr_Help[playerIndex] = Attr_Help[playerIndex]+(250*itCharges)
elseif(itId == ITEM_hemophagia_mask) then
    //吸血面具
    set Attr_Hemophagia[playerIndex] = Attr_Hemophagia[playerIndex]+(6*itCharges)
elseif(itId == ITEM_dagger) then
    //匕首
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(16*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(10*I2R(itCharges))
    set Attr_Avoid[playerIndex] = Attr_Avoid[playerIndex]+(70*itCharges)
elseif(itId == ITEM_tank_shield) then
    //先锋盾
    set Attr_Life[playerIndex] = Attr_Life[playerIndex]+(500*itCharges)
    set Attr_Defend[playerIndex] = Attr_Defend[playerIndex]+(8*itCharges)
elseif(itId == ITEM_thaumaturgy) then
    //奇术
    set Attr_Skill[playerIndex] = Attr_Skill[playerIndex]+(10*itCharges)
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(120*itCharges)
    set Attr_ExpRatio[playerIndex] = Attr_ExpRatio[playerIndex]+(3*itCharges)
elseif(itId == ITEM_tank_boot) then
    //先锋靴
    set Attr_Life[playerIndex] = Attr_Life[playerIndex]+(500*itCharges)
    set Attr_Move[playerIndex] = Attr_Move[playerIndex]+(45*itCharges)
    set Attr_Defend[playerIndex] = Attr_Defend[playerIndex]+(5*itCharges)
elseif(itId == ITEM_leather_armor) then
    //皮甲
    set Attr_Toughness[playerIndex] = Attr_Toughness[playerIndex]+(6.00*I2R(itCharges))
    set Attr_PunishFull[playerIndex] = Attr_PunishFull[playerIndex]+(600*itCharges)
elseif(itId == ITEM_shadow_coat) then
    //影子风衣
    set Attr_Avoid[playerIndex] = Attr_Avoid[playerIndex]+(175*itCharges)
elseif(itId == ITEM_ghoul_gloves) then
    //食人鬼手套
    set Attr_LifeBack[playerIndex] = Attr_LifeBack[playerIndex]+(-8.00*I2R(itCharges))
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(66*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(10*I2R(itCharges))
    set Attr_Knocking[playerIndex] = Attr_Knocking[playerIndex]+(150*itCharges)
    set Attr_PunishFull[playerIndex] = Attr_PunishFull[playerIndex]+(-100*itCharges)
elseif(itId == ITEM_spear) then
    //钢枪
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(50*itCharges)
elseif(itId == ITEM_flute) then
    //风声笛子
    set Attr_Quick[playerIndex] = Attr_Quick[playerIndex]+(18*itCharges)
elseif(itId == ITEM_staff) then
    //法杖
    set Attr_Mana[playerIndex] = Attr_Mana[playerIndex]+(200*itCharges)
    set Attr_Skill[playerIndex] = Attr_Skill[playerIndex]+(15*itCharges)
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(150*itCharges)
elseif(itId == ITEM_crystal_boot) then
    //冰魔靴
    set Attr_Mana[playerIndex] = Attr_Mana[playerIndex]+(500*itCharges)
    set Attr_Move[playerIndex] = Attr_Move[playerIndex]+(40*itCharges)
    set Attr_Skill[playerIndex] = Attr_Skill[playerIndex]+(10*itCharges)
elseif(itId == ITEM_sky_diamond) then
    //天空钻
    set Attr_SkillDamage[playerIndex] = Attr_SkillDamage[playerIndex]+(500*itCharges)
elseif(itId == ITEM_robbers_boot) then
    //无声靴
    set Attr_Move[playerIndex] = Attr_Move[playerIndex]+(50*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(15*I2R(itCharges))
    set Attr_Avoid[playerIndex] = Attr_Avoid[playerIndex]+(180*itCharges)
elseif(itId == ITEM_blood_feather_drill) then
    //血羽钻
    set Attr_Hemophagia[playerIndex] = Attr_Hemophagia[playerIndex]+(15*itCharges)
elseif(itId == ITEM_ghost_hammer) then
    //食人鬼巨锤
    set Attr_LifeBack[playerIndex] = Attr_LifeBack[playerIndex]+(-10.00*I2R(itCharges))
    set Attr_Defend[playerIndex] = Attr_Defend[playerIndex]+(-3*itCharges)
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(100*itCharges)
    set Attr_Knocking[playerIndex] = Attr_Knocking[playerIndex]+(250*itCharges)
    set Attr_PunishFull[playerIndex] = Attr_PunishFull[playerIndex]+(-200*itCharges)
elseif(itId == ITEM_bloodiness_spear) then
    //血枪
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(50*itCharges)
    set Attr_Hemophagia[playerIndex] = Attr_Hemophagia[playerIndex]+(12*itCharges)
elseif(itId == ITEM_chaos_stone) then
    //混沌之石
    set Attr_Avoid[playerIndex] = Attr_Avoid[playerIndex]+(180*itCharges)
elseif(itId == ITEM_leather_armor_big) then
    //镶皮甲
    set Attr_Defend[playerIndex] = Attr_Defend[playerIndex]+(1*itCharges)
    set Attr_Toughness[playerIndex] = Attr_Toughness[playerIndex]+(10.00*I2R(itCharges))
    set Attr_PunishFull[playerIndex] = Attr_PunishFull[playerIndex]+(1200*itCharges)
endif
if(true==false) then
    //nothing
elseif(itId == ITEM_sky_stick) then
    //冥天之杖
    set Attr_Mana[playerIndex] = Attr_Mana[playerIndex]+(200*itCharges)
    set Attr_Skill[playerIndex] = Attr_Skill[playerIndex]+(25*itCharges)
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(280*itCharges)
    set Attr_ExpRatio[playerIndex] = Attr_ExpRatio[playerIndex]+(3*itCharges)
elseif(itId == ITEM_original_stone) then
    //原石
    set Attr_Power[playerIndex] = Attr_Power[playerIndex]+(16*itCharges)
elseif(itId == ITEM_fly_boot) then
    //飞靴
    set Attr_Move[playerIndex] = Attr_Move[playerIndex]+(50*itCharges)
    set Attr_Avoid[playerIndex] = Attr_Avoid[playerIndex]+(360*itCharges)
elseif(itId == ITEM_earth_axe) then
    //大地钺
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(70*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(-15*I2R(itCharges))
    set Attr_Power[playerIndex] = Attr_Power[playerIndex]+(15*itCharges)
    set Attr_Knocking[playerIndex] = Attr_Knocking[playerIndex]+(120*itCharges)
    set Attr_Hemophagia[playerIndex] = Attr_Hemophagia[playerIndex]+(20*itCharges)
    set Attr_Split[playerIndex] = Attr_Split[playerIndex]+(70*itCharges)
elseif(itId == ITEM_thunder_stone) then
    //雷石
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(30*I2R(itCharges))
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(130*itCharges)
elseif(itId == ITEM_ice_stone) then
    //冰石
    set Attr_ManaBack[playerIndex] = Attr_ManaBack[playerIndex]+(10.00*I2R(itCharges))
    set Attr_Skill[playerIndex] = Attr_Skill[playerIndex]+(30*itCharges)
elseif(itId == ITEM_fire_stone) then
    //焰石
    set Attr_Knocking[playerIndex] = Attr_Knocking[playerIndex]+(50*itCharges)
    set Attr_Split[playerIndex] = Attr_Split[playerIndex]+(20*itCharges)
elseif(itId == ITEM_ghost_stone) then
    //鬼石
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(30*I2R(itCharges))
    set Attr_Power[playerIndex] = Attr_Power[playerIndex]+(-10*itCharges)
    set Attr_Quick[playerIndex] = Attr_Quick[playerIndex]+(18*itCharges)
elseif(itId == ITEM_thunder_stick) then
    //霹雳棒
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(10*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(35*I2R(itCharges))
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(300*itCharges)
elseif(itId == ITEM_noble_diamond) then
    //贵族钻
    set Attr_Move[playerIndex] = Attr_Move[playerIndex]+(30*itCharges)
    set Attr_Defend[playerIndex] = Attr_Defend[playerIndex]+(10*itCharges)
    set Attr_GoldRatio[playerIndex] = Attr_GoldRatio[playerIndex]+(8*itCharges)
elseif(itId == ITEM_crystal_hammer) then
    //晶体锤
    set Attr_Skill[playerIndex] = Attr_Skill[playerIndex]+(35*itCharges)
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(100*itCharges)
elseif(itId == ITEM_fire_axe) then
    //裂焰斧
    set Attr_Defend[playerIndex] = Attr_Defend[playerIndex]+(8*itCharges)
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(30*itCharges)
    set Attr_Split[playerIndex] = Attr_Split[playerIndex]+(30*itCharges)
elseif(itId == ITEM_thunder_hammer) then
    //雷电之锤
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(30*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(25*I2R(itCharges))
    set Attr_Knocking[playerIndex] = Attr_Knocking[playerIndex]+(100*itCharges)
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(100*itCharges)
elseif(itId == ITEM_ice_thunder_charm) then
    //冰雷符
    set Attr_Skill[playerIndex] = Attr_Skill[playerIndex]+(15*itCharges)
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(350*itCharges)
elseif(itId == ITEM_emerald) then
    //绿幽石
    set Attr_LifeBack[playerIndex] = Attr_LifeBack[playerIndex]+(15.00*I2R(itCharges))
    set Attr_ManaBack[playerIndex] = Attr_ManaBack[playerIndex]+(15.00*I2R(itCharges))
    set Attr_SkillDamage[playerIndex] = Attr_SkillDamage[playerIndex]+(750*itCharges)
    set Attr_Help[playerIndex] = Attr_Help[playerIndex]+(1500*itCharges)
elseif(itId == ITEM_original_fire) then
    //源头之火
    set Attr_Split[playerIndex] = Attr_Split[playerIndex]+(25*itCharges)
elseif(itId == ITEM_exquisite_staff) then
    //幽透杖
    set Attr_Mana[playerIndex] = Attr_Mana[playerIndex]+(200*itCharges)
    set Attr_Power[playerIndex] = Attr_Power[playerIndex]+(5*itCharges)
    set Attr_Skill[playerIndex] = Attr_Skill[playerIndex]+(45*itCharges)
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(150*itCharges)
elseif(itId == ITEM_saviour) then
    //救世者
    set Attr_LifeBack[playerIndex] = Attr_LifeBack[playerIndex]+(20.00*I2R(itCharges))
    set Attr_ManaBack[playerIndex] = Attr_ManaBack[playerIndex]+(10.00*I2R(itCharges))
    set Attr_SkillDamage[playerIndex] = Attr_SkillDamage[playerIndex]+(800*itCharges)
    set Attr_Help[playerIndex] = Attr_Help[playerIndex]+(1800*itCharges)
elseif(itId == ITEM_wind_dagger) then
    //疾风之刃
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(15*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(45*I2R(itCharges))
    set Attr_Quick[playerIndex] = Attr_Quick[playerIndex]+(26*itCharges)
    set Attr_Avoid[playerIndex] = Attr_Avoid[playerIndex]+(50*itCharges)
elseif(itId == ITEM_wolf_backbone) then
    //狼脊骨
    set Attr_Life[playerIndex] = Attr_Life[playerIndex]+(4000*itCharges)
    set Attr_PunishFull[playerIndex] = Attr_PunishFull[playerIndex]+(2000*itCharges)
elseif(itId == ITEM_show_fox_fur) then
    //雪狐毛
    set Attr_Avoid[playerIndex] = Attr_Avoid[playerIndex]+(2000*itCharges)
endif
if(true==false) then
    //nothing
elseif(itId == ITEM_phoenix_feather) then
    //火鸟羽毛
    set Attr_Split[playerIndex] = Attr_Split[playerIndex]+(30*itCharges)
elseif(itId == ITEM_lion_tooth) then
    //狮齿
    set Attr_Move[playerIndex] = Attr_Move[playerIndex]+(30*itCharges)
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(90*itCharges)
    set Attr_Hemophagia[playerIndex] = Attr_Hemophagia[playerIndex]+(15*itCharges)
elseif(itId == ITEM_ice_beetle) then
    //冰晶虫
    set Attr_SkillDamage[playerIndex] = Attr_SkillDamage[playerIndex]+(5000*itCharges)
elseif(itId == ITEM_leather_armor_born) then
    //邪骨甲
    set Attr_Life[playerIndex] = Attr_Life[playerIndex]+(4000*itCharges)
    set Attr_Defend[playerIndex] = Attr_Defend[playerIndex]+(3*itCharges)
    set Attr_Toughness[playerIndex] = Attr_Toughness[playerIndex]+(10.00*I2R(itCharges))
    set Attr_PunishFull[playerIndex] = Attr_PunishFull[playerIndex]+(3500*itCharges)
elseif(itId == ITEM_silvery_bullet) then
    //银狐子弹
    set Attr_Move[playerIndex] = Attr_Move[playerIndex]+(55*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(18*I2R(itCharges))
    set Attr_Avoid[playerIndex] = Attr_Avoid[playerIndex]+(2350*itCharges)
elseif(itId == ITEM_thunder_thunder_stick) then
    //霹雳霹雳
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(15*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(55*I2R(itCharges))
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(500*itCharges)
elseif(itId == ITEM_god_thunder_hammer) then
    //鬼道电锤
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(25*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(50*I2R(itCharges))
    set Attr_Quick[playerIndex] = Attr_Quick[playerIndex]+(10*itCharges)
    set Attr_Knocking[playerIndex] = Attr_Knocking[playerIndex]+(150*itCharges)
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(150*itCharges)
elseif(itId == ITEM_fire_sword) then
    //烽火巨剑
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(25*itCharges)
    set Attr_Knocking[playerIndex] = Attr_Knocking[playerIndex]+(50*itCharges)
    set Attr_Split[playerIndex] = Attr_Split[playerIndex]+(50*itCharges)
elseif(itId == ITEM_three_crystal_hammer) then
    //冰晶三体锤
    set Attr_Skill[playerIndex] = Attr_Skill[playerIndex]+(40*itCharges)
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(125*itCharges)
    set Attr_SkillDamage[playerIndex] = Attr_SkillDamage[playerIndex]+(6000*itCharges)
elseif(itId == ITEM_ghost_hell) then
    //鬼堕狱
    set Attr_LifeBack[playerIndex] = Attr_LifeBack[playerIndex]+(-10.00*I2R(itCharges))
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(75*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(80*I2R(itCharges))
    set Attr_Power[playerIndex] = Attr_Power[playerIndex]+(-30*itCharges)
    set Attr_Quick[playerIndex] = Attr_Quick[playerIndex]+(55*itCharges)
    set Attr_Knocking[playerIndex] = Attr_Knocking[playerIndex]+(175*itCharges)
    set Attr_PunishFull[playerIndex] = Attr_PunishFull[playerIndex]+(-500*itCharges)
elseif(itId == ITEM_ice_staff) then
    //寒冰杖
    set Attr_Mana[playerIndex] = Attr_Mana[playerIndex]+(200*itCharges)
    set Attr_Skill[playerIndex] = Attr_Skill[playerIndex]+(55*itCharges)
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(150*itCharges)
    set Attr_SkillDamage[playerIndex] = Attr_SkillDamage[playerIndex]+(5000*itCharges)
elseif(itId == ITEM_mysterious) then
    //神秘水晶
    set Attr_GoldRatio[playerIndex] = Attr_GoldRatio[playerIndex]+(50*itCharges)
    set Attr_ExpRatio[playerIndex] = Attr_ExpRatio[playerIndex]+(50*itCharges)
elseif(itId == ITEM_mysterious_ancient_oracle) then
    //亘古骨甲
    set Attr_Defend[playerIndex] = Attr_Defend[playerIndex]+(25*itCharges)
    set Attr_Toughness[playerIndex] = Attr_Toughness[playerIndex]+(50.00*I2R(itCharges))
elseif(itId == ITEM_mysterious_ghost_scream) then
    //亡者呼声
    set Attr_SkillDamage[playerIndex] = Attr_SkillDamage[playerIndex]+(5000*itCharges)
elseif(itId == ITEM_mysterious_assassin_role) then
    //刺客信条
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(100*itCharges)
    set Attr_Knocking[playerIndex] = Attr_Knocking[playerIndex]+(400*itCharges)
    set Attr_Hemophagia[playerIndex] = Attr_Hemophagia[playerIndex]+(25*itCharges)
elseif(itId == ITEM_mysterious_ground_totem) then
    //大地图腾
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(100*itCharges)
    set Attr_Knocking[playerIndex] = Attr_Knocking[playerIndex]+(500*itCharges)
    set Attr_Violence[playerIndex] = Attr_Violence[playerIndex]+(500*itCharges)
elseif(itId == ITEM_mysterious_lighting) then
    //引雷棍
    set Attr_Mana[playerIndex] = Attr_Mana[playerIndex]+(1000*itCharges)
    set Attr_ManaBack[playerIndex] = Attr_ManaBack[playerIndex]+(10.00*I2R(itCharges))
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(125*itCharges)
elseif(itId == ITEM_mysterious_provoke_horn) then
    //挑衅号角
    set Attr_Power[playerIndex] = Attr_Power[playerIndex]+(90*itCharges)
elseif(itId == ITEM_mysterious_god_fire_sword) then
    //无双勾剑
    set Attr_Split[playerIndex] = Attr_Split[playerIndex]+(150*itCharges)
elseif(itId == ITEM_mysterious_ruthless_sword) then
    //无情剑
elseif(itId == ITEM_mysterious_time_staff) then
    //时空杖
endif
if(true==false) then
    //nothing
elseif(itId == ITEM_mysterious_moon_stone) then
    //月夜石
elseif(itId == ITEM_mysterious_eat_my_tail) then
    //法老蛇的戒心
    set Attr_Move[playerIndex] = Attr_Move[playerIndex]+(100*itCharges)
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(75*itCharges)
    set Attr_Split[playerIndex] = Attr_Split[playerIndex]+(20*itCharges)
elseif(itId == ITEM_mysterious_soul_break) then
    //灵魂破碎
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(275*itCharges)
    set Attr_Hemophagia[playerIndex] = Attr_Hemophagia[playerIndex]+(20*itCharges)
elseif(itId == ITEM_mysterious_kennedy_shield) then
    //皇家圆盾
    set Attr_Defend[playerIndex] = Attr_Defend[playerIndex]+(30*itCharges)
    set Attr_PunishFull[playerIndex] = Attr_PunishFull[playerIndex]+(5000*itCharges)
elseif(itId == ITEM_mysterious_force_axe) then
    //神力斧
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(300*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(-40*I2R(itCharges))
    set Attr_Knocking[playerIndex] = Attr_Knocking[playerIndex]+(500*itCharges)
    set Attr_Split[playerIndex] = Attr_Split[playerIndex]+(30*itCharges)
elseif(itId == ITEM_mysterious_god_tree) then
    //神木
    set Attr_LifeBack[playerIndex] = Attr_LifeBack[playerIndex]+(50.00*I2R(itCharges))
    set Attr_ManaBack[playerIndex] = Attr_ManaBack[playerIndex]+(30.00*I2R(itCharges))
    set Attr_SkillDamage[playerIndex] = Attr_SkillDamage[playerIndex]+(3000*itCharges)
    set Attr_Help[playerIndex] = Attr_Help[playerIndex]+(3000*itCharges)
elseif(itId == ITEM_mysterious_debris) then
    //神秘水晶碎片
    set Attr_GoldRatio[playerIndex] = Attr_GoldRatio[playerIndex]+(10*itCharges)
    set Attr_ExpRatio[playerIndex] = Attr_ExpRatio[playerIndex]+(10*itCharges)
elseif(itId == ITEM_mysterious_power_totem) then
    //稀土之源
elseif(itId == ITEM_mysterious_compassion_blade) then
    //绝不恻隐刀
    set Attr_LifeBack[playerIndex] = Attr_LifeBack[playerIndex]+(50.00*I2R(itCharges))
    set Attr_ManaBack[playerIndex] = Attr_ManaBack[playerIndex]+(30.00*I2R(itCharges))
    set Attr_SkillDamage[playerIndex] = Attr_SkillDamage[playerIndex]+(3000*itCharges)
    set Attr_Help[playerIndex] = Attr_Help[playerIndex]+(3000*itCharges)
elseif(itId == ITEM_mysterious_purple_armor) then
    //远古紫甲
elseif(itId == ITEM_mysterious_escape_wind) then
    //逸风
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(150*itCharges)
    set Attr_Avoid[playerIndex] = Attr_Avoid[playerIndex]+(500*itCharges)
elseif(itId == ITEM_mysterious_ice_tear) then
    //霜之哀伤
    set Attr_ExpRatio[playerIndex] = Attr_ExpRatio[playerIndex]+(100*itCharges)
elseif(itId == ITEM_mysterious_shrund_flower) then
    //霹雳之花
    set Attr_SkillDamage[playerIndex] = Attr_SkillDamage[playerIndex]+(10000*itCharges)
elseif(itId == ITEM_sun_gun) then
    //光焰剑 · 烈日裁决
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(30*itCharges)
    set Attr_Knocking[playerIndex] = Attr_Knocking[playerIndex]+(50*itCharges)
    set Attr_Split[playerIndex] = Attr_Split[playerIndex]+(75*itCharges)
elseif(itId == ITEM_fire_axe_crazy) then
    //狂焚
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(155*itCharges)
    set Attr_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]+(10*I2R(itCharges))
    set Attr_Hemophagia[playerIndex] = Attr_Hemophagia[playerIndex]+(20*itCharges)
    set Attr_Split[playerIndex] = Attr_Split[playerIndex]+(70*itCharges)
elseif(itId == ITEM_lion_fire_fight) then
    //雄狮斩牙刀
    set Attr_Move[playerIndex] = Attr_Move[playerIndex]+(150*itCharges)
    set Attr_Attack[playerIndex] = Attr_Attack[playerIndex]+(475*itCharges)
    set Attr_Hemophagia[playerIndex] = Attr_Hemophagia[playerIndex]+(75*itCharges)
    set Attr_ExpRatio[playerIndex] = Attr_ExpRatio[playerIndex]+(3*itCharges)
endif




/*--------------------------------END COPY--------------------------------*/

            set i = i + 1
        endloop

        //4）+动态加成
        set Attr_Life[playerIndex]          = Attr_Life[playerIndex]        + Attr_Dynamic_Life[playerIndex]
        set Attr_Mana[playerIndex]          = Attr_Mana[playerIndex]        + Attr_Dynamic_Mana[playerIndex]
        set Attr_LifeBack[playerIndex]      = Attr_LifeBack[playerIndex]    + Attr_Dynamic_LifeBack[playerIndex]
        set Attr_ManaBack[playerIndex]      = Attr_ManaBack[playerIndex]    + Attr_Dynamic_ManaBack[playerIndex]
        set Attr_Move[playerIndex]          = Attr_Move[playerIndex]        + Attr_Dynamic_Move[playerIndex]
        set Attr_Defend[playerIndex]        = Attr_Defend[playerIndex]      + Attr_Dynamic_Defend[playerIndex]
        set Attr_Attack[playerIndex]        = Attr_Attack[playerIndex]      + Attr_Dynamic_Attack[playerIndex]
        set Attr_AttackSpeed[playerIndex]   = Attr_AttackSpeed[playerIndex] + Attr_Dynamic_AttackSpeed[playerIndex]
        set Attr_Power[playerIndex]         = Attr_Power[playerIndex]       + Attr_Dynamic_Power[playerIndex]
        set Attr_Quick[playerIndex]         = Attr_Quick[playerIndex]       + Attr_Dynamic_Quick[playerIndex]
        set Attr_Skill[playerIndex]         = Attr_Skill[playerIndex]       + Attr_Dynamic_Skill[playerIndex]
        set Attr_Toughness[playerIndex]     = Attr_Toughness[playerIndex]   + Attr_Dynamic_Toughness[playerIndex]
        set Attr_Avoid[playerIndex]         = Attr_Avoid[playerIndex]       + Attr_Dynamic_Avoid[playerIndex]
        set Attr_Knocking[playerIndex]      = Attr_Knocking[playerIndex]    + Attr_Dynamic_Knocking[playerIndex]
        set Attr_Violence[playerIndex]      = Attr_Violence[playerIndex]    + Attr_Dynamic_Violence[playerIndex]
        set Attr_PunishFull[playerIndex]    = Attr_PunishFull[playerIndex]  + Attr_Dynamic_PunishFull[playerIndex]
        set Attr_SkillDamage[playerIndex]	= Attr_SkillDamage[playerIndex] + Attr_Dynamic_SkillDamage[playerIndex]
        set Attr_Help[playerIndex]          	= Attr_Help[playerIndex]        + Attr_Dynamic_Help[playerIndex]
        set Attr_Hemophagia[playerIndex] 	= Attr_Hemophagia[playerIndex]  + Attr_Dynamic_Hemophagia[playerIndex]
        set Attr_Split[playerIndex]         	= Attr_Split[playerIndex] + Attr_Dynamic_Split[playerIndex]
        set Attr_Weight[playerIndex]   		= Attr_Weight[playerIndex] + Attr_Dynamic_Weight[playerIndex]
        set Attr_GoldRatio[playerIndex] 		= Attr_GoldRatio[playerIndex] + Attr_Dynamic_GoldRatio[playerIndex]
        set Attr_LumberRatio[playerIndex]	= Attr_LumberRatio[playerIndex] + Attr_Dynamic_LumberRatio[playerIndex]
        set Attr_ExpRatio[playerIndex]      	= Attr_ExpRatio[playerIndex] + Attr_Dynamic_ExpRatio[playerIndex]

        //5）计算会被（力量/敏捷/智力）影响的属性
        set Attr_Life[playerIndex]          = Attr_Life[playerIndex]        + R2I(funcs_dividedI2R( Attr_Power[playerIndex] , 10) * 30.00)
        set Attr_Mana[playerIndex]          = Attr_Mana[playerIndex]        + R2I(funcs_dividedI2R( Attr_Skill[playerIndex] , 10) * 30.00)
        set Attr_LifeBack[playerIndex]      = Attr_LifeBack[playerIndex]
        set Attr_ManaBack[playerIndex]      = Attr_ManaBack[playerIndex]    + funcs_dividedI2R( Attr_Skill[playerIndex] , 30) * 1.00
        set Attr_Move[playerIndex]          = Attr_Move[playerIndex] + 0
        set Attr_Defend[playerIndex]        = Attr_Defend[playerIndex]      + 0
        set Attr_Attack[playerIndex]        = Attr_Attack[playerIndex]      + R2I(funcs_dividedI2R( Attr_Power[playerIndex] , 10)) + R2I(funcs_dividedI2R( Attr_Quick[playerIndex] , 5))
        set Attr_AttackSpeed[playerIndex]   = Attr_AttackSpeed[playerIndex] + funcs_dividedI2R( Attr_Quick[playerIndex] , 25) * 1.00
        set Attr_Power[playerIndex]         = Attr_Power[playerIndex]       + 0
        set Attr_Quick[playerIndex]         = Attr_Quick[playerIndex]       + 0
        set Attr_Skill[playerIndex]         = Attr_Skill[playerIndex]       + 0
        set Attr_Toughness[playerIndex]     = Attr_Toughness[playerIndex]   + I2R(Attr_Power[playerIndex]) * 0.2
        set Attr_Avoid[playerIndex]         = Attr_Avoid[playerIndex] + Attr_Quick[playerIndex] * 3 - Attr_Power[playerIndex]
        set Attr_Knocking[playerIndex]      = Attr_Knocking[playerIndex]    + Attr_Power[playerIndex] * 5 + Attr_Quick[playerIndex] * 1 - Attr_Skill[playerIndex] * 6
        set Attr_Violence[playerIndex]      = Attr_Violence[playerIndex]    - Attr_Power[playerIndex] * 3 - Attr_Quick[playerIndex] * 3 + Attr_Skill[playerIndex] * 7
        set Attr_PunishFull[playerIndex]    = Attr_PunishFull[playerIndex]  + Attr_Power[playerIndex] * 10 - Attr_Quick[playerIndex] * 3 - Attr_Skill[playerIndex] * 5
        set Attr_SkillDamage[playerIndex]   = Attr_SkillDamage[playerIndex] + Attr_Skill[playerIndex] * 8 - Attr_Power[playerIndex] * 10 - Attr_Quick[playerIndex] * 5
        set Attr_Help[playerIndex]          = Attr_Help[playerIndex]        + 0
        set Attr_Hemophagia[playerIndex]    = Attr_Hemophagia[playerIndex]  + 0
        set Attr_Split[playerIndex]         = Attr_Split[playerIndex]       + 0
        set Attr_Weight[playerIndex]         = Attr_Weight[playerIndex]       + 0

        //6）检测上限下限
        //攻速		  下限：-80% 上限：无（实际上有大概400%）
        //活力        下限：100 上限：100000
        //魔法        下限：100 上限：10000
        //冥想力      下限：1
        //硬直        下限：1
        //物暴        下限：0
        //魔暴        下限：0
        //分裂        下限：0
        //回避        下限：0
        if( Attr_AttackSpeed[playerIndex]<-80.00 )  then
            set Attr_AttackSpeed[playerIndex] = -80.00
        endif
        if( Attr_Life[playerIndex]>100000 )  then
            set Attr_Life[playerIndex] = 100000
        endif
        if( Attr_Life[playerIndex]<100 )  then
            set Attr_Life[playerIndex] = 100
        endif
        if( Attr_Mana[playerIndex]>10000 )  then
            set Attr_Mana[playerIndex] = 10000
        endif
        if( Attr_Mana[playerIndex]<100 )  then
            set Attr_Mana[playerIndex] = 100
        endif
        if( Attr_SkillDamage[playerIndex]<1 )  then
            set Attr_SkillDamage[playerIndex] = 1
        endif
        if( Attr_PunishFull[playerIndex]<100 )  then
            set Attr_PunishFull[playerIndex] = 100
        endif
        if( Attr_Avoid[playerIndex]<0 )  then
            set Attr_Avoid[playerIndex] = 0
        endif
        if( Attr_Toughness[playerIndex]<0 )  then
            set Attr_Toughness[playerIndex] = 0
        endif
        if( Attr_Knocking[playerIndex]<0 )  then
            set Attr_Knocking[playerIndex] = 0
        endif
        if( Attr_Violence[playerIndex]<0 )  then
            set Attr_Violence[playerIndex] = 0
        endif
        if( Attr_Split[playerIndex]<0 )  then
            set Attr_Split[playerIndex] = 0
        endif
        if( Attr_Weight[playerIndex]<0 )  then
            set Attr_Weight[playerIndex] = 10.00
        endif
        if( Attr_GoldRatio[playerIndex]<0 )  then
            set Attr_GoldRatio[playerIndex] = 0.00
        endif
        if( Attr_LumberRatio[playerIndex]<0 )  then
            set Attr_LumberRatio[playerIndex] = 0.00
        endif
        if( Attr_ExpRatio[playerIndex]<0 )  then
            set Attr_ExpRatio[playerIndex] = 0.00
        endif
        //7)正式设定属性
        //生命
        if( Attr_PrevCache_Life[playerIndex] != Attr_Life[playerIndex] ) then
			set temp_life = R2I(Attr_Life[playerIndex]) - R2I(Attr_PrevCache_Life[playerIndex])	//新旧差值
			if( temp_life>=0 )then
				set qty = temp_life/10000
				set temp_life = temp_life - (temp_life/10000)*10000
				call abilities_setAbilityLM( hero , Ability_life_10000 , qty )
				set qty = temp_life/1000
				set temp_life = temp_life - (temp_life/1000)*1000
				call abilities_setAbilityLM( hero , Ability_life_1000 , qty )
				set qty = temp_life/100
				set temp_life = temp_life - (temp_life/100)*100
				call abilities_setAbilityLM( hero , Ability_life_100  , qty )
				set qty = temp_life/10
				set temp_life = temp_life - (temp_life/10)*10
				call abilities_setAbilityLM( hero , Ability_life_10 , qty )
				set qty = temp_life/1
				set temp_life = temp_life - (temp_life/1)*1
				call abilities_setAbilityLM( hero , Ability_life_1 , qty )
			else
				set temp_life = IAbsBJ(temp_life)
				set qty = temp_life/10000
				set temp_life = temp_life - (temp_life/10000)*10000
				call abilities_setAbilityLM( hero , Ability_life_FU_10000 , qty )
				set qty = temp_life/1000
				set temp_life = temp_life - (temp_life/1000)*1000
				call abilities_setAbilityLM( hero , Ability_life_FU_1000 , qty )
				set qty = temp_life/100
				set temp_life = temp_life - (temp_life/100)*100
				call abilities_setAbilityLM( hero , Ability_life_FU_100 , qty )
				set qty = temp_life/10
				set temp_life = temp_life - (temp_life/10)*10
				call abilities_setAbilityLM( hero , Ability_life_FU_10 , qty )
				set qty = temp_life/1
				set temp_life = temp_life - (temp_life/1)*1
				call abilities_setAbilityLM( hero , Ability_life_FU_1 , qty )
			endif
	        set Attr_PrevCache_Life[playerIndex] = Attr_Life[playerIndex]
        endif
        //魔法
        if( Attr_PrevCache_Mana[playerIndex] != Attr_Mana[playerIndex] ) then
	        set temp_mana = R2I(Attr_Mana[playerIndex]) - R2I(Attr_PrevCache_Mana[playerIndex])	//新旧差值
			if( temp_mana>=0 )then
				set qty = temp_mana/10000
				set temp_mana = temp_mana - (temp_mana/10000)*10000
				call abilities_setAbilityLM( hero , Ability_mana_10000 , qty )
				set qty = temp_mana/1000
				set temp_mana = temp_mana - (temp_mana/1000)*1000
				call abilities_setAbilityLM( hero , Ability_mana_1000 , qty )
				set qty = temp_mana/100
				set temp_mana = temp_mana - (temp_mana/100)*100
				call abilities_setAbilityLM( hero , Ability_mana_100  , qty )
				set qty = temp_mana/10
				set temp_mana = temp_mana - (temp_mana/10)*10
				call abilities_setAbilityLM( hero , Ability_mana_10 , qty )
				set qty = temp_mana/1
				set temp_mana = temp_mana - (temp_mana/1)*1
				call abilities_setAbilityLM( hero , Ability_mana_1 , qty )
			else
				set temp_mana = IAbsBJ(temp_mana)
				set qty = temp_mana/10000
				set temp_mana = temp_mana - (temp_mana/10000)*10000
				call abilities_setAbilityLM( hero , Ability_mana_FU_10000 , qty )
				set qty = temp_mana/1000
				set temp_mana = temp_mana - (temp_mana/1000)*1000
				call abilities_setAbilityLM( hero , Ability_mana_FU_1000 , qty )
				set qty = temp_mana/100
				set temp_mana = temp_mana - (temp_mana/100)*100
				call abilities_setAbilityLM( hero , Ability_mana_FU_100 , qty )
				set qty = temp_mana/10
				set temp_mana = temp_mana - (temp_mana/10)*10
				call abilities_setAbilityLM( hero , Ability_mana_FU_10 , qty )
				set qty = temp_mana/1
				set temp_mana = temp_mana - (temp_mana/1)*1
				call abilities_setAbilityLM( hero , Ability_mana_FU_1 , qty )
			endif
	        set Attr_PrevCache_Mana[playerIndex] = Attr_Mana[playerIndex]
        endif
        //防御
        set temp_defend = Attr_Defend[playerIndex]
        if(temp_defend>=0)then
	        call SetUnitAbilityLevel(  hero,Ability_defend_1000, (temp_defend/1000)+1 )
            set temp_defend = temp_defend - (temp_defend/1000)*1000
            call SetUnitAbilityLevel(  hero,Ability_defend_100, (temp_defend/100)+1 )
            set temp_defend = temp_defend - (temp_defend/100)*100
            call SetUnitAbilityLevel(  hero,Ability_defend_10, (temp_defend/10)+1 )
            set temp_defend = temp_defend - (temp_defend/10)*10
            call SetUnitAbilityLevel(  hero,Ability_defend_1, temp_defend+1 )
        else
            set temp_defend = IAbsBJ(temp_defend)
            call SetUnitAbilityLevel(  hero,Ability_defend_FU_1000, (temp_defend/1000)+1 )
            set temp_defend = temp_defend - (temp_defend/1000)*1000
            call SetUnitAbilityLevel(  hero,Ability_defend_FU_100, (temp_defend/100)+1 )
            set temp_defend = temp_defend - (temp_defend/100)*100
            call SetUnitAbilityLevel(  hero,Ability_defend_FU_10, (temp_defend/10)+1 )
            set temp_defend = temp_defend - (temp_defend/10)*10
            call SetUnitAbilityLevel(  hero,Ability_defend_FU_1, temp_defend+1 )
        endif
        set Attr_PrevCache_Defend[playerIndex] = Attr_Defend[playerIndex]
        //攻击
        set temp_attack = Attr_Attack[playerIndex]
        if(temp_attack>=0)then
            call SetUnitAbilityLevel(  hero,Ability_attack_10000, (temp_attack/10000)+1 )
            set temp_attack = temp_attack - (temp_attack/10000)*10000
            call SetUnitAbilityLevel(  hero,Ability_attack_1000, (temp_attack/1000)+1 )
            set temp_attack = temp_attack - (temp_attack/1000)*1000
            call SetUnitAbilityLevel(  hero,Ability_attack_100, (temp_attack/100)+1 )
            set temp_attack = temp_attack - (temp_attack/100)*100
            call SetUnitAbilityLevel(  hero,Ability_attack_10, (temp_attack/10)+1 )
            set temp_attack = temp_attack - (temp_attack/10)*10
            call SetUnitAbilityLevel(  hero,Ability_attack_1, temp_attack+1 )
        else
            set temp_attack = IAbsBJ(temp_attack)
            call SetUnitAbilityLevel(  hero,Ability_attack_FU_10000, (temp_attack/10000)+1 )
            set temp_attack = temp_attack - (temp_attack/10000)*10000
            call SetUnitAbilityLevel(  hero,Ability_attack_FU_10000, (temp_attack/1000)+1 )
            set temp_attack = temp_attack - (temp_attack/1000)*1000
            call SetUnitAbilityLevel(  hero,Ability_attack_FU_100, (temp_attack/100)+1 )
            set temp_attack = temp_attack - (temp_attack/100)*100
            call SetUnitAbilityLevel(  hero,Ability_attack_FU_10, (temp_attack/10)+1 )
            set temp_attack = temp_attack - (temp_attack/10)*10
            call SetUnitAbilityLevel(  hero,Ability_attack_FU_1, temp_attack+1 )
        endif
        set Attr_PrevCache_Attack[playerIndex] = Attr_Attack[playerIndex]
        //攻击速度
        set temp_attackSpeed = Attr_AttackSpeed[playerIndex]
        if(temp_attackSpeed>=0)then
            call SetUnitAbilityLevel(  hero,Ability_attackSpeed_100, R2I(temp_attackSpeed/100.00)+1 )
            set temp_attackSpeed = temp_attackSpeed - I2R(R2I(temp_attackSpeed/100.00))*100.00
            call SetUnitAbilityLevel(  hero,Ability_attackSpeed_10, R2I(temp_attackSpeed/10.00)+1 )
            set temp_attackSpeed = temp_attackSpeed - I2R(R2I(temp_attackSpeed/10.00))*10.00
            call SetUnitAbilityLevel(  hero,Ability_attackSpeed_1, R2I(temp_attackSpeed)+1 )
        else
            set temp_attackSpeed = RAbsBJ(temp_attackSpeed)
            call SetUnitAbilityLevel(  hero,Ability_attackSpeed_FU_100, R2I(temp_attackSpeed/100.00)+1 )
            set temp_attackSpeed = temp_attackSpeed - I2R(R2I(temp_attackSpeed/100.00))*100.00
            call SetUnitAbilityLevel(  hero,Ability_attackSpeed_FU_10, R2I(temp_attackSpeed/10.00)+1 )
            set temp_attackSpeed = temp_attackSpeed - I2R(R2I(temp_attackSpeed/10.00))*10.00
            call SetUnitAbilityLevel(  hero,Ability_attackSpeed_FU_1, R2I(temp_attackSpeed)+1 )
        endif
        set Attr_PrevCache_AttackSpeed[playerIndex] = Attr_AttackSpeed[playerIndex]
        //体质身法技巧的技能计算需要减少对应的白字属性
        //体质（力量）
        set temp_power = Attr_Power[playerIndex] - WhitePower
        if(temp_power>=0)then
            call SetUnitAbilityLevel(  hero,Ability_power_1000, (temp_power/1000)+1 )
            set temp_power = temp_power - (temp_power/1000)*1000
            call SetUnitAbilityLevel(  hero,Ability_power_100, (temp_power/100)+1 )
            set temp_power = temp_power - (temp_power/100)*100
            call SetUnitAbilityLevel(  hero,Ability_power_10, (temp_power/10)+1 )
            set temp_power = temp_power - (temp_power/10)*10
            call SetUnitAbilityLevel(  hero,Ability_power_1, temp_power+1 )
        else
            set temp_power = IAbsBJ(temp_power)
            call SetUnitAbilityLevel(  hero,Ability_power_FU_1000, (temp_power/1000)+1 )
            set temp_power = temp_power - (temp_power/1000)*1000
            call SetUnitAbilityLevel(  hero,Ability_power_FU_100, (temp_power/100)+1 )
            set temp_power = temp_power - (temp_power/100)*100
            call SetUnitAbilityLevel(  hero,Ability_power_FU_10, (temp_power/10)+1 )
            set temp_power = temp_power - (temp_power/10)*10
            call SetUnitAbilityLevel(  hero,Ability_power_FU_1, temp_power+1 )
        endif
        set Attr_PrevCache_Power[playerIndex] = Attr_Power[playerIndex]
        //身法（敏捷）
        set temp_quick = Attr_Quick[playerIndex] - WhiteQuick
        if(temp_quick>=0)then
            call SetUnitAbilityLevel(  hero,Ability_quick_1000, (temp_quick/1000)+1 )
            set temp_quick = temp_quick - (temp_quick/1000)*1000
            call SetUnitAbilityLevel(  hero,Ability_quick_100, (temp_quick/100)+1 )
            set temp_quick = temp_quick - (temp_quick/100)*100
            call SetUnitAbilityLevel(  hero,Ability_quick_10, (temp_quick/10)+1 )
            set temp_quick = temp_quick - (temp_quick/10)*10
            call SetUnitAbilityLevel(  hero,Ability_quick_1, temp_quick+1 )
        else
            set temp_quick = IAbsBJ(temp_quick)
            call SetUnitAbilityLevel(  hero,Ability_quick_FU_1000, (temp_quick/1000)+1 )
            set temp_quick = temp_quick - (temp_quick/1000)*1000
            call SetUnitAbilityLevel(  hero,Ability_quick_FU_100, (temp_quick/100)+1 )
            set temp_quick = temp_quick - (temp_quick/100)*100
            call SetUnitAbilityLevel(  hero,Ability_quick_FU_10, (temp_quick/10)+1 )
            set temp_quick = temp_quick - (temp_quick/10)*10
            call SetUnitAbilityLevel(  hero,Ability_quick_FU_1, temp_quick+1 )
        endif
        set Attr_PrevCache_Quick[playerIndex] = Attr_Quick[playerIndex]
        //技巧（智力）
        set temp_skill = Attr_Skill[playerIndex] - WhiteSkill
        if(temp_skill>=0)then
            call SetUnitAbilityLevel(  hero,Ability_skill_1000, (temp_skill/1000)+1 )
            set temp_skill = temp_skill - (temp_skill/1000)*1000
            call SetUnitAbilityLevel(  hero,Ability_skill_100, (temp_skill/100)+1 )
            set temp_skill = temp_skill - (temp_skill/100)*100
            call SetUnitAbilityLevel(  hero,Ability_skill_10, (temp_skill/10)+1 )
            set temp_skill = temp_skill - (temp_skill/10)*10
            call SetUnitAbilityLevel(  hero,Ability_skill_1, temp_skill+1 )
        else
            set temp_skill = IAbsBJ(temp_skill)
            call SetUnitAbilityLevel(  hero,Ability_skill_FU_1000, (temp_skill/1000)+1 )
            set temp_skill = temp_skill - (temp_skill/1000)*1000
            call SetUnitAbilityLevel(  hero,Ability_skill_FU_100, (temp_skill/100)+1 )
            set temp_skill = temp_skill - (temp_skill/100)*100
            call SetUnitAbilityLevel(  hero,Ability_skill_FU_10, (temp_skill/10)+1 )
            set temp_skill = temp_skill - (temp_skill/10)*10
            call SetUnitAbilityLevel(  hero,Ability_skill_FU_1, temp_skill+1 )
        endif
        set Attr_PrevCache_Skill[playerIndex] = Attr_Skill[playerIndex]
        //移动力
        if( Attr_Move[playerIndex]>500 )  then
            call SetUnitMoveSpeed( hero, 500 )
        else
            call SetUnitMoveSpeed( hero, Attr_Move[playerIndex] )
        endif
        set Attr_PrevCache_Move[playerIndex] = Attr_Move[playerIndex]
        //硬直
        if( Attr_PrevCache_PunishFull[playerIndex] != Attr_PunishFull[playerIndex] ) then
	        //按不同总量比例设定当前硬直
	        if( Attr_PrevCache_PunishFull[playerIndex]>0 and Attr_PunishFull[playerIndex]>0 ) then
		        set Attr_PunishCurrent[playerIndex] = Attr_PunishCurrent[playerIndex] * (Attr_PunishFull[playerIndex] / Attr_PrevCache_PunishFull[playerIndex])
	        endif
	        if(Attr_PunishCurrent[playerIndex]==null or Attr_PunishCurrent[playerIndex]<=0 or Attr_PunishCurrent[playerIndex]>Attr_PunishFull[playerIndex]) then
	            set Attr_PunishCurrent[playerIndex] = Attr_PunishFull[playerIndex]
	        endif
	        set Attr_PrevCache_PunishFull[playerIndex] = Attr_PunishFull[playerIndex]
        endif
        //8）记录文本
        call freshStr(playerIndex)
        //9 )刷新多面板
        call myMultiboard_create()
	endfunction

	/**
	 * 属性设定冷却
	 */
	private function calculateOneCooldown takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer playerIndex = funcs_getTimerParams_Integer( t , Key_Attr_Index )
		call calculateOneBase(playerIndex)
		set Attribute_ISCD[playerIndex] = false
		call funcs_delTimer(t,null)
	endfunction

    /**
     * 设定某个玩家英雄的各项属性
     */
    public function calculateOne takes integer playerIndex returns nothing
    	local timer cdTimer = null
		if( Attribute_ISCD[playerIndex]==true ) then
			return
		endif
		set Attribute_ISCD[playerIndex] = true
		set cdTimer = funcs_setTimeout( 0.7 , function calculateOneCooldown )
		call funcs_setTimerParams_Integer( cdTimer , Key_Attr_Index , playerIndex )
		call calculateOneBase(playerIndex)
    endfunction

    /**
     * 设定所有玩家英雄的各项属性
     */
    public function calculateAll takes nothing returns nothing
        local integer i = 1
        loop
            exitwhen i > Max_Player_num
                call calculateOne(i)
                set i = i + 1
        endloop
    endfunction

    //--------------------------------------动态修改属性方法----------------------------------------------
    private function changeAttributeTimer takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer tag = funcs_getTimerParams_Integer( t , Key_Attr_Tag )
        local integer index = funcs_getTimerParams_Integer( t , Key_Attr_Index)
        local integer data = funcs_getTimerParams_Integer( t , Key_Attr_Data)
        call DestroyTimer(GetExpiredTimer())
        if( tag == Tag_Life) then
            set Attr_Dynamic_Life[index] = Attr_Dynamic_Life[index] - data
        elseif( tag == Tag_Mana) then
            set Attr_Dynamic_Mana[index] = Attr_Dynamic_Mana[index] - data
        elseif( tag == Tag_LifeBack) then
            set Attr_Dynamic_LifeBack[index] = Attr_Dynamic_LifeBack[index] - I2R(data)
        elseif( tag == Tag_ManaBack) then
            set Attr_Dynamic_ManaBack[index] = Attr_Dynamic_ManaBack[index] - I2R(data)
        elseif( tag == Tag_Move) then
            set Attr_Dynamic_Move[index] = Attr_Dynamic_Move[index] - data
        elseif( tag == Tag_Defend) then
            set Attr_Dynamic_Defend[index] = Attr_Dynamic_Defend[index] - data
        elseif( tag == Tag_Attack) then
            set Attr_Dynamic_Attack[index] = Attr_Dynamic_Attack[index] - data
        elseif( tag == Tag_AttackSpeed) then
            set Attr_Dynamic_AttackSpeed[index] = Attr_Dynamic_AttackSpeed[index] - I2R(data)
        elseif( tag == Tag_Power) then
            set Attr_Dynamic_Power[index] = Attr_Dynamic_Power[index] - data
        elseif( tag == Tag_Quick) then
            set Attr_Dynamic_Quick[index] = Attr_Dynamic_Quick[index] - data
        elseif( tag == Tag_Skill) then
            set Attr_Dynamic_Skill[index] = Attr_Dynamic_Skill[index] - data
    	endif
        if( tag == Tag_Toughness) then
            set Attr_Dynamic_Toughness[index] = Attr_Dynamic_Toughness[index] - I2R(data)
        elseif( tag == Tag_Avoid) then
            set Attr_Dynamic_Avoid[index] = Attr_Dynamic_Avoid[index] - data
        elseif( tag == Tag_Knocking) then
            set Attr_Dynamic_Knocking[index] = Attr_Dynamic_Knocking[index] - data
        elseif( tag == Tag_Violence) then
            set Attr_Dynamic_Violence[index] = Attr_Dynamic_Violence[index] - data
        elseif( tag == Tag_PunishFull) then
            set Attr_Dynamic_PunishFull[index] = Attr_Dynamic_PunishFull[index] - data
        elseif( tag == Tag_SkillDamage) then
            set Attr_Dynamic_SkillDamage[index] = Attr_Dynamic_SkillDamage[index] - data
        elseif( tag == Tag_Help) then
            set Attr_Dynamic_Help[index] = Attr_Dynamic_Help[index] - data
        elseif( tag == Tag_Hemophagia) then
            set Attr_Dynamic_Hemophagia[index] = Attr_Dynamic_Hemophagia[index] - data
        elseif( tag == Tag_Split) then
            set Attr_Dynamic_Split[index] = Attr_Dynamic_Split[index] - data
        elseif( tag == Tag_Weight) then
            set Attr_Dynamic_Weight[index] = Attr_Dynamic_Weight[index] - data
        elseif( tag == Tag_GoldRatio) then
            set Attr_Dynamic_GoldRatio[index] = Attr_Dynamic_GoldRatio[index] - data
        elseif( tag == Tag_LumberRatio) then
            set Attr_Dynamic_LumberRatio[index] = Attr_Dynamic_LumberRatio[index] - data
        elseif( tag == Tag_ExpRatio) then
            set Attr_Dynamic_ExpRatio[index] = Attr_Dynamic_ExpRatio[index] - data
        endif
        call attribute_calculateOne(index)
    endfunction

    public function changeAttribute takes integer tag,integer index,integer data,real during returns nothing
        local timer t = null
        if( tag == Tag_Life) then
            set Attr_Dynamic_Life[index] = Attr_Dynamic_Life[index] + data
        elseif( tag == Tag_Mana) then
            set Attr_Dynamic_Mana[index] = Attr_Dynamic_Mana[index] + data
        elseif( tag == Tag_LifeBack) then
            set Attr_Dynamic_LifeBack[index] = Attr_Dynamic_LifeBack[index] + I2R(data)
        elseif( tag == Tag_ManaBack) then
            set Attr_Dynamic_ManaBack[index] = Attr_Dynamic_ManaBack[index] + I2R(data)
        elseif( tag == Tag_Move) then
            set Attr_Dynamic_Move[index] = Attr_Dynamic_Move[index] + data
        elseif( tag == Tag_Defend) then
            set Attr_Dynamic_Defend[index] = Attr_Dynamic_Defend[index] + data
        elseif( tag == Tag_Attack) then
            set Attr_Dynamic_Attack[index] = Attr_Dynamic_Attack[index] + data
        elseif( tag == Tag_AttackSpeed) then
            set Attr_Dynamic_AttackSpeed[index] = Attr_Dynamic_AttackSpeed[index] + I2R(data)
        elseif( tag == Tag_Power) then
            set Attr_Dynamic_Power[index] = Attr_Dynamic_Power[index] + data
        elseif( tag == Tag_Quick) then
            set Attr_Dynamic_Quick[index] = Attr_Dynamic_Quick[index] + data
        elseif( tag == Tag_Skill) then
            set Attr_Dynamic_Skill[index] = Attr_Dynamic_Skill[index] + data
        endif
        if( tag == Tag_Toughness) then
            set Attr_Dynamic_Toughness[index] = Attr_Dynamic_Toughness[index] + I2R(data)
        elseif( tag == Tag_Avoid) then
            set Attr_Dynamic_Avoid[index] = Attr_Dynamic_Avoid[index] + data
        elseif( tag == Tag_Knocking) then
            set Attr_Dynamic_Knocking[index] = Attr_Dynamic_Knocking[index] + data
        elseif( tag == Tag_Violence) then
            set Attr_Dynamic_Violence[index] = Attr_Dynamic_Violence[index] + data
        elseif( tag == Tag_PunishFull) then
            set Attr_Dynamic_PunishFull[index] = Attr_Dynamic_PunishFull[index] + data
        elseif( tag == Tag_SkillDamage) then
            set Attr_Dynamic_SkillDamage[index] = Attr_Dynamic_SkillDamage[index] + data
        elseif( tag == Tag_Help) then
            set Attr_Dynamic_Help[index] = Attr_Dynamic_Help[index] + data
        elseif( tag == Tag_Hemophagia) then
            set Attr_Dynamic_Hemophagia[index] = Attr_Dynamic_Hemophagia[index] + data
        elseif( tag == Tag_Split) then
            set Attr_Dynamic_Split[index] = Attr_Dynamic_Split[index] + data
        elseif( tag == Tag_Weight) then
            set Attr_Dynamic_Weight[index] = Attr_Dynamic_Weight[index] + data
        elseif( tag == Tag_GoldRatio) then
            set Attr_Dynamic_GoldRatio[index] = Attr_Dynamic_GoldRatio[index] + data
        elseif( tag == Tag_LumberRatio) then
            set Attr_Dynamic_LumberRatio[index] = Attr_Dynamic_LumberRatio[index] + data
        elseif( tag == Tag_ExpRatio) then
            set Attr_Dynamic_ExpRatio[index] = Attr_Dynamic_ExpRatio[index] + data
        endif
        set t = funcs_setTimeout(during,function changeAttributeTimer)
        call funcs_console("funcs_setTimerParams_Integer")
        call funcs_setTimerParams_Integer(t,Key_Attr_Tag,tag)
        call funcs_setTimerParams_Integer(t,Key_Attr_Index,index)
        call funcs_setTimerParams_Integer(t,Key_Attr_Data,data)
        call attribute_calculateOne(index)
    endfunction

    /**
     * 复制某个玩家英雄技能属性到某个单位，支持百分比设定
     * 只支持 护甲 攻击 攻速 移动
     * 只支持正数
     */
    public function copyAttrForShadow takes integer playerIndex ,unit targetUnit, real percentDefend , real percentAttack , real percentAttackSpeed ,real percentMove returns nothing
        local integer temp_defend = 0
        local integer temp_attack = 0
        local real temp_attackSpeed = 0
        local integer temp_move = 0
        //防御
        set temp_defend = R2I(I2R(Attr_Defend[playerIndex]) * percentDefend)
        if(temp_defend>=0)then
	        call SetUnitAbilityLevel(  targetUnit,Ability_defend_1000, (temp_defend/1000)+1 )
            set temp_defend = temp_defend - (temp_defend/1000)*1000
            call SetUnitAbilityLevel(  targetUnit,Ability_defend_100, (temp_defend/100)+1 )
            set temp_defend = temp_defend - (temp_defend/100)*100
            call SetUnitAbilityLevel(  targetUnit,Ability_defend_10, (temp_defend/10)+1 )
            set temp_defend = temp_defend - (temp_defend/10)*10
            call SetUnitAbilityLevel(  targetUnit,Ability_defend_1, temp_defend+1 )
        endif
        //攻击
        set temp_attack = R2I(I2R(Attr_Attack[playerIndex]) * percentAttack)
        if(temp_attack>=0)then
            call SetUnitAbilityLevel(  targetUnit,Ability_attack_1000, (temp_attack/10000)+1 )
            set temp_attack = temp_attack - (temp_attack/10000)*10000
            call SetUnitAbilityLevel(  targetUnit,Ability_attack_1000, (temp_attack/1000)+1 )
            set temp_attack = temp_attack - (temp_attack/1000)*1000
            call SetUnitAbilityLevel(  targetUnit,Ability_attack_100, (temp_attack/100)+1 )
            set temp_attack = temp_attack - (temp_attack/100)*100
            call SetUnitAbilityLevel(  targetUnit,Ability_attack_10, (temp_attack/10)+1 )
            set temp_attack = temp_attack - (temp_attack/10)*10
            call SetUnitAbilityLevel(  targetUnit,Ability_attack_1, temp_attack+1 )
        endif
        //攻击速度
        set temp_attackSpeed = Attr_AttackSpeed[playerIndex] * percentAttackSpeed
        if(temp_attackSpeed>=0)then
            call SetUnitAbilityLevel(  targetUnit,Ability_attackSpeed_100, R2I(temp_attackSpeed/100.00)+1 )
            set temp_attackSpeed = temp_attackSpeed - (temp_attackSpeed/100.00)*100.00
            call SetUnitAbilityLevel(  targetUnit,Ability_attackSpeed_10, R2I(temp_attackSpeed/10.00)+1 )
            set temp_attackSpeed = temp_attackSpeed - (temp_attackSpeed/10.00)*10.00
            call SetUnitAbilityLevel(  targetUnit,Ability_attackSpeed_1, R2I(temp_attackSpeed)+1 )
        endif
        //移动力
        set temp_move = R2I(I2R(Attr_Move[playerIndex]) * percentMove)
        if( temp_move>500 )  then
            call SetUnitMoveSpeed( targetUnit, 500 )
        else
            call SetUnitMoveSpeed( targetUnit, temp_move )
        endif
    endfunction

    /* 英雄属性 */
	public function formatHeroAttritube takes integer i returns nothing
        set Player_heros[i] = null
        set Player_heros_face[i] = "ReplaceableTextures\\CommandButtons\\BTNCancel.blp"
        set Player_heros_name[i] = "-"
        set Player_heros_isDead[i] = true
        set Player_heros_level[i] = 1
        set Player_heros_skillPoints[i] = 1
        //
        set Attr_Str_Life[i]          = "-"
        set Attr_Str_Mana[i]          = "-"
        set Attr_Str_LifeBack[i]      = "-"
        set Attr_Str_ManaBack[i]      = "-"
        set Attr_Str_Power[i]         = "-"
        set Attr_Str_Quick[i]         = "-"
        set Attr_Str_Skill[i]         = "-"
        set Attr_Str_SkillDamage[i]   = "-"
        set Attr_Str_Move[i]          = "-"
        set Attr_Str_Defend[i]        = "-"
        set Attr_Str_Attack[i]        = "-"
        set Attr_Str_AttackSpeed[i]   = "-"
        set Attr_Str_Toughness[i]     = "-"
        set Attr_Str_Avoid[i]         = "-"
        set Attr_Str_Knocking[i]      = "-"
        set Attr_Str_Violence[i]      = "-"
        set Attr_Str_Punish[i]        = "-"
        set Attr_Str_Help[i]          = "-"
        set Attr_Str_Hemophagia[i]    = "-"
        set Attr_Str_Split[i]         = "-"
        set Attr_Str_Weight[i]         = "-"
        set Attr_Str_GoldRatio[i]         = "-"
        set Attr_Str_LumberRatio[i]         = "-"
        set Attr_Str_ExpRatio[i]         = "-"
        //
        set Attr_PrevCache_Life[i] = 0
        set Attr_PrevCache_LifeBack[i] = 0
        set Attr_PrevCache_Mana[i] = 0
        set Attr_PrevCache_ManaBack[i] = 0
        set Attr_PrevCache_Defend[i] = 0
        set Attr_PrevCache_Move[i] = 0
        set Attr_PrevCache_Attack[i] = 0
        set Attr_PrevCache_AttackSpeed[i] = 0
        set Attr_PrevCache_Power[i] = 0
        set Attr_PrevCache_Quick[i] = 0
        set Attr_PrevCache_Skill[i] = 0
        set Attr_PrevCache_Help[i] = 0
        set Attr_PrevCache_Toughness[i] = 0
        set Attr_PrevCache_Avoid[i] = 0
        set Attr_PrevCache_Knocking[i] = 0
        set Attr_PrevCache_Violence[i] = 0
        set Attr_PrevCache_PunishFull[i] = 0
        set Attr_PrevCache_SkillDamage[i] = 0
        set Attr_PrevCache_Hemophagia[i] = 0
        set Attr_PrevCache_Split[i] = 0
        set Attr_PrevCache_Weight[i] = 0
        set Attr_PrevCache_GoldRatio[i] = 0
        set Attr_PrevCache_LumberRatio[i] = 0
        set Attr_PrevCache_ExpRatio[i] = 0
	endfunction

    /**
     * 打印某位玩家的属性到桌面
     */
    public function showOneAttrData takes integer playerIndex returns nothing
        local player p = ConvertedPlayer(playerIndex)
		call funcs_printTo(p,"生命："+Attr_Str_Life[playerIndex])
        call funcs_printTo(p,"魔法："+Attr_Str_Mana[playerIndex])
        call funcs_printTo(p,"生命恢复："+Attr_Str_LifeBack[playerIndex])
        call funcs_printTo(p,"魔法恢复："+Attr_Str_ManaBack[playerIndex])
		call funcs_printTo(p,"移动力："+Attr_Str_Move[playerIndex])
		call funcs_printTo(p,"防御："+Attr_Str_Defend[playerIndex])
		call funcs_printTo(p,"攻击："+Attr_Str_Attack[playerIndex])
		call funcs_printTo(p,"攻击速度："+Attr_Str_AttackSpeed[playerIndex])
		call funcs_printTo(p,"体质："+Attr_Str_Power[playerIndex])
		call funcs_printTo(p,"身法："+Attr_Str_Quick[playerIndex])
		call funcs_printTo(p,"技巧："+Attr_Str_Skill[playerIndex])
		call funcs_printTo(p,"韧性："+Attr_Str_Toughness[playerIndex])
		call funcs_printTo(p,"回避："+Attr_Str_Avoid[playerIndex])
		call funcs_printTo(p,"物暴："+Attr_Str_Knocking[playerIndex])
        call funcs_printTo(p,"术暴："+Attr_Str_Violence[playerIndex])
		call funcs_printTo(p,"硬直："+Attr_Str_Punish[playerIndex])
		call funcs_printTo(p,"技能输出力："+Attr_Str_SkillDamage[playerIndex])
		call funcs_printTo(p,"救助力："+Attr_Str_Help[playerIndex])
        call funcs_printTo(p,"负重："+Attr_Str_Weight[playerIndex])
        call funcs_printTo(p,"金钱获得比例："+Attr_Str_GoldRatio[playerIndex])
        call funcs_printTo(p,"木头获得比例："+Attr_Str_LumberRatio[playerIndex])
        call funcs_printTo(p,"经验获得比例："+Attr_Str_ExpRatio[playerIndex])
    endfunction

endlibrary

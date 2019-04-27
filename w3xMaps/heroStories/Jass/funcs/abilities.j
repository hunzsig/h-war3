library abilities requires funcs

    /**
     * 抽象添加技能法
     * level为null时，等级为1
     */
    private function abstractAddAbility takes unit u,integer abilityId,integer level returns nothing
        call UnitAddAbility( u, abilityId)
        call UnitMakeAbilityPermanent( u, true, abilityId)
        if( level>0 ) then
            call SetUnitAbilityLevel( u, abilityId, level )
        endif
    endfunction

    /**
     * 为单位注册一个技能，注册则默认1级
     */
    public function registAbility takes unit u,integer abilityId returns nothing
        call abstractAddAbility(u,abilityId,1)
    endfunction

    /**
     * 为单位添加一个技能
     */
    public function addAbility takes unit u,integer abilityId,integer level returns nothing
        call abstractAddAbility(u,abilityId,level)
    endfunction

    /**
     * 为单位添加N个同样的生命魔法技能 - 1级设0 2级设负 负减法（卡血牌bug）
     */
    public function setAbilityLM takes unit u,integer abilityId ,integer qty returns nothing
    	local integer i = 1
    	if( qty <= 0 )then
	    	return
		endif
    	loop
	    	exitwhen i > qty
	    		call UnitAddAbility( u, abilityId )
	    		call SetUnitAbilityLevel( u, abilityId, 2 )
	    		call UnitRemoveAbility( u, abilityId )
	    	set i = i+1
    	endloop
    endfunction

    /**
     * 删除一个技能
     */
    public function unsetAbility takes unit u,integer abilityId returns nothing
        call UnitRemoveAbility(u, abilityId)
    endfunction

    public function addBaseAbility takes unit hero returns nothing
        //护甲 1 10 100
        call abstractAddAbility( hero , Ability_defend_1 , 1 )
        call abstractAddAbility( hero , Ability_defend_10 , 1 )
        call abstractAddAbility( hero , Ability_defend_100 , 1 )
        //攻击力 1 10 100 1000
        call abstractAddAbility( hero , Ability_attack_1 , 1 )
        call abstractAddAbility( hero , Ability_attack_10 , 1 )
        call abstractAddAbility( hero , Ability_attack_100 , 1 )
        call abstractAddAbility( hero , Ability_attack_1000 , 1 )
        //攻击速度% 1 10 100
        call abstractAddAbility( hero , Ability_attackSpeed_1 , 1 )
        call abstractAddAbility( hero , Ability_attackSpeed_10 , 1 )
        call abstractAddAbility( hero , Ability_attackSpeed_100 , 1 )
        //力量 1 10 100 1000
        call abstractAddAbility( hero , Ability_power_1 , 1 )
        call abstractAddAbility( hero , Ability_power_10 , 1 )
        call abstractAddAbility( hero , Ability_power_100 , 1 )
        call abstractAddAbility( hero , Ability_power_1000 , 1 )
        //敏捷 1 10 100 1000
        call abstractAddAbility( hero , Ability_quick_1 , 1 )
        call abstractAddAbility( hero , Ability_quick_10 , 1 )
        call abstractAddAbility( hero , Ability_quick_100 , 1 )
        call abstractAddAbility( hero , Ability_quick_1000 , 1 )
        //智力 1 10 100 1000
        call abstractAddAbility( hero , Ability_skill_1 , 1 )
        call abstractAddAbility( hero , Ability_skill_10 , 1 )
        call abstractAddAbility( hero , Ability_skill_100 , 1 )
        call abstractAddAbility( hero , Ability_skill_1000 , 1 )
        //-------------------------负--------------------------------
        //-护甲 1 10 100
        call abstractAddAbility( hero , Ability_defend_FU_1 , 1 )
        call abstractAddAbility( hero , Ability_defend_FU_10 , 1 )
        call abstractAddAbility( hero , Ability_defend_FU_100 , 1 )
        //-攻击力 1 10 100 1000
        call abstractAddAbility( hero , Ability_attack_FU_1 , 1 )
        call abstractAddAbility( hero , Ability_attack_FU_10 , 1 )
        call abstractAddAbility( hero , Ability_attack_FU_100 , 1 )
        call abstractAddAbility( hero , Ability_attack_FU_1000 , 1 )
        //-攻击速度% 1 10 100
        call abstractAddAbility( hero , Ability_attackSpeed_FU_1 , 1 )
        call abstractAddAbility( hero , Ability_attackSpeed_FU_10 , 1 )
        call abstractAddAbility( hero , Ability_attackSpeed_FU_100 , 1 )
        //-力量 1 10 100 1000
        call abstractAddAbility( hero , Ability_power_FU_1 , 1 )
        call abstractAddAbility( hero , Ability_power_FU_10 , 1 )
        call abstractAddAbility( hero , Ability_power_FU_100 , 1 )
        call abstractAddAbility( hero , Ability_power_FU_1000 , 1 )
        //-敏捷 1 10 100 1000
        call abstractAddAbility( hero , Ability_quick_FU_1 , 1 )
        call abstractAddAbility( hero , Ability_quick_FU_10 , 1 )
        call abstractAddAbility( hero , Ability_quick_FU_100 , 1 )
        call abstractAddAbility( hero , Ability_quick_FU_1000 , 1 )
        //-智力 1 10 100 1000
        call abstractAddAbility( hero , Ability_skill_FU_1 , 1 )
        call abstractAddAbility( hero , Ability_skill_FU_10 , 1 )
        call abstractAddAbility( hero , Ability_skill_FU_100 , 1 )
        call abstractAddAbility( hero , Ability_skill_FU_1000 , 1 )
    endfunction

    /**
     * 打印某位玩家的通用技能到桌面
     */
    public function showOneAbilityLv takes integer playerIndex returns nothing
        local player p = ConvertedPlayer(playerIndex)
        call funcs_printTo(p,"护甲1:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_defend_1)))
        call funcs_printTo(p,"护甲10:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_defend_10)))
        call funcs_printTo(p,"护甲100:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_defend_100)))

        call funcs_printTo(p,"攻击1:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_attack_1)))
        call funcs_printTo(p,"攻击10:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_attack_10)))
        call funcs_printTo(p,"攻击100:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_attack_100)))
        call funcs_printTo(p,"攻击1000:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_attack_1000)))

        call funcs_printTo(p,"攻击速度1:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_attackSpeed_1)))
        call funcs_printTo(p,"攻击速度10:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_attackSpeed_10)))
        call funcs_printTo(p,"攻击速度100:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_attackSpeed_100)))

        call funcs_printTo(p,"力量1:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_power_1)))
        call funcs_printTo(p,"力量10:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_power_10)))
        call funcs_printTo(p,"力量100:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_power_100)))
        call funcs_printTo(p,"力量1000:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_power_1000)))

        call funcs_printTo(p,"敏捷 1:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_quick_1)))
        call funcs_printTo(p,"敏捷 10:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_quick_10)))
        call funcs_printTo(p,"敏捷 100:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_quick_100)))
        call funcs_printTo(p,"敏捷 1000:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_quick_1000)))

        call funcs_printTo(p,"智力 1:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_skill_1)))
        call funcs_printTo(p,"智力 10:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_skill_10)))
        call funcs_printTo(p,"智力 100:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_skill_100)))
        call funcs_printTo(p,"智力 1000:"  +  I2S(GetUnitAbilityLevel(Player_heros[playerIndex], Ability_skill_1000)))

    endfunction

endlibrary

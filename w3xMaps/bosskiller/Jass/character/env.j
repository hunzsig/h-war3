
//中立 Player(PLAYER_NEUTRAL_AGGRESSIVE)

library characterEnv requires skills

    //金矿适配器
    private function filter_gold takes nothing returns boolean
        local boolean bol = true
        if( GetUnitTypeId(GetFilterUnit()) != 'o01C' ) then
            set bol = false
        endif
        if( IsUnitAlly( GetFilterUnit(), Player_Ally_Building ) == false ) then
            set bol = false
        endif
        return bol
    endfunction

    //环境建筑受到伤害事件
    private function Gold_Damaged_Event takes nothing returns nothing
        local unit damageSource = GetEventDamageSource()
        local player damager= GetOwningPlayer(damageSource)
        local real damage = GetEventDamage()
        local unit village = GetTriggerUnit()
        local real villageLife = GetUnitState(village, UNIT_STATE_LIFE)
        local location loc = GetUnitLoc(village)
        local integer per = 0
        local integer i = 0
        if(damage<3)then
            return
        endif
        //重置伤害
        call skills_zeroInvulnerable(village)
        call SetUnitLifeBJ( village , villageLife-100 )

        if(GetUnitTypeId(village) == Unit_village_gold)then
            set per = (140+DIFF*10) * Enemy_Now
            call funcs_floatMsg( "|cffffcc00+" + I2S(per) + "G|r " , village )
            //分钱
            set i = 1
            loop
                exitwhen i > Max_Player_num
                    if ((GetPlayerController(Players[i]) == MAP_CONTROL_USER) and (GetPlayerSlotState(Players[i]) == PLAYER_SLOT_STATE_PLAYING)) then
                        call funcs_addGold( Players[i] , per )
                    endif
                set i = i + 1
            endloop
        elseif(GetUnitTypeId(village) == Unit_village_water)then
            set per = (90+DIFF*10) * Enemy_Now
            call funcs_floatMsg( "|cffc4c4ff+" + I2S(per) + "Exp|r " , village )
            //分钱
            set i = 1
            loop
                exitwhen i > Max_Player_num
                    if ((GetPlayerController(Players[i]) == MAP_CONTROL_USER) and (GetPlayerSlotState(Players[i]) == PLAYER_SLOT_STATE_PLAYING)) then
                        call AddHeroXPSwapped( per , Player_heros[i] , true )
                    endif
                set i = i + 1
            endloop
        endif
    endfunction

    //瞭望箭塔升级
    public function upLvArrow takes nothing returns nothing
        local integer i
        if( GetPlayerTechCountSimple( Village_upLevel_tec , Player_Ally_Building ) >= 100 ) then
            return
        endif
        //友军
        call SetPlayerTechResearched( Player_Ally_Building , Village_upLevel_tec , GetPlayerTechCountSimple(Village_upLevel_tec , Player_Ally_Building )+1  )
        //敌军
        call SetPlayerTechResearched( Player_Enemy_Building  , Village_upLevel_tec , GetPlayerTechCountSimple(Village_upLevel_tec , Player_Enemy_Building )+1  )
        //玩家
        set i = 1
        loop
            exitwhen i > Max_Player_num
                call SetPlayerTechResearched( Players[i]  , Village_upLevel_tec , GetPlayerTechCountSimple(Village_upLevel_tec ,Players[i])+1  )
            set i = i + 1
        endloop

    endfunction

    //金矿升级
    public function upLvGold takes nothing returns nothing
        local integer i
        if( GetPlayerTechCountSimple( Gold_upLevel_tec , Player_Ally_Building ) >= 100 ) then
            return
        else
            //友军
            call SetPlayerTechResearched( Player_Ally_Building , Gold_upLevel_tec , GetPlayerTechCountSimple(Gold_upLevel_tec , Player_Ally_Building )+1  )
            //敌军
            call SetPlayerTechResearched( Player_Enemy_Building  , Gold_upLevel_tec , GetPlayerTechCountSimple(Gold_upLevel_tec , Player_Enemy_Building )+1  )
             //玩家
            set i = 1
            loop
                exitwhen i > Max_Player_num
                    call SetPlayerTechResearched( Players[i]  , Gold_upLevel_tec , GetPlayerTechCountSimple(Gold_upLevel_tec ,Players[i])+1  )
                set i = i + 1
            endloop
        endif
    endfunction

	//初始化
    public function init takes nothing returns nothing
        local integer i = 0
        local trigger Gold_Damaged_Trigger = CreateTrigger()
        local integer rand = 0

        //环境受到伤害事件触发
        call TriggerAddAction( Gold_Damaged_Trigger , function Gold_Damaged_Event )
        //创建金矿
        set i = 1
        loop
            exitwhen i > Rect_Village_totalQty
                set rand = GetRandomInt(1,100)
                if(rand <= 50)then
                    call eventRegist_unitDamaged( Gold_Damaged_Trigger , CreateUnitAtLoc( Player_Enemy_Building ,Unit_village_gold,Center_Village[i], bj_UNIT_FACING ) )
                else
                    call eventRegist_unitDamaged( Gold_Damaged_Trigger , CreateUnitAtLoc( Player_Enemy_Building ,Unit_village_water,Center_Village[i], bj_UNIT_FACING ) )
                endif
            set i = i + 1
        endloop

        //创建瞭望箭塔
        set i = 1
        loop
            exitwhen i > Rect_Village_Big_totalQty
                call CreateUnitAtLoc( Player(PLAYER_NEUTRAL_PASSIVE) ,Unit_village_big,Center_Village_Big[i], bj_UNIT_FACING )
            set i = i + 1
        endloop

        call funcs_setTimeout(120.00,function upLvGold)

    endfunction


endlibrary

/**
 * Boss死亡后事件都在这里
 */

function Trig_event_transferActions takes nothing returns nothing
    local unit triggerUnit = GetTriggerUnit()
    local unit killer = GetKillingUnit()
    local integer playerIndex = GetConvertedPlayerId(GetOwningPlayer(killer))
    local integer i = 0
    local group heroGroup = null
    local location loc = null
    local integer exp = 0
    local integer gold = 0
    local integer lumber = 0

    call StartSound( gg_snd_NewTournament )
    call funcs_print( "|cffffff00"+GetUnitName(Player_heros[playerIndex])+"|r狠狠地击杀了Boss - |cffff0000" + GetUnitName(triggerUnit) +"|r" )

    set i = 1
    loop
        exitwhen i > Enemy_Type_Total_Qty
            if( Enemy_Boss_Unit[i] == triggerUnit ) then
		        call characterEnemyEnv_del(i)
                //设置Boss已被杀
                set Enemy_Config_Final_Killed[i] = true
                //检测是否有额外奖励
                if( Enemy_Config_Final_Attacked[i] == false ) then
	                //根据模式计算资源
			        set exp  = DIFF*2000 + R2I(    (7500 * I2R(Enemy_Now)) * (1+I2R(Current_Player_num-1)*0.25)       )
                    set gold = DIFF*3500 + R2I(    (10000 * I2R(Enemy_Now)) * (1+I2R(Current_Player_num-1)*0.35)       )
                    set lumber = 3 * Current_Player_num + DIFF

                    set loc = GetUnitLoc( triggerUnit )
                    set heroGroup = funcs_getGroupByPoint( loc , Share_Range , function filter_live_hero )
                    call share_awardGroup( exp , gold , lumber , heroGroup )
                    call GroupClear(heroGroup)
                    call DestroyGroup(heroGroup)
                    call RemoveLocation(loc)
                endif
                call DoNothing() YDNL exitwhen true//(  )
            endif
        set i = i + 1
    endloop

    //升级所有相关角色科技
    call scheduleGroup_update()

endfunction

//===========================================================================
function InitTrig_event_transfer takes nothing returns nothing
    set gg_trg_event_transfer = CreateTrigger()
    call TriggerAddAction(gg_trg_event_transfer, function Trig_event_transferActions)
endfunction


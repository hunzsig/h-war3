globals
    //随机池以单位等级来计算
    //例如1级的单位取的是1-10的随机物品
    //随机物品数量是 20 + (4+Enemy_Now) * (DIFF-1)
    boolean awards_isInit = false
    integer array awardItemIds

    integer Boss_Item_Tec_san_greal = 'R00N'
    integer Boss_Item_Tec_spike_pelage = 'R00O'
    integer Boss_Item_Tec_ghoul_eye = 'R00P'
    integer Boss_Item_Tec_ghoul_meat = 'R00Q'
    integer Boss_Item_Tec_ghoul_tooth = 'R00R'
    integer Boss_Item_Tec_bomb = 'R00S'
    integer Boss_Item_Tec_exquisite = 'R00T'
    integer Boss_Item_Tec_snake_bravery = 'R00U'
    integer Boss_Item_Tec_evil_soul = 'R00V'
    integer Boss_Item_Tec_evil_dragon_heart = 'R00W'
    integer Boss_Item_Tec_silver_shell = 'R00X'
    integer Boss_Item_Tec_big_stone = 'R00Y'

endglobals

function Trig_event_awardSetTec takes integer tecId returns nothing
    local integer i = 0
    if( GetPlayerTechCountSimple( tecId , Player_Ally_Building ) >= 1 ) then
        return
    else
        call SetPlayerTechResearched( Player_Ally_Building , tecId , 1 )
    endif

endfunction

function Trig_event_awardInit takes nothing returns nothing
    local integer i = 0
    if( awards_isInit == false) then
        set awards_isInit = true
        set awardItemIds[1] = 'I034'          	//金币45
        set awardItemIds[2] = 'I036'          	//金币60
        set awardItemIds[3] = 'I037'          	//金币80
        set awardItemIds[4] = 'I038'          	//金币100
        set awardItemIds[5] = 'I03A'         	//金币150
        set awardItemIds[6] = 'I03B'        	//金币175
        set awardItemIds[7] = 'I03C'        	//金币200
        set awardItemIds[8] = 'I008'        	//金币250
        set awardItemIds[9] = 'I03D'        	//金币300
        set awardItemIds[10] = 'I02E'        	//金币450
        set awardItemIds[11] = 'I02F'        	//金币500
        set awardItemIds[12] = 'I02G'        	//金币750
        set awardItemIds[13] = 'I02N'        	//金币1000
        set awardItemIds[14] = 'I02O'        	//金币1500
        set awardItemIds[15] = 'I02P'        	//金币2500
        set awardItemIds[16] = 'I00H'        	//生命水 50%
        set awardItemIds[17] = 'I00S'        	//魔法水 50%
        set awardItemIds[18] = 'I009'        	//生命水 100%
        set awardItemIds[19] = 'I00B'        	//魔法水 100%
        set awardItemIds[20] = 'I07V'        	//隐身
        set awardItemIds[21] = 'I03U'        	//无敌小
        set awardItemIds[22] = 'I00W'        	//无敌大
        set awardItemIds[23] = 'I07V'        	//隐身
        set awardItemIds[24] = 'I07V'        	//隐身
        //25  -  29
        set i = 25
        loop
            exitwhen i > 29
                set awardItemIds[i] = 'I099'        //荆木
            set i = i +1
        endloop
        //30  -  40
        set i = 30
        loop
            exitwhen i > 40
                set awardItemIds[i] = 'I018'        //奇迹
            set i = i +1
        endloop
    endif
endfunction

function Trig_event_awardActions takes nothing returns nothing
    local unit triggerUnit = GetTriggerUnit()
    local integer unitTypeId = GetUnitTypeId(triggerUnit)
    local integer unitLevel = GetUnitLevel(triggerUnit)
    local integer dropQty = 20 + (4+Enemy_Now) + SetDropQty[DIFF]
    local integer i = 0
    local location loc = null
    local integer randomItemId = 0
    local integer randMin = Enemy_Now + (Enemy_Now-1) * 2
    local integer randMax = 40
    local group heroGroup = null
    local integer exp = 0
    local integer gold = 0
    local integer lumber = 0
    local item it = null

    //debug
    if( Enemy_Now < 1 )then
        return
    endif
    //如果没有初始化 就初始化一下
    call Trig_event_awardInit()

	/* 真实奖励 */
    call StartSound( gg_snd_audio_gandepiaoliang )

	//分经验分钱
	//根据模式计算资源
    set exp  = DIFF*2000 + R2I(    (7500 * I2R(Enemy_Now)) * (1+I2R(Current_Player_num-1)*0.25)       )
    set gold = DIFF*3500 + R2I(    (10000 * I2R(Enemy_Now)) * (1+I2R(Current_Player_num-1)*0.35)       )
    set lumber = 3 * Current_Player_num + DIFF
    
    set loc = GetUnitLoc(triggerUnit)
    set heroGroup = funcs_getGroupByPoint( loc , Share_Range , function filter_live_hero )
    call share_awardGroup( exp , gold , lumber , heroGroup )
    call GroupClear(heroGroup)
    call DestroyGroup(heroGroup)
    call RemoveLocation(loc)

    //普通掉落
    set i = 1
    set loc = GetUnitLoc(triggerUnit)
    loop
        exitwhen i > dropQty
            set randomItemId = awardItemIds[GetRandomInt(randMin,randMax)]
            set it = CreateItem(randomItemId, GetLocationX(loc), GetLocationY(loc))
            call items_delItem( it , 60.00 )
        set i = i +1
    endloop

    //特殊物品权限开启
    //-------------------------------------------

    //圣杯
    if( unitTypeId == 'n01O'  or unitTypeId == 'n03Z'  or unitTypeId == 'n02C'  ) then
        call Trig_event_awardSetTec(Boss_Item_Tec_san_greal)
    endif
    //尖刺毛胚
    if( unitTypeId == 'n02N'  or unitTypeId == 'n00N'  ) then
        call Trig_event_awardSetTec(Boss_Item_Tec_spike_pelage)
    endif
    //尸鬼目
    if( unitTypeId == 'n005'  or unitTypeId == 'n00N'  or unitTypeId == 'n01K'   ) then
        call Trig_event_awardSetTec(Boss_Item_Tec_ghoul_eye)
    endif
    //尸鬼肉
    if( unitTypeId == 'n005'  or unitTypeId == 'n03Y'  ) then
        call Trig_event_awardSetTec(Boss_Item_Tec_ghoul_meat)
    endif
    //尸鬼齿
    if( unitTypeId == 'n02P'  or unitTypeId == 'n02O'  ) then
        call Trig_event_awardSetTec(Boss_Item_Tec_ghoul_tooth)
    endif
    //炸弹
    if( unitTypeId == 'n00K'  or unitTypeId == 'n03Z'  ) then
        call Trig_event_awardSetTec(Boss_Item_Tec_bomb)
    endif
    //玲珑
    if( unitTypeId == 'n03F'  or unitTypeId == 'n01Y'  or unitTypeId == 'n03G'  ) then
        call Trig_event_awardSetTec(Boss_Item_Tec_exquisite)
    endif
    //蛇胆
    if( unitTypeId == 'n02B'  or unitTypeId == 'n03F'  ) then
        call Trig_event_awardSetTec(Boss_Item_Tec_snake_bravery)
    endif
    //邪魂
    if( unitTypeId == 'n00M'  or unitTypeId == 'n02C'  or unitTypeId == 'n020'  ) then
        call Trig_event_awardSetTec(Boss_Item_Tec_evil_soul)
    endif
    //邪龙心
    if( unitTypeId == 'n01Y'  or unitTypeId == 'n040'  or unitTypeId == Enemy_Type_Dragon_Red or unitTypeId == Enemy_Type_Dragon_Black ) then
        call Trig_event_awardSetTec(Boss_Item_Tec_evil_dragon_heart)
    endif
    //银灰壳
    if( unitTypeId == 'n02P'  or unitTypeId == 'n03K'  ) then
        call Trig_event_awardSetTec(Boss_Item_Tec_silver_shell)
    endif
    //岩石
    if( unitTypeId == 'n004'  or unitTypeId == 'n02D'  ) then
        call Trig_event_awardSetTec(Boss_Item_Tec_big_stone)
    endif

    call RemoveLocation(loc)
endfunction

//===========================================================================
function InitTrig_event_award takes nothing returns nothing
    set gg_trg_event_award = CreateTrigger()
    call TriggerAddAction(gg_trg_event_award, function Trig_event_awardActions)
endfunction


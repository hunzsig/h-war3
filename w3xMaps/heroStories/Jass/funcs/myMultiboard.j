globals

	/* 多面板 */
	//多面板检查，用来检查此用户是否已经显示在上面
	//用来跳过那些非玩家 无玩家的玩家列
	//这样3个玩家就只会显示3个，而不需要多余的列来显示null
	boolean array MultiboardCheck

endglobals


library myMultiboard requires funcs

	/**
     * 创建信息多面板
     */
    public function create takes nothing returns nothing
        local integer i
        local integer j
        local multiboard mb = GetLastCreatedMultiboard()
        local string spStr  //特殊字符
        local string array apmStr //APM字符
        local integer array ce //战力字符
        set i = 1
        loop
            exitwhen i > Max_Player_num
                set MultiboardCheck[i] = false
                //计算APM
                if (System_time_count > 60) then
                    set apmStr[i] = "|cffffff00"+I2S(R2I( I2R(Apm[i])  / ( I2R(System_time_count) / 60.00 ))) + "|r"
                else
                    set apmStr[i] = "|cffffff00"+I2S(Apm[i]) +"|r"
                endif
                //战力
                if( GetPlayerSlotState(Players[i]) == PLAYER_SLOT_STATE_PLAYING )then
                    set ce[i] = 0
                    set ce[i] = ce[i] + GetUnitLevel(Player_heros[i]) * 10
                    set ce[i] = ce[i] + GetHeroStatBJ(bj_HEROSTAT_STR, Player_heros[i], true)
                    set ce[i] = ce[i] + GetHeroStatBJ(bj_HEROSTAT_AGI, Player_heros[i], true)
                    set ce[i] = ce[i] + GetHeroStatBJ(bj_HEROSTAT_INT, Player_heros[i], true)
                    set ce[i] = ce[i] + Attr_Life[i] /10 + Attr_Mana[i] /10
                    set ce[i] = ce[i] + Attr_Attack[i] + R2I(Attr_AttackSpeed[i] * 2)
                    set ce[i] = ce[i] + R2I(Attr_Toughness[i]) * 2
                    set ce[i] = ce[i] + Attr_Avoid[i] + Attr_Knocking[i] /2 + Attr_Violence[i] /2 + Attr_Hemophagia[i] + Attr_Split[i] + Attr_PunishFull[i]/16
                    set ce[i] = ce[i] + Attr_Move[i] + Attr_SkillDamage[i]/8 + Attr_Help[i] /4
                else
                    set ce[i] = 0
                endif
            set i = i + 1
        endloop

        //如果有旧的多面板则删除
        if(mb != null) then
            call DestroyMultiboard( GetLastCreatedMultiboard() )
        endif

        //建一个当前（玩家数+1）的多面板
        call CreateMultiboardBJ( 22, ( Start_Player_num + 1 ), "数据统计["+CurrentGameTitle+"]" )
        call MultiboardSetItemWidthBJ( GetLastCreatedMultiboard(), 0, 0, 2.40 )
        call MultiboardSetItemStyleBJ( GetLastCreatedMultiboard(), 0, 0, true, false )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 1, 1, "玩家名称" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 2, 1, "英雄角色" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 3, 1, "活力+恢复" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 4, 1, "魔法+恢复" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 5, 1, "攻击速度" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 6, 1, "韧性" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 7, 1, "回避" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 8, 1, "物暴" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 9, 1, "术暴" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 10, 1, "吸血" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 11, 1, "分裂" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 12, 1, "硬直" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 13, 1, "移动力" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 14, 1, "冥想力" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 15, 1, "救助力" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 16, 1, "负重" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 17, 1, "黄金率" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 18, 1, "水晶率" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 19, 1, "经验率" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 20, 1, "战力" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 21, 1, "状态" )
        call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 22, 1, "APM" )
        set i = 1
        set j = 1
        loop
            exitwhen j > Max_Player_num
            if ( (GetPlayerController(Players[j]) == MAP_CONTROL_USER) and Player_names[j] != "没有玩家" ) then
                set i = i + 1
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 1, i, Player_names[j] )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 2, i, Player_heros_name[j] )
                call MultiboardSetItemIconBJ( GetLastCreatedMultiboard(), 2, i, Player_heros_face[j] )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 3, i, Attr_Str_Life[j] + " + " + Attr_Str_LifeBack[j] +"点/秒"  )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 4, i, Attr_Str_Mana[j] + " + " + Attr_Str_ManaBack[j] +"点/秒"  )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 5, i, Attr_Str_AttackSpeed[j]+"击/秒("+I2S(R2I(Attr_AttackSpeed[j]))+"%)"  )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 6, i, Attr_Str_Toughness[j] )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 7, i, Attr_Str_Avoid[j] )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 8, i, Attr_Str_Knocking[j] )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 9, i, Attr_Str_Violence[j] )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 10, i, Attr_Str_Hemophagia[j]+"%" )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 11, i, Attr_Str_Split[j]+"%" )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 12, i, I2S(Attr_PunishCurrent[j])+ "/" + Attr_Str_Punish[j] )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 13, i, Attr_Str_Move[j] )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 14, i, Attr_Str_SkillDamage[j] )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 15, i, Attr_Str_Help[j] )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 16, i, Attr_Str_Weight[j] )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 17, i, Attr_Str_GoldRatio[j]+"%" )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 18, i, Attr_Str_LumberRatio[j]+"%" )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 19, i, Attr_Str_ExpRatio[j]+"%" )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 20, i, I2S(ce[j]) )
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 21, i, Player_heros_status[j])
                call MultiboardSetItemValueBJ( GetLastCreatedMultiboard(), 22, i, apmStr[j] )
            endif
            set j = j + 1
        endloop
        call MultiboardSetItemWidthBJ( GetLastCreatedMultiboard(), 1, 0, 4.00 )
        call MultiboardSetItemWidthBJ( GetLastCreatedMultiboard(), 2, 0, 4.50 )
        call MultiboardSetItemStyleBJ( GetLastCreatedMultiboard(), 2, 0, true, true )
        call MultiboardSetItemIconBJ( GetLastCreatedMultiboard(), 2, 1, "ReplaceableTextures\\CommandButtons\\BTNSkillz.blp" )
        call MultiboardSetItemWidthBJ( GetLastCreatedMultiboard(), 3, 0, 4.80 )
        call MultiboardSetItemWidthBJ( GetLastCreatedMultiboard(), 4, 0, 4.80 )
        call MultiboardSetItemWidthBJ( GetLastCreatedMultiboard(), 5, 0, 5.00 )
        call MultiboardSetItemWidthBJ( GetLastCreatedMultiboard(), 12, 0, 3.80 )
        call MultiboardSetItemWidthBJ( GetLastCreatedMultiboard(), 16, 0, 4.60 )
        call MultiboardSetItemWidthBJ( GetLastCreatedMultiboard(), 20, 0, 3.80 )
        call MultiboardDisplayBJ( true, GetLastCreatedMultiboard() )
    endfunction

endlibrary

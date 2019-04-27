library forge requires skills

    /**
     * 检查锻造等级
     */
     private function check takes integer playerIndex,integer itemId,player p returns boolean
        local integer Max_Life = 0
        local integer Max_LifeBack = 0
        local integer Max_Mana = 0
        local integer Max_ManaBack = 0
        local integer Max_Defend = 0
        local integer Max_Move = 10
        local integer Max_Attack = 0
        local integer Max_AttackSpeed = 0
        local integer Max_Power = 0
        local integer Max_Quick = 0
        local integer Max_Skill = 0
        local integer Max_Help = 30
        local boolean Allow = TRUE
        local string tips
        if( itemId == Forge_itemType_Life) then
            if(Max_Life!=0 and ForgeLv_Life[playerIndex] >= Max_Life) then
                set Allow = FALSE
                set tips = "此部件锻造已满上限"+I2S(Max_Life)+"级"
                call funcs_addGold(p,200)//归还金额
            endif
        elseif( itemId == Forge_itemType_LifeBack) then
            if(Max_LifeBack!=0 and ForgeLv_LifeBack[playerIndex] >= Max_LifeBack) then
                set Allow = FALSE
                set tips = "此部件锻造已满上限"+I2S(Max_LifeBack)+"级"
                call funcs_addGold(p,250)//归还金额
            endif
        elseif( itemId == Forge_itemType_Mana) then
            if(Max_Mana!=0 and ForgeLv_Mana[playerIndex] >= Max_Mana) then
                set Allow = FALSE
                set tips = "此部件锻造已满上限"+I2S(Max_Mana)+"级"
                call funcs_addGold(p,200)//归还金额
            endif
        elseif( itemId == Forge_itemType_ManaBack) then
            if(Max_ManaBack!=0 and ForgeLv_ManaBack[playerIndex] >= Max_ManaBack) then
                set Allow = FALSE
                set tips = "此部件锻造已满上限"+I2S(Max_ManaBack)+"级"
                call funcs_addGold(p,250)//归还金额
            endif
        elseif( itemId == Forge_itemType_Defend) then
            if(Max_Defend!=0 and ForgeLv_Defend[playerIndex] >= Max_Defend) then
                set Allow = FALSE
                set tips = "此部件锻造已满上限"+I2S(Max_Defend)+"级"
                call funcs_addGold(p,350)//归还金额
            endif
        elseif( itemId == Forge_itemType_Move) then
            if(Max_Move!=0 and ForgeLv_Move[playerIndex] >= Max_Move) then
                set Allow = FALSE
                set tips = "此部件锻造已满上限"+I2S(Max_Move)+"级"
                call funcs_addGold(p,350)//归还金额
            endif
        elseif( itemId == Forge_itemType_Attack) then
            if(Max_Attack!=0 and ForgeLv_Attack[playerIndex] >= Max_Attack) then
                set Allow = FALSE
                set tips = "此部件锻造已满上限"+I2S(Max_Attack)+"级"
                call funcs_addGold(p,350)//归还金额
            endif
        elseif( itemId == Forge_itemType_AttackSpeed) then
            if(Max_AttackSpeed!=0 and ForgeLv_AttackSpeed[playerIndex] >= Max_AttackSpeed) then
                set Allow = FALSE
                set tips = "此部件锻造已满上限"+I2S(Max_AttackSpeed)+"级"
                call funcs_addGold(p,350)//归还金额
            endif
        elseif( itemId == Forge_itemType_Power) then
            if(Max_Power!=0 and ForgeLv_Power[playerIndex] >= Max_Power) then
                set Allow = FALSE
                set tips = "此部件锻造已满上限"+I2S(Max_Power)+"级"
                call funcs_addGold(p,450)//归还金额
            endif
        elseif( itemId == Forge_itemType_Quick) then
            if(Max_Quick!=0 and ForgeLv_Quick[playerIndex] >= Max_Quick) then
                set Allow = FALSE
                set tips = "此部件锻造已满上限"+I2S(Max_Quick)+"级"
                call funcs_addGold(p,450)//归还金额
            endif
        elseif( itemId == Forge_itemType_Skill) then
            if(Max_Skill!=0 and ForgeLv_Skill[playerIndex] >= Max_Skill) then
                set Allow = FALSE
                set tips = "此部件锻造已满上限"+I2S(Max_Skill)+"级"
                call funcs_addGold(p,450)//归还金额
            endif
        elseif( itemId == Forge_itemType_Help) then
            if(Max_Help!=0 and ForgeLv_Help[playerIndex] >= Max_Help) then
                set Allow = FALSE
                set tips = "此部件锻造已满上限"+I2S(Max_Help)+"级"
                call funcs_addGold(p,500)//归还金额
            endif
        endif
        if(Allow == FALSE) then
            call funcs_printTo(p,tips)
        endif
        return Allow
    endfunction

    /**
     * 比较几率
     */
    private function compare takes integer playerIndex,integer itemId returns boolean
        local integer Num_randomMax
        local integer Num_compare
        local integer var_i = 1     //参数1
        local integer var_j = 1     //参数2
        local integer var_k = 1     //参数3
        local integer var_forgeLv
        local integer var_helpLv
        if( itemId == Forge_itemType_Life) then
            set var_i = 1
            set var_j = 12
            set var_k = 13
            set var_forgeLv = ForgeLv_Life[playerIndex]
            set var_helpLv = Forge_upHelper_Life[playerIndex]
        elseif( itemId == Forge_itemType_LifeBack) then
            set var_i = 1
            set var_j = 12
            set var_k = 13
            set var_forgeLv = ForgeLv_LifeBack[playerIndex]
            set var_helpLv = Forge_upHelper_LifeBack[playerIndex]
        elseif( itemId == Forge_itemType_Mana) then
            set var_i = 1
            set var_j = 12
            set var_k = 13
            set var_forgeLv = ForgeLv_Mana[playerIndex]
            set var_helpLv = Forge_upHelper_Mana[playerIndex]
        elseif( itemId == Forge_itemType_ManaBack) then
            set var_i = 1
            set var_j = 12
            set var_k = 13
            set var_forgeLv = ForgeLv_ManaBack[playerIndex]
            set var_helpLv = Forge_upHelper_ManaBack[playerIndex]
        elseif( itemId == Forge_itemType_Defend) then
            set var_i = 2
            set var_j = 15
            set var_k = 17
            set var_forgeLv = ForgeLv_Defend[playerIndex]
            set var_helpLv = Forge_upHelper_Defend[playerIndex]
        elseif( itemId == Forge_itemType_Move) then
            set var_i = 2
            set var_j = 15
            set var_k = 17
            set var_forgeLv = ForgeLv_Move[playerIndex]
            set var_helpLv = Forge_upHelper_Move[playerIndex]
        elseif( itemId == Forge_itemType_Attack) then
            set var_i = 2
            set var_j = 15
            set var_k = 17
            set var_forgeLv = ForgeLv_Attack[playerIndex]
            set var_helpLv = Forge_upHelper_Attack[playerIndex]
        elseif( itemId == Forge_itemType_AttackSpeed) then
            set var_i = 2
            set var_j = 15
            set var_k = 17
            set var_forgeLv = ForgeLv_AttackSpeed[playerIndex]
            set var_helpLv = Forge_upHelper_AttackSpeed[playerIndex]
        elseif( itemId == Forge_itemType_Power) then
            set var_i = 3
            set var_j = 10
            set var_k = 13
            set var_forgeLv = ForgeLv_Power[playerIndex]
            set var_helpLv = Forge_upHelper_Power[playerIndex]
        elseif( itemId == Forge_itemType_Quick) then
            set var_i = 3
            set var_j = 10
            set var_k = 13
            set var_forgeLv = ForgeLv_Quick[playerIndex]
            set var_helpLv = Forge_upHelper_Quick[playerIndex]
        elseif( itemId == Forge_itemType_Skill) then
            set var_i = 3
            set var_j = 10
            set var_k = 13
            set var_forgeLv = ForgeLv_Skill[playerIndex]
            set var_helpLv = Forge_upHelper_Skill[playerIndex]
        elseif( itemId == Forge_itemType_Help) then
            set var_i = 3
            set var_j = 0
            set var_k = 6
            set var_forgeLv = ForgeLv_Help[playerIndex]
            set var_helpLv = Forge_upHelper_Help[playerIndex]
        endif
        set Num_randomMax = var_forgeLv * var_i + var_j
        set Num_compare   = var_helpLv + var_k
        return (GetRandomInt(0,Num_randomMax) <= Num_compare )
    endfunction

    /**
     * 锻造失败
     **/
    private function fail takes integer playerIndex,integer itemId,player p returns nothing
        local real successPercent = 0.00
        if( itemId == Forge_itemType_Life) then
            //生命
            set Forge_upHelper_Life[playerIndex] = Forge_upHelper_Life[playerIndex] + 1
            set successPercent = 100.00 * ((13.00 + I2R(Forge_upHelper_Life[playerIndex])) / (I2R(ForgeLv_Life[playerIndex]) * 1.00 + 12.00 ))
        elseif( itemId == Forge_itemType_LifeBack) then
            //生命恢复
            set Forge_upHelper_LifeBack[playerIndex] = Forge_upHelper_LifeBack[playerIndex] + 1
            set successPercent = 100.00 * ((13.00 + I2R(Forge_upHelper_LifeBack[playerIndex])) / (I2R(ForgeLv_LifeBack[playerIndex]) * 1.00 + 12.00 ))
        elseif( itemId == Forge_itemType_Mana) then
            //魔法
            set Forge_upHelper_Mana[playerIndex] = Forge_upHelper_Mana[playerIndex] + 1
            set successPercent = 100.00 * ((13.00 + I2R(Forge_upHelper_Mana[playerIndex])) / (I2R(ForgeLv_Mana[playerIndex]) * 1.00 + 12.00 ))
        elseif( itemId == Forge_itemType_ManaBack) then
            //魔法恢复
            set Forge_upHelper_ManaBack[playerIndex] = Forge_upHelper_ManaBack[playerIndex] + 1
            set successPercent = 100.00 * ((13.00 + I2R(Forge_upHelper_ManaBack[playerIndex])) / (I2R(ForgeLv_ManaBack[playerIndex]) * 1.00 + 12.00 ))
        elseif( itemId == Forge_itemType_Defend) then
            //防御
            set Forge_upHelper_Defend[playerIndex] = Forge_upHelper_Defend[playerIndex] + 1
            set successPercent = 100.00 * ((17.00 + I2R(Forge_upHelper_Defend[playerIndex])) / (I2R(ForgeLv_Defend[playerIndex]) * 2.00 + 15.00 ))
        elseif( itemId == Forge_itemType_Move) then
            //移动
            set Forge_upHelper_Move[playerIndex] = Forge_upHelper_Move[playerIndex] + 1
            set successPercent = 100.00 * ((17.00 + I2R(Forge_upHelper_Move[playerIndex])) / (I2R(ForgeLv_Move[playerIndex]) * 2.00 + 15.00 ))
        elseif( itemId == Forge_itemType_Attack) then
            //攻击力
            set Forge_upHelper_Attack[playerIndex] = Forge_upHelper_Attack[playerIndex] + 1
            set successPercent = 100.00 * ((17.00 + I2R(Forge_upHelper_Attack[playerIndex])) / (I2R(ForgeLv_Attack[playerIndex]) * 2.00 + 15.00 ))
        elseif( itemId == Forge_itemType_AttackSpeed) then
            //攻击速度
            set Forge_upHelper_AttackSpeed[playerIndex] = Forge_upHelper_AttackSpeed[playerIndex] + 1
            set successPercent = 100.00 * ((17.00 + I2R(Forge_upHelper_AttackSpeed[playerIndex])) / (I2R(ForgeLv_AttackSpeed[playerIndex]) * 2.00 + 15.00 ))
        elseif( itemId == Forge_itemType_Power) then
            //体质
            set Forge_upHelper_Power[playerIndex] = Forge_upHelper_Power[playerIndex] + 1
            set successPercent = 100.00 * ((13.00 + I2R(Forge_upHelper_Power[playerIndex])) / (I2R(ForgeLv_Power[playerIndex]) * 3.00 + 10.00 ))
        elseif( itemId == Forge_itemType_Quick) then
            //身法
            set Forge_upHelper_Quick[playerIndex] = Forge_upHelper_Quick[playerIndex] + 1
            set successPercent = 100.00 * ((13.00 + I2R(Forge_upHelper_Quick[playerIndex])) / (I2R(ForgeLv_Quick[playerIndex]) * 3.00 + 10.00 ))
        elseif( itemId == Forge_itemType_Skill) then
            //技巧
            set Forge_upHelper_Skill[playerIndex] = Forge_upHelper_Skill[playerIndex] + 1
            set successPercent = 100.00 * ((13.00 + I2R(Forge_upHelper_Skill[playerIndex])) / (I2R(ForgeLv_Skill[playerIndex]) * 3.00 + 10.00 ))
        elseif( itemId == Forge_itemType_Help) then
            //救助力
            set Forge_upHelper_Help[playerIndex] = Forge_upHelper_Help[playerIndex] + 1
            set successPercent = 100.00 * ((6.00 + I2R(Forge_upHelper_Help[playerIndex])) / (I2R(ForgeLv_Help[playerIndex]) * 3.00 + 0.00 ))
        else
        endif
        call funcs_printTo(p,"锻造失败！下次锻造成功几率：" + I2S(R2I(successPercent)) + "%")
    endfunction

    /**
     * 执行锻造
     */
    public function action takes integer playerIndex,integer itemId,player p returns nothing
        local boolean Limit = TRUE
        local boolean Fail = TRUE
        local string tips
        local integer Level

        //检查上限
        set Limit = check(playerIndex,itemId,p)
        if(Limit==FALSE) then
            return
        endif

        //开始锻造，计算成功率
        set Fail = compare(playerIndex,itemId)
        if(Fail==FALSE) then
            call fail(playerIndex,itemId,p)
            return
        endif

        //如果成功则体现锻造结果
        if( itemId == Forge_itemType_Life) then
            //生命
            set Forge_upHelper_Life[playerIndex] = 0
            set ForgeLv_Life[playerIndex] = ForgeLv_Life[playerIndex] + 1
            set Level = ForgeLv_Life[playerIndex]
            set tips = "头盔"
        elseif( itemId == Forge_itemType_LifeBack) then
            //生命恢复
            set Forge_upHelper_LifeBack[playerIndex] = 0
            set ForgeLv_LifeBack[playerIndex] = ForgeLv_LifeBack[playerIndex] + 1
            set Level = ForgeLv_LifeBack[playerIndex]
            set tips = "胸甲"
        elseif( itemId == Forge_itemType_Mana) then
            //魔法
            set Forge_upHelper_Mana[playerIndex] = 0
            set ForgeLv_Mana[playerIndex] = ForgeLv_Mana[playerIndex] + 1
            set Level = ForgeLv_Mana[playerIndex]
            set tips = "臂环"
        elseif( itemId == Forge_itemType_ManaBack) then
            //魔法恢复
            set Forge_upHelper_ManaBack[playerIndex] = 0
            set ForgeLv_ManaBack[playerIndex] = ForgeLv_ManaBack[playerIndex] + 1
            set Level = ForgeLv_ManaBack[playerIndex]
            set tips = "戒指"
        elseif( itemId == Forge_itemType_Defend) then
            //防御
            set Forge_upHelper_Defend[playerIndex] = 0
            set ForgeLv_Defend[playerIndex] = ForgeLv_Defend[playerIndex] + 1
            set Level = ForgeLv_Defend[playerIndex]
            set tips = "身甲"
        elseif( itemId == Forge_itemType_Move) then
            //移动
            set Forge_upHelper_Move[playerIndex] = 0
            set ForgeLv_Move[playerIndex] = ForgeLv_Move[playerIndex] + 1
            set Level = ForgeLv_Move[playerIndex]
            set tips = "行履"
        elseif( itemId == Forge_itemType_Attack) then
            //攻击
            set Forge_upHelper_Attack[playerIndex] = 0
            set ForgeLv_Attack[playerIndex] = ForgeLv_Attack[playerIndex] + 1
            set Level = ForgeLv_Attack[playerIndex]
            set tips = "武器"
        elseif( itemId == Forge_itemType_AttackSpeed) then
            //攻击速度
            set Forge_upHelper_AttackSpeed[playerIndex] = 0
            set ForgeLv_AttackSpeed[playerIndex] = ForgeLv_AttackSpeed[playerIndex] + 1
            set Level = ForgeLv_AttackSpeed[playerIndex]
            set tips = "手套"
        elseif( itemId == Forge_itemType_Power) then
            //体质
            set Forge_upHelper_Power[playerIndex] = 0
            set ForgeLv_Power[playerIndex] = ForgeLv_Power[playerIndex] + 1
            set Level = ForgeLv_Power[playerIndex]
            set tips = "下装"
        elseif( itemId == Forge_itemType_Quick) then
            //身法
            set Forge_upHelper_Quick[playerIndex] = 0
            set ForgeLv_Quick[playerIndex] = ForgeLv_Quick[playerIndex] + 1
            set Level = ForgeLv_Quick[playerIndex]
            set tips = "面纱"
        elseif( itemId == Forge_itemType_Skill) then
            //技巧
            set Forge_upHelper_Skill[playerIndex] = 0
            set ForgeLv_Skill[playerIndex] = ForgeLv_Skill[playerIndex] + 1
            set Level = ForgeLv_Skill[playerIndex]
            set tips = "辅武"
        elseif( itemId == Forge_itemType_Help) then
            //救助力
            set Forge_upHelper_Help[playerIndex] = 0
            set ForgeLv_Help[playerIndex] = ForgeLv_Help[playerIndex] + 1
            set Level = ForgeLv_Help[playerIndex]
            set tips = "药品"
        endif
        set tips = "|cffffff00" + GetPlayerName(p) + "|r成功锻造了 |cff0080ff" + I2S(Level) + "级|r的"+tips+"装备！"
        call funcs_print(tips)
        //计算属性
        call attribute_calculateOne(playerIndex)
    endfunction

    /**
     * 打印某位玩家的锻造等级到桌面
     */
    public function showOneForgeLv takes integer playerIndex returns nothing
        local player p = ConvertedPlayer(playerIndex)
        call funcs_printTo(p,"头盔："+I2S(ForgeLv_Life[playerIndex]))
		call funcs_printTo(p,"胸甲："+I2S(ForgeLv_LifeBack[playerIndex]))
		call funcs_printTo(p,"臂环："+I2S(ForgeLv_Mana[playerIndex]))
		call funcs_printTo(p,"戒指："+I2S(ForgeLv_ManaBack[playerIndex]))
		call funcs_printTo(p,"身甲："+I2S(ForgeLv_Defend[playerIndex]))
		call funcs_printTo(p,"行履："+I2S(ForgeLv_Move[playerIndex]))
		call funcs_printTo(p,"武器："+I2S(ForgeLv_Attack[playerIndex]))
		call funcs_printTo(p,"手套："+I2S(ForgeLv_AttackSpeed[playerIndex]))
		call funcs_printTo(p,"下装："+I2S(ForgeLv_Power[playerIndex]))
		call funcs_printTo(p,"面纱："+I2S(ForgeLv_Quick[playerIndex]))
		call funcs_printTo(p,"辅武："+I2S(ForgeLv_Skill[playerIndex]))
		call funcs_printTo(p,"药品："+I2S(ForgeLv_Help[playerIndex]))
    endfunction
endlibrary

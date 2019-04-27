globals

	trigger m1_Trigger_BeSpelled = null

endglobals

library m1BeSpelled requires m1BeAttacked

	private function actions takes nothing returns nothing
		local unit beUnit = GetTriggerUnit()                	//受伤单位
	    local unit sourceUnit = GetEventDamageSource()   	//予伤单位
	    local real damage = GetEventDamage()          		//受伤值
	    //---------------------------
	    //玩家档
	    local integer playerIndex = 0
	    local integer sourceIndex = GetConvertedPlayerId(GetOwningPlayer(sourceUnit))
	    local integer beIndex = GetConvertedPlayerId(GetOwningPlayer(beUnit))
	    local integer violence = 0
	    local real last_ViolenceDamage	= 0				//最终数据
	    local boolean isViolence = false              		//是否已触发术暴
	    //---------------------------
	    //技能数据
	    local integer skillLv = 0
	    //---------------------------
	    local integer charges = 0
	    local integer odds_stable = 0    //固有几率
	    local integer odds_gain = 0     //增量几率
	    local location loc = null
	    local group temp_group = null
	    local unit createUnit = null
	    local real val = 0

		if( damage <=1 or IsUnitAliveBJ(beUnit) == false) then
		    return
	    endif

		if( IsUnitInGroup( beUnit , Group_BeAttack_Fake[sourceIndex] ) == false and IsUnitInGroup( sourceUnit , Group_Attack_Fake[sourceIndex] ) == false) then
			//TODO 关闭当前触发器
		   	call DisableTrigger(GetTriggeringTrigger())

		    if( IsUnitAlly(beUnit, Player_Enemy)==true and IsUnitType(sourceUnit, UNIT_TYPE_HERO) == true) then
		        //TODO 敌方情况
		        set playerIndex = GetConvertedPlayerId(GetOwningPlayer(sourceUnit))
		        set violence = Attr_Violence[playerIndex]

				//------------------术暴------------------------
		        if( isViolence == false and GetRandomInt(1, 100) <= (10+R2I(I2R(violence)/550)) ) then
			     	set last_ViolenceDamage = I2R(violence)/10
			        call funcs_huntByToken( last_ViolenceDamage, sourceUnit , beUnit )
		            call funcs_floatMsg("|cff80ffff暴击"+I2S(R2I(last_ViolenceDamage))+"！|r"  , beUnit)
		            set isViolence = true
		        endif
		    elseif( GetOwningPlayer(beUnit) == Player(PLAYER_NEUTRAL_PASSIVE) ) then
		        //TODO 中立单位情况
		        //none
		    else
		        //TODO 玩家情况
		        //none
		    endif

		   	//TODO 重新开启此触发
			call EnableTrigger(GetTriggeringTrigger())
		endif
	endfunction

	public function init takes nothing returns nothing
		set m1_Trigger_BeSpelled = CreateTrigger()
	    call TriggerAddAction(m1_Trigger_BeSpelled, function actions )
	endfunction

endlibrary


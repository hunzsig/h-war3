
/* boss技能库 */

globals

	hashtable HASH_BOSS_Punish		//boss硬直
	hashtable HASH_BOSS_CoolDown	//boss技能冷却

endglobals

library characterEnemySpellAbstract requires characterEnemy

	//清除某单位技能CD
	private function clearCD takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer spellId = funcs_getTimerParams_Integer( t , Key_Skill_i )
		local unit triggerUnit = funcs_getTimerParams_Unit( t , Key_Skill_j )
		call funcs_delTimer( t , null )
		call SaveBoolean( HASH_BOSS_CoolDown , spellId , GetHandleId(triggerUnit) , false )
	endfunction

	//设置某单位技能CD
	private function setCD takes integer spellId , unit triggerUnit , real cd returns nothing
		local timer t = null
		if( cd > 0 ) then
			//只有CD大于0才进入CD计算
			call SaveBoolean( HASH_BOSS_CoolDown , spellId , GetHandleId(triggerUnit) , true )
			set t = funcs_setTimeout( cd , function clearCD )
			call funcs_setTimerParams_Integer( t , Key_Skill_i , spellId )
			call funcs_setTimerParams_Unit( t , Key_Skill_j , triggerUnit )
		endif
	endfunction

	//判断某单位技能是否处在CD状态
	private function isCD takes integer spellId , unit triggerUnit returns boolean
		return LoadBoolean( HASH_BOSS_CoolDown , spellId , GetHandleId(triggerUnit) )
	endfunction



	/* ------------------------------------------------------------------ */

	//设置硬直漂浮字
    private function punishTexttag takes unit triggerUnit , real val ,real limit returns nothing
    	local texttag bossTexttag = LoadTextTagHandle( HASH_BOSS_Punish , 7777 , GetHandleId(triggerUnit) )
		local string ttgStr = ""
		local real percent = 0
		local integer block = 0
		local integer blockMax = 50
		local real textSize = 5.00
		local real textZOffset = TEXTTAG_HEIGHT_Lv3
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
                        set ttgStr = ttgStr + "|cffecbf62"+font+"|r"
                    else
                        set ttgStr = ttgStr + "|cff000000"+font+"|r"
                    endif
                set i = i + 1
            endloop
        endif
        if( bossTexttag == null ) then
            set bossTexttag = funcs_floatMsgWithSizeAutoBind( ttgStr , triggerUnit , textSize , textZOffset , textOpacity , textXOffset )
            call SaveTextTagHandle( HASH_BOSS_Punish , 7777 , GetHandleId(triggerUnit) , bossTexttag )
        else
	        call SetTextTagTextBJ( bossTexttag , ttgStr , textSize )
        endif
	endfunction

	//硬直
	public function punish takes unit triggerUnit , real damage , real max returns nothing
		local boolean isInit = LoadBoolean( HASH_BOSS_Punish , 7777 , GetHandleId(triggerUnit) )
		local real currentPunish = LoadReal( HASH_BOSS_Punish , 7789 , GetHandleId(triggerUnit) )
		//初始化
		if( isInit != true ) then
			set currentPunish = max
			call SaveBoolean( HASH_BOSS_Punish , 7777 , GetHandleId(triggerUnit) , true )
			call punishTexttag( triggerUnit , currentPunish , max )
		endif

		if( IsUnitPaused(triggerUnit) == false ) then
			set currentPunish = currentPunish - damage
	    endif
	    if(currentPunish <= 0 ) then
	        set currentPunish = max
	        call skills_punish( triggerUnit , 1.75 , SKILL_PUNISH_TYPE_black )
	        call funcs_floatMsgWithSize( "|cffc0c0c0僵硬|r", triggerUnit ,10.00)
	    endif
	    call SaveReal( HASH_BOSS_Punish , 7789 , GetHandleId(triggerUnit) , currentPunish )
	    call punishTexttag( triggerUnit , currentPunish , max )
    endfunction

	//召唤小弟
	public function callBrother takes real CD , unit triggerUnit returns nothing
		local integer SPELLID = 666
		local integer i = 0
		local location loc = null
		if( isCD( SPELLID , triggerUnit ) != true ) then
			if( GetUnitTypeId(triggerUnit) == Enemy_Config_Last_Final_boss ) then
				set loc = GetUnitLoc(triggerUnit)
		        call characterEnemy_createArmy( 5 , Enemy_Config_Last_Final_normal1 , loc , Center_C )
		        call characterEnemy_createArmy( 5 , Enemy_Config_Last_Final_normal2 , loc , Center_C )
		        call characterEnemy_createArmy( 3 , Enemy_Config_Last_Final_hard1 , loc , Center_C )
		        call characterEnemy_createArmy( 3 , Enemy_Config_Last_Final_hard2 , loc , Center_C )
		        call RemoveLocation(loc)
			else
				set i = 1
				loop
					exitwhen( i > Enemy_Type_Total_Qty )
						if( GetUnitTypeId(triggerUnit) == Enemy_Config_Boss[i] ) then
							set loc = GetUnitLoc(triggerUnit)
		                    call characterEnemy_createArmy( 5 , Enemy_Config_Weak[i] , loc , Center_C )
		                    call characterEnemy_createArmy( 2 , Enemy_Config_Strong[i] , loc , Center_C )
		                    call RemoveLocation(loc)
			                call DoNothing() YDNL exitwhen true//(  )
			            endif
					set i = i + 1
				endloop
			endif
			call setCD( SPELLID , triggerUnit , CD )
		endif
	endfunction

	//无敌
	public function invincible takes real CD , unit triggerUnit , real during returns nothing
		local integer SPELLID = 1
		if( isCD( SPELLID , triggerUnit ) != true ) then
			call skills_invulnerable( triggerUnit , during )
			call funcs_effectUnit( Effect_DivineRage , triggerUnit , "origin" )
			call setCD( SPELLID , triggerUnit , CD )
		endif
	endfunction

	//回避
	public function avoid takes real CD , unit triggerUnit , real odds returns nothing
		local integer SPELLID = 2
		if( isCD( SPELLID , triggerUnit ) != true ) then
	        if( GetRandomInt(1,100) <= odds ) then
				call skills_zeroInvulnerable( triggerUnit )
	            call funcs_floatMsg( "|cffc9ff93BOSS机智地回避了危险|r" ,  triggerUnit  )
	            call setCD( SPELLID , triggerUnit , CD )
	        endif
		endif
	endfunction

	//晕破吼
	public function breakHowl takes real CD , unit triggerUnit , real range , real hunt returns nothing
		local integer SPELLID = 3
		local location loc = null
		local group heroGroup = null
		local unit u = null
		if( isCD( SPELLID , triggerUnit ) != true ) then
			set loc = GetUnitLoc( triggerUnit )
			set heroGroup = funcs_getGroupByPoint( loc , range , function filter_live_hero )
            call funcs_effectPoint( Effect_S_EvilWave_Effect , loc )
            call RemoveLocation( loc )
            loop
                exitwhen(IsUnitGroupEmptyBJ(heroGroup) == true)
	                //must do
	                set u = FirstOfGroup(heroGroup)
	                call GroupRemoveUnit( heroGroup , u )
                    if( IsUnitEnemy(u,GetOwningPlayer(triggerUnit)) ==true ) then
                        set loc = GetUnitLoc( u )
                        call funcs_effectPoint( Effect_Stomp , loc )
                        call RemoveLocation( loc )
                        call skills_swim( u , 2.00 )
                    endif
            endloop
         	call GroupClear(heroGroup)
         	call DestroyGroup(heroGroup)
            call setCD( SPELLID , triggerUnit , CD )
		endif
	endfunction

	//多重剃
	public function multiLeap takes real CD , integer model , unit triggerUnit , unit target , real distance , real speed , string moveEffect , integer qty , real perDeg , real hunt , string huntEffect , boolean isRepeat returns nothing
		local integer SPELLID = 4
	    local location loc = null
	    local location targetLoc = null
	    local real facing = 0
	    local real firstDeg = 0
	    local integer i = 0
	    local unit arrow = null
	    local location locStart = null
	    local location locEnd = null
	    if( isCD( SPELLID , triggerUnit ) != true ) then
		    set loc = GetUnitLoc( triggerUnit )
		    set targetLoc = GetUnitLoc( target )
		    set firstDeg = facing - ( perDeg * ((qty-1)/2))
		    set i = 0
		    loop
		        exitwhen i >= qty
		            set locStart = PolarProjectionBJ( loc , 0 , firstDeg + i * perDeg )
		            set locEnd = PolarProjectionBJ( loc , distance , firstDeg + i * perDeg )
		            set arrow = funcs_createUnit ( GetOwningPlayer(triggerUnit) , model , locStart , locEnd )
		            call RemoveLocation( locStart )
		            call funcs_setUnitLife( arrow , distance / (speed*45) )
		            call skills_leap( arrow , locEnd , speed , moveEffect , hunt, 100.00 , huntEffect , isRepeat)
		        set i = i + 1
		    endloop
		    call RemoveLocation(loc)
		    call RemoveLocation(targetLoc)
		    call setCD( SPELLID , triggerUnit , CD )
		endif
	endfunction

	//多重僵直
	public function multiPunish takes real CD , unit triggerUnit , string callEffect , real range , real during , integer punishType, real hunt , string huntEffect returns nothing
		local integer SPELLID = 5
	    local location loc = null
		local group heroGroup = null
		local unit u = null
		if( isCD( SPELLID , triggerUnit ) != true ) then
			set loc = GetUnitLoc( triggerUnit )
			set heroGroup = funcs_getGroupByPoint( loc , range , function filter_live_hero )
            call funcs_effectPoint( callEffect , loc )
            call RemoveLocation( loc )
            loop
                exitwhen(IsUnitGroupEmptyBJ(heroGroup) == true)
	                //must do
	                set u = FirstOfGroup(heroGroup)
	                call GroupRemoveUnit( heroGroup , u )
                    if( IsUnitEnemy(u,GetOwningPlayer(triggerUnit)) ==true ) then
                        set loc = GetUnitLoc( u )
                        call funcs_effectPoint( huntEffect , loc )
                        call RemoveLocation( loc )
                        call skills_punish( u , during , punishType )
                    endif
            endloop
         	call GroupClear(heroGroup)
         	call DestroyGroup(heroGroup)
            call setCD( SPELLID , triggerUnit , CD )
		endif
	endfunction

	//残影踏
	private function canyingtaCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
	    local unit triggerUnit = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local integer shadowQty = funcs_getTimerParams_Integer( t , Key_Skill_j  )
	    local integer shadowQtyInc = funcs_getTimerParams_Integer( t , Key_Skill_k )
	    local integer shadowToken = funcs_getTimerParams_Integer( t , Key_Skill_Model )
	    local real hunt = funcs_getTimerParams_Real( t , Key_Skill_Hunt  )
	    local location loc
	    local group g
	    local unit u
	    if( shadowQtyInc < shadowQty ) then
	        //获取一个随机单位位置，后建组
	        set loc = GetUnitLoc(triggerUnit)
	        set g = funcs_getGroupByPoint( loc , 300.00 , function filter_live_disbuild)
	        call RemoveLocation(loc)
	        loop
	            exitwhen(IsUnitGroupEmptyBJ(g) == true)
	                //must do
	                set u = GroupPickRandomUnit(g)
	                call GroupRemoveUnit( g , u )
	                //检测是否敌军
	                if( IsUnitEnemy( u , GetOwningPlayer(triggerUnit))  == TRUE ) then
	                    set loc = GetUnitLoc(u)
	                    call DoNothing() YDNL exitwhen true
	                endif
	        endloop
	        call DestroyGroup(g)
	        set u = funcs_createUnitFacing( GetOwningPlayer(triggerUnit) , shadowToken ,loc , GetRandomReal(0.00,360.00))
	        call IssueImmediateOrder( u , "stomp" )
	        call SetUnitVertexColorBJ( u, 100, 100, 100, 50.00 )
	        call funcs_delUnit( u , 1.25 )
	        set g = funcs_getGroupByPoint( loc , 250.00 , function filter_live_disbuild)
	        call funcs_huntGroup(g, triggerUnit,hunt,null,null,FILTER_ENEMY)
	        call DestroyGroup(g)
	        call RemoveLocation(loc)
	    else
	        call funcs_delTimer( t ,null )
	    endif
	    call funcs_setTimerParams_Integer( t , Key_Skill_k , shadowQtyInc+1 )
	endfunction

	//残影踏
	public function canyingta takes real CD , unit triggerUnit , integer shadowQty , integer shadowToken , real hunt returns nothing
		local integer SPELLID = 5
		local timer t = null
		if( isCD( SPELLID , triggerUnit ) != true ) then
			set t = funcs_setInterval( 0.35 , function canyingtaCall )
		    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , triggerUnit)
		    call funcs_setTimerParams_Integer( t , Key_Skill_j , shadowQty )
		    call funcs_setTimerParams_Integer( t , Key_Skill_k , 0 )
		    call funcs_setTimerParams_Integer( t , Key_Skill_Model , shadowToken )
		    call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt )
            call setCD( SPELLID , triggerUnit , CD )
		endif
	endfunction

	//剃
	public function leap takes real CD , unit triggerUnit , unit target , real distance , real speed , string moveEffect , real hunt , string huntEffect , boolean isRepeat returns nothing
		local integer SPELLID = 6
	    local location loc = null
	    local location targetLoc = null
	    local location point = null
	    if( isCD( SPELLID , triggerUnit ) != true ) then
		    set loc = GetUnitLoc(triggerUnit)
		    set targetLoc = GetUnitLoc(target)
		    set point = PolarProjectionBJ( targetLoc , distance , funcs_getFacingBetweenUnits(triggerUnit,target) )
		    call RemoveLocation(targetLoc)
		    call RemoveLocation(loc)
		    call SetUnitVertexColorBJ( triggerUnit, 100, 100, 100, 80.00 )
	    	call skills_leap( triggerUnit , point , speed , moveEffect , hunt, 100 , huntEffect , isRepeat)
	    	call setCD( SPELLID , triggerUnit , CD )
    	endif
	endfunction

	//冲锋
	public function charge takes real CD , unit triggerUnit , unit target , string chargeType , real distance , real speed , string moveEffect , real hunt , string huntEffect , boolean isRepeat returns nothing
		local integer SPELLID = 7
	    local real facing = 0
	    if( isCD( SPELLID , triggerUnit ) != true ) then
		    set facing = funcs_getFacingBetweenUnits(triggerUnit,target)
		    call SetUnitAnimationByIndex( triggerUnit , 3 )
	    	call skills_charge( triggerUnit , facing , distance , speed , chargeType , moveEffect , hunt , 150 , huntEffect , isRepeat )
	    	call setCD( SPELLID , triggerUnit , CD )
    	endif
	endfunction

	//冲锋 - 马甲
	public function chargeToken takes real CD , unit triggerUnit , integer token , unit target , string chargeType , real distance , real speed , string moveEffect , real hunt , string huntEffect , boolean isRepeat returns nothing
		local integer SPELLID = 8
	    local real facing = 0
	    local location loc = null
	    local unit createUnit = null
	    if( isCD( SPELLID , triggerUnit ) != true ) then
		    set facing = funcs_getFacingBetweenUnits(triggerUnit,target)
		    set loc = GetUnitLoc(triggerUnit)
		    set createUnit = funcs_createUnit( GetOwningPlayer(triggerUnit) , token , loc , loc )
		    call funcs_setUnitLife( createUnit , distance / (speed*45) )
		    call RemoveLocation(loc)
	    	call skills_charge( createUnit , facing , distance , speed , chargeType , moveEffect , hunt , 150 , huntEffect , isRepeat )
	    	call setCD( SPELLID , triggerUnit , CD )
    	endif
	endfunction

	//跳跃冲锋
	public function jump takes real CD , unit triggerUnit , unit target , real speed , string Jeffect , real hunt , string Heffect returns nothing
		local integer SPELLID = 9
		if( isCD( SPELLID , triggerUnit ) != true ) then
			call skills_jump( triggerUnit , target, speed , Jeffect, hunt, Heffect )
			call setCD( SPELLID , triggerUnit , CD )
    	endif
	endfunction

	//穿梭
	public function shuttle takes real CD , unit triggerUnit , real range , real speed , integer qty , string Jeffect , real hunt , string Heffect returns nothing
		local integer SPELLID = 10
		local location loc = null
		local group targetGroup = null
		if( isCD( SPELLID , triggerUnit ) != true ) then
			set loc = GetUnitLoc(triggerUnit)
		    set targetGroup = funcs_getGroupByPoint( loc , range , function filter_live_hero)
		    call RemoveLocation(loc)
		    //
		    call SetUnitVertexColorBJ( triggerUnit, 100, 100, 100, 95.00 )
		    call SetUnitAnimation( triggerUnit, "attack" )
		    call skills_shuttleForGroup( triggerUnit , targetGroup, qty , hunt , 0 , speed , 5 , 100 , 0 , 0 , 0 , Jeffect , Heffect , "attack" , 'A05R' , 0.00, 0.00 , false )
		    call setCD( SPELLID , triggerUnit , CD )
		endif
	endfunction

	//随机召唤
	public function summon takes real CD , unit triggerUnit , integer model , integer qty , real perDistance , real during , trigger deadTrigger returns nothing
		local integer SPELLID = 11
		local location loc = null
		local location targetLoc = null
		local integer i = 0
		local unit createUnit = null
		if( isCD( SPELLID , triggerUnit ) != true ) then
			set loc = GetUnitLoc(triggerUnit)
		    set i = 1
		    loop
			    exitwhen i > qty
			    	set targetLoc = PolarProjectionBJ( loc , perDistance * i , GetRandomReal(0,360) )
					set createUnit = funcs_createUnit( GetOwningPlayer(triggerUnit) , model , targetLoc , targetLoc )
					call RemoveLocation(targetLoc)
		    		if( deadTrigger != null ) then
			    		call eventRegist_unitDeath( deadTrigger , createUnit )
			    		call funcs_setUnitLife( createUnit , during )
		    		else
		    			call funcs_delUnit( createUnit , during )
			    	endif
			    set i = i + 1
			endloop
		    call RemoveLocation(loc)
		    call setCD( SPELLID , triggerUnit , CD )
		endif
	endfunction


endlibrary

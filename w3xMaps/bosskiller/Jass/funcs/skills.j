globals
    //回避生命
    integer ABILITY_AVOID_PLUS = 'A065'
    integer ABILITY_AVOID_MIUNS = 'A068'
endglobals

library skills requires attribute

    /**
     * 按百分比回补单位生命
     */
    public function addLifePercent takes unit u,real percent returns nothing
        call SetUnitLifePercentBJ( u, ( GetUnitLifePercent(u) + percent ) )
    endfunction
    /**
     * 按百分比回补单位魔法
     */
    public function addManaPercent takes unit u,real percent returns nothing
        call SetUnitManaPercentBJ( u, ( GetUnitManaPercent(u) + percent ) )
    endfunction

    /**
     * 按数值回补单位生命
     */
    public function addLifeValue takes unit u,real value returns nothing
        call SetUnitLifeBJ( u, ( GetUnitStateSwap(UNIT_STATE_LIFE, u) + value ) )
    endfunction
    /**
     * 按数值回补单位魔法
     */
    public function addManaValue takes unit u,real value returns nothing
        call SetUnitManaBJ( u, ( GetUnitStateSwap(UNIT_STATE_MANA, u) + value ) )
    endfunction

    /**
     * 自定义技能 - 对点
     * skillId 技能ID
     */
    public function diy2loc takes player owner,location loc,location targetLoc, integer skillId,string orderString,real during returns nothing
        local unit token = CreateUnitAtLoc(owner,Unit_Token_Super , loc , bj_UNIT_FACING)
        call abilities_registAbility( token,skillId )
        call IssuePointOrderLoc( token , orderString , targetLoc )
        call UnitApplyTimedLifeBJ( during, 'BTLF', token )
    endfunction

    /**
     * 自定义技能 - 立即
     * skillId 技能ID
     */
    public function diy2once takes player owner,location loc, integer skillId,string orderString,real during returns nothing
        local unit token = CreateUnitAtLoc(owner,Unit_Token_Super , loc , bj_UNIT_FACING)
        call abilities_registAbility( token,skillId )
        call IssueImmediateOrder( token , orderString )
        call UnitApplyTimedLifeBJ( during, 'BTLF', token )
    endfunction

    /**
     * 自定义技能 - 对单位
     * skillId 技能ID
     */
    public function diy2unit takes player owner,location loc, unit targetUnit, integer skillId,string orderString,real during returns nothing
        local unit token = CreateUnitAtLoc(owner,Unit_Token_Super , loc , bj_UNIT_FACING)
        call abilities_registAbility( token,skillId )
        call IssueTargetOrder( token , orderString , targetUnit )
        call UnitApplyTimedLifeBJ( during, 'BTLF', token )
    endfunction

    /**
     * 自定义技能 - 对单位ByID
     * skillId 技能ID
     */
    public function diy2unitById takes player owner,location loc, unit targetUnit, integer skillId,integer orderId returns nothing
        local unit token = CreateUnitAtLoc(owner,Unit_Token_Super , loc , bj_UNIT_FACING)
        call abilities_registAbility( token,skillId )
        call IssueTargetOrderById( token , orderId , targetUnit )
        call UnitApplyTimedLifeBJ( 2.00, 'BTLF', token )
    endfunction

    /**
     * 打断
     * ! 注意这个方法对中立被动无效
     */
    public function break takes unit u returns nothing
        local location loc = GetUnitLoc( u )
        local unit createUnit = funcs_createUnit( Player(PLAYER_NEUTRAL_PASSIVE) , Skill_Break_Token , loc , loc)
        call IssueTargetOrder( createUnit , "thunderbolt", u )
        call UnitApplyTimedLifeBJ( 0.5, 'BTLF', createUnit )
        call RemoveLocation( loc )
    endfunction

    /**
     * 眩晕
     * ! 注意这个方法对中立被动无效
     */
    public function swim takes unit u,real during returns nothing
        local real period = 0.5
        local integer level = R2I(during/period)
        local location loc = GetUnitLoc( u )
        local unit createUnit = null
        if( level < 1 ) then
            return
        endif
        set createUnit = funcs_createUnit( Player(PLAYER_NEUTRAL_PASSIVE) , Skill_Swim_05_Token , loc , loc)
        call SetUnitAbilityLevel( createUnit , Skill_Swim_05 , level )
        call IssueTargetOrder( createUnit , "thunderbolt", u )
        call UnitApplyTimedLifeBJ( 0.5, 'BTLF', createUnit )
        call RemoveLocation( loc )
    endfunction

	/**
	 * 变身回调
	 */
    public function shapeshiftCall takes nothing returns nothing
    	local timer t = GetExpiredTimer()
    	local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
    	local integer modelFrom = funcs_getTimerParams_Integer( t , Key_Skill_i )
    	local string eff = funcs_getTimerParams_String( t , Key_Skill_FEffect )
    	local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
    	local location loc = null

    	set loc = GetUnitLoc(u)
		call funcs_effectPoint( eff , loc )
	    call RemoveLocation(loc)

    	call UnitAddAbility( u , modelFrom )
		call UnitRemoveAbility( u , modelFrom )

		if( SPELL_Talent_F_isLearn[index] == true) then
			call UnitRemoveAbility( u , SPELL_Talent_F )
		endif
		if( SPELL_Talent_C_isLearn[index] == true) then
			call UnitRemoveAbility( u , SPELL_Talent_C )
		endif
		if( SPELL_Talent_V_isLearn[index] == true) then
			call UnitRemoveAbility( u , SPELL_Talent_V )
		endif

		call PolledWait(0.10) //模型变化需要一点时间，所以这里加延时,在对单位进行属性计算
	    call attribute_calculateOne(index)
    endfunction

	/**
	 * 变身
	 */
    public function shapeshift takes unit u, real during, integer modelFrom,integer modelTo,string eff returns nothing
    	local timer t = null
    	local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
    	local location loc = null

		set loc = GetUnitLoc(u)
		call funcs_effectPoint( eff , loc )
	    call RemoveLocation(loc)

    	call UnitAddAbility( u , modelTo )
		call UnitRemoveAbility( u , modelTo )

		if( SPELL_Talent_F_isLearn[index] == true) then
			call UnitRemoveAbility( u , SPELL_Talent_F )
		endif
		if( SPELL_Talent_C_isLearn[index] == true) then
			call UnitRemoveAbility( u , SPELL_Talent_C )
		endif
		if( SPELL_Talent_V_isLearn[index] == true) then
			call UnitRemoveAbility( u , SPELL_Talent_V )
		endif

		set t = funcs_setTimeout( during , function shapeshiftCall )
	    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u )
	    call funcs_setTimerParams_Integer( t , Key_Skill_i , modelFrom )
	    call funcs_setTimerParams_String( t , Key_Skill_FEffect , eff )

	    call PolledWait(0.10) //模型变化需要一点时间，所以这里加延时,在对单位进行属性计算
	    call attribute_calculateOne(index)
    endfunction

    /**
     * 通用闪电链
     * attackUnit 攻击单位
     * beUnit 被攻击单位
     * skillId 技能ID
     */
    public function thunderLink takes unit attackUnit,unit beUnit,integer skillId returns nothing
        local location point = GetUnitLoc( attackUnit )
        local player owner = GetOwningPlayer(attackUnit)
        local unit token = CreateUnitAtLoc(owner,Unit_Token_ThunderLink,point,bj_UNIT_FACING)
        call abilities_registAbility( token,skillId )
        call IssueTargetOrder( token, "chainlightning",  beUnit )
        call UnitApplyTimedLifeBJ( 1.00, 'BTLF', token )
        call RemoveLocation(  point )
    endfunction

    /**
     * 移动目标单位到某单位组内随机单位处
     * jumper 目标单位
     * whichGroup 单位组
     * isLockCamera 是否跟随镜头
     */
    public function jumpRamdomUnit takes unit jumper,group whichGroup,boolean isLockCamera returns boolean
        local unit u = GroupPickRandomUnit(whichGroup)
        local location point = GetUnitLoc(u)
        if(u == null) then
            return false
        endif
        call SetUnitPositionLoc( jumper, point )
        if(isLockCamera) then
            call PanCameraToTimedLocForPlayer( GetOwningPlayer(jumper), point, 0.30 )
        endif
        call RemoveLocation(point)
        return true
    endfunction

    //为单位添加效果只限技能类一段时间 回调
    private function addAbilityEffectCall takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit whichUnit = funcs_getTimerParams_Unit(t,Key_Skill_Unit)
        local integer whichAbility = funcs_getTimerParams_Integer(t,Key_Skill_i)
        call abilities_unsetAbility( whichUnit,whichAbility )
        call funcs_delTimer( t ,null )
    endfunction

    //为单位添加效果只限技能类一段时间
    public function addAbilityEffect takes unit whichUnit,integer whichAbility,integer abilityLevel,real during returns nothing
        local timer t
        if( whichUnit!=null and whichAbility!=null and during >0 )then
            call abilities_registAbility( whichUnit,whichAbility )
            if(abilityLevel>1)then
                call SetUnitAbilityLevel( whichUnit,whichAbility,abilityLevel )
            endif
            set t = funcs_setTimeout( during,function addAbilityEffectCall )
            call funcs_setTimerParams_Unit(t,Key_Skill_Unit,whichUnit)
            call funcs_setTimerParams_Integer(t,Key_Skill_i,whichAbility)
        endif
    endfunction

    //撞退Call
    private function crashCall takes nothing returns nothing
        local timer t =GetExpiredTimer()
        local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
        local real speed = funcs_getTimerParams_Real( t , Key_Skill_Unit )
        local real deg = funcs_getTimerParams_Real( t , Key_Skill_DEG )
        local real facing = funcs_getTimerParams_Real( t , Key_Skill_Facing )
        local real during = funcs_getTimerParams_Real( t , Key_Skill_During )
        local real duringInc = funcs_getTimerParams_Real( t , Key_Skill_DuringInc )
        local location sourceLoc = GetUnitLoc( u )
        local location targetLoc = PolarProjectionBJ(sourceLoc, speed, deg)
        call SetUnitPositionLoc( u , targetLoc )
        call SetUnitFacing( u , facing )
        if( funcs_isWater(targetLoc) == true ) then
            //如果是水面，创建水花
            call funcs_effectPoint(Effect_CrushingWaveDamage,targetLoc)
        else
            //如果是地面，创建沙尘
            call funcs_effectPoint(Effect_ImpaleTargetDust,targetLoc)
        endif
        call RemoveLocation(targetLoc)
        call RemoveLocation(sourceLoc)
        //结束
        if( IsUnitDeadBJ(u) == true)then
            call SetUnitTimeScalePercent( u, 100 )
            call funcs_delTimer( t ,null )
        elseif( duringInc >= during ) then
            call SetUnitTimeScalePercent( u, 100 )
            call ResetUnitAnimation(  u ) //恢复动画
            call funcs_delTimer( t ,null )
        endif
        call funcs_setTimerParams_Real( t , Key_Skill_DuringInc , duringInc + 1 )
    endfunction
    //撞退 - 单体
    public function crashOne takes unit source, unit targetUnit ,real speed returns nothing
        local location triggerLoc = GetUnitLoc(source)
        local location loc = null
        local real deg = 0.00
        local real facing = 0.00
        local timer t = null
        local boolean canCrash
        set canCrash = TRUE
        //检测是否建筑
        if( IsUnitType( targetUnit , UNIT_TYPE_STRUCTURE) == true ) then
            set canCrash = FALSE
        endif
        //检测是否敌军
        if( IsUnitEnemy( targetUnit , GetOwningPlayer(source))  == FALSE ) then
            set canCrash = FALSE
        endif
        if(canCrash == TRUE) then
            set loc = GetUnitLoc(targetUnit)
            call SetUnitTimeScalePercent( targetUnit, 150 )
            //call SetUnitAnimation( targetUnit , "death" )
            set deg = AngleBetweenPoints(triggerLoc, loc)
            set facing = AngleBetweenPoints(loc, triggerLoc)
            set t = funcs_setInterval( 0.02 , function crashCall)
            call funcs_setTimerParams_Unit( t , Key_Skill_Unit , targetUnit )
            call funcs_setTimerParams_Real( t , Key_Skill_Unit , speed )
            call funcs_setTimerParams_Real( t , Key_Skill_DEG , deg )
            call funcs_setTimerParams_Real( t , Key_Skill_Facing , facing )
            call funcs_setTimerParams_Real( t , Key_Skill_During , (250.00/speed) )
            call funcs_setTimerParams_Real( t , Key_Skill_DuringInc , 0 )
            call RemoveLocation(loc)
        endif
        call RemoveLocation(triggerLoc)
    endfunction
    //撞退
    public function crash takes unit source, real range,real speed, group remove_group returns nothing
        local location triggerLoc = GetUnitLoc(source)
        local location loc = null
        local group g = funcs_getGroupByPoint( triggerLoc , range , function filter_live_disbuild )
        local unit u = null
        local real deg = 0.00
        local real facing = 0.00
        local timer t = null
        local boolean canCrash
        loop
            exitwhen(IsUnitGroupEmptyBJ(g) == true)
                //must do
                set u = FirstOfGroup(g)
                call GroupRemoveUnit( g , u )
                //
                set canCrash = TRUE
                if(remove_group != null) then
                    if( IsUnitInGroup(u, remove_group) == TRUE ) then
                        set canCrash = FALSE
                    else
                        call GroupAddUnit( remove_group , u )
                    endif
                endif
                //检测是否敌军
                if( IsUnitEnemy( u , GetOwningPlayer(source))  == FALSE ) then
                    set canCrash = FALSE
                endif

                if(canCrash == TRUE) then
                    set loc = GetUnitLoc(u)
                    call SetUnitTimeScalePercent( u, 150 )
                    //call SetUnitAnimation( u , "death" )
                    set deg = AngleBetweenPoints(triggerLoc, loc)
                    set facing = AngleBetweenPoints(loc, triggerLoc)
                    set t = funcs_setInterval( 0.02 , function crashCall)
                    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u )
                    call funcs_setTimerParams_Real( t , Key_Skill_Unit , speed )
                    call funcs_setTimerParams_Real( t , Key_Skill_DEG , deg )
                    call funcs_setTimerParams_Real( t , Key_Skill_Facing , facing )
                    call funcs_setTimerParams_Real( t , Key_Skill_During , (250.00/speed) )
                    call funcs_setTimerParams_Real( t , Key_Skill_DuringInc , 0 )
                    call RemoveLocation(loc)
                endif
        endloop
        call GroupClear( g )
        call DestroyGroup( g )
        call RemoveLocation(triggerLoc)
    endfunction

    //撞飞Call
    private function flyCall takes nothing returns nothing
        local timer t =GetExpiredTimer()
        local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
        local string FEffect = funcs_getTimerParams_String( t , Key_Skill_FEffect )
        local real firstHeight = funcs_getTimerParams_Real( t , Key_Skill_Distance )
        local real speed = funcs_getTimerParams_Real( t , Key_Skill_Speed )
        local location loc = GetUnitLoc( u )
        call funcs_delTimer( t ,null )
        if( FEffect !=null ) then
            call funcs_effectPoint(FEffect,loc)
        endif
        call RemoveLocation(loc)
        call PauseUnitBJ( false, u )
        call SetUnitFlyHeight( u , firstHeight, speed * 2 )
    endfunction
    //撞飞
    public function fly takes unit source, real range,real speed, real height,group remove_group returns nothing
        local location triggerLoc = GetUnitLoc(source)
        local location loc = null
        local group g = funcs_getGroupByPoint( triggerLoc , range , function filter_live_disbuild )
        local unit u = null
        local timer t = null
        local boolean canFly
        local string FEffect = null
        local real firstHeight = 0.00
        local real flySpeed = height * 0.75
        loop
            exitwhen(IsUnitGroupEmptyBJ(g) == true)
                //must do
                set u = FirstOfGroup(g)
                call GroupRemoveUnit( g , u )
                //
                set canFly = TRUE
                if(remove_group != null) then
                    if( IsUnitInGroup(u, remove_group) == TRUE ) then
                        set canFly = FALSE
                    else
                        call GroupAddUnit( remove_group , u )
                    endif
                endif
                //检测是否敌军
                if( IsUnitEnemy( u , GetOwningPlayer(source))  == FALSE ) then
                    set canFly = FALSE
                endif

                if(canFly == TRUE) then
                    set loc = GetUnitLoc(u)
                    set firstHeight = GetLocationZ(loc)
                    call PauseUnitBJ( true, u )
                    call SetUnitTimeScalePercent( u, 150 )
                    call SetUnitAnimation( u , "death" )
                    call funcs_setUnitFly( u )
                    call SetUnitFlyHeight( u , height, flySpeed )
                    if( funcs_isWater(loc) == true ) then
                        //如果是水面，创建水爆
                        set FEffect = Effect_CrushingWaveDamage
                        call funcs_effectPoint(Effect_CrushingWaveBrust,loc)
                    else
                        //如果是地面，创建扩张特效
                        set FEffect = Effect_ImpaleTargetDust
                        call funcs_effectPoint(Effect_CrushingWhiteRing,loc)
                    endif
                    set t = funcs_setTimeout( (height/flySpeed) , function flyCall)
                    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , u )
                    call funcs_setTimerParams_String( t , Key_Skill_FEffect , FEffect )
                    call funcs_setTimerParams_Real( t , Key_Skill_Speed , flySpeed)
                    call funcs_setTimerParams_Real( t , Key_Skill_Distance , firstHeight)
                    call RemoveLocation(loc)
                endif
        endloop
        call GroupClear( g )
        call DestroyGroup( g )
        call RemoveLocation(triggerLoc)
    endfunction

    //剃回调
    public function leapCall takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local real speed = funcs_getTimerParams_Real(t,Key_Skill_Speed)
        local real hunt = funcs_getTimerParams_Real(t,Key_Skill_Hunt)
        local real range = funcs_getTimerParams_Real(t,Key_Skill_Range)
        local location targetPoint = funcs_getTimerParams_Loc(t,Key_Skill_TargetPoint)
        local string MEffect = funcs_getTimerParams_String(t,Key_Skill_MEffect)
        local string HEffect = funcs_getTimerParams_String(t,Key_Skill_HEffect)
        local unit mover = funcs_getTimerParams_Unit(t,Key_Skill_Unit)
        local group remove_group = funcs_getTimerParams_Group(t,Key_Skill_Group)
        local real duringInc = funcs_getTimerParams_Real(t,Key_Skill_DuringInc)
        local real distance
        local location point
        local location point2
        local group tmp_group

        call funcs_setTimerParams_Real(t,Key_Skill_DuringInc,duringInc+TimerGetTimeout(t))

        set point =  GetUnitLoc(mover)
        set point2 = PolarProjectionBJ(point, speed, AngleBetweenPoints(point, targetPoint))
        call SetUnitPositionLoc( mover, point2 )
        call RemoveLocation(point2)
        call RemoveLocation(point)

        set point =  GetUnitLoc(mover)
        if(MEffect != null)then
            call funcs_effectPoint(MEffect,point)
        endif
        if(hunt > 0) then
            set tmp_group = funcs_getGroupByPoint(point,range,function filter_live_disbuild)
            call funcs_huntGroup(tmp_group,mover,hunt,HEffect,remove_group,FILTER_ENEMY)
            call DestroyGroup(tmp_group)
        endif
        set distance = DistanceBetweenPoints(point, targetPoint)
        call RemoveLocation(point)

        if(distance<speed or distance<=0 or speed <=0 or IsUnitDeadBJ(mover) == true or duringInc > 10) then
            call funcs_delTimer(t,null)
            call SetUnitInvulnerable( mover, false )
            call SetUnitPathing( mover, true )
            call SetUnitPositionLoc( mover, targetPoint)
            call SetUnitVertexColorBJ( mover, 100, 100, 100, 0 )
            call DestroyGroup(remove_group)
            call RemoveLocation(targetPoint)
        endif
    endfunction

    //剃
    public function leap takes unit mover,location targetPoint,real speed,string Meffect,real hunt,real range,string Heffect,boolean isRepeat returns nothing
        local real lock_var_period = 0.02
        local location point
        local timer t
        local group remove_group = null

        //debug
        if(mover==null or targetPoint==null) then
            return
        endif

        //重复判定
        if( isRepeat == false ) then
            set remove_group = CreateGroup()
        else
            set remove_group = null
        endif

        set point = GetUnitLoc(mover)
        if(speed>150) then
            set speed = 150   //最大速度
        elseif(speed<=1) then
            set speed = 1   //最小速度
        endif
        call RemoveLocation(point)
        call SetUnitInvulnerable( mover, true )
        call SetUnitPathing( mover, false )
        set t = funcs_setInterval(lock_var_period,function leapCall)
        call funcs_setTimerParams_Real(t,Key_Skill_Speed,speed)
        call funcs_setTimerParams_Real(t,Key_Skill_Hunt,hunt)
        call funcs_setTimerParams_Real(t,Key_Skill_Range,range)
        call funcs_setTimerParams_Unit(t,Key_Skill_Unit,mover)
        call funcs_setTimerParams_String(t,Key_Skill_MEffect,Meffect)
        call funcs_setTimerParams_String(t,Key_Skill_HEffect,Heffect)
        call funcs_setTimerParams_Loc(t,Key_Skill_TargetPoint,targetPoint)
        call funcs_setTimerParams_Group(t,Key_Skill_Group,remove_group)
        call funcs_setTimerParams_Real(t,Key_Skill_DuringInc,0)
    endfunction

    //冲锋回调
    public function chargeCall takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local real speed = funcs_getTimerParams_Real(t,Key_Skill_Speed)
        local real hunt = funcs_getTimerParams_Real(t,Key_Skill_Hunt)
        local real range = funcs_getTimerParams_Real(t,Key_Skill_Range)
        local real facing = funcs_getTimerParams_Real(t,Key_Skill_Facing)
        local string chargeType = funcs_getTimerParams_String(t,Key_Skill_Type)
        local string MEffect = funcs_getTimerParams_String(t,Key_Skill_MEffect)
        local string HEffect = funcs_getTimerParams_String(t,Key_Skill_HEffect)
        local unit mover = funcs_getTimerParams_Unit(t,Key_Skill_Unit)
        local location targetPoint = funcs_getTimerParams_Loc(t,Key_Skill_TargetPoint)
        local group remove_group = funcs_getTimerParams_Group(t,Key_Skill_Group)
        local group remove_group2 = funcs_getTimerParams_Group(t,Key_Skill_Group2)
        local boolean isRepeat = funcs_getTimerParams_Boolean(t,Key_Skill_Boolean)
        local real duringInc = funcs_getTimerParams_Real(t,Key_Skill_DuringInc)
        local real distance = 0.00
        local location point = null
        local location point2 = null
        local group tmp_group = null

        call funcs_setTimerParams_Real(t,Key_Skill_DuringInc,duringInc+TimerGetTimeout(t))

        set point =  GetUnitLoc(mover)
        set point2 = PolarProjectionBJ(point, speed, AngleBetweenPoints(point, targetPoint))
        call SetUnitPositionLoc( mover, point2 )
        set distance = DistanceBetweenPoints( point2, targetPoint)

        //如果强制设定移动特效，则显示设定的否则自动判断地形产生特效
        if(MEffect != null)then
            call funcs_effectPoint(MEffect,point2)
        else
            if( funcs_isWater(point) == true ) then
                //如果是水面，创建水花
                call funcs_effectPoint(Effect_CrushingWaveDamage,point2)
            else
                //如果是地面，创建沙尘
                call funcs_effectPoint(Effect_ImpaleTargetDust,point2)
            endif
        endif

        call RemoveLocation(point2)
        call RemoveLocation(point)
        if(hunt > 0) then
            set point =  GetUnitLoc(mover)
            set tmp_group = funcs_getGroupByPoint( point,range,function filter_live_disbuild )
            if( isRepeat==true ) then
                call funcs_huntGroup(tmp_group,mover,hunt,HEffect,null,FILTER_ENEMY)
            else
                call funcs_huntGroup(tmp_group,mover,hunt,HEffect,remove_group,FILTER_ENEMY)
            endif
            call DestroyGroup(tmp_group)
            call RemoveLocation(point)
        endif

        //冲锋特技
        if( chargeType == SKILL_CHARGE_CRASH ) then
            //撞退
            call skills_crash( mover , 75.00 , speed , remove_group2 )
        elseif( chargeType == SKILL_CHARGE_FLY ) then
            //撞飞
             call skills_fly( mover , 75.00 , speed , 500.00,remove_group2 )
        elseif( chargeType == SKILL_CHARGE_DRAG ) then
            //拖行
            set point = GetUnitLoc(mover)
            set point2 = PolarProjectionBJ(point, 135.00, facing)
            set tmp_group = funcs_getGroupByPoint(point,100.00,function filter_live_disbuild_ground)
            call funcs_moveGroup(tmp_group, point2, mover, 0.00, null,FILTER_ENEMY)
            call DestroyGroup(tmp_group)
            call RemoveLocation(point2)
            call RemoveLocation(point)
        endif

        if(distance<speed or distance<=0 or speed <=0 or IsUnitDeadBJ(mover) == true or duringInc > 10) then
            //停止
            call funcs_delTimer(t,null)
            call SetUnitPositionLoc( mover, targetPoint)
            call SetUnitPathing( mover, true )
            call PauseUnitBJ( false, mover )
            call SetUnitTimeScalePercent( mover, 100 )
            call SetUnitVertexColorBJ( mover, 100, 100, 100, 0.00 )
            call ResetUnitAnimation(  mover ) //恢复动画
            call RemoveLocation(targetPoint)
            call DestroyGroup(remove_group)
            call DestroyGroup(remove_group2)
        endif
    endfunction

    //冲锋
    //chargeType 冲锋类型 参考global string
    //不能攻击空中单位
    public function charge takes unit mover,real facing,real distance,real speed,string chargeType,string Meffect,real hunt,real range,string Heffect,boolean isRepeat returns nothing
        local real lock_var_period = 0.02
        local location point
        local location targetPoint
        local timer t
        local group remove_group = CreateGroup()
        local group remove_group2 = CreateGroup()

        //debug
        if(mover==null) then
            return
        endif

        set point = GetUnitLoc(mover)
        set targetPoint = PolarProjectionBJ(point, distance, facing)
        if(speed>150) then
            set speed = 150   //最大速度
        elseif(speed<=1) then
            set speed = 1   //最小速度
        endif
        call RemoveLocation(point)
        call SetUnitPathing( mover, false )
        call PauseUnitBJ( true, mover )
        call SetUnitTimeScalePercent( mover, 300 )
        set t = funcs_setInterval(lock_var_period,function chargeCall)
        call funcs_setTimerParams_Real(t,Key_Skill_Speed,speed)
        call funcs_setTimerParams_Real(t,Key_Skill_Hunt,hunt)
        call funcs_setTimerParams_Real(t,Key_Skill_Range,range)
        call funcs_setTimerParams_Real(t,Key_Skill_Facing,facing)
        call funcs_setTimerParams_Unit(t,Key_Skill_Unit,mover)
        call funcs_setTimerParams_String(t,Key_Skill_Type,chargeType)
        call funcs_setTimerParams_String(t,Key_Skill_MEffect,Meffect)
        call funcs_setTimerParams_String(t,Key_Skill_HEffect,Heffect)
        call funcs_setTimerParams_Loc(t,Key_Skill_TargetPoint,targetPoint)
        call funcs_setTimerParams_Group(t,Key_Skill_Group,remove_group)
        call funcs_setTimerParams_Group(t,Key_Skill_Group2,remove_group2)
        call funcs_setTimerParams_Boolean(t,Key_Skill_Boolean,isRepeat)
        call funcs_setTimerParams_Real(t,Key_Skill_DuringInc,0)
    endfunction

    //前进回调
    public function forwardCall takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local real speed = funcs_getTimerParams_Real(t,Key_Skill_Speed)
        local real hunt = funcs_getTimerParams_Real(t,Key_Skill_Hunt)
        local real range = funcs_getTimerParams_Real(t,Key_Skill_Range)
        local real duringInc = funcs_getTimerParams_Real(t,Key_Skill_DuringInc)
        local string MEffect = funcs_getTimerParams_String(t,Key_Skill_MEffect)
        local string HEffect = funcs_getTimerParams_String(t,Key_Skill_HEffect)
        local unit mover = funcs_getTimerParams_Unit(t,Key_Skill_Unit)
        local unit source = funcs_getTimerParams_Unit(t,Key_Skill_UnitSource)
        local location targetPoint = funcs_getTimerParams_Loc(t,Key_Skill_TargetPoint)
        local group remove_group = funcs_getTimerParams_Group(t,Key_Skill_Group)
        local real during = funcs_getTimerParams_Real(t,Key_Skill_During)

        local real distance
        local location point
        local location point2
        local group tmp_group

        call funcs_setTimerParams_Real(t,Key_Skill_DuringInc,duringInc+TimerGetTimeout(t))

        set point =  GetUnitLoc(mover)
        set distance = DistanceBetweenPoints(point, targetPoint)
        if((GetLocationX(targetPoint)==0 and GetLocationX(targetPoint)==0) or distance<speed) then
            call SetUnitPositionLoc( mover, targetPoint)
            call RemoveLocation(targetPoint)
        else
            set point2 = PolarProjectionBJ(point, speed, AngleBetweenPoints(point, targetPoint))
            call SetUnitPositionLoc( mover, point2 )
            if(MEffect != null)then
                call funcs_effectPoint(MEffect,point2)
            endif
            call RemoveLocation(point2)
        endif
        call RemoveLocation(point)

        if(hunt > 0 and ModuloReal( duringInc , TimerGetTimeout(t)*10 ) == TimerGetTimeout(t) ) then
            set point =  GetUnitLoc(mover)
            set tmp_group = funcs_getGroupByPoint(point,range,function filter_live_disbuild)
            call funcs_huntGroup(tmp_group, source ,hunt,HEffect,remove_group,FILTER_ENEMY)
            call DestroyGroup(tmp_group)
            call RemoveLocation(point)
        endif

        if(duringInc >= during or IsUnitDeadBJ(mover) == TRUE) then
            call funcs_delTimer(t,null)
            call SetUnitVertexColorBJ( mover, 100, 100, 100, 0.00 )
        endif

    endfunction

    //前进
    public function forward takes unit mover,unit source,location targetPoint,real speed,string Meffect,real hunt,real range,string Heffect,boolean isRepeat,real during returns nothing
        local real lock_var_period = 0.02
        local location point
        local timer t
        local group remove_group = null

        //debug
        if(mover==null or targetPoint==null or during==null) then
            return
        endif

        //重复判定
        if( isRepeat == false ) then
            set remove_group = CreateGroup()
        else
            set remove_group = null
        endif

        set point = GetUnitLoc(mover)
        if(speed>150) then
            set speed = 150   //最大速度
        elseif(speed<=1) then
            set speed = 1   //最小速度
        endif
        call RemoveLocation(point)
        call SetUnitInvulnerable( mover, true )
        call SetUnitPathing( mover, false )
        set t = funcs_setInterval(lock_var_period,function forwardCall)
        call funcs_setTimerParams_Real(t,Key_Skill_Speed,speed)
        call funcs_setTimerParams_Real(t,Key_Skill_Hunt,hunt)
        call funcs_setTimerParams_Real(t,Key_Skill_Range,range)
        call funcs_setTimerParams_Real(t,Key_Skill_DuringInc,0)
        call funcs_setTimerParams_Real(t,Key_Skill_During,during)
        call funcs_setTimerParams_Unit(t,Key_Skill_Unit,mover)
        call funcs_setTimerParams_Unit(t,Key_Skill_UnitSource,source)
        call funcs_setTimerParams_String(t,Key_Skill_MEffect,Meffect)
        call funcs_setTimerParams_String(t,Key_Skill_HEffect,Heffect)
        call funcs_setTimerParams_Loc(t,Key_Skill_TargetPoint,targetPoint)
        call funcs_setTimerParams_Group(t,Key_Skill_Group,remove_group)
    endfunction


    //跳跃(向某单位)回调
    private function jumpCallBack takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local real speed = funcs_getTimerParams_Real(t,Key_Skill_Speed)
        local real hunt = funcs_getTimerParams_Real(t,Key_Skill_Hunt)
        local real duringInc = funcs_getTimerParams_Real(t,Key_Skill_DuringInc)
        local string JEffect = funcs_getTimerParams_String(t,Key_Skill_JEffect)
        local string HEffect = funcs_getTimerParams_String(t,Key_Skill_HEffect)
        local unit jumper = funcs_getTimerParams_Unit(t,Key_Skill_Unit)
        local unit targetUnit = funcs_getTimerParams_Unit(t,Key_Skill_TargetUnit)
        local real distance
        local location point
        local location point2
        local location targetPoint = GetUnitLoc(targetUnit)
        call funcs_console("handle:jumpCallBack")

		call funcs_setTimerParams_Real(t,Key_Skill_DuringInc,duringInc+TimerGetTimeout(t))

        set point =  GetUnitLoc(jumper)
        set point2 = PolarProjectionBJ(point, speed, AngleBetweenPoints(point, targetPoint))
        call SetUnitPositionLoc( jumper, point2 )
        call RemoveLocation(point2)
        call RemoveLocation(point)

        set point =  GetUnitLoc(jumper)
        if(JEffect != null)then
            call funcs_effectPoint(JEffect,point)
        endif
        set distance = DistanceBetweenPoints(point, targetPoint)
        call funcs_console("distance:"+R2S(distance))
        call funcs_console("speed:"+R2S(speed))
        call RemoveLocation(point)

        if(distance<speed or IsUnitDeadBJ(jumper) or IsUnitDeadBJ(targetUnit) or duringInc > 5) then
            call funcs_console("handle:jumpCallBack END")
            call funcs_delTimer(t,null)
            call SetUnitInvulnerable( jumper, false )
            call SetUnitPathing( jumper, true )
            call SetUnitPositionLoc( jumper, targetPoint)
            call SetUnitVertexColorBJ( jumper, 100, 100, 100, 0.00 )
            if(hunt > 0) then
                call funcs_huntBySelf(hunt,jumper,targetUnit)
                if(HEffect != null)then
                    call funcs_effectPoint(HEffect,targetPoint)
                endif
            endif
            call RemoveLocation(targetPoint)
        endif
    endfunction
    //跳跃(向某单位)
    public function jump takes unit jumper,unit targetUnit,real speed,string Jeffect,real hunt,string Heffect returns nothing
        local real lock_var_period = 0.02
        local location point
        local location targetPoint
        local timer t
        local real distance
        //local group remove_group = CreateGroup()
        //debug
        if(jumper==null or targetUnit==null) then
            return
        endif

        set point = GetUnitLoc(jumper)
        set targetPoint = GetUnitLoc(targetUnit)
        set distance = DistanceBetweenPoints(point, targetPoint)
        if(speed>150) then
            set speed = 150   //最大速度
        elseif(speed<=1) then
            set speed = 1   //最小速度
        endif
        call RemoveLocation(point)
        call RemoveLocation(targetPoint)
        call SetUnitInvulnerable(jumper, true )
        call SetUnitPathing( jumper, false )
        set t = funcs_setInterval(lock_var_period,function jumpCallBack)
        call funcs_setTimerParams_Real(t,Key_Skill_Speed,speed)
        call funcs_setTimerParams_Real(t,Key_Skill_Hunt,hunt)
        call funcs_setTimerParams_Unit(t,Key_Skill_Unit,jumper)
        call funcs_setTimerParams_Unit(t,Key_Skill_TargetUnit,targetUnit)
        call funcs_setTimerParams_String(t,Key_Skill_JEffect,Jeffect)
        call funcs_setTimerParams_String(t,Key_Skill_HEffect,Heffect)
        call funcs_setTimerParams_Real(t,Key_Skill_DuringInc,0)
    endfunction

    //穿梭回调
    private function shuttleCall takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer during = funcs_getTimerParams_Integer( t , Key_Skill_During )
        local unit shutter = funcs_getTimerParams_Unit( t , Key_Skill_Unit  )
        local group whichGroup = funcs_getTimerParams_Group( t , Key_Skill_Group )
        local real hunt = funcs_getTimerParams_Real( t , Key_Skill_Hunt )
        local real huntPlus = funcs_getTimerParams_Real( t , Key_Skill_HuntPlus )
        local integer times = funcs_getTimerParams_Integer( t , Key_Skill_Times )
        local real speed = funcs_getTimerParams_Real( t , Key_Skill_Speed  )
        local real speedPlus = funcs_getTimerParams_Real( t , Key_Skill_SpeedPlus )
        local real offsetDistance = funcs_getTimerParams_Real( t , Key_Skill_Distance )
        local integer attrTag = funcs_getTimerParams_Integer( t , Key_Skill_AttrTag )
        local integer attrVal =  funcs_getTimerParams_Integer( t , Key_Skill_AttrVal )
        local integer attrDur = funcs_getTimerParams_Integer( t , Key_Skill_AttrDuring )
        local string JEffect = funcs_getTimerParams_String( t , Key_Skill_JEffect )
        local string HEffect = funcs_getTimerParams_String( t , Key_Skill_HEffect )
        local string animate = funcs_getTimerParams_String( t , Key_Skill_Animate )
        local integer skillModel = funcs_getTimerParams_Integer( t , Key_Skill_Model  )
        local real swimTime = funcs_getTimerParams_Real( t , Key_Skill_During2 )
        local real crashRange = funcs_getTimerParams_Real( t , Key_Skill_Distance2 )
        local boolean isAttack = funcs_getTimerParams_Boolean( t , Key_Skill_Boolean )
        local unit targetUnit = funcs_getTimerParams_Unit( t , Key_Skill_TargetUnit )
        local location targetLoc = funcs_getTimerParams_Loc( t , Key_Skill_Loc )
        //--------------------
        local integer playerIndex = GetConvertedPlayerId(GetOwningPlayer(shutter))
        local real distance = 0
        local location loc = null
        local location tempLoc = null
        local integer i = 0
        local unit tempUnit = null
        local group crashGroup = null


        if( shutter !=null and IsUnitAliveBJ(shutter) == true and CountUnitsInGroup(whichGroup)>0 ) then
            if( during <1 ) then
                call abilities_registAbility(shutter,skillModel)
            endif
            //TODO
            set loc = GetUnitLoc(shutter)
            //向一个单位进行目标穿梭,如果没有，从单位组取一个(需要进行缓存)
            if( targetUnit == null ) then
                set targetUnit = GroupPickRandomUnit(whichGroup)
                set tempLoc = GetUnitLoc(targetUnit)
                set targetLoc = PolarProjectionBJ( tempLoc , offsetDistance , AngleBetweenPoints(loc, tempLoc) )
                call funcs_setTimerParams_Unit( t , Key_Skill_TargetUnit , targetUnit ) //save
                call funcs_setTimerParams_Loc( t , Key_Skill_Loc , targetLoc ) //save
                call RemoveLocation(tempLoc)
            endif
            //移动
            call SetUnitFacing(shutter, AngleBetweenPoints(loc, targetLoc))
            call SetUnitPositionLoc( shutter, PolarProjectionBJ(loc, speed, AngleBetweenPoints(loc, targetLoc)) )
            //移动特效
            if( JEffect != null )then
                call funcs_effectPoint( JEffect , loc )
            endif
            //计算单轮距离是否到终点
            set distance = DistanceBetweenPoints( loc, targetLoc )
            call RemoveLocation(loc)
            call funcs_console("distance"+R2S(distance))
            //
            call funcs_console("hunt"+R2S(hunt))
            if( distance < speed ) then //单轮结束
                //添加攻击判定
                if( isAttack == true ) then
                    call eventRegist_registerBeAttack( shutter , targetUnit )
                endif
                call SetUnitAnimation( shutter, animate )
                call SetUnitPositionLoc( shutter, targetLoc)
                call RemoveLocation(targetLoc)
                //伤害
                if( IsUnitAliveBJ(targetUnit) == true and hunt > 0 ) then
                    call funcs_huntBySelf( hunt, shutter , targetUnit )
                    if( HEffect != null)then
                        set loc =  GetUnitLoc( targetUnit )
                        call funcs_effectPoint( HEffect,loc )
                        call RemoveLocation( loc )
                    endif
                endif
                //眩晕
                if( IsUnitAliveBJ(targetUnit) == true and swimTime >= 0.5) then
                    call swim( targetUnit , swimTime )
                endif
                //击退
                if( crashRange > 0 ) then
                    set crashGroup = CreateGroup()
                    call crash( shutter , crashRange , 8.00 , crashGroup )
                endif
                //TAG增益
                if( attrTag > 0 and  attrVal >0 and  attrDur>0 ) then
                    call attribute_changeAttribute(attrTag, playerIndex , attrVal , attrDur )
                endif
                if( during+1 >= times ) then
                    call funcs_delTimer( t, null )
                    if(skillModel!=null) then
                        call abilities_unsetAbility(shutter,skillModel)
                    endif
                    call SetUnitPositionLoc( shutter, targetLoc)
                    call RemoveLocation(targetLoc)
                    call SetUnitTimeScale( shutter, 1 )
                    call SetUnitInvulnerable( shutter, false )
                    call SetUnitPathing( shutter, true )
                    call SetUnitVertexColorBJ( shutter, 100, 100, 100, 0.00 )
                    call GroupClear(whichGroup)
                    call DestroyGroup(whichGroup)
                    call funcs_console("shuttleForGroup END NORMAL")
                else
                    //选定下一个
                    set i = 1
                    set tempUnit = GroupPickRandomUnit(whichGroup)
                    loop
                        exitwhen( (IsUnitAliveBJ(targetUnit) ==true and tempUnit != targetUnit) or i>5 )
                        set tempUnit = GroupPickRandomUnit(whichGroup)
                        set i = i + 1
                    endloop
                    set loc = GetUnitLoc(shutter)
                    set tempLoc = GetUnitLoc(tempUnit)
                    set targetLoc = PolarProjectionBJ( tempLoc , offsetDistance , AngleBetweenPoints(loc, tempLoc) )
                    call RemoveLocation(tempLoc)
                    call RemoveLocation(loc)
                    call funcs_setTimerParams_Integer( t , Key_Skill_During ,(during + 1))
                    call funcs_setTimerParams_Unit( t , Key_Skill_TargetUnit , tempUnit )
                    call funcs_setTimerParams_Loc( t , Key_Skill_Loc , targetLoc )
                    call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt+huntPlus )
                    call funcs_setTimerParams_Real( t , Key_Skill_Speed , speed+speedPlus )
                endif
            endif
        else
            call funcs_delTimer( t, null )
            if(shutter !=null ) then
                if(skillModel!=null) then
                    call abilities_unsetAbility(shutter,skillModel)
                endif
                call SetUnitTimeScale( shutter, 1 )
                call SetUnitInvulnerable( shutter, false )
                call SetUnitPathing( shutter, true )
                call SetUnitVertexColorBJ( shutter, 100, 100, 100, 0.00 )
            endif
            if( targetLoc !=null )then
                call RemoveLocation(targetLoc)
            endif
            call GroupClear(whichGroup)
            call DestroyGroup(whichGroup)
            call funcs_console("shuttleForGroup Start SP")
        endif

    endfunction

    /**
     *  穿梭选定单位组
     * shuttlePeriod 穿梭周期
     * times 穿梭次数
     * isAttack 是否触发普通攻击判定
     */
    public function shuttleForGroup takes unit shutter,group whichGroup,integer times,real hunt,real huntPlus,real speed,real speedPlus,real offsetDistance,integer attrTag,integer attrVal,integer attrDur,string JEffect,string HEffect,string animate,integer skillModel,real swimTime,real crashRange,boolean isAttack returns nothing
        local timer t = null
        local real shuttlePeriod = 0.03
        call funcs_console("shuttleForGroup Start")
        call SetUnitTimeScale( shutter, 10 )
        call SetUnitInvulnerable( shutter, true )
        call SetUnitPathing( shutter, false )
        set t = funcs_setInterval( shuttlePeriod ,function shuttleCall )
        call funcs_setTimerParams_Integer( t , Key_Skill_During , 0 )
        call funcs_setTimerParams_Unit( t , Key_Skill_Unit , shutter )
        call funcs_setTimerParams_Group( t , Key_Skill_Group , whichGroup )
        call funcs_setTimerParams_Real( t , Key_Skill_Hunt , hunt )
        call funcs_setTimerParams_Real( t , Key_Skill_HuntPlus , huntPlus )
        call funcs_setTimerParams_Integer( t , Key_Skill_Times , times )
        call funcs_setTimerParams_Real( t , Key_Skill_Speed , speed )
        call funcs_setTimerParams_Real( t , Key_Skill_SpeedPlus , speedPlus )
        call funcs_setTimerParams_Real( t , Key_Skill_Distance , offsetDistance )
        call funcs_setTimerParams_Integer( t , Key_Skill_AttrTag , attrTag )
        call funcs_setTimerParams_Integer( t , Key_Skill_AttrVal , attrVal )
        call funcs_setTimerParams_Integer( t , Key_Skill_AttrDuring , attrDur )
        call funcs_setTimerParams_String( t , Key_Skill_JEffect , JEffect )
        call funcs_setTimerParams_String( t , Key_Skill_HEffect , HEffect )
        call funcs_setTimerParams_String( t , Key_Skill_Animate , animate )
        call funcs_setTimerParams_Integer( t , Key_Skill_Model , skillModel )
        call funcs_setTimerParams_Real( t , Key_Skill_During2 , swimTime )
        call funcs_setTimerParams_Real( t , Key_Skill_Distance2 , crashRange )
        call funcs_setTimerParams_Boolean( t , Key_Skill_Boolean , isAttack )
    endfunction

    /**
     * 回避回调
     */
    private function avoidCallBack takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit whichUnit = funcs_getTimerParams_Unit(t,1)
        call UnitAddAbility( whichUnit, ABILITY_AVOID_MIUNS )
        call SetUnitAbilityLevel( whichUnit, ABILITY_AVOID_MIUNS, 2 )
        call UnitRemoveAbility( whichUnit, ABILITY_AVOID_MIUNS )
        call funcs_delTimer(t,null)
    endfunction
    /**
     * 回避
     */
    public function avoid takes unit whichUnit returns nothing
        local timer t = null
        if(whichUnit==null) then
            return
        endif
        call UnitAddAbility( whichUnit, ABILITY_AVOID_PLUS )
        call SetUnitAbilityLevel( whichUnit, ABILITY_AVOID_PLUS, 2 )
        call UnitRemoveAbility( whichUnit, ABILITY_AVOID_PLUS )
        set t = funcs_setTimeout( 0.00 ,function avoidCallBack)
        call funcs_setTimerParams_Unit(t,1,whichUnit)
    endfunction

    /**
     * 0秒无敌回调
     */
    public function zeroInvulnerableCallBack takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit whichUnit = funcs_getTimerParams_Unit(t,1)
        call SetUnitInvulnerable( whichUnit , false )
        call funcs_delTimer(t,null)
    endfunction
    /**
     * 0秒无敌
     */
    public function zeroInvulnerable takes unit whichUnit returns nothing
        local timer t = null
        if(whichUnit==null) then
            return
        endif
        call SetUnitInvulnerable( whichUnit, true )
        set t = funcs_setTimeout( 0.00 ,function zeroInvulnerableCallBack)
        call funcs_setTimerParams_Unit(t,1,whichUnit)
    endfunction
    
    /**
     * 无敌回调
     */
    private function invulnerableCallBack takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit whichUnit = funcs_getTimerParams_Unit(t,Key_Skill_Unit)
        call SetUnitInvulnerable( whichUnit , false )
        call funcs_console("handle:invulnerableCallBack END")
        call funcs_delTimer(t,null)
    endfunction

    /**
     * 无敌
     */
    public function invulnerable takes unit whichUnit,real during returns nothing
        local timer t = null
        if(whichUnit==null) then
            return
        endif
        if( during == null ) then
            set during = 0.00       //如果没有设置持续时间，则0秒无敌，跟回避效果相同
        endif
        call SetUnitInvulnerable( whichUnit, true )
        set t = funcs_setTimeout( during ,function invulnerableCallBack)
        call funcs_setTimerParams_Unit(t,Key_Skill_Unit,whichUnit)
    endfunction

    /**
     * 群体无敌回调1
     */
    private function invulnerableGroupCallBack1 takes nothing returns nothing
        call SetUnitInvulnerable( GetEnumUnit() , true )
    endfunction

    /**
     * 群体无敌回调2
     */
    private function invulnerableGroupCallBack2 takes nothing returns nothing
        call SetUnitInvulnerable( GetEnumUnit() , false )
    endfunction

     /**
     * 群体无敌回调T
     */
    private function invulnerableGroupCallBackT takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local group whichGroup = funcs_getTimerParams_Group( t,Key_Skill_Group )
        call ForGroup(whichGroup, function invulnerableGroupCallBack2)
        call GroupClear(whichGroup)
        call DestroyGroup(whichGroup)
    endfunction

    /**
     * 群体无敌
     */
    public function invulnerableGroup takes group whichGroup ,real during returns nothing
        local timer t = null
        if( whichGroup == null ) then
            return
        endif
        call ForGroup(whichGroup, function invulnerableGroupCallBack1)
        set t = funcs_setTimeout( during ,function invulnerableGroupCallBackT)
        call funcs_setTimerParams_Group(t,Key_Skill_Group,whichGroup)
    endfunction

    /**
     * 僵直/硬直效果回调
     */
    private function punishCallBack takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit whichUnit = funcs_getTimerParams_Unit(t,Key_Skill_Unit)
        local integer skillPunishType = funcs_getTimerParams_Integer(t,Key_Skill_i)
        call PauseUnit( whichUnit , false )
        if( skillPunishType > 0 ) then
            call SetUnitVertexColorBJ( whichUnit , 100, 100, 100, 0 )
        endif
        call SetUnitTimeScalePercent( whichUnit , 100.00 )
        call funcs_console("handle:punishCallBack END")
        call funcs_delTimer(t,null)
    endfunction

    /**
     * 僵直/硬直效果
     */
    public function punish takes unit whichUnit,real during,integer skillPunishType returns nothing
        local timer t = null
        local timer prevTimer = null
        local real prevTimeRemaining = 0
        if(whichUnit==null) then
            return
        endif
        if( during == null ) then
            set during = 0.01   //假如没有设置时间，默认打断效果
        endif
        set prevTimer = LoadTimerHandle( HASH_Punish , GetHandleId(whichUnit) , Key_Skill_Punish )
        set prevTimeRemaining = TimerGetRemaining(prevTimer)
        if( prevTimeRemaining > 0 )then
            call funcs_delTimer( prevTimer ,null )
        else
            set prevTimeRemaining = 0
        endif
        if( skillPunishType == SKILL_PUNISH_TYPE_black ) then
            call SetUnitVertexColorBJ( whichUnit , 30, 30, 30, 0 )
        elseif( skillPunishType == SKILL_PUNISH_TYPE_blue ) then
        	call SetUnitVertexColorBJ( whichUnit , 30, 30, 150 , 0 )
        endif
        call SetUnitTimeScalePercent( whichUnit, 0.00 )
        call PauseUnit( whichUnit, true )
        set t = funcs_setTimeout( (during+prevTimeRemaining) ,function punishCallBack )
        call funcs_setTimerParams_Unit(t,Key_Skill_Unit,whichUnit)
        call funcs_setTimerParams_Integer(t,Key_Skill_i, skillPunishType )
        call SaveTimerHandle( HASH_Punish , GetHandleId(whichUnit) , Key_Skill_Punish , t )
    endfunction

    /**
     * 玩家镜头摇晃回调（其实这个函数应该写在funcs里，为了方便管理，才与回避硬直等放在一块）
     * 镜头源
     */
    private function cameraNoiseSetTargetCallBack takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local player whichPlayer = funcs_getTimerParams_Player(t,Key_Skill_Player)
        if (GetLocalPlayer() == whichPlayer) then
            call CameraSetTargetNoise(0, 0)
        endif
        call funcs_setPlayerParams_Boolean( whichPlayer , Key_Skill_Camera , false)
        call funcs_console("handle:cameraNoiseSetTargetCallBack END")
        call funcs_delTimer(t,null)
    endfunction

    /**
     * 玩家镜头摇晃
     * @param scale 振幅 - 摇晃
     */
    public function cameraNoiseSetTarget takes player whichPlayer,real during,real scale returns nothing
        local timer t
        if(whichPlayer==null) then
            return
        endif
        if( during == null ) then
            set during = 0.10   //假如没有设置时间，默认0.10秒意思意思一下
        endif
        if( scale == null ) then
            set scale = 5.00   //假如没有振幅，默认5.00意思意思一下
        endif

        //镜头动作降噪
        if( funcs_getPlayerParams_Boolean( whichPlayer , Key_Skill_Camera ) == true ) then
            return
        else
            call funcs_setPlayerParams_Boolean( whichPlayer , Key_Skill_Camera , true)
        endif

        call CameraSetTargetNoiseForPlayer( whichPlayer , scale , 1.00 )    //0.50为速率
        set t = funcs_setTimeout( during ,function cameraNoiseSetTargetCallBack)
        call funcs_setTimerParams_Player(t,Key_Skill_Player,whichPlayer)
    endfunction

    /**
     * 玩家镜头震动回调（其实这个函数应该写在funcs里，理由同摇晃）
     */
    private function cameraNoiseSetEQCallBack takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local player whichPlayer = funcs_getTimerParams_Player(t,Key_Skill_Player)
        call CameraClearNoiseForPlayer( whichPlayer )
        call funcs_setPlayerParams_Boolean( whichPlayer , Key_Skill_Camera , false)
        call funcs_console("handle:cameraNoiseSetEQCallBack END")
        call funcs_delTimer(t,null)
    endfunction

    /**
     * 玩家镜头震动
     * @param scale 振幅 - 震动
     */
    public function cameraNoiseSetEQ takes player whichPlayer,real during,real scale returns nothing
        local timer t
        if(whichPlayer==null) then
            return
        endif
        if( during == null ) then
            set during = 0.10   //假如没有设置时间，默认0.10秒意思意思一下
        endif
        if( scale == null ) then
            set scale = 5.00   //假如没有振幅，默认5.00意思意思一下
        endif

        //镜头动作降噪
        if( funcs_getPlayerParams_Boolean( whichPlayer , Key_Skill_Camera ) == true ) then
            return
        else
            call funcs_setPlayerParams_Boolean( whichPlayer , Key_Skill_Camera , true)
        endif

        call CameraSetEQNoiseForPlayer( whichPlayer , scale )
        set t = funcs_setTimeout( during ,function cameraNoiseSetEQCallBack)
        call funcs_setTimerParams_Player(t,Key_Skill_Player,whichPlayer)
    endfunction

endlibrary

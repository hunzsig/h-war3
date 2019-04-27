
/* 管理器：管理所有模式的初始化和进度 */
library scheduleGroup requires scheduleNormal

	/**
     * 敌军开始Gate
     */
    public function start takes nothing returns nothing
        if( Enemy_Timer_Main != null ) then
            call funcs_delTimer(Enemy_Timer_Main,null)
        endif
        set Enemy_Timer_Main = funcs_setTimeout( scheduleNormal_getRoadPeriod() , function scheduleNormal_main )
    	call funcs_setTimerDialog(Enemy_Timer_Main,"敌人正在蠢蠢欲动")
    endfunction

    /**
     * 敌军Stop
     */
    public function stop takes nothing returns nothing
        if( Enemy_Timer_Main != null ) then
            set Enemy_Timer_CountDown_Cache = R2I(TimerGetRemaining(Enemy_Timer_Main))
            call funcs_delTimer(Enemy_Timer_Main,null)
        endif
        set Enemy_Timer_Main = null
    endfunction

    /**
	 * 初始化
	 */
	public function init takes nothing returns nothing
		call scheduleNormal_init()
		call characterEnemySpellNormal_init()
		call start()
	endfunction

    /**
     * 阶段性升级
     */
    public function update takes nothing returns nothing
		//神木
        call characterAlly_upLvGodWood()
        //金矿
        call characterEnv_upLvGold()
        //敌人
        call scheduleNormal_upLvEnemy()
    endfunction

endlibrary

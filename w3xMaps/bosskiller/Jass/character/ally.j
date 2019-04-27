
library characterAlly requires characterEnv

	//周期给1金
    private function add1Gold takes nothing returns nothing
        local integer i
        set i = 1
        loop
            exitwhen i > Max_Player_num
                call funcs_addGold( Players[i] , 1 )
            set i = i + 1
        endloop
    endfunction

	//周期给1木
    private function add1Lumber takes nothing returns nothing
        local integer i
        set i = 1
        loop
            exitwhen i > Max_Player_num
                call funcs_addLumber( Players[i] , 1 )
            set i = i + 1
        endloop
    endfunction

	//初始化
    public function init takes nothing returns nothing
		//周期赠送木头
        call funcs_setInterval( 200.00 , function add1Lumber )

    endfunction

    private function buildGodTreeCorel takes nothing returns nothing
    	call funcs_setFailHandle_Unit(CreateUnitAtLoc( Player_Ally_Building , Unit_God_Tree_Core , Center_C ,270.00 ),"神木核心完全枯萎......世界渐渐堕入无限黑暗！失守！！")
	    call funcs_print( "痛心|cffffff00神木|r已被毁坏，暴露出了核心！" )
	    call PingMinimapLocForForceEx( GetPlayersAll(), Center_C, 3.00 , bj_MINIMAPPINGSTYLE_FLASHY, 100, 100, 100 )
	endfunction

	//建立一个中心基地 - 神木 - normal
    public function buildGodTreeNormal takes nothing returns nothing
    	local trigger t = CreateTrigger()
    	local unit u = CreateUnitAtLoc( Player_Ally_Building , Unit_God_Tree_Normal , Center_C ,270.00 )
	    call funcs_print( "请|cffffff00守护好神木|r，神木毁坏，世界将迎来黑暗时代！" )
	    call eventRegist_unitDeath( t,u )
	    call TriggerAddAction( t , function buildGodTreeCorel)
	    call PingMinimapLocForForceEx( GetPlayersAll(), Center_C, 3.00 , bj_MINIMAPPINGSTYLE_FLASHY, 100, 100, 100 )
    endfunction



    /*  -UPDATE-  */

    //神树升级
    public function upLvGodWood takes nothing returns nothing
        local integer i
        if( GetPlayerTechCountSimple( GodWood_upLevel_tec , Player_Ally_Building ) >= 30 ) then
            return
        else
            call SetPlayerTechResearched( Player_Ally_Building , GodWood_upLevel_tec , GetPlayerTechCountSimple(GodWood_upLevel_tec, Player_Ally_Building )+1  )
        endif
    endfunction

endlibrary

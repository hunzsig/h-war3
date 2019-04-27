library m1Ally requires m1Enemy

    //周期给1金
    public function add1Gold takes nothing returns nothing
        local integer i
        set i = 1
        loop
            exitwhen i > Max_Player_num
                call funcs_addGold( Players[i] , 1 )
            set i = i + 1
        endloop
    endfunction

	//周期给1木
    public function add1Lumber takes nothing returns nothing
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
    endfunction

endlibrary

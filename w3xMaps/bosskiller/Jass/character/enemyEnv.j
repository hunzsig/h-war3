globals

    //环境
    integer Env_rain        = 'u00P'
    integer Env_storm     = 'u00O'
    integer Env_fire         = 'u00I'
    integer Env_storn      = 'u00N'
    integer Env_dark      = 'u00M'
    integer Env_ice_s      = 'u00J'
    integer Env_ice_l      = 'u00K'

endglobals

library characterEnemyEnv requires characterEnemySpellGod

    //召唤环境
    public function create takes integer currentEnemy returns nothing
        local location loc = null
        local integer i = 0
        local integer qty = 0
        local unit createUnit = null
        if( currentEnemy == 1 ) then
            set i = 1
            set qty = 3
            loop
                exitwhen i >qty
                set loc = PolarProjectionBJ( Center_C , 800 , 360*i / qty )
                set createUnit = funcs_createUnit( Player_Enemy_Building , Env_storn , loc , loc )
                call GroupAddUnit( Enemy_Config_Final_Environment[currentEnemy] , createUnit )
                call RemoveLocation( loc )
                set i = i+1
            endloop
        elseif( currentEnemy == 2 ) then
            set i = 1
            set qty = 2
            loop
                exitwhen i >qty
                set loc = PolarProjectionBJ( Center_C , 1000 , 360*i / qty )
                set createUnit = funcs_createUnit( Player_Enemy_Building , Env_rain , loc , loc )
                call GroupAddUnit( Enemy_Config_Final_Environment[currentEnemy] , createUnit )
                call RemoveLocation( loc )
                set i = i+1
            endloop
        elseif(  currentEnemy == 3 ) then
            set i = 1
            set qty = 8
            loop
                exitwhen i >qty
                set loc = PolarProjectionBJ( Center_C , GetRandomReal(250,1300) , 360*i / qty )
                set createUnit = funcs_createUnit( Player_Enemy_Building , Env_fire , loc , loc )
                call GroupAddUnit( Enemy_Config_Final_Environment[currentEnemy] , createUnit )
                call RemoveLocation( loc )
                set i = i+1
            endloop
        elseif( currentEnemy == 4 ) then
            set i = 1
            set qty = 8
            loop
                exitwhen i >qty
                set loc = PolarProjectionBJ( Center_C , 800 , 360*i / qty )
                set createUnit = funcs_createUnit( Player_Enemy_Building , Env_storm , loc , loc )
                call GroupAddUnit( Enemy_Config_Final_Environment[currentEnemy] , createUnit )
                call RemoveLocation( loc )
                set i = i+1
            endloop
        elseif( currentEnemy == 5 ) then
            set i = 1
            set qty = 5
            loop
                exitwhen i >qty
                set loc = PolarProjectionBJ( Center_C , GetRandomReal(250,1300) , 360*i / qty )
                set createUnit = funcs_createUnit( Player_Enemy_Building , Env_dark , loc , loc )
                call GroupAddUnit( Enemy_Config_Final_Environment[currentEnemy] , createUnit )
                call RemoveLocation( loc )
                set i = i+1
            endloop
        elseif( currentEnemy == 6 ) then
            set i = 1
            set qty = 6
            loop
                exitwhen i >qty
                set loc = PolarProjectionBJ( Center_C , GetRandomReal(300,1500) , 360*i / qty )
                set createUnit = funcs_createUnit( Player_Enemy_Building , Env_ice_s , loc , loc )
                call GroupAddUnit( Enemy_Config_Final_Environment[currentEnemy] , createUnit )
                call RemoveLocation( loc )
                set i = i+1
            endloop
            set i = 1
            set qty = 3
            loop
                exitwhen i >qty
                set loc = PolarProjectionBJ( Center_C , GetRandomReal(400,1000) , 360*i / qty )
                set createUnit = funcs_createUnit( Player_Enemy_Building , Env_ice_l , loc , loc )
                call GroupAddUnit( Enemy_Config_Final_Environment[currentEnemy] , createUnit )
                call RemoveLocation( loc )
                set i = i+1
            endloop
        elseif( currentEnemy == 7 ) then
            set i = 1
            set qty = 12
            loop
                exitwhen i >qty
                set loc = PolarProjectionBJ( Center_C , 800 , 360*i / qty )
                set createUnit = funcs_createUnit( Player_Enemy_Building , Env_storm , loc , loc )
                call GroupAddUnit( Enemy_Config_Final_Environment[currentEnemy] , createUnit )
                call RemoveLocation( loc )
                set i = i+1
            endloop
        elseif( currentEnemy == 8 ) then
            set i = 1
            set qty = 5
            loop
                exitwhen i >qty
                set loc = PolarProjectionBJ( Center_C , 800 , 360*i / qty )
                set createUnit = funcs_createUnit( Player_Enemy_Building , Env_storm , loc , loc )
                call GroupAddUnit( Enemy_Config_Final_Environment[currentEnemy] , createUnit )
                call RemoveLocation( loc )
                set i = i+1
            endloop
            set i = 1
            set qty = 2
            loop
                exitwhen i >qty
                set loc = PolarProjectionBJ( Center_C , 1000 , 360*i / qty )
                set createUnit = funcs_createUnit( Player_Enemy_Building , Env_rain , loc , loc )
                call GroupAddUnit( Enemy_Config_Final_Environment[currentEnemy] , createUnit )
                call RemoveLocation( loc )
                set i = i+1
            endloop
        endif
    endfunction

    //召唤环境 -  混乱
    public function createChaos takes nothing returns nothing
        local location loc = null
        local integer i = 0
        local integer qty = 0
        local unit createUnit = null
        //石头
        set i = 1
        set qty = 3
        loop
            exitwhen i >qty
            set loc = PolarProjectionBJ( Center_C , 800 , 360*i / qty )
            set createUnit = funcs_createUnit( Player_Enemy_Building , Env_storn , loc , loc )
            call RemoveLocation( loc )
            set i = i+1
        endloop
        //酸雨
        set createUnit = funcs_createUnit( Player_Enemy_Building , Env_rain , Center_C , Center_C )
        //烈焰
        set i = 1
        set qty = 3
        loop
            exitwhen i >qty
            set loc = PolarProjectionBJ( Center_C , GetRandomReal(200,1000) , 360*i / qty )
            set createUnit = funcs_createUnit( Player_Enemy_Building , Env_fire , loc , loc )
            call RemoveLocation( loc )
            set i = i+1
        endloop
        //暴风
        set i = 1
        set qty = 4
        loop
            exitwhen i >qty
            set loc = PolarProjectionBJ( Center_C , 700 , 360*i / qty )
            set createUnit = funcs_createUnit( Player_Enemy_Building , Env_storm , loc , loc )
            call RemoveLocation( loc )
            set i = i+1
        endloop
        //暗黑
        set i = 1
        set qty = 2
        loop
            exitwhen i >qty
            set loc = PolarProjectionBJ( Center_C , GetRandomReal(200,1000) , 360*i / qty )
            set createUnit = funcs_createUnit( Player_Enemy_Building , Env_dark , loc , loc )
            call RemoveLocation( loc )
            set i = i+1
        endloop
        //小冰
        set i = 1
        set qty = 3
        loop
            exitwhen i >qty
            set loc = PolarProjectionBJ( Center_C , GetRandomReal(350,1200) , 360*i / qty )
            set createUnit = funcs_createUnit( Player_Enemy_Building , Env_ice_s , loc , loc )
            call RemoveLocation( loc )
            set i = i+1
        endloop
        //大冰
        set i = 1
        set qty = 2
        loop
            exitwhen i >qty
            set loc = PolarProjectionBJ( Center_C , GetRandomReal(500,1200) , 360*i / qty )
            set createUnit = funcs_createUnit( Player_Enemy_Building , Env_ice_l , loc , loc )
            call RemoveLocation( loc )
            set i = i+1
        endloop
    endfunction

    //删除环境 - 执行
    private function delEnv takes nothing returns nothing
        call RemoveUnit( GetEnumUnit() )
    endfunction

	//删除环境
    public function del takes integer currentEnemy returns nothing
        call ForGroup( Enemy_Config_Final_Environment[currentEnemy] , function delEnv )
    endfunction

endlibrary

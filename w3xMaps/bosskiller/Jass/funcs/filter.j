library filter requires funcs

    //适配器 条件 | [存活]
    public function live takes nothing returns boolean
        local boolean boole = true
        local unit filterUnit = GetFilterUnit()

        if(IsUnitDeadBJ(filterUnit)) then
            set boole = false
        endif
        return boole
    endfunction

    //适配器 条件 | [存活][NO建筑]
    public function live_disbuild takes nothing returns boolean
        local boolean boole = true
        local unit filterUnit = GetFilterUnit()

        if(IsUnitDeadBJ(filterUnit)) then
            set boole = false
        endif
        if(IsUnitType(filterUnit, UNIT_TYPE_STRUCTURE) == true) then
            set boole = false
        endif
        return boole
    endfunction

    //适配器 条件 | [存活][建筑]
    public function live_build takes nothing returns boolean
        local boolean boole = true
        local unit filterUnit = GetFilterUnit()

        if(IsUnitDeadBJ(filterUnit)) then
            set boole = false
        endif
        if(IsUnitType(filterUnit, UNIT_TYPE_STRUCTURE) == false) then
            set boole = false
        endif
        return boole
    endfunction

    //适配器 条件 | [存活][非英雄]
    public function live_dishero takes nothing returns boolean
        local boolean boole = true
        local unit filterUnit = GetFilterUnit()

        if(IsUnitDeadBJ(filterUnit)) then
            set boole = false
        endif
        if(IsUnitType(filterUnit, UNIT_TYPE_HERO) == true) then
            set boole = false
        endif
        return boole
    endfunction

    //适配器 条件 | [存活][英雄]
    public function live_hero takes nothing returns boolean
        local boolean boole = true
        local unit filterUnit = GetFilterUnit()

        if(IsUnitDeadBJ(filterUnit)) then
            set boole = false
        endif
        if(IsUnitType(filterUnit, UNIT_TYPE_HERO) == false) then
            set boole = false
        endif
        return boole
    endfunction

    //适配器 条件 | [存活][NO建筑][非英雄]
    public function live_disbuild_dishero takes nothing returns boolean
        local boolean boole = true
        local unit filterUnit = GetFilterUnit()

        if(IsUnitDeadBJ(filterUnit)) then
            set boole = false
        endif
        if(IsUnitType(filterUnit, UNIT_TYPE_STRUCTURE) == true) then
            set boole = false
        endif
        if(IsUnitType(filterUnit, UNIT_TYPE_HERO) == true) then
            set boole = false
        endif
        return boole
    endfunction

    //适配器 条件 | [存活][NO建筑][地面]
    public function live_disbuild_ground takes nothing returns boolean
        local boolean boole = true
        local unit filterUnit = GetFilterUnit()

        if(IsUnitDeadBJ(filterUnit)) then
            set boole = false
        endif
        if(IsUnitType(filterUnit, UNIT_TYPE_STRUCTURE) == true) then
            set boole = false
        endif
        if(IsUnitType(filterUnit, UNIT_TYPE_GROUND) == false) then
            set boole = false
        endif
        return boole
    endfunction

    //适配器 条件 | [死的]
    public function death takes nothing returns boolean
        local boolean boole = true
        local unit filterUnit = GetFilterUnit()

        if(IsUnitAliveBJ(filterUnit)) then
            set boole = false
        endif
        return boole
    endfunction



endlibrary

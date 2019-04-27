library filterTrigger requires funcs

    //适配器 条件 | [敌人][存活][NO建筑]
    public function enemy_live_disbuild takes nothing returns boolean
        local boolean boole = true
        local unit filterUnit = GetFilterUnit()
        if(IsUnitDeadBJ(filterUnit)) then
            set boole = false
        endif
        if(IsUnitType(filterUnit, UNIT_TYPE_STRUCTURE) == true) then
            set boole = false
        endif
        if(IsUnitEnemy(filterUnit, GetOwningPlayer(GetTriggerUnit())) == false) then
            set boole = false
        endif
        return boole
    endfunction

endlibrary

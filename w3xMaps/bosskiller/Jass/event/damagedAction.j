//eventDamagedAction
library eventDamagedAction requires eventRegist

    //****以下为伤害源判定

    //小型炸弹
    public function xiaoxingzhadan takes unit sourceUnit,unit beUnit returns nothing
        local location sourceLoc = GetUnitLoc(sourceUnit)
        local location beLoc = GetUnitLoc(beUnit)
        local group g = null
        local real hunt = GetUnitState( sourceUnit , UNIT_STATE_MAX_LIFE ) * 1.50
        set g = funcs_getGroupByPoint(beLoc,150.00,function filter_live)
        call funcs_huntGroup(g,sourceUnit, hunt ,Effect_Explosion,null,FILTER_ENEMY)
        call TerrainDeformationCraterBJ( 0.5, false, beLoc, 100, 32 )
        call DestroyGroup(g)
        call ExplodeUnitBJ( sourceUnit )
        call RemoveLocation(beLoc)
        call RemoveLocation(sourceLoc)
    endfunction

endlibrary

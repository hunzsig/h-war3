function Trig_event_beAttackConditions takes nothing returns boolean
    return ((IsUnitType(GetAttacker(), UNIT_TYPE_HERO) == true) and (GetPlayerController(GetOwningPlayer(GetAttacker())) == MAP_CONTROL_USER) and (IsUnitEnemy(GetAttacker(), Player_Enemy_Building) == true))
endfunction

function Trig_event_beAttackActions takes nothing returns nothing
    call eventRegist_registerBeAttack( GetAttacker(), GetTriggerUnit() )
endfunction

//===========================================================================
function InitTrig_event_beAttack takes nothing returns nothing
    set gg_trg_event_beAttack = CreateTrigger()
    call TriggerAddAction(gg_trg_event_beAttack, function Trig_event_beAttackActions)
    call TriggerAddCondition(gg_trg_event_beAttack, Condition(function Trig_event_beAttackConditions))
endfunction

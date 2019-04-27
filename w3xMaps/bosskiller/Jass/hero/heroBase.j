library heroBase initializer init requires skills

	private function isHero takes nothing returns boolean
	    return (IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == true)
	endfunction

	/* ------------------------------------------ */
	//鹰眼
	private function talent_eagle_eye takes nothing returns nothing
		//nothing
	endfunction

	//冲锋
	private function talent_charge takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
	    local real facing = GetUnitFacing(u)
	    local real speed = I2R(level)+19
	    local real hunt = I2R(level) * 30
	    local real range = 75
	    local real distance = 250 + I2R(level) * 50
	    call SetUnitVertexColorBJ( u, 100, 100, 100, 95.00 )
	    call skills_charge(u,facing,distance,speed,SKILL_CHARGE_CRASH,null,hunt,range,Effect_red_shatter,false)
	endfunction

	//跳跃
	private function talent_jump takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local unit targetUnit = GetSpellTargetUnit()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local real speed = I2R(level)+34
	    call SetUnitVertexColorBJ( u, 100, 100, 100, 95.00 )
	    call skills_jump( u , targetUnit , speed , Effect_MirrorImageCaster , 0 , Effect_red_shatter )
	endfunction

	//鬼步
	private function talent_ghost_walk takes nothing returns nothing
		local unit u = GetTriggerUnit()
	    local integer level = GetUnitAbilityLevel(u, GetSpellAbilityId())
	    local location loc = null
	    local location targetLoc = null
	    local real distance = 100 + I2R(level) * 20
	    call PolledWait(0.01)
	    set loc = GetUnitLoc(u)
	    set targetLoc = PolarProjectionBJ( loc , distance , GetUnitFacing(u)+180 )
	    call funcs_effectPoint( Effect_MirrorImageCaster , loc )
	    call funcs_effectPoint( Effect_MirrorImageCaster , targetLoc )
	    call SetUnitPositionLoc( u , targetLoc )
	    call RemoveLocation(loc)
	    call RemoveLocation(targetLoc)
	endfunction

	/* Action - 释放技能 */
	private function action_spell_effect takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		if( abilityId == SPELL_Talent_Eagle_Eye ) then
			call talent_eagle_eye()
		elseif( abilityId == SPELL_Talent_Charge ) then
			call talent_charge()
		elseif( abilityId == SPELL_Talent_Jump ) then
			call talent_jump()
		elseif( abilityId == SPELL_Talent_Ghost_Walk ) then
			call talent_ghost_walk()
		endif
	endfunction

	/* 单位注册所有属性技能 */
	public function regAllAttrSkill takes unit whichUnit returns nothing
		//生命魔法
		call UnitAddAbility( whichUnit, Ability_life_1 )
		call UnitAddAbility( whichUnit, Ability_life_10 )
		call UnitAddAbility( whichUnit, Ability_life_100 )
		call UnitAddAbility( whichUnit, Ability_life_1000 )
		call UnitAddAbility( whichUnit, Ability_life_10000 )
		call UnitAddAbility( whichUnit, Ability_life_FU_1 )
		call UnitAddAbility( whichUnit, Ability_life_FU_10 )
		call UnitAddAbility( whichUnit, Ability_life_FU_100 )
		call UnitAddAbility( whichUnit, Ability_life_FU_1000 )
		call UnitAddAbility( whichUnit, Ability_life_FU_10000 )
		call UnitAddAbility( whichUnit, Ability_mana_1 )
		call UnitAddAbility( whichUnit, Ability_mana_10 )
		call UnitAddAbility( whichUnit, Ability_mana_100 )
		call UnitAddAbility( whichUnit, Ability_mana_1000 )
		call UnitAddAbility( whichUnit, Ability_mana_10000 )
		call UnitAddAbility( whichUnit, Ability_mana_FU_1 )
		call UnitAddAbility( whichUnit, Ability_mana_FU_10 )
		call UnitAddAbility( whichUnit, Ability_mana_FU_100 )
		call UnitAddAbility( whichUnit, Ability_mana_FU_1000 )
		call UnitAddAbility( whichUnit, Ability_mana_FU_10000 )
		call UnitRemoveAbility( whichUnit, Ability_life_1 )
		call UnitRemoveAbility( whichUnit, Ability_life_10 )
		call UnitRemoveAbility( whichUnit, Ability_life_100 )
		call UnitRemoveAbility( whichUnit, Ability_life_1000 )
		call UnitRemoveAbility( whichUnit, Ability_life_10000 )
		call UnitRemoveAbility( whichUnit, Ability_life_FU_1 )
		call UnitRemoveAbility( whichUnit, Ability_life_FU_10 )
		call UnitRemoveAbility( whichUnit, Ability_life_FU_100 )
		call UnitRemoveAbility( whichUnit, Ability_life_FU_1000 )
		call UnitRemoveAbility( whichUnit, Ability_life_FU_10000 )
		call UnitRemoveAbility( whichUnit, Ability_mana_1 )
		call UnitRemoveAbility( whichUnit, Ability_mana_10 )
		call UnitRemoveAbility( whichUnit, Ability_mana_100 )
		call UnitRemoveAbility( whichUnit, Ability_mana_1000 )
		call UnitRemoveAbility( whichUnit, Ability_mana_10000 )
		call UnitRemoveAbility( whichUnit, Ability_mana_FU_1 )
		call UnitRemoveAbility( whichUnit, Ability_mana_FU_10 )
		call UnitRemoveAbility( whichUnit, Ability_mana_FU_100 )
		call UnitRemoveAbility( whichUnit, Ability_mana_FU_1000 )
		call UnitRemoveAbility( whichUnit, Ability_mana_FU_10000 )

		//绿字攻击
        call UnitAddAbility( whichUnit , Ability_attack_1)
        call UnitAddAbility( whichUnit , Ability_attack_10)
        call UnitAddAbility( whichUnit , Ability_attack_100)
        call UnitAddAbility( whichUnit , Ability_attack_1000)
        call UnitAddAbility( whichUnit , Ability_attack_10000)
        call UnitAddAbility( whichUnit , Ability_attack_FU_1)
        call UnitAddAbility( whichUnit , Ability_attack_FU_10)
        call UnitAddAbility( whichUnit , Ability_attack_FU_100)
        call UnitAddAbility( whichUnit , Ability_attack_FU_1000)
        call UnitAddAbility( whichUnit , Ability_attack_FU_10000)
		//绿色属性
		call UnitAddAbility( whichUnit , Ability_power_1)
        call UnitAddAbility( whichUnit , Ability_power_10)
        call UnitAddAbility( whichUnit , Ability_power_100)
        call UnitAddAbility( whichUnit , Ability_power_1000)
        call UnitAddAbility( whichUnit , Ability_power_FU_1)
        call UnitAddAbility( whichUnit , Ability_power_FU_10)
        call UnitAddAbility( whichUnit , Ability_power_FU_100)
        call UnitAddAbility( whichUnit , Ability_power_FU_1000)
        call UnitAddAbility( whichUnit , Ability_quick_1)
        call UnitAddAbility( whichUnit , Ability_quick_10)
        call UnitAddAbility( whichUnit , Ability_quick_100)
        call UnitAddAbility( whichUnit , Ability_quick_1000)
        call UnitAddAbility( whichUnit , Ability_quick_FU_1)
        call UnitAddAbility( whichUnit , Ability_quick_FU_10)
        call UnitAddAbility( whichUnit , Ability_quick_FU_100)
        call UnitAddAbility( whichUnit , Ability_quick_FU_1000)
        call UnitAddAbility( whichUnit , Ability_skill_1)
        call UnitAddAbility( whichUnit , Ability_skill_10)
        call UnitAddAbility( whichUnit , Ability_skill_100)
        call UnitAddAbility( whichUnit , Ability_skill_1000)
        call UnitAddAbility( whichUnit , Ability_skill_FU_1)
        call UnitAddAbility( whichUnit , Ability_skill_FU_10)
        call UnitAddAbility( whichUnit , Ability_skill_FU_100)
        call UnitAddAbility( whichUnit , Ability_skill_FU_1000)
        //攻击速度
        call UnitAddAbility( whichUnit , Ability_attackSpeed_1)
        call UnitAddAbility( whichUnit , Ability_attackSpeed_10)
        call UnitAddAbility( whichUnit , Ability_attackSpeed_100)
        call UnitAddAbility( whichUnit , Ability_attackSpeed_FU_1)
        call UnitAddAbility( whichUnit , Ability_attackSpeed_FU_10)
        call UnitAddAbility( whichUnit , Ability_attackSpeed_FU_100)
        //防御
		call UnitAddAbility( whichUnit , Ability_defend_1)
        call UnitAddAbility( whichUnit , Ability_defend_10)
        call UnitAddAbility( whichUnit , Ability_defend_100)
        call UnitAddAbility( whichUnit , Ability_defend_1000)
        call UnitAddAbility( whichUnit , Ability_defend_FU_1)
        call UnitAddAbility( whichUnit , Ability_defend_FU_10)
        call UnitAddAbility( whichUnit , Ability_defend_FU_100)
        call UnitAddAbility( whichUnit , Ability_defend_FU_1000)

        //设定特殊技能永久性
		call UnitMakeAbilityPermanent( whichUnit , true, Ability_power_1)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_power_10)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_power_100)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_power_1000)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_power_FU_1)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_power_FU_10)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_power_FU_100)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_power_FU_1000)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_quick_1)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_quick_10)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_quick_100)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_quick_1000)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_quick_FU_1)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_quick_FU_10)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_quick_FU_100)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_quick_FU_1000)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_skill_1)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_skill_10)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_skill_100)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_skill_1000)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_skill_FU_1)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_skill_FU_10)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_skill_FU_100)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_skill_FU_1000)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_attackSpeed_1)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_attackSpeed_10)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_attackSpeed_100)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_attackSpeed_FU_1)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_attackSpeed_FU_10)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_attackSpeed_FU_100)
		call UnitMakeAbilityPermanent( whichUnit , true, Ability_defend_1)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_defend_10)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_defend_100)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_defend_1000)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_defend_FU_1)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_defend_FU_10)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_defend_FU_100)
        call UnitMakeAbilityPermanent( whichUnit , true, Ability_defend_FU_1000)

        call SetUnitAbilityLevel( whichUnit , Ability_attackSpeed_1,  1 )
    	call SetUnitAbilityLevel( whichUnit , Ability_attackSpeed_10, 1 )
    	call SetUnitAbilityLevel( whichUnit , Ability_attackSpeed_100,1 )
    	call SetUnitAbilityLevel( whichUnit , Ability_attackSpeed_FU_1,  1 )
    	call SetUnitAbilityLevel( whichUnit , Ability_attackSpeed_FU_10, 1 )
    	call SetUnitAbilityLevel( whichUnit , Ability_attackSpeed_FU_100,1 )
        call SetUnitAbilityLevel( whichUnit , Ability_defend_1,       1 )
        call SetUnitAbilityLevel( whichUnit , Ability_defend_10,      1 )
        call SetUnitAbilityLevel( whichUnit , Ability_defend_100,     1 )
        call SetUnitAbilityLevel( whichUnit , Ability_defend_1000,    1 )
        call SetUnitAbilityLevel( whichUnit , Ability_defend_FU_1,       1 )
        call SetUnitAbilityLevel( whichUnit , Ability_defend_FU_10,      1 )
        call SetUnitAbilityLevel( whichUnit , Ability_defend_FU_100,     1 )
        call SetUnitAbilityLevel( whichUnit , Ability_defend_FU_1000,    1 )
        call SetUnitAbilityLevel( whichUnit , Ability_attack_1,       1 )
        call SetUnitAbilityLevel( whichUnit , Ability_attack_10,      1 )
        call SetUnitAbilityLevel( whichUnit , Ability_attack_100,     1 )
        call SetUnitAbilityLevel( whichUnit , Ability_attack_1000,    1 )
        call SetUnitAbilityLevel( whichUnit , Ability_attack_10000,   1 )
        call SetUnitAbilityLevel( whichUnit , Ability_attack_FU_1,       1 )
        call SetUnitAbilityLevel( whichUnit , Ability_attack_FU_10,      1 )
        call SetUnitAbilityLevel( whichUnit , Ability_attack_FU_100,     1 )
        call SetUnitAbilityLevel( whichUnit , Ability_attack_FU_1000,    1 )
        call SetUnitAbilityLevel( whichUnit , Ability_attack_FU_10000,   1 )
        call SetUnitAbilityLevel( whichUnit , Ability_power_1,        1 )
        call SetUnitAbilityLevel( whichUnit , Ability_power_10,       1 )
        call SetUnitAbilityLevel( whichUnit , Ability_power_100,      1 )
        call SetUnitAbilityLevel( whichUnit , Ability_power_1000,     1 )
        call SetUnitAbilityLevel( whichUnit , Ability_power_FU_1,        1 )
        call SetUnitAbilityLevel( whichUnit , Ability_power_FU_10,       1 )
        call SetUnitAbilityLevel( whichUnit , Ability_power_FU_100,      1 )
        call SetUnitAbilityLevel( whichUnit , Ability_power_FU_1000,     1 )
        call SetUnitAbilityLevel( whichUnit , Ability_quick_1,        1 )
        call SetUnitAbilityLevel( whichUnit , Ability_quick_10,       1 )
        call SetUnitAbilityLevel( whichUnit , Ability_quick_100,      1 )
        call SetUnitAbilityLevel( whichUnit , Ability_quick_1000,     1 )
        call SetUnitAbilityLevel( whichUnit , Ability_quick_FU_1,        1 )
        call SetUnitAbilityLevel( whichUnit , Ability_quick_FU_10,       1 )
        call SetUnitAbilityLevel( whichUnit , Ability_quick_FU_100,      1 )
        call SetUnitAbilityLevel( whichUnit , Ability_quick_FU_1000,     1 )
        call SetUnitAbilityLevel( whichUnit , Ability_skill_1,        1 )
        call SetUnitAbilityLevel( whichUnit , Ability_skill_10,       1 )
        call SetUnitAbilityLevel( whichUnit , Ability_skill_100,      1 )
        call SetUnitAbilityLevel( whichUnit , Ability_skill_1000,     1 )
        call SetUnitAbilityLevel( whichUnit , Ability_skill_FU_1,        1 )
        call SetUnitAbilityLevel( whichUnit , Ability_skill_FU_10,       1 )
        call SetUnitAbilityLevel( whichUnit , Ability_skill_FU_100,      1 )
        call SetUnitAbilityLevel( whichUnit , Ability_skill_FU_1000,     1 )
	endfunction

	//预读
	private function preread takes nothing returns nothing
	    local integer i = 0
	    local integer total = 17
	    local integer array prereads
	    local unit array prereadUnits

	    set prereads[1] = Hero_crypt_beetle
	    set prereads[2] = Hero_arcane_hunter
	    set prereads[3] = Hero_demon_hunter
	    set prereads[4] = Hero_unparalleled
	    set prereads[5] = Hero_assassin
	    set prereads[6] = Hero_wind
	    set prereads[7] = Hero_thunderbolt
	    set prereads[8] = Hero_kael
	    set prereads[9] = Hero_druid_farre
	    set prereads[10] = Hero_shadow_shaman
	    set prereads[11] = Hero_alchemist
	    set prereads[12] = Hero_medusa
	    set prereads[13] = Hero_holy_knight
	    set prereads[14] = Hero_mountain_king
	    set prereads[15] = Hero_protect_knight
	    set prereads[16] = Hero_shake_bull
	    set prereads[17] = Hero_death_knight
	    set i = 1
	    loop
	        exitwhen i>total
	            set prereadUnits[i] = CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), prereads[i], GetRectCenter(GetPlayableMapRect()), bj_UNIT_FACING)
	            call regAllAttrSkill(prereadUnits[i])
	        set i = i+1
	    endloop
	    call PolledWait(0.00)
	    set i = 1
	    loop
	        exitwhen i>total
	            call RemoveUnit(prereadUnits[i])
	        set i = i+1
	    endloop
	endfunction

	public function init takes nothing returns nothing

		local trigger trigger_heroBase_spell_effect = CreateTrigger()
		//释放技能
	    call TriggerRegisterAnyUnitEventBJ( trigger_heroBase_spell_effect , EVENT_PLAYER_UNIT_SPELL_EFFECT )
	    call TriggerAddAction( trigger_heroBase_spell_effect , function action_spell_effect )

		call preread()
	endfunction

endlibrary

//死亡骑士
#include "hero/deathKnight.j"
//霹雳
#include "hero/thunderbolt.j"
//捍卫骑士
#include "hero/protectKnight.j"
//地穴甲虫
#include "hero/cryptBeetle.j"
//召唤师
#include "hero/kael.j"
//恶魔猎手
#include "hero/demonHunter.j"
//影刺客
#include "hero/arcaneHunter.j"
//暗杀者
#include "hero/assassin.j"
//山丘之王
#include "hero/mountainKing.j"
//撼地蛮牛
#include "hero/shakeBull.j"
//逸风
#include "hero/wind.j"
//美杜莎
#include "hero/medusa.j"
//德鲁伊法尔
#include "hero/druidFarre.j"
//无双
#include "hero/unparalleled.j"
//暗影萨满
#include "hero/shadowShaman.j"
//炼金术士
#include "hero/alchemist.j"
//圣骑士
#include "hero/holyKnight.j"
//蝠王
#include "hero/bat_king.j"

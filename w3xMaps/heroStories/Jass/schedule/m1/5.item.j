
#include "items/lib.j"
#include "items/skills.j"

globals
	trigger m1_triggerItemUse			//使用
	trigger m1_triggerItemSpellEffect	//释放物品技能
	trigger m1_triggerItemPickUp		//获得
	trigger m1_triggerItemDrop			//丢弃
	trigger m1_triggerItemSell			//出售
	trigger m1_triggerItemPawn		//抵押
endglobals

library m1Item requires m1ItemSkill

	private function initItem takes nothing returns nothing
		//小生命药水
		call items_setItem(ITEMREEL_life_water_lv1,ITEM_life_water_lv1,99,1,25,0,0.1)
		//小魔法药水
		call items_setItem(ITEMREEL_mana_water_lv1,ITEM_mana_water_lv1,99,1,25,0,0.1)
		//大生命药水
		call items_setItem(ITEMREEL_life_water_lv2,ITEM_life_water_lv2,99,1,50,0,0.1)
		//大魔法药水
		call items_setItem(ITEMREEL_mana_water_lv2,ITEM_mana_water_lv2,99,1,50,0,0.1)
		//督视猫头鹰
		call items_setItem(ITEMREEL_isee,ITEM_isee,99,1,50,0,0.1)
		//传送卷轴
		call items_setItem(ITEMREEL_portal_scroll,ITEM_portal_scroll,99,1,100,0,0.1)
		//隐身药水
		call items_setItem(ITEMREEL_transparent_drug,ITEM_transparent_drug,99,1,100,0,0.1)
		//超生命药水
		call items_setItem(ITEMREEL_life_water_lv3,ITEM_life_water_lv3,99,1,100,0,0.1)
		//超魔法药水
		call items_setItem(ITEMREEL_mana_water_lv3,ITEM_mana_water_lv3,99,1,100,0,0.1)
		//铁皮树枝
		call items_setItem(ITEMREEL_iron_branch,ITEM_iron_branch,99,1,300,0,0.1)
		//生命石
		call items_setItem(ITEMREEL_life_stone,ITEM_life_stone,99,1,375,0,0.1)
		//魔法石
		call items_setItem(ITEMREEL_mana_stone,ITEM_mana_stone,99,1,375,0,0.1)
		//攻击之爪
		call items_setItem(ITEMREEL_paw,ITEM_paw,99,1,400,0,0.1)
		//护环
		call items_setItem(ITEMREEL_retaining_ring,ITEM_retaining_ring,99,1,475,0,0.1)
		//加速手套
		call items_setItem(ITEMREEL_speed_glove,ITEM_speed_glove,99,1,775,0,0.1)
		//魔法护身符
		call items_setItem(ITEMREEL_mana_amulet,ITEM_mana_amulet,99,2,1350,0,1.2)
		//生命护身符
		call items_setItem(ITEMREEL_life_amulet,ITEM_life_amulet,99,3,1550,0,1.8)
		//速度之靴
		call items_setItem(ITEMREEL_boot,ITEM_boot,99,3,1800,0,0.5)
		//钢盔
		call items_setItem(ITEMREEL_helmet,ITEM_helmet,99,4,2150,0,2.8)
		//短剑
		call items_setItem(ITEMREEL_sword,ITEM_sword,99,5,2700,0,3.5)
		//铁斧
		call items_setItem(ITEMREEL_axe,ITEM_axe,99,6,3400,0,4.2)
		//铁锤
		call items_setItem(ITEMREEL_hammer,ITEM_hammer,99,6,3400,0,4.4)
		//杖棍
		call items_setItem(ITEMREEL_stick,ITEM_stick,99,7,3500,0,1.4)
		//吸血面具
		call items_setItem(ITEMREEL_hemophagia_mask,ITEM_hemophagia_mask,99,7,3600,0,0.4)
		//匕首
		call items_setItem(ITEMREEL_dagger,ITEM_dagger,99,7,3800,0,0.6)
		//先锋盾
		call items_setItem(ITEMREEL_tank_shield,ITEM_tank_shield,99,8,4175,0,4.2)
		//奇术
		call items_setItem(ITEMREEL_thaumaturgy,ITEM_thaumaturgy,99,9,4500,0,0.2)
		//先锋靴
		call items_setItem(ITEMREEL_tank_boot,ITEM_tank_boot,99,11,5500,0,4.2)
		//皮甲
		call items_setItem(ITEMREEL_leather_armor,ITEM_leather_armor,99,5,5600,0,1.5)
		//影子风衣
		call items_setItem(ITEMREEL_shadow_coat,ITEM_shadow_coat,99,6,6400,0,0.2)
		//食人鬼手套
		call items_setItem(ITEMREEL_ghoul_gloves,ITEM_ghoul_gloves,99,13,6800,0,1.1)
		//钢枪
		call items_setItem(ITEMREEL_spear,ITEM_spear,99,14,7000,0,3.3)
		//风声笛子
		call items_setItem(ITEMREEL_flute,ITEM_flute,99,15,7500,0,0.8)
		//法杖
		call items_setItem(ITEMREEL_staff,ITEM_staff,99,15,7600,0,1.0)
		//冰魔靴
		call items_setItem(ITEMREEL_crystal_boot,ITEM_crystal_boot,99,15,7650,0,1.4)
		//天空钻
		call items_setItem(ITEMREEL_sky_diamond,ITEM_sky_diamond,99,16,8000,0,0.5)
		//无声靴
		call items_setItem(ITEMREEL_robbers_boot,ITEM_robbers_boot,99,17,8975,0,0.4)
		//血羽钻
		call items_setItem(ITEMREEL_blood_feather_drill,ITEM_blood_feather_drill,99,20,10000,0,2.2)
		//食人鬼巨锤
		call items_setItem(ITEMREEL_ghost_hammer,ITEM_ghost_hammer,99,20,10200,0,5.0)
		//血枪
		call items_setItem(ITEMREEL_bloodiness_spear,ITEM_bloodiness_spear,99,21,10600,0,3.3)
		//混沌之石
		call items_setItem(ITEMREEL_chaos_stone,ITEM_chaos_stone,99,22,11000,0,2.3)
		//镶皮甲
		call items_setItem(ITEMREEL_leather_armor_big,ITEM_leather_armor_big,99,22,11200,0,2.7)
		//冥天之杖
		call items_setItem(ITEMREEL_sky_stick,ITEM_sky_stick,99,24,12100,0,1.1)
		//原石
		call items_setItem(ITEMREEL_original_stone,ITEM_original_stone,99,27,13500,0,2.5)
		//飞靴
		call items_setItem(ITEMREEL_fly_boot,ITEM_fly_boot,99,38,19200,0,2.3)
		//大地钺
		call items_setItem(ITEMREEL_earth_axe,ITEM_earth_axe,99,40,20300,0,10.0)
		//雷石
		call items_setItem(ITEMREEL_thunder_stone,ITEM_thunder_stone,99,48,24000,0,0.9)
		//冰石
		call items_setItem(ITEMREEL_ice_stone,ITEM_ice_stone,99,50,25000,0,1.0)
		//焰石
		call items_setItem(ITEMREEL_fire_stone,ITEM_fire_stone,99,50,25000,0,1.6)
		//鬼石
		call items_setItem(ITEMREEL_ghost_stone,ITEM_ghost_stone,99,55,27500,0,1.0)
		//霹雳棒
		call items_setItem(ITEMREEL_thunder_stick,ITEM_thunder_stick,99,55,27500,0,2.1)
		//贵族钻
		call items_setItem(ITEMREEL_noble_diamond,ITEM_noble_diamond,99,56,28000,0,1.0)
		//晶体锤
		call items_setItem(ITEMREEL_crystal_hammer,ITEM_crystal_hammer,99,56,28400,0,4.9)
		//裂焰斧
		call items_setItem(ITEMREEL_fire_axe,ITEM_fire_axe,99,56,28400,0,5.2)
		//雷电之锤
		call items_setItem(ITEMREEL_thunder_hammer,ITEM_thunder_hammer,99,56,28400,0,4.8)
		//冰雷符
		call items_setItem(ITEMREEL_ice_thunder_charm,ITEM_ice_thunder_charm,99,57,28500,0,1.0)
		//绿幽石
		call items_setItem(ITEMREEL_emerald,ITEM_emerald,99,60,30000,0,2.1)
		//源头之火
		call items_setItem(ITEMREEL_original_fire,ITEM_original_fire,99,60,30000,0,1.0)
		//幽透杖
		call items_setItem(ITEMREEL_exquisite_staff,ITEM_exquisite_staff,99,65,32600,0,1.8)
		//救世者
		call items_setItem(ITEMREEL_saviour,ITEM_saviour,99,67,33500,0,3.2)
		//疾风之刃
		call items_setItem(ITEMREEL_wind_dagger,ITEM_wind_dagger,99,77,38800,0,2.2)
		//狼脊骨
		call items_setItem(ITEMREEL_wolf_backbone,ITEM_wolf_backbone,99,80,40000,0,3.0)
		//雪狐毛
		call items_setItem(ITEMREEL_show_fox_fur,ITEM_show_fox_fur,99,90,45000,0,0.3)
		//火鸟羽毛
		call items_setItem(ITEMREEL_phoenix_feather,ITEM_phoenix_feather,99,96,48000,0,0.1)
		//狮齿
		call items_setItem(ITEMREEL_lion_tooth,ITEM_lion_tooth,99,96,48000,0,1.1)
		//冰晶虫
		call items_setItem(ITEMREEL_ice_beetle,ITEM_ice_beetle,99,98,49000,0,0.1)
		//邪骨甲
		call items_setItem(ITEMREEL_leather_armor_born,ITEM_leather_armor_born,99,102,51200,0,5.1)
		//银狐子弹
		call items_setItem(ITEMREEL_silvery_bullet,ITEM_silvery_bullet,99,107,53975,0,0.6)
		//霹雳霹雳
		call items_setItem(ITEMREEL_thunder_thunder_stick,ITEM_thunder_thunder_stick,99,110,55000,0,3.8)
		//鬼道电锤
		call items_setItem(ITEMREEL_god_thunder_hammer,ITEM_god_thunder_hammer,99,111,55900,0,5.2)
		//烽火巨剑
		call items_setItem(ITEMREEL_fire_sword,ITEM_fire_sword,99,151,75700,0,4.7)
		//冰晶三体锤
		call items_setItem(ITEMREEL_three_crystal_hammer,ITEM_three_crystal_hammer,99,154,77400,0,4.5)
		//鬼堕狱
		call items_setItem(ITEMREEL_ghost_hell,ITEM_ghost_hell,99,178,89300,0,3.7)
		//寒冰杖
		call items_setItem(ITEMREEL_ice_staff,ITEM_ice_staff,99,179,89600,0,2.2)
		//神秘水晶
		call items_setItem(ITEMREEL_mysterious,ITEM_mysterious,1,200,100000,0,10.0)
		//亘古骨甲
		call items_setItem(ITEMREEL_mysterious_ancient_oracle,ITEM_mysterious_ancient_oracle,1,200,100000,0,10.0)
		//亡者呼声
		call items_setItem(ITEMREEL_mysterious_ghost_scream,ITEM_mysterious_ghost_scream,1,200,100000,0,10.0)
		//刺客信条
		call items_setItem(ITEMREEL_mysterious_assassin_role,ITEM_mysterious_assassin_role,1,200,100000,0,10.0)
		//大地图腾
		call items_setItem(ITEMREEL_mysterious_ground_totem,ITEM_mysterious_ground_totem,1,200,100000,0,10.0)
		//引雷棍
		call items_setItem(ITEMREEL_mysterious_lighting,ITEM_mysterious_lighting,1,200,100000,0,10.0)
		//挑衅号角
		call items_setItem(ITEMREEL_mysterious_provoke_horn,ITEM_mysterious_provoke_horn,1,200,100000,0,10.0)
		//无双勾剑
		call items_setItem(ITEMREEL_mysterious_god_fire_sword,ITEM_mysterious_god_fire_sword,1,200,100000,0,10.0)
		//无情剑
		call items_setItem(ITEMREEL_mysterious_ruthless_sword,ITEM_mysterious_ruthless_sword,1,200,100000,0,10.0)
		//时空杖
		call items_setItem(ITEMREEL_mysterious_time_staff,ITEM_mysterious_time_staff,1,200,100000,0,10.0)
		//月夜石
		call items_setItem(ITEMREEL_mysterious_moon_stone,ITEM_mysterious_moon_stone,1,200,100000,0,10.0)
		//法老蛇的戒心
		call items_setItem(ITEMREEL_mysterious_eat_my_tail,ITEM_mysterious_eat_my_tail,1,200,100000,0,10.0)
		//灵魂破碎
		call items_setItem(ITEMREEL_mysterious_soul_break,ITEM_mysterious_soul_break,1,200,100000,0,10.0)
		//皇家圆盾
		call items_setItem(ITEMREEL_mysterious_kennedy_shield,ITEM_mysterious_kennedy_shield,1,200,100000,0,10.0)
		//神力斧
		call items_setItem(ITEMREEL_mysterious_force_axe,ITEM_mysterious_force_axe,1,200,100000,0,10.0)
		//神木
		call items_setItem(ITEMREEL_mysterious_god_tree,ITEM_mysterious_god_tree,1,200,100000,0,10.0)
		//神秘水晶碎片
		call items_setItem(ITEMREEL_mysterious_debris,ITEM_mysterious_debris,1,200,100000,0,10.0)
		//稀土之源
		call items_setItem(ITEMREEL_mysterious_power_totem,ITEM_mysterious_power_totem,1,200,100000,0,10.0)
		//绝不恻隐刀
		call items_setItem(ITEMREEL_mysterious_compassion_blade,ITEM_mysterious_compassion_blade,1,200,100000,0,10.0)
		//远古紫甲
		call items_setItem(ITEMREEL_mysterious_purple_armor,ITEM_mysterious_purple_armor,1,200,100000,0,10.0)
		//逸风
		call items_setItem(ITEMREEL_mysterious_escape_wind,ITEM_mysterious_escape_wind,1,200,100000,0,10.0)
		//霜之哀伤
		call items_setItem(ITEMREEL_mysterious_ice_tear,ITEM_mysterious_ice_tear,1,200,100000,0,10.0)
		//霹雳之花
		call items_setItem(ITEMREEL_mysterious_shrund_flower,ITEM_mysterious_shrund_flower,1,200,100000,0,10.0)
		//光焰剑 · 烈日裁决
		call items_setItem(ITEMREEL_sun_gun,ITEM_sun_gun,99,211,105700,0,5.1)
		//狂焚
		call items_setItem(ITEMREEL_fire_axe_crazy,ITEM_fire_axe_crazy,99,248,124400,0,5.8)
		//雄狮斩牙刀
		call items_setItem(ITEMREEL_lion_fire_fight,ITEM_lion_fire_fight,99,485,242700,0,8.1)
	endfunction

	private function initMix takes nothing returns nothing
		//生命护身符 + 钢盔 + 护环 = 先锋盾
		call items_setMix(ITEMREEL_tank_shield,ITEM_life_amulet,1,ITEM_helmet,1,ITEM_retaining_ring,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//速度之靴 + 钢盔 + 生命护身符 = 先锋靴
		call items_setMix(ITEMREEL_tank_boot,ITEM_boot,1,ITEM_helmet,1,ITEM_life_amulet,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//速度之靴 + 魔法护身符 + 奇术 = 冰魔靴
		call items_setMix(ITEMREEL_crystal_boot,ITEM_boot,1,ITEM_mana_amulet,1,ITEM_thaumaturgy,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//速度之靴 + 加速手套 + 影子风衣 = 无声靴
		call items_setMix(ITEMREEL_robbers_boot,ITEM_boot,1,ITEM_speed_glove,1,ITEM_shadow_coat,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//铁锤 + 食人鬼手套 = 食人鬼巨锤
		call items_setMix(ITEMREEL_ghost_hammer,ITEM_hammer,1,ITEM_ghoul_gloves,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//钢枪 + 吸血面具 = 血枪
		call items_setMix(ITEMREEL_bloodiness_spear,ITEM_spear,1,ITEM_hemophagia_mask,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//皮甲x2 = 镶皮甲
		call items_setMix(ITEMREEL_leather_armor_big,ITEM_leather_armor,2,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//法杖 + 奇术 = 冥天之杖
		call items_setMix(ITEMREEL_sky_stick,ITEM_staff,1,ITEM_thaumaturgy,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//速度之靴 + 混沌之石 + 影子风衣 = 飞靴
		call items_setMix(ITEMREEL_fly_boot,ITEM_boot,1,ITEM_chaos_stone,1,ITEM_shadow_coat,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//铁斧 + 铁锤 + 原石 = 大地钺
		call items_setMix(ITEMREEL_earth_axe,ITEM_axe,1,ITEM_hammer,1,ITEM_original_stone,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//杖棍 + 雷石 = 霹雳棒
		call items_setMix(ITEMREEL_thunder_stick,ITEM_stick,1,ITEM_thunder_stone,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//铁锤 + 冰石 = 晶体锤
		call items_setMix(ITEMREEL_crystal_hammer,ITEM_hammer,1,ITEM_ice_stone,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//铁斧 + 焰石 = 裂焰斧
		call items_setMix(ITEMREEL_fire_axe,ITEM_axe,1,ITEM_fire_stone,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//铁锤 + 雷石 = 雷电之锤
		call items_setMix(ITEMREEL_thunder_hammer,ITEM_hammer,1,ITEM_thunder_stone,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//奇术 + 雷石 = 冰雷符
		call items_setMix(ITEMREEL_ice_thunder_charm,ITEM_thaumaturgy,1,ITEM_thunder_stone,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//法杖 + 冰石 = 幽透杖
		call items_setMix(ITEMREEL_exquisite_staff,ITEM_staff,1,ITEM_ice_stone,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//杖棍 + 绿幽石 = 救世者
		call items_setMix(ITEMREEL_saviour,ITEM_stick,1,ITEM_emerald,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//匕首 + 风声笛子 + 鬼石 = 疾风之刃
		call items_setMix(ITEMREEL_wind_dagger,ITEM_dagger,1,ITEM_flute,1,ITEM_ghost_stone,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//镶皮甲 + 狼脊骨 = 邪骨甲
		call items_setMix(ITEMREEL_leather_armor_born,ITEM_leather_armor_big,1,ITEM_wolf_backbone,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//无声靴 + 雪狐毛 = 银狐子弹
		call items_setMix(ITEMREEL_silvery_bullet,ITEM_robbers_boot,1,ITEM_show_fox_fur,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//霹雳棒x2 = 霹雳霹雳
		call items_setMix(ITEMREEL_thunder_thunder_stick,ITEM_thunder_stick,2,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//雷电之锤 + 鬼石 = 鬼道电锤
		call items_setMix(ITEMREEL_god_thunder_hammer,ITEM_thunder_hammer,1,ITEM_ghost_stone,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//短剑 + 焰石 + 火鸟羽毛 = 烽火巨剑
		call items_setMix(ITEMREEL_fire_sword,ITEM_sword,1,ITEM_fire_stone,1,ITEM_phoenix_feather,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//晶体锤 + 冰晶虫 = 冰晶三体锤
		call items_setMix(ITEMREEL_three_crystal_hammer,ITEM_crystal_hammer,1,ITEM_ice_beetle,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//食人鬼手套 + 鬼石x3 = 鬼堕狱
		call items_setMix(ITEMREEL_ghost_hell,ITEM_ghoul_gloves,1,ITEM_ghost_stone,3,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//幽透杖 + 天空钻 + 冰晶虫 = 寒冰杖
		call items_setMix(ITEMREEL_ice_staff,ITEM_exquisite_staff,1,ITEM_sky_diamond,1,ITEM_ice_beetle,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//烽火巨剑 + 源头之火 = 光焰剑 · 烈日裁决
		call items_setMix(ITEMREEL_sun_gun,ITEM_fire_sword,1,ITEM_original_fire,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//裂焰斧 + 狮齿 + 火鸟羽毛 = 狂焚
		call items_setMix(ITEMREEL_fire_axe_crazy,ITEM_fire_axe,1,ITEM_lion_tooth,1,ITEM_phoenix_feather,1,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
		//短剑 + 狮齿x5 = 雄狮斩牙刀
		call items_setMix(ITEMREEL_lion_fire_fight,ITEM_sword,1,ITEM_lion_tooth,5,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0,ITEM_NULL,0)
	endfunction

    /* 获取神秘变异的TypeId */
    private function getSteriousReelId takes unit whichUnit , integer index returns integer
        local integer unitType = GetUnitTypeId(whichUnit)
        local integer mysteriousReelId = ITEMREEL_mysterious_debris

        //皇家之盾 - 圣骑士

        //亘古骨甲 - 地穴甲虫
        if( unitType == Hero_crypt_beetle and Attr_Toughness[index] > 250 ) then
            set mysteriousReelId = ITEMREEL_mysterious_ancient_oracle
        endif

        //亡者呼声 - 召唤师
        if( unitType == Hero_kael and Attr_SkillDamage[index] > 10000) then
        	set mysteriousReelId = ITEMREEL_mysterious_ghost_scream
        endif

        //刺客信条 - 影刺客
        if( unitType == Hero_arcane_hunter and Attr_Avoid[index] > 3000 ) then
            set mysteriousReelId = ITEMREEL_mysterious_assassin_role
        endif

        //大地图腾 - 撼地蛮牛
        if( unitType == Hero_shake_bull and Attr_Move[index] > 1000 ) then
            set mysteriousReelId = ITEMREEL_mysterious_ground_totem
        endif

        //神力斧 - 山丘之王
        if( unitType == Hero_mountain_king ) then
	        if( GetUnitAbilityLevel( whichUnit, m1MountainKing_spell_lianchuiwu ) >= 1 ) then
            	set mysteriousReelId = ITEMREEL_mysterious_force_axe
        	endif
        endif

        //引雷棍- 霹雳
        if( unitType == Hero_thunderbolt and Attr_Attack[index] > 300 ) then
            set mysteriousReelId = ITEMREEL_mysterious_lighting
        endif

        //挑衅号角 - 捍卫骑士
        if( unitType == Hero_protect_knight and Attr_Power[index] > 300 ) then
            set mysteriousReelId = ITEMREEL_mysterious_provoke_horn
        endif

        //无情剑 - 火焰剑鬼

        //月夜石 - 蝠王

        //无双勾剑 - 无双
        if( unitType == Hero_unparalleled and Attr_Quick[index] > 1000 ) then
            set mysteriousReelId = ITEMREEL_mysterious_god_fire_sword
        endif

        //灵魂破碎 - 恶魔猎手 / 邪·恶魔猎手
        if( unitType == Hero_demon_hunter or unitType == Hero_demon_hunter_sp ) then
	        if( GetUnitAbilityLevel( whichUnit, m1DemonHunter_spell_guiying ) >= 10 ) then
            	set mysteriousReelId = ITEMREEL_mysterious_soul_break
            endif
        endif

        //神木 - 德鲁伊法尔
        if( unitType == Hero_druid_farre and Attr_Skill[index] > 500 ) then
            set mysteriousReelId = ITEMREEL_mysterious_god_tree
        endif

        //绝不恻隐刀 - 暗杀者
        if( unitType == Hero_assassin and Attr_Knocking[index] > 6000 ) then
            set mysteriousReelId = ITEMREEL_mysterious_compassion_blade
        endif

        //稀土之源

        //远古紫甲

        //逃逸之风 - 逸风
        if( unitType == Hero_wind ) then
	        if( GetUnitAbilityLevel(whichUnit,  m1Wind_spell_wuyingzhanfeng) >= 5  ) then
            	set mysteriousReelId = ITEMREEL_mysterious_escape_wind
            endif
        endif

        //时空杖

        //霜之哀伤 - 死亡骑士
        if( unitType == Hero_death_knight and GetUnitLevel(whichUnit) >= 125  ) then
            set mysteriousReelId = ITEMREEL_mysterious_ice_tear
        endif

        //霹雳之花

        //法老蛇的戒心 - 美杜莎
        if( unitType == Hero_medusa and Attr_AttackSpeed[index] > 300  ) then
            set mysteriousReelId = ITEMREEL_mysterious_eat_my_tail
        endif

        return mysteriousReelId
    endfunction

	/* 触发 - 物品使用 */
	private function triggerItemUseActions takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local item it = GetManipulatedItem()
		local itemtype itType = GetItemType(it)
	    local integer itTypeId = GetItemTypeId(it)
	    local integer itCharges = GetItemCharges(it)
	    local integer playerIndex = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
	    local integer itReelId = 0
		//TODO 永久类
	    if( itType == ITEM_TYPE_PERMANENT ) then
			if(itTypeId != ITEM_life_stone and itTypeId != ITEM_mana_stone )then
				//使用永久类物品，锁定使用次数不减少(除了一些特别的物品)
		    	call SetItemCharges( it, itCharges+1 )
		    endif
			//神秘
		    if( itTypeId == ITEM_mysterious_debris ) then  //神秘水晶碎片
		        set itCharges = GetItemCharges(GetItemOfTypeFromUnitBJ( u , ITEM_mysterious_debris ))
		        if( itCharges > 0 ) then
		            set itReelId = getSteriousReelId( u , playerIndex )
		            if(  itReelId != ITEMREEL_mysterious_debris ) then
		                call RemoveItem( it )
		                call items_createItem2Hero( itReelId , u , itCharges )
		            else
		                call funcs_printTo( GetOwningPlayer(u) , "碎片没有反应，依然破碎不堪..." )
		            endif
		        endif
		    endif
		    //TODO
		    call m1ItemSkill_itemUse( itTypeId , u , playerIndex )
		elseif( itType == ITEM_TYPE_CHARGED ) then
			call m1ItemSkill_itemUse( itTypeId , u , playerIndex )
	    endif
	endfunction

	/* 触发 - 物品技能释放 */
	private function triggerItemSpellEffectActions takes nothing returns nothing
		local integer abilityId = GetSpellAbilityId()
		local unit createUnit = null
	    local player whichplayer = GetOwningPlayer(GetTriggerUnit())
	    local location loc = null
	    local location loc2 = null
	    local integer i = 0
		if(abilityId == 'A04J') then //TODO 冰雷符
			set loc = GetSpellTargetLoc()
			set createUnit = funcs_createUnit( whichplayer , 'u000'  , loc , loc)
		    call funcs_setUnitLife( createUnit , 10.00 )
		    set  i = 1
		    loop
		        exitwhen i > 5
		            set loc2 = PolarProjectionBJ(loc, 150 , I2R(i) * 90 )
		            set createUnit = funcs_createUnit( whichplayer , 'u00G'  , loc2 , loc2)
		            call funcs_setUnitLife( createUnit , 10.00 )
		            call RemoveLocation(loc2)
		        set i = i + 1
		    endloop
		    call RemoveLocation(loc)
		endif
	endfunction

	/* 触发 - 物品获得 */
	private function triggerItemPickUpActions takes nothing returns nothing
		local integer i = 0
	    local unit u = GetTriggerUnit()
	    local player whichPlayer = GetOwningPlayer(u)
	    local integer playerIndex = GetConvertedPlayerId(whichPlayer)
		local item it = GetManipulatedItem()
		local itemtype itType = GetItemType(it)
		local integer itTypeId = GetItemTypeId(it)
	    local integer reel_charges = GetItemCharges(it) //获得的卷轴使用次数
	    local integer nextLevel = 0
		if( itType == ITEM_TYPE_ARTIFACT ) then	//卷轴
		    if(  itTypeId == ITEMREEL_mysterious ) then
		        //如果是神秘水晶
		        call RemoveItem(it)
		        call items_createItem2Hero( getSteriousReelId( u , playerIndex ) , u , 1 )
		    else
		        //如果不是神秘水晶，执行合成系统
		        call items_addItem( itTypeId ,reel_charges,u)
		        //如果是英雄则算一算属性
		        if(m1Hero_isHero(u)) then
		            call PolledWait(0.40)   //处理延迟
		            call attribute_calculateOne(playerIndex)
		        endif
		    endif
		endif
	endfunction

	/* 【存活的】【英雄】【非镜像】【物品栏满了】【玩家单位】 */
	private function triggerItemDropFilter takes nothing returns boolean
	    local boolean boole = true
	    local unit filterUnit = GetFilterUnit()
	    if( IsUnitDeadBJ(filterUnit) ) then
	        set boole = false
	    endif
	    if( IsUnitType(filterUnit, UNIT_TYPE_HERO) == false ) then
	        set boole = false
	    endif
	    if( IsUnitIllusion(filterUnit) == true ) then
	        set boole = false
	    endif
	    if( UnitInventoryCount(filterUnit) < UnitInventorySizeBJ(filterUnit) ) then
	        set boole = false
	    endif
	    if( GetPlayerController(GetOwningPlayer(filterUnit)) != MAP_CONTROL_USER ) then
	        set boole = false
	    endif
	    return boole
	endfunction

	private function triggerItemDropJudge takes nothing returns nothing
	    local timer t =GetExpiredTimer()
	    local item it = funcs_getTimerParams_Item( t , Key_Skill_Item )
	    local integer index = funcs_getTimerParams_Integer( t , Key_Skill_i )
	    local unit u = funcs_getTimerParams_Unit( t , Key_Skill_Unit )
	    local integer real_charges = GetItemCharges(it) //获得的丢弃物品的使用次数
	    local integer reelId
	    local location loc = GetItemLoc(it)
	    local real facing = GetUnitFacing(u)
	    local group catchGroup = funcs_getGroupByPoint( loc, 50.00 ,function triggerItemDropFilter)
	    local unit gu = null
	    local unit catchUnit = null
	    //call PolledWait(0.40)   //处理延迟
	    if( IsItemOwned(it) == true ) then
	        //如果是被人持有
	        //nothing
	    else
	        //不被人持有
	        set reelId = items_getReelIdByItemId(GetItemTypeId(it))
	        call RemoveItem(it)
	        if( CountUnitsInGroup(catchGroup) > 0 ) then
	            //#1如果是给予别人的
	            loop
	                exitwhen(IsUnitGroupEmptyBJ(catchGroup) == true)
	                    //must do
	                    set gu = FirstOfGroup(catchGroup)
	                    call GroupRemoveUnit( catchGroup , gu )
	                    //
	                    if( u == gu ) then
	                        //nothing
	                    else
	                        set catchUnit = gu
	                        call GroupClear(catchGroup)
	                    endif
	            endloop
	            call items_addItem(reelId ,real_charges , catchUnit)
	        else
	            //#2创建到地面
	            set it = CreateItem(reelId , GetLocationX(loc), GetLocationY(loc))
	            call SetItemCharges(it, real_charges)
	        endif
	    endif
	    call GroupClear(catchGroup)
	    call DestroyGroup(catchGroup)
	    call RemoveLocation(loc)
	    call funcs_delTimer(t,null)
	    call attribute_calculateOne(index)
	endfunction

	/* 触发 - 物品丢弃 */
	private function triggerItemDropActions takes nothing returns nothing
		local item it = GetManipulatedItem()
	    local unit triggerUnit = GetTriggerUnit()
	    local unit manipulatingUnit = GetManipulatingUnit()
	    local integer index = GetConvertedPlayerId(GetOwningPlayer(triggerUnit))
	    local timer t = null

	    set canRepick[index] = FALSE    //丢弃过物品就禁止重选
	    call SetItemPlayer( it , Player(PLAYER_NEUTRAL_PASSIVE) , false )    //改变归属

	    set t = funcs_setTimeout( 0.00 , function triggerItemDropJudge )
	    call funcs_setTimerParams_Item( t , Key_Skill_Item , it )
	    call funcs_setTimerParams_Integer( t , Key_Skill_i , index )
	    call funcs_setTimerParams_Unit( t , Key_Skill_Unit , manipulatingUnit )
	endfunction

	/* 触发 - 物品出售|抵押 - SellPawnCall */
	private function triggerItemSellPawnCall takes nothing returns nothing
	    local timer t =GetExpiredTimer()
	    local integer index = funcs_getTimerParams_Integer( t , Key_Skill_i )
	    call funcs_delTimer(t,null)
	    call attribute_calculateOne(index)
	endfunction

	/* 触发 - 物品出售 */
	private function triggerItemSellActions takes nothing returns nothing
		local itemtype itType = GetItemType(GetManipulatedItem())
		local integer index = GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
    	local timer t = null
		if( itType == ITEM_TYPE_PERMANENT ) then
			set t = funcs_setTimeout( 0.00 , function triggerItemSellPawnCall )
    		call funcs_setTimerParams_Integer( t , Key_Skill_i , index )
		endif
	endfunction

	/* 触发 - 物品抵押 */
	private function triggerItemPawnActions takes nothing returns nothing
		local item it = GetSoldItem()
		local itemtype itType = GetItemType(it)
		local integer itemId = GetItemTypeId( it )
	    local integer itemCharges = GetItemCharges( it )
	    local integer itemGold = items_getGoldByItemId( itemId )
	    local integer itemLumber = items_getLumberByItemId( itemId )
	    local integer itemTotalGold = itemGold * itemCharges / 2
	    local integer itemTotalLumber = itemLumber * itemCharges / 2
	    local unit u = GetTriggerUnit()
	    local player witchPlayer = GetOwningPlayer( u )
		local integer index = GetConvertedPlayerId(GetOwningPlayer(u))
    	local timer t = null
		if( itType == ITEM_TYPE_PERMANENT ) then
			set t = funcs_setTimeout( 0.00 , function triggerItemSellPawnCall )
    		call funcs_setTimerParams_Integer( t , Key_Skill_i , index )
		endif
		if( itType == ITEM_TYPE_PERMANENT or itType == ITEM_TYPE_CHARGED ) then
			call funcs_addGold( witchPlayer , itemTotalGold )
		    call funcs_addLumber( witchPlayer , itemTotalLumber )
		    if( itemTotalGold > 0 ) then
		        call funcs_floatMsg("|cffffcc00+"+I2S(itemTotalGold)+"|r"  ,u)
		    endif
		    if( itemTotalLumber > 0 ) then
		        call funcs_floatMsg("|cff80ff80+"+I2S(itemTotalLumber)+"|r"  ,u)
		    endif
		endif
	endfunction

	public function triggerItemBind takes unit hero returns nothing
		call TriggerRegisterUnitEvent( m1_triggerItemUse, hero, EVENT_UNIT_USE_ITEM )
		call TriggerRegisterUnitEvent( m1_triggerItemSpellEffect, hero, EVENT_UNIT_SPELL_EFFECT )
	    call TriggerRegisterUnitEvent( m1_triggerItemPickUp, hero, EVENT_UNIT_PICKUP_ITEM )
	    call TriggerRegisterUnitEvent( m1_triggerItemDrop, hero, EVENT_UNIT_DROP_ITEM )
	    call TriggerRegisterUnitEvent( m1_triggerItemSell, hero, EVENT_UNIT_SELL_ITEM )
	    call TriggerRegisterUnitEvent( m1_triggerItemPawn, hero, EVENT_UNIT_PAWN_ITEM )
	endfunction


    /* 设定 */
	public function init takes nothing returns nothing

		//数据
		call initItem()

		//合成
		call initMix()

		//触发
		set m1_triggerItemUse = CreateTrigger()
		set m1_triggerItemSpellEffect = CreateTrigger()
		set m1_triggerItemPickUp = CreateTrigger()
		set m1_triggerItemDrop = CreateTrigger()
		set m1_triggerItemSell = CreateTrigger()
		set m1_triggerItemPawn = CreateTrigger()

		call TriggerAddAction( m1_triggerItemUse , function triggerItemUseActions )
		call TriggerAddAction( m1_triggerItemSpellEffect , function triggerItemSpellEffectActions )
		call TriggerAddAction( m1_triggerItemPickUp , function triggerItemPickUpActions )
		call TriggerAddAction( m1_triggerItemDrop , function triggerItemDropActions )
		call TriggerAddAction( m1_triggerItemSell , function triggerItemSellActions )
		call TriggerAddAction( m1_triggerItemPawn , function triggerItemPawnActions )

	endfunction

endlibrary

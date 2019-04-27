/* 物品系统 */
globals

//数组最大8192
//最大支持818～9 共818个
//个位数1～9：
/**
 * 1 卷轴ID
 * 2 真实物品ID
 * 3 最大叠加数
 * 4 物品等级
 * 5 物品金额
 **/
integer ITEM_INDEX = 0  //物品游标
integer Max_Item_num = 3000         //300个（物品|卷轴）
integer array ITEM
real array ITEM_WEIGHT  //物品重量

integer ITEM_MIX_INDEX = 0  //物品合成游标
integer Max_Item_mix_num = 1200  //合成公式最大数量
integer array ITEM_MIX          //合成物品ID
integer array ITEM_MIX_QTY  //合成数量
integer ITEM_TARGET_ID = 0    //目标物品ID

//物品记录
//空
integer ITEM_NULL = 0

//物品自定义值
integer UserData_Item_NobanRepick = 168

//other

/* COPY */

//300魔法水
integer ITEM_mana_water_300='I003'
integer ITEMREEL_mana_water_300='I00F'
//600生命水
integer ITEM_life_water_600='I00O'
integer ITEMREEL_life_water_600='I00E'
//食人鬼手套
integer ITEM_ghoul_gloves='I05E'
integer ITEMREEL_ghoul_gloves='I05R'
//法师短袍
integer ITEM_short_robe='I05D'
integer ITEMREEL_short_robe='I05M'
//合金拳套
integer ITEM_alloy_fist='I05B'
integer ITEMREEL_alloy_fist='I05K'
//蛛网鞋袜
integer ITEM_spider_socks='I05C'
integer ITEMREEL_spider_socks='I05P'
//魔法石
integer ITEM_mana_stone='I05H'
integer ITEMREEL_mana_stone='I05S'
//2500生命水
integer ITEM_life_water_2500='I000'
integer ITEMREEL_life_water_2500='I00H'
//生命石
integer ITEM_life_stone='I05G'
integer ITEMREEL_life_stone='I05N'
//1200魔法水
integer ITEM_mana_water_1200='I00N'
integer ITEMREEL_mana_water_1200='I00S'
//铁皮树枝
integer ITEM_iron_branch='I00V'
integer ITEMREEL_iron_branch='I059'
//3000魔法水
integer ITEM_mana_water_3000='I00P'
integer ITEMREEL_mana_water_3000='I00B'
//5000生命水
integer ITEM_life_water_5000='I002'
integer ITEMREEL_life_water_5000='I009'
//传送卷轴
integer ITEM_portal_scroll='I00I'
integer ITEMREEL_portal_scroll='I03V'
//护环
integer ITEM_retaining_ring='I05F'
integer ITEMREEL_retaining_ring='I05Q'
//聚风铃
integer ITEM_converge_winder='I05J'
integer ITEMREEL_converge_winder='I05O'
//无敌药水
integer ITEM_Invincible_drug='I011'
integer ITEMREEL_Invincible_drug='I03U'
//隐身药水
integer ITEM_transparent_drug='I00Y'
integer ITEMREEL_transparent_drug='I07V'
//奇术
integer ITEM_thaumaturgy='I05I'
integer ITEMREEL_thaumaturgy='I05L'
//攻击之爪
integer ITEM_paw='I007'
integer ITEMREEL_paw='I06C'
//奇迹药剂
integer ITEM_miracle_drug='I00Q'
integer ITEMREEL_miracle_drug='I018'
//大无敌药水
integer ITEM_Invincible_drug_big='I026'
integer ITEMREEL_Invincible_drug_big='I00W'
//督视猫头鹰
integer ITEM_isee='I04A'
integer ITEMREEL_isee='I04B'
//魔法指环
integer ITEM_mana_ring='I06I'
integer ITEMREEL_mana_ring='I06W'
//加速手套
integer ITEM_speed_glove='I05V'
integer ITEMREEL_speed_glove='I067'
//恢复指环
integer ITEM_life_ring='I06H'
integer ITEMREEL_life_ring='I06S'
//短剑
integer ITEM_sword='I05T'
integer ITEMREEL_sword='I062'
//魔法护身符
integer ITEM_mana_amulet='I06G'
integer ITEMREEL_mana_amulet='I06V'
//匕首
integer ITEM_dagger='I05U'
integer ITEMREEL_dagger='I06D'
//皮甲
integer ITEM_leather_armor='I06N'
integer ITEMREEL_leather_armor='I06P'
//生命护身符
integer ITEM_life_amulet='I05A'
integer ITEMREEL_life_amulet='I06T'
//速度之靴
integer ITEM_boot='I06K'
integer ITEMREEL_boot='I06Q'
//吸血面具
integer ITEM_hemophagia_mask='I06L'
integer ITEMREEL_hemophagia_mask='I06R'
//钢盔
integer ITEM_helmet='I06J'
integer ITEMREEL_helmet='I06U'
//法杖
integer ITEM_staff='I05X'
integer ITEMREEL_staff='I06E'
//风声笛子
integer ITEM_flute='I05Y'
integer ITEMREEL_flute='I06A'
//导魔之爪
integer ITEM_mana_paw='I00K'
integer ITEMREEL_mana_paw='I01Y'
//生机之爪
integer ITEM_vitality_paw='I005'
integer ITEMREEL_vitality_paw='I020'
//狼脊骨
integer ITEM_wolf_backbone='I07B'
integer ITEMREEL_wolf_backbone='I07J'
//影子风衣
integer ITEM_shadow_coat='I06O'
integer ITEMREEL_shadow_coat='I06Y'
//杖棍
integer ITEM_stick='I060'
integer ITEMREEL_stick='I06F'
//魔导靴
integer ITEM_mana_boot='I08F'
integer ITEMREEL_mana_boot='I027'
//铁斧
integer ITEM_axe='I05W'
integer ITEMREEL_axe='I06B'
//盗贼匕首
integer ITEM_robbers_dagger='I016'
integer ITEMREEL_robbers_dagger='I025'
//不响子
integer ITEM_silent_whelk='I06M'
integer ITEMREEL_silent_whelk='I06X'
//血羽钻
integer ITEM_blood_feather_drill='I073'
integer ITEMREEL_blood_feather_drill='I07O'
//鬼石
integer ITEM_ghost_stone='I071'
integer ITEMREEL_ghost_stone='I07P'
//焰石
integer ITEM_fire_stone='I070'
integer ITEMREEL_fire_stone='I07R'
//雷石
integer ITEM_thunder_stone='I06Z'
integer ITEMREEL_thunder_stone='I07S'
//冰石
integer ITEM_ice_stone='I072'
integer ITEMREEL_ice_stone='I07Q'
//混沌之石
integer ITEM_chaos_stone='I078'
integer ITEMREEL_chaos_stone='I07M'
//铁锤
integer ITEM_hammer='I061'
integer ITEMREEL_hammer='I068'
//钢枪
integer ITEM_spear='I05Z'
integer ITEMREEL_spear='I069'
//嗜血骨爪
integer ITEM_bloodthirsty_bone_paw='I010'
integer ITEMREEL_bloodthirsty_bone_paw='I02K'
//魔力之源
integer ITEM_mana_core='I08C'
integer ITEMREEL_mana_core='I00C'
//魔冰之戒
integer ITEM_ice_ring='I08B'
integer ITEMREEL_ice_ring='I02L'
//镶皮甲
integer ITEM_leather_armor_big='I08J'
integer ITEMREEL_leather_armor_big='I021'
//绿宝石
integer ITEM_emerald='I075'
integer ITEMREEL_emerald='I07U'
//原石
integer ITEM_original_stone='I074'
integer ITEMREEL_original_stone='I07T'
//活力之源
integer ITEM_life_core='I08H'
integer ITEMREEL_life_core='I00L'
//天空钻
integer ITEM_sky_diamond='I077'
integer ITEMREEL_sky_diamond='I07K'
//狮齿
integer ITEM_lion_tooth='I07A'
integer ITEMREEL_lion_tooth='I07F'
//圣杯
integer ITEM_san_greal='I02S'
integer ITEMREEL_san_greal='I02T'
//尖刺毛胚
integer ITEM_spike_pelage='I04O'
integer ITEMREEL_spike_pelage='I03S'
//尸鬼目
integer ITEM_ghoul_eye='I04K'
integer ITEMREEL_ghoul_eye='I03J'
//尸鬼肉
integer ITEM_ghoul_meat='I04I'
integer ITEMREEL_ghoul_meat='I03L'
//尸鬼齿
integer ITEM_ghoul_tooth='I04J'
integer ITEMREEL_ghoul_tooth='I03M'
//巨岩石
integer ITEM_big_stone='I04H'
integer ITEMREEL_big_stone='I03N'
//炸弹
integer ITEM_bomb='I04L'
integer ITEMREEL_bomb='I03Q'
//玲珑
integer ITEM_exquisite='I04N'
integer ITEMREEL_exquisite='I03X'
//蛇胆
integer ITEM_snake_bravery='I04M'
integer ITEMREEL_snake_bravery='I03R'
//邪魂
integer ITEM_evil_soul='I04R'
integer ITEMREEL_evil_soul='I03W'
//邪龙心
integer ITEM_evil_dragon_heart='I07W'
integer ITEMREEL_evil_dragon_heart='I07X'
//银灰壳
integer ITEM_silver_shell='I04Q'
integer ITEMREEL_silver_shell='I03T'
//飞靴
integer ITEM_charge_boot='I08I'
integer ITEMREEL_charge_boot='I024'
//野象牙
integer ITEM_mammoth_tooth='I07D'
integer ITEMREEL_mammoth_tooth='I07H'
//贵族钻
integer ITEM_noble_diamond='I076'
integer ITEMREEL_noble_diamond='I07L'
//火鸟羽毛
integer ITEM_phoenix_feather='I07C'
integer ITEMREEL_phoenix_feather='I07G'
//魔法盾
integer ITEM_mana_shield='I086'
integer ITEMREEL_mana_shield='I02B'
//先锋盾
integer ITEM_tank_shield='I087'
integer ITEMREEL_tank_shield='I028'
//冰晶虫
integer ITEM_ice_beetle='I07E'
integer ITEMREEL_ice_beetle='I07I'
//豚骨
integer ITEM_pig_bone='I09Y'
integer ITEMREEL_pig_bone='I09X'
//雷电之锤
integer ITEM_thunder_hammer='I082'
integer ITEMREEL_thunder_hammer='I00D'
//冷血枪
integer ITEM_bloodiness_spear='I052'
integer ITEMREEL_bloodiness_spear='I00A'
//先祖狼图腾
integer ITEM_wolf_totem='I03G'
integer ITEMREEL_wolf_totem='I03F'
//狼魂
integer ITEM_wolf_soul='I03H'
integer ITEMREEL_wolf_soul='I03I'
//仙风
integer ITEM_immortals='I0AD'
integer ITEMREEL_immortals='I0AE'
//毛袍
integer ITEM_fur_robe='I0BM'
integer ITEMREEL_fur_robe='I0BN'
//雪狐毛
integer ITEM_show_fox_fur='I0A0'
integer ITEMREEL_show_fox_fur='I09Z'
//雷霆之锤
integer ITEM_super_thunder_hammer='I083'
integer ITEMREEL_super_thunder_hammer='I01E'
//霹雳棒
integer ITEM_thunder_stick='I035'
integer ITEMREEL_thunder_stick='I02J'
//钻戒
integer ITEM_diamond_ring='I08A'
integer ITEMREEL_diamond_ring='I00R'
//鬼刀
integer ITEM_ghost_broadsword='I08M'
integer ITEMREEL_ghost_broadsword='I01R'
//冰雷符
integer ITEM_ice_thunder_charm='I088'
integer ITEMREEL_ice_thunder_charm='I014'
//骑士巨剑
integer ITEM_knight_sword='I001'
integer ITEMREEL_knight_sword='I013'
//沙虫尖尖尾
integer ITEM_sandworm_tail='I0A2'
integer ITEMREEL_sandworm_tail='I0A1'
//冥天之杖
integer ITEM_sky_stick='I080'
integer ITEMREEL_sky_stick='I00U'
//赤炼红环
integer ITEM_fire_ring='I09D'
integer ITEMREEL_fire_ring='I09C'
//刺客佩刀
integer ITEM_assassin_dagger='I004'
integer ITEMREEL_assassin_dagger='I029'
//剔透
integer ITEM_gleaming='I09Q'
integer ITEMREEL_gleaming='I09R'
//苦难根
integer ITEM_suffering_root='I0AQ'
integer ITEMREEL_suffering_root='I0AP'
//混沌之源
integer ITEM_chaos_source='I09T'
integer ITEMREEL_chaos_source='I09S'
//盗靴
integer ITEM_robbers_boot='I08E'
integer ITEMREEL_robbers_boot='I00Z'
//救世者
integer ITEM_saviour='I081'
integer ITEMREEL_saviour='I01J'
//鬼堕狱
integer ITEM_ghost_hell='I08L'
integer ITEMREEL_ghost_hell='I022'
//刺枪
integer ITEM_very_spear='I089'
integer ITEMREEL_very_spear='I012'
//晶体锤
integer ITEM_crystal_hammer='I0A8'
integer ITEMREEL_crystal_hammer='I0A7'
//血鬼爪牙
integer ITEM_blood_ghost_paw='I04T'
integer ITEMREEL_blood_ghost_paw='I042'
//龙甲
integer ITEM_leather_armor_dragon='I08K'
integer ITEMREEL_leather_armor_dragon='I01M'
//古绿罗刹
integer ITEM_green_raksasa='I09G'
integer ITEMREEL_green_raksasa='I09F'
//霹雳霹雳
integer ITEM_thunder_thunder_stick='I03K'
integer ITEMREEL_thunder_thunder_stick='I01A'
//源头之火
integer ITEM_original_fire='I0AF'
integer ITEMREEL_original_fire='I0AG'
//大地斧
integer ITEM_earth_axe='I02Z'
integer ITEMREEL_earth_axe='I023'
//盗贼手套
integer ITEM_robbers_gloves='I01T'
integer ITEMREEL_robbers_gloves='I006'
//火牙枪
integer ITEM_fire_spear='I051'
integer ITEMREEL_fire_spear='I01K'
//尸鬼堕狱
integer ITEM_ghoul_hell='I04S'
integer ITEMREEL_ghoul_hell='I041'
//裂焰斧
integer ITEM_fire_axe='I01U'
integer ITEMREEL_fire_axe='I01D'
//影刀
integer ITEM_shadow_broadsword='I01G'
integer ITEMREEL_shadow_broadsword='I00X'
//疾风之刃
integer ITEM_wind_dagger='I01S'
integer ITEMREEL_wind_dagger='I01O'
//龙铠
integer ITEM_leather_armor_dragon_shell='I0AH'
integer ITEMREEL_leather_armor_dragon_shell='I0AI'
//龙鳞
integer ITEM_leather_armor_dragon_snake='I09M'
integer ITEMREEL_leather_armor_dragon_snake='I09N'
//剔透杖
integer ITEM_exquisite_staff='I04X'
integer ITEMREEL_exquisite_staff='I045'
//雷神之锤
integer ITEM_god_thunder_hammer='I084'
integer ITEMREEL_god_thunder_hammer='I01Q'
//神秘水晶
integer ITEM_mysterious='I079'
integer ITEMREEL_mysterious='I07N'
//七彩炼玉
integer ITEM_mysterious_sky_staff='I096'
integer ITEMREEL_mysterious_sky_staff='I066'
//不破盾
integer ITEM_mysterious_kennedy_shield='I08T'
integer ITEMREEL_mysterious_kennedy_shield='I08R'
//亘古甲骨
integer ITEM_mysterious_ancient_oracle='I08Z'
integer ITEMREEL_mysterious_ancient_oracle='I04C'
//亡者呼声
integer ITEM_mysterious_ghost_scream='I08Y'
integer ITEMREEL_mysterious_ghost_scream='I065'
//冷冷牙
integer ITEM_cold_tooth='I0AO'
integer ITEMREEL_cold_tooth='I0AN'
//刺客信条
integer ITEM_mysterious_assassin_role='I08U'
integer ITEMREEL_mysterious_assassin_role='I04F'
//原力之斧
integer ITEM_mysterious_force_axe='I0AV'
integer ITEMREEL_mysterious_force_axe='I0AW'
//大地图腾
integer ITEM_mysterious_ground_totem='I091'
integer ITEMREEL_mysterious_ground_totem='I08Q'
//引雷棍
integer ITEM_mysterious_lighting='I0AL'
integer ITEMREEL_mysterious_lighting='I0AM'
//挑衅号角
integer ITEM_mysterious_provoke_horn='I094'
integer ITEMREEL_mysterious_provoke_horn='I08S'
//无情剑
integer ITEM_mysterious_ruthless_sword='I093'
integer ITEMREEL_mysterious_ruthless_sword='I04G'
//月夜石
integer ITEM_mysterious_moon_stone='I08V'
integer ITEMREEL_mysterious_moon_stone='I04D'
//权力之伪
integer ITEM_mysterious_fake_power='I04V'
integer ITEMREEL_mysterious_fake_power='I017'
//火神短剑
integer ITEM_mysterious_god_fire_sword='I0AZ'
integer ITEMREEL_mysterious_god_fire_sword='I0B0'
//灵魂破碎
integer ITEM_mysterious_soul_break='I0AX'
integer ITEMREEL_mysterious_soul_break='I0AY'
//神木
integer ITEM_mysterious_god_tree='I08W'
integer ITEMREEL_mysterious_god_tree='I08N'
//神秘水晶碎片
integer ITEM_mysterious_debris='I09K'
integer ITEMREEL_mysterious_debris='I09L'
//绝不恻隐刀
integer ITEM_mysterious_compassion_blade='I092'
integer ITEMREEL_mysterious_compassion_blade='I04P'
//蛮力图腾
integer ITEM_mysterious_power_totem='I090'
integer ITEMREEL_mysterious_power_totem='I08P'
//远古紫甲
integer ITEM_mysterious_purple_armor='I098'
integer ITEMREEL_mysterious_purple_armor='I04E'
//逃逸之风
integer ITEM_mysterious_escape_wind='I095'
integer ITEMREEL_mysterious_escape_wind='I064'
//霜之哀伤
integer ITEM_mysterious_ice_tear='I0B1'
integer ITEMREEL_mysterious_ice_tear='I0B2'
//霹雳之花
integer ITEM_mysterious_shrund_flower='I097'
integer ITEMREEL_mysterious_shrund_flower='I08O'
//风声
integer ITEM_mysterious_wind_sound='I08X'
integer ITEMREEL_mysterious_wind_sound='I063'
//骨杖
integer ITEM_mysterious_bone_staff='I030'
integer ITEMREEL_mysterious_bone_staff='I00T'
//玲珑剔透杖
integer ITEM_exquisite_exquisite_staff='I09P'
integer ITEMREEL_exquisite_exquisite_staff='I09O'
//冰晶三体锤
integer ITEM_three_crystal_hammer='I0A9'
integer ITEMREEL_three_crystal_hammer='I0AA'
//银色子弹
integer ITEM_silvery_bullet='I054'
integer ITEMREEL_silvery_bullet='I047'
//寒冰巫杖
integer ITEM_ice_staff='I031'
integer ITEMREEL_ice_staff='I01N'
//狂焰斧
integer ITEM_fire_axe_crazy='I01V'
integer ITEMREEL_fire_axe_crazy='I01X'
//狮狂大剑
integer ITEM_lion_big_sword='I0A4'
integer ITEMREEL_lion_big_sword='I0A3'
//激爆刃
integer ITEM_burst_dagger='I019'
integer ITEMREEL_burst_dagger='I01H'
//钢颲靴
integer ITEM_steel_boot='I08D'
integer ITEMREEL_steel_boot='I02A'
//烈日裁决
integer ITEM_sun_gun='I0AU'
integer ITEMREEL_sun_gun='I0AT'
//Jesus
integer ITEM_jesus='I0AS'
integer ITEMREEL_jesus='I0AR'
//罗刹影刃
integer ITEM_shadow_raksasa='I09H'
integer ITEMREEL_shadow_raksasa='I09I'
//炼·火牙枪
integer ITEM_cool_bloodiness_spear='I09U'
integer ITEMREEL_cool_bloodiness_spear='I09V'
//激爆炸裂
integer ITEM_crazy_burst_dagger='I04W'
integer ITEMREEL_crazy_burst_dagger='I044'
//烈焰狂豚斧
integer ITEM_fire_axe_crazy_pig='I053'
integer ITEMREEL_fire_axe_crazy_pig='I046'
//冰空靴
integer ITEM_crystal_boot='I08G'
integer ITEMREEL_crystal_boot='I01B'
//雄狮斩火刀
integer ITEM_lion_fire_fight='I0AK'
integer ITEMREEL_lion_fire_fight='I0AJ'
//炸裂狂豚斧
integer ITEM_brust_fire_axe_crazy_pig='I0AC'
integer ITEMREEL_brust_fire_axe_crazy_pig='I0AB'
//灭世魔刀
integer ITEM_mix_demon_sword='I0A6'
integer ITEMREEL_mix_demon_sword='I0A5'
//猛犸锤
integer ITEM_mammoth_hammer='I085'
integer ITEMREEL_mammoth_hammer='I01L'
//猛犸巨岩锤
integer ITEM_mammoth_earth_hammer='I04U'
integer ITEMREEL_mammoth_earth_hammer='I043'
//圣剑
integer ITEM_excalibur='I02U'
integer ITEMREEL_excalibur='I02V'
//圣枪
integer ITEM_holy_spear='I07Y'
integer ITEMREEL_holy_spear='I01P'
//夺命枪
integer ITEM_deadly_spear='I07Z'
integer ITEMREEL_deadly_spear='I02M'


/* COPYEND */



/* SHOP - Talent */
integer ITEM_Talent_Eagle_Eye = 'I0BI'
integer ITEM_Talent_Charge = 'I0BK'
integer ITEM_Talent_Jump = 'I0BL'
integer ITEM_Talent_Ghost_Walk = 'I0BJ'

integer ITEM_Talent_Heroic_Swordsmen = 'I056'
integer ITEM_Talent_Aim = 'I04Y'
integer ITEM_Talent_Aura_Leaf = 'I04Z'
integer ITEM_Talent_Source_Vitality = 'I050'

integer ITEM_Talent_Hepatoenteral_Fracture = 'I055'
integer ITEM_Talent_Holy_Sword = 'I057'
integer ITEM_Talent_Crusade = 'I058'
integer ITEM_Talent_Snow_Frost = 'I0BH'

endglobals

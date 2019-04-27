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

//other

/* COPY */

//小生命药水
integer ITEM_life_water_lv1='I00O'
integer ITEMREEL_life_water_lv1='I00E'
//小魔法药水
integer ITEM_mana_water_lv1='I003'
integer ITEMREEL_mana_water_lv1='I00F'
//大生命药水
integer ITEM_life_water_lv2='I000'
integer ITEMREEL_life_water_lv2='I00H'
//大魔法药水
integer ITEM_mana_water_lv2='I00N'
integer ITEMREEL_mana_water_lv2='I00S'
//督视猫头鹰
integer ITEM_isee='I04A'
integer ITEMREEL_isee='I04B'
//传送卷轴
integer ITEM_portal_scroll='I00I'
integer ITEMREEL_portal_scroll='I03V'
//隐身药水
integer ITEM_transparent_drug='I00Y'
integer ITEMREEL_transparent_drug='I07V'
//超生命药水
integer ITEM_life_water_lv3='I002'
integer ITEMREEL_life_water_lv3='I009'
//超魔法药水
integer ITEM_mana_water_lv3='I00P'
integer ITEMREEL_mana_water_lv3='I00B'
//铁皮树枝
integer ITEM_iron_branch='I00V'
integer ITEMREEL_iron_branch='I059'
//生命石
integer ITEM_life_stone='I05G'
integer ITEMREEL_life_stone='I05N'
//魔法石
integer ITEM_mana_stone='I05H'
integer ITEMREEL_mana_stone='I05S'
//攻击之爪
integer ITEM_paw='I007'
integer ITEMREEL_paw='I06C'
//护环
integer ITEM_retaining_ring='I05F'
integer ITEMREEL_retaining_ring='I05Q'
//加速手套
integer ITEM_speed_glove='I05V'
integer ITEMREEL_speed_glove='I067'
//魔法护身符
integer ITEM_mana_amulet='I06G'
integer ITEMREEL_mana_amulet='I06V'
//生命护身符
integer ITEM_life_amulet='I05A'
integer ITEMREEL_life_amulet='I06T'
//速度之靴
integer ITEM_boot='I06K'
integer ITEMREEL_boot='I06Q'
//钢盔
integer ITEM_helmet='I06J'
integer ITEMREEL_helmet='I06U'
//短剑
integer ITEM_sword='I05T'
integer ITEMREEL_sword='I062'
//铁斧
integer ITEM_axe='I05W'
integer ITEMREEL_axe='I06B'
//铁锤
integer ITEM_hammer='I061'
integer ITEMREEL_hammer='I068'
//杖棍
integer ITEM_stick='I060'
integer ITEMREEL_stick='I06F'
//吸血面具
integer ITEM_hemophagia_mask='I06L'
integer ITEMREEL_hemophagia_mask='I06R'
//匕首
integer ITEM_dagger='I05U'
integer ITEMREEL_dagger='I06D'
//先锋盾
integer ITEM_tank_shield='I087'
integer ITEMREEL_tank_shield='I028'
//奇术
integer ITEM_thaumaturgy='I05I'
integer ITEMREEL_thaumaturgy='I05L'
//先锋靴
integer ITEM_tank_boot='I08H'
integer ITEMREEL_tank_boot='I00L'
//皮甲
integer ITEM_leather_armor='I06N'
integer ITEMREEL_leather_armor='I06P'
//影子风衣
integer ITEM_shadow_coat='I06O'
integer ITEMREEL_shadow_coat='I06Y'
//食人鬼手套
integer ITEM_ghoul_gloves='I05E'
integer ITEMREEL_ghoul_gloves='I05R'
//钢枪
integer ITEM_spear='I05Z'
integer ITEMREEL_spear='I069'
//风声笛子
integer ITEM_flute='I05Y'
integer ITEMREEL_flute='I06A'
//法杖
integer ITEM_staff='I05X'
integer ITEMREEL_staff='I06E'
//冰魔靴
integer ITEM_crystal_boot='I08G'
integer ITEMREEL_crystal_boot='I01B'
//天空钻
integer ITEM_sky_diamond='I077'
integer ITEMREEL_sky_diamond='I07K'
//无声靴
integer ITEM_robbers_boot='I08E'
integer ITEMREEL_robbers_boot='I00Z'
//血羽钻
integer ITEM_blood_feather_drill='I073'
integer ITEMREEL_blood_feather_drill='I07O'
//食人鬼巨锤
integer ITEM_ghost_hammer='I085'
integer ITEMREEL_ghost_hammer='I01L'
//血枪
integer ITEM_bloodiness_spear='I051'
integer ITEMREEL_bloodiness_spear='I01K'
//混沌之石
integer ITEM_chaos_stone='I078'
integer ITEMREEL_chaos_stone='I07M'
//镶皮甲
integer ITEM_leather_armor_big='I08J'
integer ITEMREEL_leather_armor_big='I021'
//冥天之杖
integer ITEM_sky_stick='I080'
integer ITEMREEL_sky_stick='I00U'
//原石
integer ITEM_original_stone='I074'
integer ITEMREEL_original_stone='I07T'
//飞靴
integer ITEM_fly_boot='I08I'
integer ITEMREEL_fly_boot='I024'
//大地钺
integer ITEM_earth_axe='I02Z'
integer ITEMREEL_earth_axe='I023'
//雷石
integer ITEM_thunder_stone='I06Z'
integer ITEMREEL_thunder_stone='I07S'
//冰石
integer ITEM_ice_stone='I072'
integer ITEMREEL_ice_stone='I07Q'
//焰石
integer ITEM_fire_stone='I070'
integer ITEMREEL_fire_stone='I07R'
//鬼石
integer ITEM_ghost_stone='I071'
integer ITEMREEL_ghost_stone='I07P'
//霹雳棒
integer ITEM_thunder_stick='I035'
integer ITEMREEL_thunder_stick='I02J'
//贵族钻
integer ITEM_noble_diamond='I076'
integer ITEMREEL_noble_diamond='I07L'
//晶体锤
integer ITEM_crystal_hammer='I0A8'
integer ITEMREEL_crystal_hammer='I0A7'
//裂焰斧
integer ITEM_fire_axe='I01V'
integer ITEMREEL_fire_axe='I01X'
//雷电之锤
integer ITEM_thunder_hammer='I082'
integer ITEMREEL_thunder_hammer='I00D'
//冰雷符
integer ITEM_ice_thunder_charm='I088'
integer ITEMREEL_ice_thunder_charm='I014'
//绿幽石
integer ITEM_emerald='I075'
integer ITEMREEL_emerald='I07U'
//源头之火
integer ITEM_original_fire='I0AF'
integer ITEMREEL_original_fire='I0AG'
//幽透杖
integer ITEM_exquisite_staff='I04X'
integer ITEMREEL_exquisite_staff='I045'
//救世者
integer ITEM_saviour='I081'
integer ITEMREEL_saviour='I01J'
//疾风之刃
integer ITEM_wind_dagger='I01S'
integer ITEMREEL_wind_dagger='I01O'
//狼脊骨
integer ITEM_wolf_backbone='I07B'
integer ITEMREEL_wolf_backbone='I07J'
//雪狐毛
integer ITEM_show_fox_fur='I0A0'
integer ITEMREEL_show_fox_fur='I09Z'
//火鸟羽毛
integer ITEM_phoenix_feather='I07C'
integer ITEMREEL_phoenix_feather='I07G'
//狮齿
integer ITEM_lion_tooth='I07A'
integer ITEMREEL_lion_tooth='I07F'
//冰晶虫
integer ITEM_ice_beetle='I07E'
integer ITEMREEL_ice_beetle='I07I'
//邪骨甲
integer ITEM_leather_armor_born='I08K'
integer ITEMREEL_leather_armor_born='I01M'
//银狐子弹
integer ITEM_silvery_bullet='I054'
integer ITEMREEL_silvery_bullet='I047'
//霹雳霹雳
integer ITEM_thunder_thunder_stick='I03K'
integer ITEMREEL_thunder_thunder_stick='I01A'
//鬼道电锤
integer ITEM_god_thunder_hammer='I084'
integer ITEMREEL_god_thunder_hammer='I01Q'
//烽火巨剑
integer ITEM_fire_sword='I0A4'
integer ITEMREEL_fire_sword='I0A3'
//冰晶三体锤
integer ITEM_three_crystal_hammer='I0A9'
integer ITEMREEL_three_crystal_hammer='I0AA'
//鬼堕狱
integer ITEM_ghost_hell='I08L'
integer ITEMREEL_ghost_hell='I022'
//寒冰杖
integer ITEM_ice_staff='I031'
integer ITEMREEL_ice_staff='I01N'
//神秘水晶
integer ITEM_mysterious='I079'
integer ITEMREEL_mysterious='I07N'
//亘古骨甲
integer ITEM_mysterious_ancient_oracle='I08Z'
integer ITEMREEL_mysterious_ancient_oracle='I04C'
//亡者呼声
integer ITEM_mysterious_ghost_scream='I08Y'
integer ITEMREEL_mysterious_ghost_scream='I065'
//刺客信条
integer ITEM_mysterious_assassin_role='I08U'
integer ITEMREEL_mysterious_assassin_role='I04F'
//大地图腾
integer ITEM_mysterious_ground_totem='I091'
integer ITEMREEL_mysterious_ground_totem='I08Q'
//引雷棍
integer ITEM_mysterious_lighting='I0AL'
integer ITEMREEL_mysterious_lighting='I0AM'
//挑衅号角
integer ITEM_mysterious_provoke_horn='I094'
integer ITEMREEL_mysterious_provoke_horn='I08S'
//无双勾剑
integer ITEM_mysterious_god_fire_sword='I0AZ'
integer ITEMREEL_mysterious_god_fire_sword='I0B0'
//无情剑
integer ITEM_mysterious_ruthless_sword='I093'
integer ITEMREEL_mysterious_ruthless_sword='I04G'
//时空杖
integer ITEM_mysterious_time_staff='I096'
integer ITEMREEL_mysterious_time_staff='I066'
//月夜石
integer ITEM_mysterious_moon_stone='I08V'
integer ITEMREEL_mysterious_moon_stone='I04D'
//法老蛇的戒心
integer ITEM_mysterious_eat_my_tail='I08X'
integer ITEMREEL_mysterious_eat_my_tail='I063'
//灵魂破碎
integer ITEM_mysterious_soul_break='I0AX'
integer ITEMREEL_mysterious_soul_break='I0AY'
//皇家圆盾
integer ITEM_mysterious_kennedy_shield='I08T'
integer ITEMREEL_mysterious_kennedy_shield='I08R'
//神力斧
integer ITEM_mysterious_force_axe='I0AV'
integer ITEMREEL_mysterious_force_axe='I0AW'
//神木
integer ITEM_mysterious_god_tree='I08W'
integer ITEMREEL_mysterious_god_tree='I08N'
//神秘水晶碎片
integer ITEM_mysterious_debris='I09K'
integer ITEMREEL_mysterious_debris='I09L'
//稀土之源
integer ITEM_mysterious_power_totem='I090'
integer ITEMREEL_mysterious_power_totem='I08P'
//绝不恻隐刀
integer ITEM_mysterious_compassion_blade='I092'
integer ITEMREEL_mysterious_compassion_blade='I04P'
//远古紫甲
integer ITEM_mysterious_purple_armor='I098'
integer ITEMREEL_mysterious_purple_armor='I04E'
//逸风
integer ITEM_mysterious_escape_wind='I095'
integer ITEMREEL_mysterious_escape_wind='I064'
//霜之哀伤
integer ITEM_mysterious_ice_tear='I0B1'
integer ITEMREEL_mysterious_ice_tear='I0B2'
//霹雳之花
integer ITEM_mysterious_shrund_flower='I097'
integer ITEMREEL_mysterious_shrund_flower='I08O'
//光焰剑 · 烈日裁决
integer ITEM_sun_gun='I0AU'
integer ITEMREEL_sun_gun='I0AT'
//狂焚
integer ITEM_fire_axe_crazy='I053'
integer ITEMREEL_fire_axe_crazy='I046'
//雄狮斩牙刀
integer ITEM_lion_fire_fight='I0AK'
integer ITEMREEL_lion_fire_fight='I0AJ'

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


//学习-凌波微步
integer ITEM_study_lingboweibu = 'I03Y'
//学习-凝思冥想
integer ITEM_study_ningsimingxiang = 'I03Z'
//学习-活力充沛
integer ITEM_study_huolichongpei = 'I02H'
//学习-钢筋铁骨
integer ITEM_study_gangjintiegu = 'I02I'
//学习-苦中之乐
integer ITEM_study_kuzhongzhile = 'I02D'
//学习-超越之道
integer ITEM_study_skillPoint = 'I09J'
//荆木
integer ITEM_jingmu = 'I099'

endglobals

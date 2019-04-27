
globals
location Loc_C = Location(1150,1660)
integer g_token_count = 0
integer g_hero_count = 0
integer g_boss_count = 0
integer g_mon_yequ_count = 0
integer g_mon_shanjian_count = 0
integer g_mon_lianyu_count = 0
integer g_mon_guqu_count = 0
integer g_mon_chengqu_count = 0
integer g_mon_bingyuan_count = 0
integer array g_token
integer array g_hero
integer array g_boss
integer array g_mon_yequ
integer array g_mon_shanjian
integer array g_mon_lianyu
integer array g_mon_guqu
integer array g_mon_chengqu
integer array g_mon_bingyuan

integer g_env_count = 0
location array g_loc_env
integer array g_env
unit array g_u_env
integer array env_ices

rect rectJumpA1 = null
rect rectJumpA2 = null
rect rectJumpB1 = null
rect rectJumpB2 = null
rect rectJumpI1 = null
rect rectJumpI2 = null
integer g_loc_yequ_count = 0
integer g_loc_shanjian_count = 0
integer g_loc_lianyu_count = 0
integer g_loc_guqu_count = 0
integer g_loc_chengqu_count = 0
integer g_loc_bingyuan_count = 0
location array g_loc_yequ
location array g_loc_shanjian
location array g_loc_lianyu
location array g_loc_guqu
location array g_loc_chengqu
location array g_loc_bingyuan
group array g_g_yequ
group array g_g_shanjian
group array g_g_lianyu
group array g_g_guqu
group array g_g_chengqu
group array g_g_bingyuan
integer g_build_min_yequ = 6
integer g_build_min_shanjian = 3
integer g_build_min_lianyu = 6
integer g_build_min_guqu = 4
integer g_build_min_chengqu = 4
integer g_build_min_bingyuan = 5
integer g_build_max_yequ = 12
integer g_build_max_shanjian = 5
integer g_build_max_lianyu = 8
integer g_build_max_guqu = 8
integer g_build_max_chengqu = 7
integer g_build_max_bingyuan = 8

location g_loc_boss_hupo = Location(3531,1700)
location g_loc_boss_shanjian = Location(-1492,5829)
location g_loc_boss_lianyu = Location(4666,-2920)
location g_loc_boss_chengqu = Location(325,-3000)
location g_loc_boss_bingyuan = Location(6757,4358)
location g_loc_sp_bingyuan = Location(4611,6812)

integer array chengquBoss
unit array chengquBossUnit

integer momentItems_count = 0
integer array momentItems

boolean array inDungeons

rect rectShanjianL = null
rect rectShanjianM = null
rect rectShanjianR = null
boolean randomHoleAllow = false
integer randomHoleIndex = 1
integer array randomHole

endglobals

struct hGlobals

    public static method do takes nothing returns nothing
        set g_token_count = 16
        set g_token[1] = 'n01T'
        set g_token[2] = 'n01U'
        set g_token[3] = 'n023'
        set g_token[4] = 'n024'
        set g_token[5] = 'n025'
        set g_token[6] = 'n022'
        set g_token[7] = 'n01X'
        set g_token[8] = 'n01Y'
        set g_token[9] = 'n021'
        set g_token[10] = 'n020'
        set g_token[11] = 'n01Z'
        set g_token[12] = 'n026'
        set g_token[13] = 'n027'
        set g_token[14] = 'n028'
        set g_token[15] = 'n029'
        set g_token[16] = 'n02A'

        set g_hero_count = 1
        set g_hero[1] = 'H001'
        call hhero.setHeroType(g_hero[1],HERO_TYPE_AGI)
        call hunit.setAvatar(g_hero[1],"ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp")
        call hunit.setAttackSpeedBaseSpace(g_hero[1],1.50)

        set g_boss_count = 14
        set g_boss[1] = 'n01P'
        set g_boss[2] = 'n01H'
        set g_boss[3] = 'n018'
        set g_boss[4] = 'n01G'
        set g_boss[5] = 'n01F'
        set g_boss[6] = 'n01E'
        set g_boss[7] = 'n01D'
        set g_boss[8] = 'n01C'
        set g_boss[9] = 'n01B'
        set g_boss[10] = 'n01A'
        set g_boss[11] = 'n019'
        set g_boss[12] = 'n01O'
        set g_boss[13] = 'n017'
        set g_boss[14] = 'n016'

        set g_mon_yequ_count = 18
        set g_mon_yequ[1] = 'n005'
        set g_mon_yequ[2] = 'n007'
        set g_mon_yequ[3] = 'n008'
        set g_mon_yequ[4] = 'n00B'
        set g_mon_yequ[5] = 'n00D'
        set g_mon_yequ[6] = 'n00C'
        set g_mon_yequ[7] = 'n009'
        set g_mon_yequ[8] = 'n00A'
        set g_mon_yequ[9] = 'n00G'
        set g_mon_yequ[10] = 'n00K'
        set g_mon_yequ[11] = 'n00I'
        set g_mon_yequ[12] = 'n00J'
        set g_mon_yequ[13] = 'n004'
        set g_mon_yequ[14] = 'n002'
        set g_mon_yequ[15] = 'n003'
        set g_mon_yequ[16] = 'n00E'
        set g_mon_yequ[17] = 'n00H'
        set g_mon_yequ[18] = 'n00S'

        set g_mon_shanjian_count = 5
        set g_mon_shanjian[1] = 'n01M'
        set g_mon_shanjian[2] = 'n01L'
        set g_mon_shanjian[3] = 'n01K'
        set g_mon_shanjian[4] = 'n01I'
        set g_mon_shanjian[5] = 'n01N'

        set g_mon_lianyu_count = 4
        set g_mon_lianyu[1] = 'n013'
        set g_mon_lianyu[2] = 'n015'
        set g_mon_lianyu[3] = 'n014'
        set g_mon_lianyu[4] = 'n012'

        set g_mon_guqu_count = 12
        set g_mon_guqu[1] = 'n00N'
        set g_mon_guqu[2] = 'n00X'
        set g_mon_guqu[3] = 'n00U'
        set g_mon_guqu[4] = 'n00V'
        set g_mon_guqu[5] = 'n00W'
        set g_mon_guqu[6] = 'n00Q'
        set g_mon_guqu[7] = 'n00T'
        set g_mon_guqu[8] = 'n00R'
        set g_mon_guqu[9] = 'n00O'
        set g_mon_guqu[10] = 'n00P'
        set g_mon_guqu[11] = 'n00L'
        set g_mon_guqu[12] = 'n00M'

        set g_mon_chengqu_count = 4
        set g_mon_chengqu[1] = 'n00Z'
        set g_mon_chengqu[2] = 'n011'
        set g_mon_chengqu[3] = 'n010'
        set g_mon_chengqu[4] = 'n00Y'

        set g_mon_bingyuan_count = 3
        set g_mon_bingyuan[1] = 'n01Q'
        set g_mon_bingyuan[2] = 'n01J'
        set g_mon_bingyuan[3] = 'n01R'

        set rectJumpA1 = hrect.createInLoc(3040,3330,80,80)
        set rectJumpA2 = hrect.createInLoc(3032,3685,80,80)
        set rectJumpB1 = hrect.createInLoc(2616,-3037,80,80)
        set rectJumpB2 = hrect.createInLoc(2820,-2340,80,80)
        set rectJumpI1 = hrect.createInLoc(-2950,6863,80,80)
        set rectJumpI2 = hrect.createInLoc(3325,4864,80,80)


        //刷野点
        set g_loc_yequ_count = 13
        set g_loc_yequ[1] = Location(-1163,1694)
        set g_loc_yequ[2] = Location(-158,209)
        set g_loc_yequ[3] = Location(-1370,143)
        set g_loc_yequ[4] = Location(-2800,1120)
        set g_loc_yequ[5] = Location(-2538,114)
        set g_loc_yequ[6] = Location(-2538,114)
        set g_loc_yequ[7] = Location(-1066,-874)
        set g_loc_yequ[8] = Location(-2711,-800)
        set g_loc_yequ[9] = Location(-2711,-800)
        set g_loc_yequ[10] = Location(-1780,-1798)
        set g_loc_yequ[11] = Location(-2647,-1855)
        set g_loc_yequ[12] = Location(-2645,-2905)
        set g_loc_yequ[13] = Location(-312,1388)

        set g_loc_shanjian_count = 11
        set g_loc_shanjian[1] = Location(1685,4211)
        set g_loc_shanjian[2] = Location(2469,4946)
        set g_loc_shanjian[3] = Location(2469,4946)
        set g_loc_shanjian[4] = Location(1817,6000)
        set g_loc_shanjian[5] = Location(1125,5062)
        set g_loc_shanjian[6] = Location(128,6652)
        set g_loc_shanjian[7] = Location(203,4439)
        set g_loc_shanjian[8] = Location(-612,3682)
        set g_loc_shanjian[9] = Location(-551,4296)
        set g_loc_shanjian[10] = Location(-2392,3375)
        set g_loc_shanjian[11] = Location(-1577,4630)

        set g_loc_lianyu_count = 12
        set g_loc_lianyu[1] = Location(6336,690)
        set g_loc_lianyu[2] = Location(5842,-43)
        set g_loc_lianyu[3] = Location(4570,-223)
        set g_loc_lianyu[4] = Location(4776,-1010)
        set g_loc_lianyu[5] = Location(5553,-1010)
        set g_loc_lianyu[6] = Location(4996,-1567)
        set g_loc_lianyu[7] = Location(4318,-1793)
        set g_loc_lianyu[8] = Location(5532,-2281)
        set g_loc_lianyu[9] = Location(6500,-3000)
        set g_loc_lianyu[10] = Location(4658,-2942)
        set g_loc_lianyu[11] = Location(3674,-2723)
        set g_loc_lianyu[12] = Location(6092,-1900)

        set g_loc_guqu_count = 6
        set g_loc_guqu[1] = Location(3130,294)
        set g_loc_guqu[2] = Location(2100,-400)
        set g_loc_guqu[3] = Location(2942,-744)
        set g_loc_guqu[4] = Location(2147,-1355)
        set g_loc_guqu[5] = Location(1888,-2162)
        set g_loc_guqu[6] = Location(1717,-2777)

        set g_loc_chengqu_count = 9
        set g_loc_chengqu[1] = Location(738,-306)
        set g_loc_chengqu[2] = Location(90,-1354)
        set g_loc_chengqu[3] = Location(806,-1410)
        set g_loc_chengqu[4] = Location(-34,-2265)
        set g_loc_chengqu[5] = Location(638,-2294)
        set g_loc_chengqu[7] = Location(-228,-3115)
        set g_loc_chengqu[8] = Location(-228,-3115)
        set g_loc_chengqu[9] = Location(877,-3108)

        set g_loc_bingyuan_count = 9
        set g_loc_bingyuan[1] = Location(3733,5583)
        set g_loc_bingyuan[2] = Location(3100,6069)
        set g_loc_bingyuan[3] = Location(2756,6601)
        set g_loc_bingyuan[4] = Location(5113,6370)
        set g_loc_bingyuan[5] = Location(6136,5574)
        set g_loc_bingyuan[6] = Location(5104,4665)
        set g_loc_bingyuan[7] = Location(5104,4665)
        set g_loc_bingyuan[8] = Location(6724,5415)
        set g_loc_bingyuan[9] = Location(4230,3067)

        set chengquBoss[1] = 'n01H'
		set chengquBoss[2] = 'n01G'
		set chengquBoss[3] = 'n01F'
		set chengquBoss[4] = 'n01E'
		set chengquBoss[5] = 'n01D'
		set chengquBoss[6] = 'n01C'
		set chengquBoss[7] = 'n01B'
		set chengquBoss[8] = 'n01A'
		set chengquBoss[9] = 'n019'
		set chengquBoss[10] = 'n018'

        //env
        set env_ices[1] = 'n026'
        set env_ices[2] = 'n027'
        set env_ices[3] = 'n028'
        set g_env_count = 65
        set g_env[1] = 'n01U'
        set g_env[2] = 'n01U'
        set g_env[3] = 'n01U'
        set g_env[4] = 'n01U'
        set g_env[5] = 'n01U'
        set g_env[6] = 'n01U'
        set g_env[7] = 'n01U'
        set g_env[8] = 'n01U'
        set g_env[9] = 'n01U'
        set g_env[10] = env_ices[GetRandomInt(1,3)]
        set g_env[11] = env_ices[GetRandomInt(1,3)]
        set g_env[12] = env_ices[GetRandomInt(1,3)]
        set g_env[13] = env_ices[GetRandomInt(1,3)]
        set g_env[14] = env_ices[GetRandomInt(1,3)]
        set g_env[15] = env_ices[GetRandomInt(1,3)]
        set g_env[16] = env_ices[GetRandomInt(1,3)]
        set g_env[17] = env_ices[GetRandomInt(1,3)]
        set g_env[18] = env_ices[GetRandomInt(1,3)]
        set g_env[19] = env_ices[GetRandomInt(1,3)]
        set g_env[20] = env_ices[GetRandomInt(1,3)]
        set g_env[21] = env_ices[GetRandomInt(1,3)]
        set g_env[22] = env_ices[GetRandomInt(1,3)]
        set g_env[23] = env_ices[GetRandomInt(1,3)]
        set g_env[24] = env_ices[GetRandomInt(1,3)]
        set g_env[25] = env_ices[GetRandomInt(1,3)]
        set g_env[26] = env_ices[GetRandomInt(1,3)]
        set g_env[27] = env_ices[GetRandomInt(1,3)]
        set g_env[28] = env_ices[GetRandomInt(1,3)]
        set g_env[29] = env_ices[GetRandomInt(1,3)]
        set g_env[30] = env_ices[GetRandomInt(1,3)]
        set g_env[31] = 'n029'
        set g_env[32] = 'n029'
        set g_env[33] = 'n029'
        set g_env[34] = 'n029'
        set g_env[35] = 'n029'
        set g_env[36] = 'n029'
        set g_env[37] = 'n029'
        set g_env[38] = 'n029'
        set g_env[39] = 'n029'
        set g_env[40] = 'n029'
        set g_env[41] = 'n02A'
        set g_env[42] = 'n02A'
        set g_env[43] = 'n02A'
        set g_env[44] = 'n02A'
        set g_env[45] = 'n02A'
        set g_env[46] = 'n02A'
        set g_env[47] = 'n02A'
        set g_env[48] = 'n02A'
        set g_env[49] = 'n02A'
        set g_env[50] = 'n02A'
        set g_env[51] = 'n02A'
        set g_env[52] = 'n02A'
        set g_env[53] = 'n02A'
        set g_env[54] = 'n02A'
        set g_env[55] = 'n02A'
        set g_env[56] = 'n02A'
        set g_env[57] = 'n02A'
        set g_env[58] = 'n02A'
        set g_env[59] = 'n02A'
        set g_env[60] = 'n02A'
        set g_env[61] = 'n02A'
        set g_env[62] = 'n02A'
        set g_env[63] = 'n02A'
        set g_env[64] = 'n02A'
        set g_env[65] = 'n02A'
        // 风
        set g_loc_env[1] = Location(-1554,5747)
        set g_loc_env[2] = Location(-1925,6324)
        set g_loc_env[3] = Location(-1039,6360)
        set g_loc_env[4] = Location(-1996,5342)
        set g_loc_env[5] = Location(-2363,4284)
        set g_loc_env[6] = Location(122,4191)
        set g_loc_env[7] = Location(1024,5444)
        set g_loc_env[8] = Location(1765,5013)
        set g_loc_env[9] = Location(1348,6292)
        //冰
        set g_loc_env[10] = Location(2658,6404)
        set g_loc_env[11] = Location(2812,6488)
        set g_loc_env[12] = Location(2962,6438)
        set g_loc_env[13] = Location(2962,6438)
        set g_loc_env[14] = Location(3062,6416)
        set g_loc_env[15] = Location(3774,6119)
        set g_loc_env[16] = Location(3913,6076)
        set g_loc_env[17] = Location(3913,6076)
        set g_loc_env[18] = Location(4000,7014)
        set g_loc_env[19] = Location(4208,6964)
        set g_loc_env[20] = Location(4330,6885)
        set g_loc_env[21] = Location(4462,6869)
        set g_loc_env[22] = Location(4571,6830)
        set g_loc_env[23] = Location(4642,6052)
        set g_loc_env[24] = Location(4815,5950)
        set g_loc_env[25] = Location(4815,5950)
        set g_loc_env[26] = Location(5247,6256)
        set g_loc_env[27] = Location(5982,5593)
        set g_loc_env[28] = Location(6861,6228)
        set g_loc_env[29] = Location(6452,5118)
        set g_loc_env[30] = Location(6615,4330)
        // 火坑
        set g_loc_env[31] = Location(4688,-2203)
        set g_loc_env[32] = Location(3498,-1986)
        set g_loc_env[33] = Location(3906,-1212)
        set g_loc_env[34] = Location(5631,-1489)
        set g_loc_env[35] = Location(6510,-2305)
        set g_loc_env[36] = Location(6140,-2799)
        set g_loc_env[37] = Location(5248,-3161)
        set g_loc_env[38] = Location(7073,-3342)
        set g_loc_env[39] = Location(6134,-1328)
        set g_loc_env[40] = Location(6392,-1775)
        // 火焰
        set g_loc_env[41] = Location(4485,-911)
        set g_loc_env[42] = Location(4453,-986)
        set g_loc_env[43] = Location(4712,-963)
        set g_loc_env[44] = Location(5256,-808)
        set g_loc_env[45] = Location(5577,-1276)
        set g_loc_env[46] = Location(4944,-1783)
        set g_loc_env[47] = Location(5254,-4266)
        set g_loc_env[48] = Location(5043,-2625)
        set g_loc_env[49] = Location(3940,-3036)
        set g_loc_env[50] = Location(4190,-3032)
        set g_loc_env[51] = Location(3916,-1757)
        set g_loc_env[52] = Location(4147,-1585)
        set g_loc_env[53] = Location(2747,-2290)
        set g_loc_env[54] = Location(2980,-2316)
        set g_loc_env[55] = Location(6250,-2794)
        set g_loc_env[56] = Location(6476,-2619)
        set g_loc_env[57] = Location(6575,-2455)
        set g_loc_env[58] = Location(6864,-1783)
        set g_loc_env[59] = Location(7078,-1789)
        set g_loc_env[60] = Location(6790,-1315)
        set g_loc_env[61] = Location(6908,-1121)
        set g_loc_env[62] = Location(6731,-854)
        set g_loc_env[63] = Location(6886,-696)
        set g_loc_env[64] = Location(7177,-166)
        set g_loc_env[65] = Location(7299,-312)

        // 物品
        set momentItems_count = 8
        set momentItems[1]= 'o002'
        set momentItems[2]= 'o009'
        set momentItems[3]= 'o004'
        set momentItems[4]= 'o005'
        set momentItems[5]= 'o006'
        set momentItems[6]= 'o007'
        set momentItems[7]= 'o008'
        set momentItems[8]= 'o003'

    endmethod

endstruct

/* 属性系统 */
//定义全局变量
globals

    //生命
    integer array Attr_Life
    string array Attr_Str_Life
    //生命恢复
    real array Attr_LifeBack
    string array Attr_Str_LifeBack
    //魔法
    integer array Attr_Mana
    string array Attr_Str_Mana
    //魔法恢复
    real array Attr_ManaBack
    string array Attr_Str_ManaBack
    //移动力
    integer array Attr_Move
    string array Attr_Str_Move
    //防御
    integer array Attr_Defend
    string array Attr_Str_Defend
    //攻击力
    integer array Attr_Attack
    string array Attr_Str_Attack
    //攻击速度
    real array Attr_AttackSpeed
    string array Attr_Str_AttackSpeed
    //体质
    integer array Attr_Power
    string array Attr_Str_Power
    //身法
    integer array Attr_Quick
    string array Attr_Str_Quick
    //技巧
    integer array Attr_Skill
    string array Attr_Str_Skill
    //
    //韧性
    real array Attr_Toughness
    string array Attr_Str_Toughness
    //回避
    integer array Attr_Avoid
    string array Attr_Str_Avoid
    //物暴
    integer array Attr_Knocking
    string array Attr_Str_Knocking
    //术暴
    integer array Attr_Violence
    string array Attr_Str_Violence
    //当前硬直/最大硬直
    integer array Attr_PunishCurrent
    integer array Attr_PunishFull
    string array Attr_Str_Punish
    //冥想力(技能输出力)
    integer array Attr_SkillDamage
    string array Attr_Str_SkillDamage
    //救助力
    integer array Attr_Help
    string array Attr_Str_Help
    //吸血
    integer array Attr_Hemophagia
    string array Attr_Str_Hemophagia
    //分裂
    integer array Attr_Split
    string array Attr_Str_Split
    //负重
    real array Attr_WeightCurrent
    real array Attr_Weight
    string array Attr_Str_Weight
    //金钱获得比例
    real array Attr_GoldRatio
    string array Attr_Str_GoldRatio
    //木头获得比例
    real array Attr_LumberRatio
    string array Attr_Str_LumberRatio
    //经验获得比例
    real array Attr_ExpRatio
    string array Attr_Str_ExpRatio

    //动态属性(可变的)
    //注意：此变量组只能用于增减均衡的改变中?
    //只有增加过必须要在之后减少才能使用这些变量
    //生命
    integer array Attr_Dynamic_Life
    //生命恢复
    real array Attr_Dynamic_LifeBack
    //魔法
    integer array Attr_Dynamic_Mana
    //魔法恢复
    real array Attr_Dynamic_ManaBack
    //防御
    integer array Attr_Dynamic_Defend
    //移动力
    integer array Attr_Dynamic_Move
    //攻击力
    integer array Attr_Dynamic_Attack
    //攻击速度
    real array Attr_Dynamic_AttackSpeed
    //体质
    integer array Attr_Dynamic_Power
    //身法
    integer array Attr_Dynamic_Quick
    //技巧
    integer array Attr_Dynamic_Skill
    //救助力
    integer array Attr_Dynamic_Help
    //
    //韧性
    real array Attr_Dynamic_Toughness
    //回避
    integer array Attr_Dynamic_Avoid
    //物暴
    integer array Attr_Dynamic_Knocking
    //术暴
    integer array Attr_Dynamic_Violence
    //当前硬直/最大硬直
    integer array Attr_Dynamic_PunishCurrent
    integer array Attr_Dynamic_PunishFull
    //冥想力(技能输出力)
    integer array Attr_Dynamic_SkillDamage
    //吸血
    integer array Attr_Dynamic_Hemophagia
    //分裂
    integer array Attr_Dynamic_Split
    //负重
    real array Attr_Dynamic_Weight
    //金钱获得比例
    real array Attr_Dynamic_GoldRatio
    //木头获得比例
    real array Attr_Dynamic_LumberRatio
    //经验获得比例
    real array Attr_Dynamic_ExpRatio


    //prev cache
    //生命
    integer array Attr_PrevCache_Life
    //生命恢复
    real array Attr_PrevCache_LifeBack
    //魔法
    integer array Attr_PrevCache_Mana
    //魔法恢复
    real array Attr_PrevCache_ManaBack
    //防御
    integer array Attr_PrevCache_Defend
    //移动力
    integer array Attr_PrevCache_Move
    //攻击力
    integer array Attr_PrevCache_Attack
    //攻击速度
    real array Attr_PrevCache_AttackSpeed
    //体质
    integer array Attr_PrevCache_Power
    //身法
    integer array Attr_PrevCache_Quick
    //技巧
    integer array Attr_PrevCache_Skill
    //救助力
    integer array Attr_PrevCache_Help
    //韧性
    real array Attr_PrevCache_Toughness
    //回避
    integer array Attr_PrevCache_Avoid
    //物暴
    integer array Attr_PrevCache_Knocking
    //术暴
    integer array Attr_PrevCache_Violence
    //硬直
    integer array Attr_PrevCache_PunishFull
    //冥想力
    integer array Attr_PrevCache_SkillDamage
    //吸血
    integer array Attr_PrevCache_Hemophagia
    //分裂
    integer array Attr_PrevCache_Split
    //负重
    real array Attr_PrevCache_Weight
    //金钱获得比例
    real array Attr_PrevCache_GoldRatio
    //木头获得比例
    real array Attr_PrevCache_LumberRatio
    //经验获得比例
    real array Attr_PrevCache_ExpRatio



    //Tag
    integer Tag_Life 			= 1
    integer Tag_Mana 			= 2
    integer Tag_LifeBack 		= 3
    integer Tag_ManaBack 	= 4
    integer Tag_Move 			= 5
    integer Tag_Defend 		= 6
    integer Tag_Attack 		= 7
    integer Tag_AttackSpeed	= 8
    integer Tag_Power       	= 9
    integer Tag_Quick       	= 10
    integer Tag_Skill       		= 11
    integer Tag_Toughness   	= 12
    integer Tag_Avoid       	= 13
    integer Tag_Knocking    	= 14
    integer Tag_Violence		= 15
    integer Tag_PunishFull  	= 16
    integer Tag_SkillDamage 	= 17
    integer Tag_Help        	= 18
    integer Tag_Hemophagia 	= 19
    integer Tag_Split 			= 20
    integer Tag_Weight 		= 21
    integer Tag_GoldRatio 		= 22
    integer Tag_LumberRatio 	= 23
    integer Tag_ExpRatio 		= 24

endglobals

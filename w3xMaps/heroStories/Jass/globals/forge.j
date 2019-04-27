/* 锻造系统 */
globals

//锻造等级
//生命
integer array ForgeLv_Life
//生命恢复
integer array ForgeLv_LifeBack
//魔法
integer array ForgeLv_Mana
//魔法恢复
integer array ForgeLv_ManaBack
//防御
integer array ForgeLv_Defend
//移动力
integer array ForgeLv_Move
//攻击力
integer array ForgeLv_Attack
//攻击速度
integer array ForgeLv_AttackSpeed
//体质
integer array ForgeLv_Power
//身法
integer array ForgeLv_Quick
//技巧
integer array ForgeLv_Skill
//救助力
integer array ForgeLv_Help


//锻造物品
integer Forge_itemType_Life = 'I01C'
integer Forge_itemType_LifeBack = 'I00G'
integer Forge_itemType_Mana = 'I00J'
integer Forge_itemType_ManaBack = 'I00M'
integer Forge_itemType_Defend = 'I01F'
integer Forge_itemType_Move = 'I01I'
integer Forge_itemType_Attack = 'I01W'
integer Forge_itemType_AttackSpeed = 'I01Z'
integer Forge_itemType_Power = 'I02C'
integer Forge_itemType_Quick = 'I02W'
integer Forge_itemType_Skill = 'I03O'
integer Forge_itemType_Help = 'I03P'

//锻造成功率提升成功率助手的整数变量
//每次锻造失败对应的助手等级会+1，提升下一次的强化几率，成功时清空
integer array Forge_upHelper_Life
integer array Forge_upHelper_LifeBack
integer array Forge_upHelper_Mana
integer array Forge_upHelper_ManaBack
integer array Forge_upHelper_Defend
integer array Forge_upHelper_Move
integer array Forge_upHelper_Attack
integer array Forge_upHelper_AttackSpeed
integer array Forge_upHelper_Power
integer array Forge_upHelper_Quick
integer array Forge_upHelper_Skill
integer array Forge_upHelper_Help

endglobals

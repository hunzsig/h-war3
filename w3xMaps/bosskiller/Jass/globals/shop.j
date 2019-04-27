globals

	integer Shop_grey_forest 			= 'n00H'			//灰色森林

	integer Shop_baoshishangren 		= 'n00E'			//宝石商人
	integer Shop_zahuodian 			= 'n00C'			//杂货店
	integer Shop_shujingxiaofan 		= 'n028'			//树精小贩
	integer Shop_wuqimofang 			= 'n002'			//武器磨坊
	integer Shop_lieshouren 			= 'n001'			//猎兽人
	integer Shop_shenmodaoshikanong	= 'n003'			//神魔导师卡农
	integer Shop_hanwu 				= 'n00W'			//罕物
	integer Shop_duanzaojianhaosilisi 	= 'n00A'			//锻造剑豪斯利斯
	integer Shop_fangjuwu 			= 'n00D'			//防具屋
	integer Shop_cangbaoge 			= 'n03R'			//藏宝阁
	integer Shop_heishi 				= 'n00S'			//黑市

	integer Shop_Item_baoshishangren 			= 'I0B6'			//宝石商人
	integer Shop_Item_zahuodian 				= 'I0B5'			//杂货店
	integer Shop_Item_shujingxiaofan 			= 'I0B4'			//树精小贩
	integer Shop_Item_wuqimofang				= 'I0B7'			//武器磨坊
	integer Shop_Item_lieshouren 				= 'I0B8'			//猎兽人
	integer Shop_Item_shenmodaoshikanong	= 'I0B9'			//神魔导师卡农
	integer Shop_Item_hanwu 					= 'I0BA'			//罕物
	integer Shop_Item_duanzaojianhaosilisi 		= 'I0B3'			//锻造剑豪斯利斯
	integer Shop_Item_fangjuwu 				= 'I0BB'			//防具屋
	integer Shop_Item_cangbaoge 				= 'I0BG'			//藏宝阁
	integer Shop_Item_heishi 					= 'I0BE'			//黑市

	unit Shop_Unit_grey_forest					//灰色森林
	unit Shop_Unit_baoshishangren				//宝石商人
	unit Shop_Unit_zahuodian 					//杂货店
	unit Shop_Unit_shujingxiaofan 				//树精小贩
	unit Shop_Unit_wuqimofang 				//武器磨坊
	unit Shop_Unit_lieshouren 					//猎兽人
	unit Shop_Unit_shenmodaoshikanong		//神魔导师卡农
	unit Shop_Unit_hanwu 						//罕物
	unit Shop_Unit_duanzaojianhaosilisi			//锻造剑豪斯利斯
	unit Shop_Unit_fangjuwu 					//防具屋
	unit Shop_Unit_cangbaoge 					//藏宝阁
	unit array Shop_Unit_heishi 				//黑市（每个玩家都不一样）

	group Shop_Group = CreateGroup()		//商城组

	integer Shop_system_open = 'A02E'			//开启商店技能模板
	boolean array Shop_system_hero_isInit		//英雄是否已经对商店初始化
	integer Shop_token = 'n00J'				//买物品马甲
	unit array Shop_tokens

	//TODO ESC状态值
	trigger shop_esc_trigger = CreateTrigger()			//单位ESC切换触发
	trigger shop_choose_unit_trigger = CreateTrigger()	//玩家选择单位
	integer array Shop_system_esc_status				//ESC状态值
	integer Shop_esc_status_close 	= 0
	integer Shop_esc_status_open 	= 1
	integer Shop_esc_status_chooes	= 2

	//TODO 黑市翻页
	integer Shop_Page_heishi_prev = 'I0BC'	//上一页
	integer Shop_Page_heishi_next = 'I0BD'	//下一页

endglobals

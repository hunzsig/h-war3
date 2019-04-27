globals

	/* COMMON */

	//trigger
	trigger Trigger_Enemy_Army_Del 	= CreateTrigger()
	trigger Trigger_Enemy_Army_Award	= CreateTrigger()

     //timer
    timer Enemy_Timer_Main = null
    integer Enemy_Timer_During_Cache = 0		//用于记录during被暂停时的值，防止计时重置
    integer Enemy_Timer_CountDown_Cache = 0	//用于记录剩余倒计时被暂停时的值，防止计时重置
    integer Enemy_Now = 0

	/* Enemy_Config */

	integer Enemy_Type_Total_Qty = 21					//基数
    //每一波的详细数据
    integer array Enemy_Config_Boss          		//每波 - 敌人 - boss级别
    integer array Enemy_Config_Weak           		//每波 - 敌人 - 弱鸡
    integer array Enemy_Config_Strong            	//每波 - 敌人 -  强壮
    integer array Enemy_Config_Leader       		//每波 - 敌人 -  引路人
    string array Enemy_Config_Tips               	//每波 - boss敌人出现时的tips

    //每一波的最终整合数据，最后以这个作为生成关卡的依据
    integer array Enemy_Config_Final_Boss
    integer array Enemy_Config_Final_Weak
    integer array Enemy_Config_Final_Strong

    integer array Enemy_Config_Final_Leader

    string array Enemy_Config_Final_Tips
    boolean array Enemy_Config_Final_TipsShow
    boolean array Enemy_Config_Final_Killed
    boolean array Enemy_Config_Final_Attacked
    group array Enemy_Config_Final_Environment

    unit array Enemy_Boss_Leader_Unit
    unit array Enemy_Boss_Unit

    /* Enemy_Config 野区 */

    //野区
    integer Enemy_Type_Dragon_Red = 'n013'
    integer Enemy_Type_Dragon_Black = 'n014'
    unit Enemy_Dragon_Red = null
    unit Enemy_Dragon_Black = null

    /* Enemy_Config Last */

    //最后一波选择
    integer Enemy_Last_Type_Total_Qty = 3
    integer array Enemy_Config_Last_weak1           	//最终波 - 敌人 - 弱1
    integer array Enemy_Config_Last_weak2           	//最终波 - 敌人 - 弱2
    integer array Enemy_Config_Last_normal1        		//最终波 - 敌人 - 中1
    integer array Enemy_Config_Last_normal2       		//最终波 - 敌人 - 中2
    integer array Enemy_Config_Last_hard1          		//最终波 - 敌人 - 强1
    integer array Enemy_Config_Last_hard2        		//最终波 - 敌人 - 强2
    integer array Enemy_Config_Last_boss        		//最终波 - 敌人 - boss
    string array Enemy_Config_Last_Tips               	//最终波 - boss敌人出现时的tips
    //---------------------------
    integer Enemy_Config_Last_Final_weak1
    integer Enemy_Config_Last_Final_weak2
    integer Enemy_Config_Last_Final_normal1
    integer Enemy_Config_Last_Final_normal2
    integer Enemy_Config_Last_Final_hard1
    integer Enemy_Config_Last_Final_hard2
    integer Enemy_Config_Last_Final_boss              	//最终波 boss
    string Enemy_Config_Last_Final_Tips

endglobals

library characterEnemy requires characterAlly

	/* 通用军队处理 */

	//军队组触发删除事件
	private function triggerActionArmyDel takes nothing returns nothing
	    local unit u = GetTriggerUnit()
	    local player enemy = GetOwningPlayer(u)
	    local integer index = 0
	    local integer i = 0
	    //找出归属的玩家index
	    set i = 1
	    loop
	        exitwhen ( i > Enemy_Army_Group_Max )
	            if( enemy == Enemy_Army_GroupPlayer[i] ) then
	                set index = i
	                call DoNothing() YDNL exitwhen true
	            endif
	            set i = i + 1
	    endloop
	    call GroupRemoveUnit( Enemy_Army_Group[index] , u )
	    call funcs_delUnit( u , 30.00 )
	endfunction

	//军队组触发奖励事件
	private function triggerActionArmyAward takes nothing returns nothing
	    local unit triggerUnit = GetTriggerUnit()
	    local unit u
	    local group heroGroup = null
	    local location loc = null
	    local integer exp = 0
	    local integer gold = 0
	    local integer lumber = 0
	    local real lifeLevel = R2I(GetUnitState(triggerUnit, UNIT_STATE_MAX_LIFE) / 5000)
	    local real lifeLevelMax = 0
	    //todo 分经验分钱
	    if( lifeLevel < 1) then
	        set lifeLevel = 1
	    endif
	    //根据模式计算资源
        set lifeLevelMax = 3
	    if( lifeLevel > lifeLevelMax) then
	        set lifeLevel = lifeLevelMax
	    endif
	    //计算资源
        set exp  = R2I(      (((72-DIFF*2) * lifeLevel )  +  18 * I2R(Enemy_Now-1))       *     ( 1 + I2R(Current_Player_num-1)*0.8 ) )
        set gold  = R2I(    (((52-DIFF*2) * lifeLevel )  +  16 * I2R(Enemy_Now-1))         *      ( 1 + I2R(Current_Player_num-1)*0.7) )
        set lumber = 0

	    set loc = GetUnitLoc(triggerUnit)
	    set heroGroup = funcs_getGroupByPoint( loc , Share_Range , function filter_live_hero )
	    call share_awardGroup( exp , gold , lumber , heroGroup )
	    call GroupClear(heroGroup)
	    call DestroyGroup(heroGroup)
	    call RemoveLocation(loc)
	endfunction

	 //把敌人加进Enemy_Army
    public function addEnemyInGroup takes group g , unit u returns nothing
        call GroupAddUnit( g , u )
        call eventRegist_unitDeath( Trigger_Enemy_Army_Del , u )
        call eventRegist_unitDeath( Trigger_Enemy_Army_Award , u )
        call eventRegist_unitBeAttack( gg_trg_event_beAttack , u )
        call eventRegist_unitDamaged( gg_trg_event_damaged , u )
    endfunction

    //创建敌人
    public function createArmy takes integer qty , integer unitTypeId , location sourceLoc , location targetLoc returns nothing
        local group g = null
        local unit u = null
        local integer index = 0
        local integer i = 0
        local integer tempQty = 0
        //找出数量最少的单位组
        set i = 1
        loop
            exitwhen ( i > Enemy_Army_Group_Max )
                if( index == 0 ) then
                    set index = i
                    set tempQty = CountUnitsInGroup(Enemy_Army_Group[i])
                elseif( CountUnitsInGroup(Enemy_Army_Group[i]) < tempQty ) then
                    set index = i
                endif
                set i = i + 1
        endloop
        if( qty > 0) then
            set g = funcs_createNUnitAttackToLoc( qty , unitTypeId , Enemy_Army_GroupPlayer[index]  , sourceLoc  , targetLoc )
            loop
                exitwhen(IsUnitGroupEmptyBJ(g) == true)
                    //must do
                    set u = FirstOfGroup(g)
                    if( IsUnitInGroup( u , Enemy_Army_Group[index] ) == FALSE) then
                        call addEnemyInGroup( Enemy_Army_Group[index] ,u )
                        call SetUnitColor( u, ConvertPlayerColor(12) )//黑色
                    endif
                    call GroupRemoveUnit( g , u )
            endloop
            call GroupClear(g)
            call DestroyGroup(g)
        endif
    endfunction

	//初始化
	//绑定各种敌军数据
	public function init takes nothing returns nothing

	    //注册触发
	    call TriggerAddAction( Trigger_Enemy_Army_Del 	, function triggerActionArmyDel )
	    call TriggerAddAction( Trigger_Enemy_Army_Award 	, function triggerActionArmyAward)

	    //军队组
	    set Enemy_Army_GroupPlayer[1] = Player(9)
	    set Enemy_Army_GroupPlayer[2] = Player(10)
	    set Enemy_Army_Group[1] = CreateGroup()
	    set Enemy_Army_Group[2] = CreateGroup()

		/* Enemy_Config */

	    //数据绑定
	    //第1种 - 食尸鬼部队
	    set Enemy_Config_Tips[1] = "草丛中传来微弱的声响....似乎有吞食尸体的的味道..."
	    set Enemy_Config_Boss[1] = 'n005'          //群暴食尸鬼
	    set Enemy_Config_Weak[1] = 'n00I'         //小个子食尸鬼
	    set Enemy_Config_Strong[1] = 'n01B'       //狂暴噬魂鬼
	    set Enemy_Config_Leader[1] = 'n037'       //引路人
	    //第2种  - 网蛛部队
	    set Enemy_Config_Tips[2] = ".......恩恩....恩...报信人浑身白丝似乎无法动弹"
	    set Enemy_Config_Boss[2] = 'n00N'          //鬼狼蛛
	    set Enemy_Config_Weak[2] = 'n02K'         //狼蛛
	    set Enemy_Config_Strong[2] = 'n02L'       //网蛛
	    set Enemy_Config_Leader[2] = 'n03A'       //引路人
	    //第3种  - 巨岩部队
	    set Enemy_Config_Tips[3] = "大地震动着，快要站不稳了"
	    set Enemy_Config_Boss[3] = 'n004'          //巨石人
	    set Enemy_Config_Weak[3] = 'n007'         //小石人
	    set Enemy_Config_Strong[3] = 'n01G'       //傀儡灵石
	    set Enemy_Config_Leader[3] = 'n01A'       //引路人
	    //第4种  - 炸弹部队
	    set Enemy_Config_Tips[4] = "一股满满的火药味，难闻死了"
	    set Enemy_Config_Boss[4] = 'n00K'          //炸弹魔
	    set Enemy_Config_Weak[4] = 'n00G'         //小型炸弹
	    set Enemy_Config_Strong[4] = 'n01E'       //迫击炮小队
	    set Enemy_Config_Leader[4] = 'n01D'       //引路人
	    //第5种  - 铁甲军团
	    set Enemy_Config_Tips[5] = "刀枪不入的铁甲军团进攻了"
	    set Enemy_Config_Boss[5] = 'n01O'          //军统领
	    set Enemy_Config_Weak[5] = 'n01L'         //铁甲步兵
	    set Enemy_Config_Strong[5] = 'n01M'      //铁骑士
	    set Enemy_Config_Leader[5] = 'n03B'       //引路人
	    //第6种  - 食人族
	    set Enemy_Config_Tips[6] = "一群大胖子缓缓地走了过来"
	    set Enemy_Config_Boss[6] = 'n01K'          //食人大佬
	    set Enemy_Config_Weak[6] = 'n01H'        //食人鬼战士
	    set Enemy_Config_Strong[6] = 'n01I'       //食人鬼魔法师
	    set Enemy_Config_Leader[6] = 'n03C'       //引路人
	     //第7种  - 娜迦族
	    set Enemy_Config_Tips[7] = "冒泡～冒泡～"
	    set Enemy_Config_Boss[7] = 'n02B'          //飞蛇
	    set Enemy_Config_Weak[7] = 'n021'         //小鱼人
	    set Enemy_Config_Strong[7] = 'n023'       //海妖武士
	    set Enemy_Config_Leader[7] = 'n03D'       //引路人
	     //第8种  - 海水居民
	    set Enemy_Config_Tips[8] = "可恶的海水住民攻过来了"
	    set Enemy_Config_Boss[8] = 'n03F'          //深海海民
	    set Enemy_Config_Weak[8] = 'n025'         //水魔怪
	    set Enemy_Config_Strong[8] = 'n022'       //海龙
	    set Enemy_Config_Leader[8] = 'n03E'       //引路人
	    //第9种  - 狼群
	    set Enemy_Config_Tips[9] = "啊呜～～～～～～～～～～～～～～～～"
	    set Enemy_Config_Boss[9] = 'n00M'          //怖残像狼
	    set Enemy_Config_Weak[9] = 'n01J'         //巨狼牙
	    set Enemy_Config_Strong[9] = 'n02G'       //狂狼
	    set Enemy_Config_Leader[9] = 'n03H'       //引路人
	    //第10种  - 怪颜族
	    set Enemy_Config_Tips[10] = "一群长相奇怪的人走过来了，有的像个J8"
	    set Enemy_Config_Boss[10] = 'n020'          //鬼巨人
	    set Enemy_Config_Weak[10] = 'n02E'         //J8颜面
	    set Enemy_Config_Strong[10] = 'n02F'       //J8赤面
	    set Enemy_Config_Leader[10] = 'n03I'       //引路人
	    //第11种  - 角鹰部落
	    set Enemy_Config_Tips[11] = "好多角鹰兽飞过来！"
	    set Enemy_Config_Boss[11] = 'n03G'          //狮鹫
	    set Enemy_Config_Weak[11] = 'n01Q'         //弓箭手
	    set Enemy_Config_Strong[11] = 'n01R'       //角鹰兽骑士
	    set Enemy_Config_Leader[11] = 'n03J'       //引路人
	    //第12种  - 魔导师小队
	    set Enemy_Config_Tips[12] = "adonarusi tadala Ida～"
	    set Enemy_Config_Boss[12] = 'n040'          //外道魔导师
	    set Enemy_Config_Weak[12] = 'n01S'         //牧师
	    set Enemy_Config_Strong[12] = 'n01T'       //魔导师
	    set Enemy_Config_Leader[12] = 'n03L'       //引路人
	    //第13种  - 精灵族
	    set Enemy_Config_Tips[13] = "同是精灵族，为什么要争斗？"
	    set Enemy_Config_Boss[13] = 'n01Y'           //奇美拉
	    set Enemy_Config_Weak[13] = 'n01U'         //精灵龙
	    set Enemy_Config_Strong[13] = 'n03V'       //小精灵
	    set Enemy_Config_Leader[13] = 'n03M'       //引路人
	     //第14种  - 刀锋战士
	    set Enemy_Config_Tips[14] = "刀光闪闪"
	    set Enemy_Config_Boss[14] = 'n02C'          //狂斩刺客
	    set Enemy_Config_Weak[14] = 'n026'         //刀锋
	    set Enemy_Config_Strong[14] = 'n03N'       //影杀
	    set Enemy_Config_Leader[14] = 'n03O'       //引路人
	     //第15种  - 怪异族人
	    set Enemy_Config_Tips[15] = "一些怪怪的生物过来了"
	    set Enemy_Config_Boss[15] = 'n02N'          //尖毛猪
	    set Enemy_Config_Weak[15] = 'n024'         //狗头人
	    set Enemy_Config_Strong[15] = 'n029'       //图卡斯
	    set Enemy_Config_Leader[15] = 'n03P'       //引路人
	    //第16种  - 荒漠怪类
	    set Enemy_Config_Tips[16] = "黄沙漫天飞，视线都模糊了"
	    set Enemy_Config_Boss[16] = 'n02P'          //灰沙蝎王
	    set Enemy_Config_Weak[16] = 'n027'         //蜥蜴
	    set Enemy_Config_Strong[16] = 'n02M'       //三头蛇
	    set Enemy_Config_Leader[16] = 'n03Q'       //引路人
	    //第17种  - 野性兽人
	    set Enemy_Config_Tips[17] = "哦啦哦啦哦啦哦啦哦啦！"
	    set Enemy_Config_Boss[17] = 'n03K'          //提灯白牛
	    set Enemy_Config_Weak[17] = 'n01V'         //拍拍熊
	    set Enemy_Config_Strong[17] = 'n01X'       //撼地牛
	    set Enemy_Config_Leader[17] = 'n03S'       //引路人
	    //第18种  - 骷髅战队
	    set Enemy_Config_Tips[18] = "即使化身一身白骨，战士之魂还是复活了"
	    set Enemy_Config_Boss[18] = 'n02O'          //骷髅杀手
	    set Enemy_Config_Weak[18] = 'n02I'         //兽兵骷髅
	    set Enemy_Config_Strong[18] = 'n02J'       //白骨弓兵
	    set Enemy_Config_Leader[18] = 'n03T'       //引路人
	    //第19种  - 远古战士
	    set Enemy_Config_Tips[19] = "一股古老的气息！杀气十足"
	    set Enemy_Config_Boss[19] = 'n02D'          //破坏猛犸王
	    set Enemy_Config_Weak[19] = 'n01W'         //巨背犀牛
	    set Enemy_Config_Strong[19] = 'n02A'       //猛犸象
	    set Enemy_Config_Leader[19] = 'n03U'       //引路人
	    //第20种  - 火药军
	    set Enemy_Config_Tips[20] = "这群家伙一碰就火火火起来，好可怕"
	    set Enemy_Config_Boss[20] = 'n03Z'          //疯狂大炮
	    set Enemy_Config_Weak[20] = 'n01F'         //矮人火枪手
	    set Enemy_Config_Strong[20] = 'n01N'       //炮火机车
	    set Enemy_Config_Leader[20] = 'n01Z'       //引路人
	    //第21种  - 白骨军团
	    set Enemy_Config_Tips[21] = "即使化身一身白骨，战士之魂还是复活了"
	    set Enemy_Config_Boss[21] = 'n03Y'          //腐蚀邪鬼
	    set Enemy_Config_Weak[21] = 'n02H'         //枯骨刀
	    set Enemy_Config_Strong[21] = 'n03X'       //幽灵法师
	    set Enemy_Config_Leader[21] = 'n03W'       //引路人


		/* Enemy_Config Last */

		//数据绑定
	    //第1种
	    set Enemy_Config_Last_Tips[1] = "死神：死亡不再是永久，神来了！大挥着镰刀，似乎永远不会死亡"
	    set Enemy_Config_Last_boss[1] = 'n02Q'
	    set Enemy_Config_Last_weak1[1] = 'n02W'     //腐尸
	    set Enemy_Config_Last_weak2[1] = 'n02X'     //幽灵
	    set Enemy_Config_Last_normal1[1] = 'n02Y'     //复仇天神
	    set Enemy_Config_Last_normal2[1] = 'n02Z'     //冰霜骨龙
	    set Enemy_Config_Last_hard1[1] = 'n030'     //冰火鬼
	    set Enemy_Config_Last_hard2[1] = 'n031'     //鬼爆尸
	    //第2种
	    set Enemy_Config_Last_Tips[2] = "锯裂机车：金属的世界，刀光剑影的杀戮！你们准备好了吗！？"
	    set Enemy_Config_Last_boss[2] = 'n02R'
	    set Enemy_Config_Last_weak1[2] = 'n032'     //小锯裂机车
	    set Enemy_Config_Last_weak2[2] = 'n033'     //飞机
	    set Enemy_Config_Last_normal1[2] = 'n034'     //恶鬼机车
	    set Enemy_Config_Last_normal2[2] = 'n034'     //恶鬼机车
	    set Enemy_Config_Last_hard1[2] = 'n035'     //地狱战舰
	    set Enemy_Config_Last_hard2[2] = 'n035'     //地狱战舰
	    //第3种
	    set Enemy_Config_Last_Tips[3] = "DarkElement：黑暗将成为永远！堕入暗世界吧！！被吞灭的精灵们"
	    set Enemy_Config_Last_boss[3] = 'n02S'
	    set Enemy_Config_Last_weak1[3] = 'n011'     //腐泥1
	    set Enemy_Config_Last_weak2[3] = 'n012'     //腐泥2
	    set Enemy_Config_Last_normal1[3] = 'n00Z'     //暗夜女王
	    set Enemy_Config_Last_normal2[3] = 'n010'     //暗夜虚空
	    set Enemy_Config_Last_hard1[3] = 'n00X'    //暗元素（近战）
	    set Enemy_Config_Last_hard2[3] = 'n00Y'    //暗元素（远程）
	    //第4种
	    set Enemy_Config_Last_Tips[4] = "无冕帝王：真正的帝王是不会在意弱兵的死亡，来吧！我自己来干你们！"
	    set Enemy_Config_Last_boss[4] = 'n02T'
	    set Enemy_Config_Last_weak1[4] = 0
	    set Enemy_Config_Last_weak2[4] = 0
	    set Enemy_Config_Last_normal1[4] = 0
	    set Enemy_Config_Last_normal2[4] = 0
	    set Enemy_Config_Last_hard1[4] = 0
	    set Enemy_Config_Last_hard2[4] = 0
	    //第5种
	    set Enemy_Config_Last_Tips[5] = "守卫强暴者：你们还没有见过真正的炮火！来来来！轰爆你们这群渣渣！"
	    set Enemy_Config_Last_boss[5] = 'n02U'
	    set Enemy_Config_Last_weak1[5] = 0
	    set Enemy_Config_Last_weak2[5] = 0
	    set Enemy_Config_Last_normal1[5] = 0
	    set Enemy_Config_Last_normal2[5] = 0
	    set Enemy_Config_Last_hard1[5] = 0
	    set Enemy_Config_Last_hard2[5] = 0

	endfunction


endlibrary

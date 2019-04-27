
#include "scheduleInit.j"

globals

	/* 游戏模式 */
	integer GameModelMaxLv = 0
	timer GameModelTimer = null
	button array GameModelButtons
	string array GameModelTitle

	integer CurrentGameModel = 0
	string CurrentGameTitle = ""
	integer CurrentGameModelMoney = 0
	integer CurrentGameModelLumber = 0
	real CurrentGameModelCycle = 0

	location Loc_C = Location(2048, 2048)
	

endglobals

struct hSchedule

	/* 任务 */
	private static method initMission takes nothing returns nothing
		local integer i = 0
	    local string array tipsTitle
	    local string array tipsConst
	    local string array tipsTitleHelp
	    local string array tipsConstHelp

		set tipsTitle[1] = "地图介绍"
	    set tipsConst[1] = "地图名称：谋掠"
	    set tipsConst[1] = tipsConst[1] + "|n地图类型：TD对战"
	    set tipsConst[1] = tipsConst[1] + "|n语言：中文|n魔兽版本：1.24以上|n作者：hunzsig"
	    set tipsConst[1] = tipsConst[1] + "|n支持人数：1-4"
	    set tipsConst[1] = tipsConst[1] + "|n官方QQ群：325338043"
	    set tipsConst[1] = tipsConst[1] + "|n始创日期：2017年05月"

	    set tipsTitle[2] = "游戏流程"
	    set tipsConst[2] = "胜利目标：摧毁敌方基地或掠夺完黄金"
	    set tipsConst[2] = tipsConst[2] + "|n失败条件：基地被摧毁"
	    set tipsConst[2] = tipsConst[2] + "|n每位玩家拥有一座基地，每个周期发动士兵引领战争，自动攻击你想要攻击的玩家"
	    set tipsConst[2] = tipsConst[2] + "|n当基地被敌人攻击时会被偷取黄金，转移至敌军城堡内！"
	    set tipsConst[2] = tipsConst[2] + "|n您可以在随时随地改变作战目标及发动一些特殊战略/军令，甚至及时改变军队的进攻目标"
	    set tipsConst[2] = tipsConst[2] + "|n(缺少玩家的位置将自动由电脑AI补上)"

	    set tipsTitle[3] = "鸣谢"
	    set tipsConst[3] = "krisky"
	    set tipsConst[3] = tipsConst[3] + ""

	    set i = 1
	    loop
	        exitwhen i > 3
	        	call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED,tipsTitle[i],tipsConst[i],"ReplaceableTextures\\CommandButtons\\BTNScrollUber.blp")
	        set i = i + 1
	    endloop

	    set tipsTitleHelp[1] = "进阶：如何选定攻击对象（目标）"
	    set tipsConstHelp[1] = "双击对方的基地，可以将他设为目标，士兵也将对其发动攻击"
	    set tipsConstHelp[1] = tipsConstHelp[1] + "|n*出征后的士兵并不会响应军令，除非目标已被歼灭"

		set tipsTitleHelp[2] = "进阶：如何取消已经派遣的士兵"
	    set tipsConstHelp[2] = "双击基地旁边的士兵模型，即可减少士兵"
	    set tipsConstHelp[2] = tipsConstHelp[2] + "*取消的部队会返回一半的金额，并释放人口"
	    set tipsConstHelp[2] = tipsConstHelp[2] + "*升级会依旧保留"

		set tipsTitleHelp[3] = "进阶：如何巧用英雄"
	    set tipsConstHelp[3] = "英雄可以在战场上随意走动"
	    set tipsConstHelp[3] = tipsConstHelp[3] + "|n英雄死亡后会在20秒后在自己阵营重生"
	    set tipsConstHelp[3] = tipsConstHelp[3] + "|n使用英雄直接攻击对方基地时，会有金币小偷偷取金币(每回英雄等级x5)"
	    set tipsConstHelp[3] = tipsConstHelp[3] + "|n金币小偷隐身移动缓慢，到达自己基地时金币才入库，如果中途被击杀，金币会掉落在战场上，谁捡谁得"
	    set tipsConstHelp[3] = tipsConstHelp[3] + "|n(*注意英雄死亡后敌方会获得较多的黄金与经验)"

	    set tipsTitleHelp[4] = "进阶：增加士兵数"
	    set tipsConstHelp[4] = "在基地购买相应的道具，可以增加最大士兵数"

	    set tipsTitleHelp[5] = "进阶：疑难解答"
	    set tipsConstHelp[5] = "问：当我的士兵和英雄被击杀时，会不会失去黄金？"
	    set tipsConstHelp[5] = tipsConstHelp[5] + "|n答：不会，而且士兵击杀敌方士兵和英雄时会获得黄金和战略点"
	    set tipsConstHelp[5] = tipsConstHelp[5] + "|n问：我可以把防御塔建在敌方阵营附近吗？"
	    set tipsConstHelp[5] = tipsConstHelp[5] + "|n答：完全可以，战场都是共有的资源"
	    set tipsConstHelp[5] = tipsConstHelp[5] + "|n问：我可以无限造兵吗？"
	    set tipsConstHelp[5] = tipsConstHelp[5] + "|n答：可以，每个军营限定最大10个单位，你可以在基地增员，也可以双击部队指示单位来减少特定的兵种"

	    set i = 1
	    loop
	        exitwhen i > 5
	        	call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED,tipsTitleHelp[i],tipsConstHelp[i],"ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp")
	        set i = i + 1
	    endloop

	    call FlashQuestDialogButton()
	endmethod

	/* 电影 */
	private static method initMoive takes nothing returns nothing
		local string array tips
	    local integer i
	    local unit moive_Speaker = null
	    local MediaDialogue dia = MediaDialogue.create()

		//播放剧情
	    call CinematicModeBJ( true, GetPlayersAll() )
	    call ForceCinematicSubtitles( true )
	    call PanCameraToTimed( GetLocationX(Loc_C), GetLocationY(Loc_C) , 0 )
	    call CameraSetupApplyForceDuration( gg_cam_init, true, 5.00 )

		set dia[1] = "有四座敌对基地！你是其中一位城主！拥有的黄金就是你的战力！打败其他人的基地，成为王者吧！"
		set dia[2] = "双击其他人的基地可以将他设为目标|n|n干掉不顺眼的家伙！"
		set dia[3] = "只要有钱，你可以无限提升士兵水平，建立强大的塔，关键的战略,得到更强的战力和守卫力"
		set dia[4] = "战争开始！！！！！"
		set moive_Speaker = hunit.createUnitFacing( Player(PLAYER_NEUTRAL_PASSIVE) , 'n00O' , Loc_C, 270)

		call hmedia.moive2force( GetPlayersAll() , moive_Speaker , dia )
	    call CinematicModeBJ( false, GetPlayersAll() )
	    call ResetToGameCamera( 1.00 )
	    call hunit.del(moive_Speaker,0)

	    set i = 1
	    loop
	        exitwhen i > player_max_qty
	        	call PanCameraToTimedLocForPlayer( players[i] , GetPlayerStartLocationLoc( players[i] ), 0.50 )
	        set i = i + 1
	    endloop
	    call PolledWait(0.60)
	endmethod
	
	private static method mySchedule takes nothing returns nothing
		local m1AbstractSchedule m1 = m1AbstractSchedule.create()

		call StartSound(gg_snd_audio_huanyingbiaoyan)
		
		/* 开启电影 */
		if(CurrentGameModel==1)then
			call initMoive()
		endif

    	/* 开启任务 */
		call initMission()

		/* 开启进度 */
		call m1.run()
	endmethod

	/* Model */
	private static method selectGameModel takes integer model returns nothing
		local integer i = 0
		local integer array GameModelMoneys
		local integer array GameModelLumbers
		local real array GameModelCycles

	    set GameModelMoneys[1] = 1000
	    set GameModelMoneys[2] = 300

	    set GameModelLumbers[1] = 5
	    set GameModelLumbers[2] = 1

	    set GameModelCycles[1] = 25
	    set GameModelCycles[2] = 25

		set CurrentGameModel = model
		set CurrentGameTitle = GameModelTitle[CurrentGameModel]
		set CurrentGameModelMoney = GameModelMoneys[CurrentGameModel]
		set CurrentGameModelCycle = GameModelCycles[CurrentGameModel]
		//特殊变动
		if(CurrentGameModel==1)then
			set HERO_GET_GOLD_FROM_CITY = 30
			set DEFAULT_CENTER_GOLD_DURING = 45
			set DEFAULT_UNGRADE_DURING = 150
		elseif(CurrentGameModel==2)then
			set HERO_GET_GOLD_FROM_CITY = 75
			set DEFAULT_CENTER_GOLD_DURING = 15
			set DEFAULT_UNGRADE_DURING = 300
		endif
		//提示开始
        call hmsg.echo("|cffffff00" + CurrentGameTitle + "|r")
        //删除对话框
        call htime.delTimer( GameModelTimer )
        //初始资源
        set i = 1
        loop
            exitwhen i > player_max_qty
        		call hplayer.setStatus(players[i],"谋掠中")
	            if (his.computer(players[i]) == false) then
	            	call hplayer.addGold(players[i],GameModelMoneys[CurrentGameModel])
	            	call hplayer.addLumber(players[i],GameModelLumbers[CurrentGameModel])
	            else
	            	call hplayer.addGold(players[i],GameModelMoneys[CurrentGameModel]*3)
	            	call hplayer.addLumber(players[i],GameModelLumbers[CurrentGameModel]*3)
	            endif
            set i = i + 1
        endloop
		call mySchedule()
	endmethod

	private static method TriggerGameModelActions takes nothing returns nothing
	    local integer i = 1
	    loop
	        exitwhen i > GameModelMaxLv
	        if (GetClickedButtonBJ() == GameModelButtons[i]) then
		        call selectGameModel(i)
	            call DoNothing() YDNL exitwhen true//(  )
	        endif
	        set i = i + 1
	    endloop
	endmethod

	private static method scheduleAbortLose takes nothing returns nothing
        local integer i = 0
        set i = 1
        loop
            exitwhen i > player_max_qty
            	call hplayer.defeat(players[i])
            set i = i + 1
        endloop
    endmethod
	public static method scheduleAbort takes nothing returns nothing
        call CinematicModeBJ( true,  GetPlayersAll() )
        call ForceCinematicSubtitles( true )
        call TransmissionFromUnitWithNameBJ(  GetPlayersAll() , null, "游戏终止" , null, "没有选择模式，游戏已结束！" , bj_TIMETYPE_SET, 5.00, false )
        call htime.setTimeout(3.00,function thistype.scheduleAbortLose)
    endmethod

	public static method run takes nothing returns nothing
		local integer i
		local trigger triggerGameModel = CreateTrigger()
		local dialog dialogGameModel = DialogCreate()

		//游戏模式
		set GameModelMaxLv = 2
		set GameModelTitle[1] = " - 疯狂激战 - "
		set GameModelTitle[2] = " - 抢金谋战 - "

		if( GameModelMaxLv == 1 )then	//如果只有一种模式，立刻开始
        	call selectGameModel(1)
	    elseif( GameModelMaxLv > 1 )then	//如果多种模式，选择模式
	    	call hmsg.echo(" |cffffff00正在选择游戏模式...|r")
	    	call DialogSetMessage( dialogGameModel , "游戏模式" )
		    call TriggerRegisterDialogEvent( triggerGameModel, dialogGameModel )
		    call TriggerAddAction(triggerGameModel, function thistype.TriggerGameModelActions)
	        //游戏模式
	    	set i = 1
		    loop
		        exitwhen i > GameModelMaxLv
		        call DialogAddButtonBJ( dialogGameModel , GameModelTitle[i] )
		        set GameModelButtons[i] = GetLastCreatedButtonBJ()
		        set i = i + 1
		    endloop
		    set i = 1
		    loop
		        exitwhen i > player_max_qty
		        if(his.computer(players[i]) == false) then
		            call DialogDisplayBJ( true, dialogGameModel , players[i] )
		            call DoNothing() YDNL exitwhen true//(  )
		        else
		        endif
		        set i = i + 1
		    endloop
		    set GameModelTimer = htime.setTimeout( 20.00, function thistype.scheduleAbort )
		    call htime.setDialog( GameModelTimer , "正在选择游戏模式" )
	    endif

	endmethod

endstruct

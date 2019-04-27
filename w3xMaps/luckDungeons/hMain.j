
//载入 hJass
#include "../hJass/hJass.j"
#include "global.j"
#include "set.j"
#include "schedule.j"

//载入 房间音乐
function hBgm takes string s returns nothing
	local string uri = "main.mp3"	//这个路径你可以播放默认的音乐（在F5）也可以播放F12导入的音乐
	call SetMapDescription(s)
	call PlayMusic(uri)
endfunction
#define SetMapDescription(s) hBgm(s)

library Main initializer init needs hJass

	//预读
	private function preread takes nothing returns nothing
	    local integer i = 0
	    local integer total = 0
	    local unit array prereadUnits
	    set i = g_token_count
	    loop
	        exitwhen i<=0
				set total = total+1
	            set prereadUnits[total] = CreateUnitAtLoc(player_passive, g_token[i], Loc_C, bj_UNIT_FACING)
	            call hattr.regAllAttrSkill(prereadUnits[total])
	        set i = i-1
	    endloop
		set i = g_hero_count
	    loop
	        exitwhen i<=0
				set total = total+1
	            set prereadUnits[total] = CreateUnitAtLoc(player_passive, g_hero[i], Loc_C, bj_UNIT_FACING)
	            call hattr.regAllAttrSkill(prereadUnits[total])
	        set i = i-1
	    endloop
		set i = g_boss_count
	    loop
	        exitwhen i<=0
				set total = total+1
	            set prereadUnits[total] = CreateUnitAtLoc(player_passive, g_boss[i], Loc_C, bj_UNIT_FACING)
				call hunit.setAttackSpeedBaseSpace(g_boss[i],2.00)
	            call hattr.regAllAttrSkill(prereadUnits[total])
	        set i = i-1
	    endloop
		set i = g_mon_yequ_count
	    loop
	        exitwhen i<=0
				set total = total+1
	            set prereadUnits[total] = CreateUnitAtLoc(player_passive, g_mon_yequ[i], Loc_C, bj_UNIT_FACING)
				call hunit.setAttackSpeedBaseSpace(g_mon_yequ[i],2.50)
	            call hattr.regAllAttrSkill(prereadUnits[total])
	        set i = i-1
	    endloop
		set i = g_mon_shanjian_count
	    loop
	        exitwhen i<=0
				set total = total+1
	            set prereadUnits[total] = CreateUnitAtLoc(player_passive, g_mon_shanjian[i], Loc_C, bj_UNIT_FACING)
				call hunit.setAttackSpeedBaseSpace(g_mon_shanjian[i],2.00)
	            call hattr.regAllAttrSkill(prereadUnits[total])
	        set i = i-1
	    endloop
		set i = g_mon_lianyu_count
	    loop
	        exitwhen i<=0
				set total = total+1
	            set prereadUnits[total] = CreateUnitAtLoc(player_passive, g_mon_lianyu[i], Loc_C, bj_UNIT_FACING)
				call hunit.setAttackSpeedBaseSpace(g_mon_lianyu[i],2.00)
	            call hattr.regAllAttrSkill(prereadUnits[total])
	        set i = i-1
	    endloop
		set i = g_mon_guqu_count
	    loop
	        exitwhen i<=0
				set total = total+1
	            set prereadUnits[total] = CreateUnitAtLoc(player_passive, g_mon_guqu[i], Loc_C, bj_UNIT_FACING)
				call hunit.setAttackSpeedBaseSpace(g_mon_guqu[i],2.00)
	            call hattr.regAllAttrSkill(prereadUnits[total])
	        set i = i-1
	    endloop
		set i = g_mon_chengqu_count
	    loop
	        exitwhen i<=0
				set total = total+1
	            set prereadUnits[total] = CreateUnitAtLoc(player_passive, g_mon_chengqu[i], Loc_C, bj_UNIT_FACING)
				call hunit.setAttackSpeedBaseSpace(g_mon_chengqu[i],2.00)
	            call hattr.regAllAttrSkill(prereadUnits[total])
	        set i = i-1
	    endloop
		set i = g_mon_bingyuan_count
	    loop
	        exitwhen i<=0
				set total = total+1
	            set prereadUnits[total] = CreateUnitAtLoc(player_passive, g_mon_bingyuan[i], Loc_C, bj_UNIT_FACING)
				call hunit.setAttackSpeedBaseSpace(g_mon_bingyuan[i],2.00)
	            call hattr.regAllAttrSkill(prereadUnits[total])
	        set i = i-1
	    endloop
	    call PolledWait(0.01)
	    set i = total
	    loop
	        exitwhen i<=0
	            call RemoveUnit(prereadUnits[i])
	        set i = i-1
	    endloop
	endfunction

	//游戏开始0秒
	private function start takes nothing returns nothing
	
		local hSchedule hschedule = hSchedule.create()
		call hschedule.run()

	endfunction

	private function init takes nothing returns nothing
		local trigger startTrigger = null
		local hGlobals hg
		//globals
		set hg = hGlobals.create()
		call hg.do()
		//预读
		call preread()
		//镜头模式
		call hcamera.setModel("zoomin")
		//属性 - 硬直条
		call hattrUnit.punishTtgIsOpen(false)
		//资源共享范围
		call haward.setRange(10000)
		//开启日志
		call hconsole.open(true)
		//开始触发
		set startTrigger = CreateTrigger()
	    call TriggerRegisterTimerEventSingle( startTrigger, 0.01 )
	    call TriggerAddAction(startTrigger, function start)

    endfunction

endlibrary
//最后一行必须留空请勿修改

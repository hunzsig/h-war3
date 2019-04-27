
//载入 hJass
#include "attributeIds.j"
#include "../hJass/hJass.j"
#include "schedule.j"

//载入 房间音乐
function hBgm takes string s returns nothing
	local string uri = "Sound\\Music\\mp3Music\\PursuitTheme.mp3"	//这个路径你可以播放默认的音乐（在F5）也可以播放F12导入的音乐
	call SetMapDescription(s)
	call PlayMusic(uri)
endfunction
#define SetMapDescription(s) hBgm(s)

library Main initializer init needs hJass

	//预读
	private function preread takes nothing returns nothing
	    local integer i = 0
	    local integer total = 73
	    local integer array prereads
	    local unit array prereadUnits

	    //英雄
	    set prereads[1] = 'H009'
	    set prereads[2] = 'H00M'
	    set prereads[3] = 'H008'
	    set prereads[4] = 'H00A'
	    //小偷
	    set prereads[5] = 'o008'
	    set prereads[6] = 'o003'
	    set prereads[7] = 'o007'
	    set prereads[8] = 'o009'
	    //建筑
	    set prereads[9] = 'e007'
	    set prereads[10] = 'e004'
	    set prereads[11] = 'e009'
	    set prereads[12] = 'e001'
	    set prereads[13] = 'e000'
	    set prereads[14] = 'e005'
	    set prereads[15] = 'e008'
	    set prereads[16] = 'e002'
	    set prereads[17] = 'e006'
	    set prereads[18] = 'e00B'
	    set prereads[19] = 'e00A'
	    set prereads[20] = 'e003'
	    //箭矢
	    set prereads[21] = 'o000'
	    set prereads[22] = 'o002'
	    set prereads[23] = 'o005'
	    set prereads[24] = 'o006'
	    //士兵
	    set prereads[25] = 'n01H'
	    set prereads[26] = 'n01C'
	    set prereads[27] = 'n01B'
	    set prereads[28] = 'n018'
	    set prereads[29] = 'n01E'
	    set prereads[30] = 'n01A'
	    set prereads[31] = 'n019'
	    set prereads[32] = 'n01G'
	    set prereads[33] = 'n01I'
	    set prereads[34] = 'n017'
	    set prereads[35] = 'n01D'
	    set prereads[36] = 'n01F'
	    set prereads[37] = 'n00G'
	    set prereads[38] = 'n003'
	    set prereads[39] = 'n00E'
	    set prereads[40] = 'n005'
	    set prereads[41] = 'n00A'
	    set prereads[42] = 'n008'
	    set prereads[43] = 'n00C'
	    set prereads[44] = 'n00H'
	    set prereads[45] = 'n00D'
	    set prereads[46] = 'n002'
	    set prereads[47] = 'n001'
	    set prereads[48] = 'n00I'
	    set prereads[49] = 'n004'
	    set prereads[50] = 'n00K'
	    set prereads[51] = 'n00L'
	    set prereads[52] = 'n00R'
	    set prereads[53] = 'n00M'
	    set prereads[54] = 'n00N'
	    set prereads[55] = 'n00U'
	    set prereads[56] = 'n00Q'
	    set prereads[57] = 'n009'
	    set prereads[58] = 'n00S'
	    set prereads[59] = 'n00P'
	    set prereads[60] = 'n00T'
	    set prereads[61] = 'n00Y'
	    set prereads[62] = 'n015'
	    set prereads[63] = 'n014'
	    set prereads[64] = 'n00X'
	    set prereads[65] = 'n00W'
	    set prereads[66] = 'n012'
	    set prereads[67] = 'n013'
	    set prereads[68] = 'n010'
	    set prereads[69] = 'n011'
	    set prereads[70] = 'n016'
	    set prereads[71] = 'n007'
	    set prereads[72] = 'n00Z'
	    //
	    set prereads[73] = 'o00A'
	    
	    set i = 1
	    loop
	        exitwhen i>total
	            set prereadUnits[i] = CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), prereads[i], GetRectCenter(GetPlayableMapRect()), bj_UNIT_FACING)
	            call hattr.regAllAttrSkill(prereadUnits[i])
	        set i = i+1
	    endloop
	    call PolledWait(0.00)
	    set i = 1
	    loop
	        exitwhen i>total
	            call RemoveUnit(prereadUnits[i])
	        set i = i+1
	    endloop
	endfunction

	//游戏开始0秒
	private function start takes nothing returns nothing
	
		local hSchedule hschedule = hSchedule.create()
		call hschedule.run()

	endfunction

	private function init takes nothing returns nothing
		local trigger startTrigger = null
		set player_max_qty = 4
		//预读
		call preread()
		//镜头模式
		call hcamera.setModel("normal")
		//属性 - 硬直条
		call hattrUnit.punishTtgIsOpen(false)
		//资源共享范围
		call haward.setRange(10000)
		//迷雾
		call FogEnable( false )
		//阴影
		call FogMaskEnable( false )
		//开启日志
		call hconsole.open(false)
		//开始触发
		set startTrigger = CreateTrigger()
	    call TriggerRegisterTimerEventSingle( startTrigger, 0.01 )
	    call TriggerAddAction(startTrigger, function start)
    endfunction

endlibrary
//最后一行必须留空请勿修改

library abstractSchedule requires characterGroup

	private function bgmCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
		call PlayMusic(funcs_getTimerParams_String(t,1))
		call funcs_delTimer(t,null)
	endfunction

	//播放音乐，如果背景音乐无法循环播放，尝试格式工厂转wav再转回mp3
    public function bgm takes string musicFileName returns nothing
        local timer t = null
        if(musicFileName!=null and musicFileName!="")then
            call StopMusic( true )
            set t = funcs_setTimeout(3.00,function bgmCall)
            call funcs_setTimerParams_String(t,1,musicFileName)
        endif
    endfunction

endlibrary

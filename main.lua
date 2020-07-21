-- カウントタイマースクリプト
-- author: minfia
-- ver. 1.2.1

--track0:サイズ,0,2000,200
--track1:ライン幅,0,2000,30
--track2:文字サイズ,0,1000,50
--dialog:フォント,local font="MS UI Gothic";小数桁数,local digit=2;文字の色/col,local char_color=0xffffff;リングの色/col,local ring_color=0xffffff;カウントダウン/chk,local count_down=0;反時計回り/chk,local ccw=0;文字表示/chk,local visible_char=1;リング表示/chk,local visible_ring=1;
--check0:時分秒表記,0

local total_time = obj.totaltime
local now_time = obj.time
local l = math.floor(obj.track0/2)
local time
local time_str
local r


if (count_down == 0) then
	-- カウントアップ
	time = now_time
	r = (180 - (now_time * (180 / total_time)))
else
	-- カウントダウン
	time = total_time - now_time
	r = (now_time * (180 / total_time))
end


if (not obj.check0) then
	-- 秒表記
	if (digit == 0) then
		time_str = string.format("%d", time)
	elseif (digit == 1) then
		time_str = string.format("%.1f", time)
	elseif (digit == 2) then
		time_str = string.format("%.2f", time)
	elseif (digit == 3) then
		time_str = string.format("%.3f", time)
	elseif (digit == 4) then
		time_str = string.format("%.4f", time)
	elseif (digit == 5) then
		time_str = string.format("%.5f", time)
	else
		time_str = string.format("%.6f", time)
	end
else
	-- 時分秒表記
	time_str = string.format("%02d:%02d:%02d", (time/3600), ((time%3600)/60), (time %60))
end

obj.setoption("drawtarget", "tempbuffer", obj.track0, obj.track0)

-- リング生成
if (visible_ring == 1) then
	obj.load("figure", "円", ring_color, l * 2, obj.track1)
	obj.effect("斜めクリッピング", "角度", r)
	obj.effect("ミラー", "境目調整", -l)

	local rz
	if (ccw == count_down) then
		-- 時計回り
		rz = (90 + r * -100 / 100)
	else
		-- 反時計回り
		rz = (90 + r * 100 / 100)
	end
	obj.draw(0, 0, 0, 1, 1, 0, 0, rz)
end

-- 文字生成
if (visible_char == 1) then
	obj.setfont(font, obj.track2, 0, char_color)
	obj.load("text", time_str)
	obj.draw()
end

obj.load("tempbuffer")


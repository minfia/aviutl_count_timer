-- カウントタイマースクリプト
-- author: minfia
-- ver. 2.0.0

--track0:サイズ,0,2000,200
--track1:ライン幅,0,2000,30
--track2:文字サイズ,0,1000,50
--dialog:font,local font="MS UI Gothic";小数桁数,local digit=2;文字の色/col,local char_color=0xffffff;色分割の割合,local rate={60,30};リングの色(開始)/col,local ring_color_start=0xffffff;リングの色(中間)/col,local ring_color_middle=0xffffff;リングの色(終了)/col,local ring_color_end=0xffffff;カウントダウン/chk,local count_down=0;反時計回り/chk,local ccw=0;単位表示,local visible_unit=0;漢字表記/chk,local to_kanji=0;
--check0:時分秒表記,0


-- 数字を大字の漢数字に変換
-- @param num 0 to 99
-- @return 変換された文字列(paramの範囲を超えた場合は、"無限"が入る)
local function convert_num_to_kanji(num)
  local ONES_PLACE_TABLE = {"零", "壱", "弐", "参", "肆", "伍", "陸","漆", "捌", "玖"}
  local TENS_PLACE = "拾"

  if (99 < num) then
    return "無限"
  end


  local ones_place = ONES_PLACE_TABLE[tonumber(string.format("%d",(num % 10) + 1))]
  local tens_place

  if (num < 10) then
    tens_place = "　　"
  else
    if ((num % 10) < 1) then
      ones_place = "　"
      tens_num = "　　"
    end

    local tens_num
    if (num < 20) then
      tens_num = "　"
    else
      tens_num = ONES_PLACE_TABLE[tonumber(string.format("%d", (num / 10) + 1))]
    end
    tens_place = tens_num .. TENS_PLACE
  end

  return (tens_place .. ones_place)
end


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

local hour = (time / 3600)
local minites = ((time % 3600) / 60)
local second = (time % 60)

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
  local h_unit
  local m_unit
  local s_unit
  if (visible_unit == 1) then
    h_unit = "時"
    m_unit = "分"
    s_unit = "秒"
  elseif (visible_unit == 2) then
    h_unit = "h"
    m_unit = "m"
    s_unit = "s"
  elseif (visible_unit == 3) then
    h_unit = "°"
    m_unit = "′"
    s_unit = "\""
  else
    h_unit = ":"
    m_unit = ":"
    s_unit = ""
  end
    if (to_kanji == 0) then
      time_str = string.format("%02d%s%02d%s%02d%s", hour, h_unit, minites, m_unit, second, s_unit)
    else
      time_str = string.format("%s %s %s", convert_num_to_kanji(hour), convert_num_to_kanji(minites), convert_num_to_kanji(second))
    end
end

local ring_color
local time_rate = 100 - ((now_time / total_time) * 100)
if (time_rate < rate[2]) then
  ring_color = ring_color_end
elseif (time_rate < rate[1]) then
  ring_color = ring_color_middle
else
  ring_color = ring_color_start
end

obj.setoption("drawtarget", "tempbuffer", obj.track0, obj.track0)

-- リング生成
local ring_size = obj.track1
if (0.0 < ring_size) then
  obj.load("figure", "円", ring_color, l * 2, ring_size)
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
local font_size = obj.track2
if (0.0 < font_size) then
  obj.setfont(font, font_size, 0, char_color)
  obj.load("text", time_str)
  obj.draw()
end

obj.load("tempbuffer")


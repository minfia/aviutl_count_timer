-- �J�E���g�^�C�}�[�X�N���v�g
-- author: minfia
-- ver. 1.2.1

--track0:�T�C�Y,0,2000,200
--track1:���C����,0,2000,30
--track2:�����T�C�Y,0,1000,50
--dialog:�t�H���g,local font="MS UI Gothic";��������,local digit=2;�����̐F/col,local char_color=0xffffff;�����O�̐F/col,local ring_color=0xffffff;�J�E���g�_�E��/chk,local count_down=0;�����v���/chk,local ccw=0;�����\��/chk,local visible_char=1;�����O�\��/chk,local visible_ring=1;
--check0:�����b�\�L,0

local total_time = obj.totaltime
local now_time = obj.time
local l = math.floor(obj.track0/2)
local time
local time_str
local r


if (count_down == 0) then
	-- �J�E���g�A�b�v
	time = now_time
	r = (180 - (now_time * (180 / total_time)))
else
	-- �J�E���g�_�E��
	time = total_time - now_time
	r = (now_time * (180 / total_time))
end


if (not obj.check0) then
	-- �b�\�L
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
	-- �����b�\�L
	time_str = string.format("%02d:%02d:%02d", (time/3600), ((time%3600)/60), (time %60))
end

obj.setoption("drawtarget", "tempbuffer", obj.track0, obj.track0)

-- �����O����
if (visible_ring == 1) then
	obj.load("figure", "�~", ring_color, l * 2, obj.track1)
	obj.effect("�΂߃N���b�s���O", "�p�x", r)
	obj.effect("�~���[", "���ڒ���", -l)

	local rz
	if (ccw == count_down) then
		-- ���v���
		rz = (90 + r * -100 / 100)
	else
		-- �����v���
		rz = (90 + r * 100 / 100)
	end
	obj.draw(0, 0, 0, 1, 1, 0, 0, rz)
end

-- ��������
if (visible_char == 1) then
	obj.setfont(font, obj.track2, 0, char_color)
	obj.load("text", time_str)
	obj.draw()
end

obj.load("tempbuffer")


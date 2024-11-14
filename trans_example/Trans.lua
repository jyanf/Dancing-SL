local Trans={}
function Trans.reMap(val, rangeS, rangeD)--线性映射
	if(rangeS[1]>=rangeS[2]) then return nil end
	if(val<=rangeS[1]) then return rangeD[1] end
	if(val>=rangeS[2]) then return rangeD[2] end
	return (rangeD[2]-rangeD[1])*(val-rangeS[1])/(rangeS[2]-rangeS[1]) + rangeD[1]
end

function Trans.getPos(sprite, anchor)--获取贴图在窗口中的直角坐标&极坐标（已抵消缩放、旋转的影响）
	if(not sprite) then return nil end
	anchor=anchor or {0,0}
	local xf, yf= -(sprite.position.x-anchor[1])*sprite.scale.x,
					-(sprite.position.y-anchor[2])*sprite.scale.y
	local theta= math.atan(yf, xf) + math.rad(sprite.rotation)
	local p=math.sqrt(xf^2+yf^2)
	xf, yf=p*math.cos(theta), p*math.sin(theta)
	return xf, yf, theta, p
end

function Trans.rePos(sprite, destiny, anchor)--移动到窗口中的目标位置（已抵消缩放、旋转的影响）
	if(not sprite) then return end
	anchor=anchor or {0,0}
	local xf, yf= destiny[1], destiny[2]
	local t= (destiny[3] or math.atan(yf, xf)) - math.rad(sprite.rotation)
	if t~=0 then
		local p= destiny[4] or math.sqrt(xf^2+yf^2)
		xf, yf=p*math.cos(t), p*math.sin(t)
	end
	sprite.position.x=-xf/sprite.scale.x + anchor[1]
	sprite.position.y=-yf/sprite.scale.y + anchor[2]
end

function Trans.Scale(sprite, scale, anchor)--缩放到指定倍数（自动重定位）
	if(not sprite) then return end
	anchor=anchor or {0,0}
	local destiny = table.pack(Trans.getPos(sprite, anchor))
	--error("不支持缩放到0倍，请换成趋近于0的小数.")
	if(scale[1]==0) then scale[1]=0.01 end
	if(scale[2]==0) then scale[2]=0.01 end
	sprite.scale.x, sprite.scale.y= scale[1], scale[2]
	Trans.rePos(sprite, destiny, anchor)
	return table.unpack(destiny)
end

function Trans.Rotate(sprite, angle, anchor)--旋转到指定角度（自动重定位）
	if(not sprite) then return end
	anchor=anchor or {0,0}
	local destiny = table.pack(Trans.getPos(sprite, anchor))
	sprite.rotation=angle
	Trans.rePos(sprite, destiny, anchor)
	return table.unpack(destiny)
end

return Trans

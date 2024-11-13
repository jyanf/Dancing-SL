local Tr= dofile("trans_example/Trans.lua")
soku.SubscribeSceneChange(
	function(newsceneId, scene)
		local data = scene.data
		data["counter"]=0
		local p= resource.createfromfile("trans_example/icon.png")
		data["anchor"]= {p.width/2, p.height/2}
		data["ind"]= scene.renderer:createSprite("trans_example/icon.png")
		data["ind2"]= scene.renderer:createSprite("trans_example/icon2.png")
		Tr.rePos(data["ind"], {320, 240}, data["anchor"])
		return function(s)
			local dat = s.data
			local ind = dat["ind"]
			local ind2 = dat["ind2"]
			local counter = dat["counter"]
			local anchor = dat["anchor"]
			Tr.Scale(ind, {0.1*math.cos(counter/10)+1, 0.1*math.sin(counter/10)+1}, anchor)
			Tr.Rotate(ind, 10*math.sin(counter/60), anchor)
			Tr.rePos(ind, {320+60*math.cos(counter/30), 240+60*math.sin(counter/30)}, anchor)
			Tr.Scale(ind2, {0.1*math.sin(counter/10)+1, 0.1*math.cos(counter/10)+1}, anchor)
			Tr.Rotate(ind2, -10*math.sin(counter/60), anchor)
			Tr.rePos(ind2, {320-60*math.cos(counter/30), 240-60*math.sin(counter/30)}, anchor)
			--ind.layer = math.sin(counter/60)>0 and 1 or -1
			--ind2.layer = -ind.layer
			dat["counter"] = counter + 1
		end
	end
)
local cb = {
	static = "conveyor_belt_belt_1.png",
	anim_top = {name="conveyor_belt_belt_anim_back.png", animation={type="vertical_frames", aspect_w = 16, aspect_h=16, length=1}},
	anim_front = {name="conveyor_belt_belt_anim_front.png", animation={type="vertical_frames", aspect_w = 16, aspect_h=16, length=1}},
	anim_bottom = {name="conveyor_belt_belt_anim_back.png", animation={type="vertical_frames", aspect_w = 16, aspect_h=16, length=1}},
	anim_back = {name="conveyor_belt_belt_anim_back.png", animation={type="vertical_frames", aspect_w = 16, aspect_h=16, length=1}},
	side = "conveyor_belt_side.png",

	interval = 0.01,
	speed = 0.25,
}

minetest.register_node("conveyor_belt:coveyor_belt_on",{
	description = "Conveyor Belt (on)",
	groups = { oddly_breakable_by_hand=1 },
	drawtype = "normal",
	tiles = { cb.anim_top, cb.anim_bottom, cb.side, cb.side, cb.anim_front, cb.anim_back },
	paramtype2 = "facedir",

	-- TODO: sounds = ...,
	on_timer = function(pos, elapsed)
		local facedir = minetest.get_node(pos).param2
		local objects = minetest.get_objects_inside_radius({x=pos.x, y=pos.y+1, z=pos.z}, 1)
		for i=1,#objects do
			local v = objects[i]:getvelocity()
			if v then
				if(facedir == 0) then		-- z+
					if v.z < cb.speed then v.z = cb.speed end
				elseif(facedir == 2) then	-- z-
					if v.z > -cb.speed then v.z = -cb.speed end
				elseif(facedir == 1) then	-- x+
					if v.x < cb.speed then v.x = cb.speed end
				elseif(facedir == 3) then	-- x-
					if v.x > -cb.speed then v.x = -cb.speed end
				else
					print(tostring(facedir))
				end
				objects[i]:setvelocity(v)
			end
		end
		minetest.get_node_timer(pos):set(cb.interval, elapsed)
	end,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(cb.interval)
	end,
})

minetest.register_node("conveyor_belt:coveyor_belt_off",{
	description = "Conveyor Belt",
	groups = { oddly_breakable_by_hand=1 },
	drawtype = "normal",
	tiles = { cb.static, cb.static, cb.static, cb.static, cb.side, cb.side },
	paramtype2 = "facedir",

	-- TODO: sounds = ...,

})

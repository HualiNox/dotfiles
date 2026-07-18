local monitor_profiles = {
	{
		output = "desc:Xiaomi Corporation Mi Monitor",
		mode = "3840x2160@160.01Hz",
		-- mode = "1920x1080@319.98",
		position = "0x0",
		scale = 1.5,
		-- scale = 1,
	},
}

for _, profile in ipairs(monitor_profiles) do
	hl.monitor(profile)
end

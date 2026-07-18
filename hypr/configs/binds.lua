require("configs.helper")

local terminal = "ghostty"
local fileManager = "nautilus"
local launcher = "fuzzel"

local mainMod = "SUPER"

local function bind(keys, action, opts)
	if type(keys) ~= "table" then
		error("keys must be a table")
	end

	local key = mainMod .. " + " .. table.concat(keys, " + ")

	hl.bind(key, action, opts)
end

bind({ "T" }, hl.dsp.exec_cmd("uwsm app -- " .. terminal), { description = "打开终端" })
bind({ "Return" }, hl.dsp.exec_cmd("uwsm app -- " .. terminal))

bind({ "Q" }, hl.dsp.window.close(), { description = "关闭窗口" })

bind({ "E" }, hl.dsp.exec_cmd("uwsm app -- " .. fileManager), { description = "打开文件管理器" })

bind({ "SPACE" }, hl.dsp.exec_cmd("uwsm app -- " .. launcher), { description = "打开启动器" })

bind({ "V" }, hl.dsp.window.float({ action = "toggle" }), { description = "切换窗口浮动状态" })

bind({ "F" }, hl.dsp.window.fullscreen(), { description = "全屏" })

bind({ "L" }, hl.dsp.exec_cmd("hyprlock"), { description = "锁屏" })

bind({ "SHIFT", "M" }, hl.dsp.exit(), { description = "关闭hyprland" })

bind({ "left" }, hl.dsp.focus({ direction = "left" }))
bind({ "right" }, hl.dsp.focus({ direction = "right" }))
bind({ "up" }, hl.dsp.focus({ direction = "up" }))
bind({ "down" }, hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
	local key = i % 10
	bind({ tostring(key) }, hl.dsp.focus({ workspace = i }), { description = "切换工作间" })
	bind({ "SHIFT", tostring(key) }, hl.dsp.window.move({ workspace = i }), { description = "移动窗口到指定工作间" })
end

bind({ "S" }, hl.dsp.workspace.toggle_special("scratch"), { description = "呼出/隐藏特殊工作区" })
bind({ "SHIFT", "S" }, function()
	if hl.get_active_special_workspace() then
		-- 当前正在特殊工作区中：移回普通工作区
		local workspace = hl.get_active_workspace()

		if workspace then
			hl.dispatch(hl.dsp.window.move({
				workspace = workspace,
			}))
		end
	else
		-- 当前在普通工作区：移入特殊工作区
		hl.dispatch(hl.dsp.window.move({
			workspace = "special:magic",
			follow = false,
		}))
	end
end, { description = "将当前窗口移入/移出特殊工作区" })


bind({ "mouse_down" }, hl.dsp.focus({ workspace = "e+1" }))
bind({ "mouse_up" }, hl.dsp.focus({ workspace = "e-1" }))

bind({ "mouse:272" }, hl.dsp.window.drag(), { mouse = true })
bind({ "mouse:273" }, hl.dsp.window.resize(), { mouse = true })

bind(
	{ "XF86AudioRaiseVolume" },
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)

bind(
	{ "XF86AudioLowerVolume" },
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)

bind(
	{ "XF86AudioMute" },
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)

bind({ "P" }, screenshot_fullscreen, { locked = true, description = "全屏截图" })
bind({ "SHIFT", " P" }, screenshot_region, { locked = true, description = "区域截图" })

bind({ "XF86AudioPlay" }, hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
bind({ "XF86AudioNext" }, hl.dsp.exec_cmd("playerctl next"), { locked = true })
bind({ "XF86AudioPrev" }, hl.dsp.exec_cmd("playerctl previous"), { locked = true })

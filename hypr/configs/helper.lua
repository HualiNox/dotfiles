local function shell_quote(value)
    return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function screenshot(mode)
    local home = assert(os.getenv("HOME"), "HOME is not set")
    local directory = home .. "/Pictures/Screenshots"
    local filepath = string.format(
        "%s/%s.png",
        directory,
        os.date("%Y-%m-%d_%H-%M-%S")
    )

    local quoted_directory = shell_quote(directory)
    local quoted_filepath = shell_quote(filepath)

    local capture_command

    if mode == "region" then
        capture_command = string.format([[
geometry="$(slurp -d)" || exit 0
[ -n "$geometry" ] || exit 0
grim -g "$geometry" %s || exit 1
]], quoted_filepath)
    elseif mode == "fullscreen" then
        capture_command = string.format([[
grim %s || exit 1
]], quoted_filepath)
    else
        error("unknown screenshot mode: " .. tostring(mode))
    end

    hl.exec_cmd(string.format([[
mkdir -p %s || exit 1

%s

wl-copy --type image/png < %s || exit 1

notify-send \
    --app-name="Screenshot" \
    --icon=%s \
    --expire-time=5000 \
    "截图完成" \
    "已保存并复制到剪贴板"
]],
        quoted_directory,
        capture_command,
        quoted_filepath,
        quoted_filepath
    ))
end

function screenshot_region()
    screenshot("region")
end

function screenshot_fullscreen()
    screenshot("fullscreen")
end

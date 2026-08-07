{ ... }:

let
  dms = name: action: [
    "dms"
    "ipc"
    "call"
    name
    action
  ];

  dmsWithArgs =
    name: action: args:
    (dms name action) ++ args;

  title = value: { hotkey-overlay.title = value; };

  spawn = command: { action.spawn = command; };

  spawnDms = name: action: spawn (dms name action);
in
{
  programs.niri.settings.binds = {
    "Mod+Shift+Slash" = (title "显示快捷键帮助") // {
      action.show-hotkey-overlay = [ ];
    };

    "Mod+T" = (title "打开终端") // (spawn "ghostty");
    "Mod+Return" = (title "打开终端") // (spawn "ghostty");
    "Mod+Shift+Return" = (title "打开浮动终端") // {
      action.spawn = [
        "ghostty"
        "--class=terminal-float"
      ];
    };
    "Mod+Space" = (title "应用启动器") // (spawnDms "spotlight" "toggle");
    "Alt+Space" = (title "应用启动器") // (spawnDms "spotlight" "toggle");
    "Alt+V" = (title "剪贴板") // (spawnDms "clipboard" "toggle");
    "Mod+N" = (title "通知中心") // (spawnDms "notifications" "toggle");
    "Mod+B" = (title "浏览器") // {
      action.spawn = [
        "xdg-open"
        "http://"
      ];
    };
    "Mod+E" = (title "文件管理器") // (spawn "nautilus");
    "Super+Alt+L" = (title "锁屏") // (spawnDms "lock" "lock");

    "Mod+O" = (title "概览视图") // {
      repeat = false;
      action.toggle-overview = [ ];
    };
    "Mod+Q" = (title "关闭窗口") // {
      repeat = false;
      action.close-window = [ ];
    };
    "Mod+C" = (title "关闭窗口") // {
      repeat = false;
      action.close-window = [ ];
    };
    "Mod+F" = (title "最大化列") // {
      action.maximize-column = [ ];
    };
    "Mod+Shift+F" = (title "全屏窗口") // {
      action.fullscreen-window = [ ];
    };
    "Mod+Ctrl+F" = (title "扩展到可用宽度") // {
      action.expand-column-to-available-width = [ ];
    };
    "Mod+A" = (title "居中列") // {
      action.center-column = [ ];
    };
    "Mod+Ctrl+C" = (title "居中可见列") // {
      action.center-visible-columns = [ ];
    };
    "Mod+V" = (title "浮动/平铺切换") // {
      action.toggle-window-floating = [ ];
    };
    "Mod+Shift+V" = (title "焦点在浮动/平铺间切换") // {
      action.switch-focus-between-floating-and-tiling = [ ];
    };
    "Mod+W" = (title "切换标签显示") // {
      action.toggle-column-tabbed-display = [ ];
    };

    "Mod+Left".action.focus-column-left = [ ];
    "Mod+Down".action.focus-window-down = [ ];
    "Mod+Up".action.focus-window-up = [ ];
    "Mod+Right".action.focus-column-right = [ ];
    "Mod+H".action.focus-column-left = [ ];
    "Mod+J".action.focus-window-down = [ ];
    "Mod+K".action.focus-window-up = [ ];
    "Mod+L".action.focus-column-right = [ ];

    "Mod+Shift+Left".action.move-column-left = [ ];
    "Mod+Shift+Down".action.move-window-down = [ ];
    "Mod+Shift+Up".action.move-window-up = [ ];
    "Mod+Shift+Right".action.move-column-right = [ ];
    "Mod+Ctrl+H".action.move-column-left = [ ];
    "Mod+Ctrl+J".action.move-window-down = [ ];
    "Mod+Ctrl+K".action.move-window-up = [ ];
    "Mod+Ctrl+L".action.move-column-right = [ ];

    "Mod+Home".action.focus-column-first = [ ];
    "Mod+End".action.focus-column-last = [ ];
    "Mod+Ctrl+Home".action.move-column-to-first = [ ];
    "Mod+Ctrl+End".action.move-column-to-last = [ ];

    "Mod+Shift+H".action.focus-monitor-left = [ ];
    "Mod+Shift+J".action.focus-monitor-down = [ ];
    "Mod+Shift+K".action.focus-monitor-up = [ ];
    "Mod+Shift+L".action.focus-monitor-right = [ ];
    "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [ ];
    "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [ ];
    "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [ ];
    "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [ ];

    "Mod+Page_Down".action.focus-workspace-down = [ ];
    "Mod+Page_Up".action.focus-workspace-up = [ ];
    "Mod+U".action.focus-workspace-down = [ ];
    "Mod+I".action.focus-workspace-up = [ ];
    "Mod+Shift+Page_Down".action.move-column-to-workspace-down = [ ];
    "Mod+Shift+Page_Up".action.move-column-to-workspace-up = [ ];
    "Mod+Ctrl+U".action.move-column-to-workspace-down = [ ];
    "Mod+Ctrl+I".action.move-column-to-workspace-up = [ ];

    "Mod+Ctrl+Page_Down".action.move-workspace-down = [ ];
    "Mod+Ctrl+Page_Up".action.move-workspace-up = [ ];
    "Mod+Shift+U".action.move-workspace-down = [ ];
    "Mod+Shift+I".action.move-workspace-up = [ ];

    "Mod+WheelScrollDown" = {
      cooldown-ms = 150;
      action.focus-workspace-down = [ ];
    };
    "Mod+WheelScrollUp" = {
      cooldown-ms = 150;
      action.focus-workspace-up = [ ];
    };
    "Mod+Ctrl+WheelScrollDown" = {
      cooldown-ms = 150;
      action.move-column-to-workspace-down = [ ];
    };
    "Mod+Ctrl+WheelScrollUp" = {
      cooldown-ms = 150;
      action.move-column-to-workspace-up = [ ];
    };
    "Mod+WheelScrollRight".action.focus-column-right = [ ];
    "Mod+WheelScrollLeft".action.focus-column-left = [ ];
    "Mod+Ctrl+WheelScrollRight".action.move-column-right = [ ];
    "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [ ];

    "Mod+1".action.focus-workspace = 1;
    "Mod+2".action.focus-workspace = 2;
    "Mod+3".action.focus-workspace = 3;
    "Mod+4".action.focus-workspace = 4;
    "Mod+5".action.focus-workspace = 5;
    "Mod+6".action.focus-workspace = 6;
    "Mod+7".action.focus-workspace = 7;
    "Mod+8".action.focus-workspace = 8;
    "Mod+9".action.focus-workspace = 9;
    "Mod+Ctrl+1".action.move-column-to-workspace = 1;
    "Mod+Ctrl+2".action.move-column-to-workspace = 2;
    "Mod+Ctrl+3".action.move-column-to-workspace = 3;
    "Mod+Ctrl+4".action.move-column-to-workspace = 4;
    "Mod+Ctrl+5".action.move-column-to-workspace = 5;
    "Mod+Ctrl+6".action.move-column-to-workspace = 6;
    "Mod+Ctrl+7".action.move-column-to-workspace = 7;
    "Mod+Ctrl+8".action.move-column-to-workspace = 8;
    "Mod+Ctrl+9".action.move-column-to-workspace = 9;

    "Mod+BracketLeft" = (title "吞入/吐出窗口（左）") // {
      action.consume-or-expel-window-left = [ ];
    };
    "Mod+BracketRight" = (title "吞入/吐出窗口（右）") // {
      action.consume-or-expel-window-right = [ ];
    };
    "Mod+Comma" = (title "吞入窗口到列") // {
      action.consume-window-into-column = [ ];
    };
    "Mod+Period" = (title "从列中吐出窗口") // {
      action.expel-window-from-column = [ ];
    };

    "Mod+R" = (title "切换预设宽度") // {
      action.switch-preset-column-width = [ ];
    };
    "Mod+Shift+R" = (title "切换预设高度") // {
      action.switch-preset-window-height = [ ];
    };
    "Mod+Ctrl+R" = (title "重置窗口高度") // {
      action.reset-window-height = [ ];
    };
    "Mod+Minus" = (title "列宽度 -10%") // {
      action.set-column-width = "-10%";
    };
    "Mod+Equal" = (title "列宽度 +10%") // {
      action.set-column-width = "+10%";
    };
    "Mod+Shift+Minus" = (title "窗口高度 -10%") // {
      action.set-window-height = "-10%";
    };
    "Mod+Shift+Equal" = (title "窗口高度 +10%") // {
      action.set-window-height = "+10%";
    };

    "Print".action.screenshot = [ ];
    "Ctrl+Print" = (title "截取当前屏幕") // {
      action.screenshot-screen = [ ];
    };
    "Alt+Print" = (title "截取当前窗口") // {
      action.screenshot-window = [ ];
    };
    "Mod+Shift+S" = (title "区域截图与标注") // {
      action.spawn-sh = ''grim -g "$(slurp)" - | satty --filename - --copy-command wl-copy'';
    };

    "XF86AudioRaiseVolume" = {
      allow-when-locked = true;
      action.spawn = dmsWithArgs "audio" "increment" [ "5" ];
    };
    "XF86AudioLowerVolume" = {
      allow-when-locked = true;
      action.spawn = dmsWithArgs "audio" "decrement" [ "5" ];
    };
    "XF86AudioMute" = {
      allow-when-locked = true;
      action.spawn = dms "audio" "mute";
    };
    "XF86AudioMicMute" = {
      allow-when-locked = true;
      action.spawn = dms "audio" "micmute";
    };
    "XF86MonBrightnessUp" = {
      allow-when-locked = true;
      action.spawn = dmsWithArgs "brightness" "increment" [
        "5"
        ""
      ];
    };
    "XF86MonBrightnessDown" = {
      allow-when-locked = true;
      action.spawn = dmsWithArgs "brightness" "decrement" [
        "5"
        ""
      ];
    };
    "XF86AudioPlay" = {
      allow-when-locked = true;
      action.spawn = dms "mpris" "playPause";
    };
    "XF86AudioNext" = {
      allow-when-locked = true;
      action.spawn = dms "mpris" "next";
    };
    "XF86AudioPrev" = {
      allow-when-locked = true;
      action.spawn = dms "mpris" "previous";
    };

    "Mod+Shift+P" = (title "关闭显示器") // {
      action.power-off-monitors = [ ];
    };
    "Mod+MouseMiddle" = (title "关闭确认") // (spawnDms "powermenu" "toggle");
    "XF86PowerOff" = (title "电源菜单") // {
      allow-when-locked = true;
      action.spawn = dms "powermenu" "toggle";
    };
    "Mod+Escape" = (title "切换快捷键抑制") // {
      allow-inhibiting = false;
      action.toggle-keyboard-shortcuts-inhibit = [ ];
    };
    "Mod+Shift+E" = (title "退出 Niri") // {
      action.quit = [ ];
    };
    "Ctrl+Alt+Delete" = (title "退出 Niri") // {
      action.quit = [ ];
    };
  };
}

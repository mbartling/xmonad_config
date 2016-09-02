import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Loggers
import System.IO
import XMonad.Hooks.SetWMName

-- batteryCmd :: Logger
-- batteryCmd = logCmd $ "/usr/bin/acpi | "
--              ++ "sed -r"
--              ++" 's/.*?: (.*)/\\1/;"
--              ++" s/[dD]ischarging, [0-9]+%, ([0-9]+:[0-9]+:[0-9]+) .*/\\1-/;"
--              ++" s/[cC]harging, [0-9]+%, ([0-9]+:[0-9]+:[0-9]+) .*/\\1+/;"
--              ++" s/[cC]harged, /Charged/'"
-- 
-- xmobarConfig :: PP
-- xmobarConfig = xmobarPP {ppSep = " | "
--                         , ppOrder = \(ws:lay:t:bat:_) -> [ws,lay,bat,t]
--                         , ppExtras = [batteryCmd]
--                         }


myManageHook = composeAll
    [ className =? "vmplayer" --> doFloat]
main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/michael/.xmobarrc"
    xmonad $ defaultConfig {
        manageHook = manageDocks <+> myManageHook
            <+> manageHook defaultConfig,
        layoutHook = avoidStruts  $  layoutHook defaultConfig
        , startupHook = setWMName "LG3D"
        , logHook = dynamicLogWithPP xmobarPP
            {
                ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "green" "" . shorten 50
            }
        , terminal = "xterm"
        -- , modMaskI = mod4Mask    -- Rebind Mod to the Windows Key
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "i3lock -t -i ~/Pictures/hatersgonnahate.jpg")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((mod4Mask, xK_Left), spawn "xrandr --output VGA1 --auto --left-of LVDS1")
        , ((mod4Mask, xK_Right), spawn "xrandr --output VGA1 --auto --right-of LVDS1")
        , ((mod4Mask, xK_Up), spawn "xrandr --output VGA1 --auto --above LVDS1")
        , ((mod4Mask, xK_Down), spawn "xrandr --output VGA1 --off")
        , ((mod4Mask .|. shiftMask, xK_Up), spawn "xrandr --output LVDS1 --auto")
        , ((mod4Mask .|. shiftMask, xK_Down), spawn "xrandr --output LVDS1 --mode 1024x768")
        , ((0, xK_Print), spawn "scrot")
        ]

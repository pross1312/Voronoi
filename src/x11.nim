import x11/xlib
import x11/x
import x11/xatom
import std/posix

const
    False = 0
    True = 1

var
    disp: PDisplay
    scr*: PScreen
    pmap: Pixmap
    root: Window
    is_quit_request: bool
    depth: cint
    visual: PVisual
    prop_root: Atom
    prop_root_ese: Atom
    gc: GC

proc init*(kill: bool): bool =
    disp = XOpenDisplay(nil);
    if disp == nil:
        return false
    scr = ScreenOfDisplay(disp, DefaultScreen(disp))
    root = RootWindow(disp, DefaultScreen(disp))
    depth = DefaultDepth(disp, DefaultScreen(disp))
    visual = DefaultVisual(disp, DefaultScreen(disp))
    discard XSync(disp, False)
    pmap = XCreatePixmap(disp, root, cuint(scr.width), cuint(scr.height), cuint(depth))
    prop_root = XInternAtom(disp, "_XROOTPMAP_ID", True)
    gc = XCreateGC(disp, pmap, 0, nil)
    if not kill:
        return true;
    var killed = false
    if prop_root != None:
        var ttype: Atom
        var format: cint
        var length, after: culong
        var data_root: ptr cchar
        discard XGetWindowProperty(disp, root, prop_root, 0, 1, False, AnyPropertyType, addr ttype, addr format, addr length, addr after, addr data_root)
        if ttype == XA_PIXMAP:
            killed = true
            echo "Killing prop root"
            discard XKillClient(disp, cast[ptr Pixmap](data_root)[])
        if data_root != nil:
            discard XFree(data_root)

    if not killed:
        prop_root_ese = XInternAtom(disp, "ESETROOT_PMAP_I", True)
        if prop_root_ese != None:
            var ttype: Atom
            var format: cint
            var length, after: culong
            var data_root: ptr cchar
            discard XGetWindowProperty(disp, root, prop_root_ese, 0, 1, False, AnyPropertyType, addr ttype, addr format, addr length, addr after, addr data_root)
            if ttype == XA_PIXMAP:
                echo "Killing prop root ese"
                discard XKillClient(disp, cast[ptr Pixmap](data_root)[])
            if data_root != nil:
                discard XFree(data_root)
    return true

proc deinit*() =
    discard XFreeGC(disp, gc)
    discard XSync(disp, True)
    discard XFlush(disp)
    discard XSetCloseDownMode(disp, RetainPermanent)
    discard XCloseDisplay(disp)

proc displayImage*(data: openArray[cchar]) =
    discard XClearWindow(disp, root)
    let image = XCreateImage(disp, visual, cuint(depth), ZPixmap, 0, cast[cstring](addr data[0]), cuint(scr.width), cuint(scr.height), 32, 0)
    discard XPutImage(disp, pmap, gc, image, 0, 0, 0, 0, cuint(scr.width), cuint(scr.height))

    prop_root = XInternAtom(disp, "_XROOTPMAP_ID", False)
    discard XChangeProperty(disp, root, prop_root, XA_PIXMAP, 32, PropModeReplace, cast[cstring](addr pmap), 1);

    prop_root_ese = XInternAtom(disp, "ESETROOT_PMAP_I", False)
    discard XChangeProperty(disp, root, prop_root, XA_PIXMAP, 32, PropModeReplace, cast[cstring](addr pmap), 1);

    discard XSync(disp, False)

proc handler() {.noconv.} =
    is_quit_request = true

when isMainModule:
    setControlCHook(handler)
    if not init(true):
        echo "Failed to init x11"
        system.quit(1)
    echo "Displaying"
    var color: cuint = 0xfffffff
    let data = newSeq[cchar](scr.width * scr.height * 4)
    while not is_quit_request:
        echo color.repr
        for h in countup(0, scr.height-1):
            for w in countup(0, scr.width-1):
                cast[ptr cuint](addr data[(h * scr.width + w) * 4])[] = color
        displayImage(data)
        discard sleep(1000)
        color += 1000
    deinit()

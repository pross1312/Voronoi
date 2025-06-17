import raylib
import x11
import std/random
import std/strformat
import std/times
import std/os
import std/cmdline
import std/nativesockets

var r = initRand(int64(epochTime()))
const
    radius = 10
    vel = 200.0
    hue = 207/255.0
    saturation = 68.42/255.0

proc `/`(x: uint8, y: cfloat): cfloat =
    return cfloat(x)/y
proc `/`(x: cint, y: cfloat): cfloat =
    return cfloat(x)/y

proc color_to_vec4(color: Color): Vector4 =
    return Vector4(x: color.r/255.0, y: color.g/255.0, z: color.b/255.0, w: color.a/255.0)

proc update_position(points: var openArray[Vector2], vel: var openArray[Vector2], radius: cfloat) =
    for i in 0..<len(points):
        points[i] += vel[i] * get_frame_time()
        if points[i].x - radius < 0:
            vel[i].x = -vel[i].x
            points[i].x = radius
        if points[i].x + radius > cfloat(scr.width):
            vel[i].x = -vel[i].x
            points[i].x = cfloat(scr.width) - radius

        if points[i].y - radius < 0:
            vel[i].y = -vel[i].y
            points[i].y = radius
        if points[i].y + radius > cfloat(scr.height):
            vel[i].y = -vel[i].y
            points[i].y = cfloat(scr.height) - radius

proc randomize_colors(colors: var openArray[Vector4]) =
    for item in mitems(colors):
        item = color_to_vec4(color_from_hsv(hue, saturation, rand(r, 1.0)))

proc shift(slice: var seq[string]): string =
    let res = slice[0]
    slice = slice[1..^1]
    return res
proc removeAlpha(pixels: var openArray[cuint]) =
    for item in mitems(pixels):
        item = htonl(item) shr 8
        # item = item shr 8

proc print_help(prog_name: string) =
    echo &"{prog_name} [mode]"
    echo &"    mode: (window|wallpaper), default window"
    discard

when isMainModule:
    var args = commandLineParams()[0..^1]
    if args.len > 1:
        print_help(os.getAppFilename())
        system.quit(1)

    var wallpaper_mode =
        if args.len == 0:
            false
        elif args[0] == "wallpaper":
            true
        elif args[0] == "window":
            true
        else:
            print_help(getAppFilename())
            system.quit(1)

    if not init(false):
        system.quit(1)
    # let window = XDefaultRootWindow(display)
    # let name: cstring = "tuong"
    # let status = XFetchName(display, window, addr name)
    # if status != 0:
    #     echo name
    # else:
    #     echo "Failed"

    init_window(scr.width, scr.height, "Voronoi")
    set_target_fps(30)

    const vertex_shader_file_path = "./shaders/vertex.glsl"
    const fragment_shader_file_path = "./shaders/fragment.glsl"
    let shader: Shader = load_shader(vertex_shader_file_path, fragment_shader_file_path)
    assert(is_shader_valid(shader) != 0)

    let time_uniform_location = get_shader_location(shader, "time")
    trace_log(LOG_INFO, "Time Uniform Location: %d", time_uniform_location)

    let voronoi_point_count_uniform_location: cint = get_shader_location(shader, "voronoi_point_count")
    trace_log(LOG_INFO, "Voronoi Point Count Uniform Location: %d", voronoi_point_count_uniform_location)

    let voronoi_points_uniform_location: cint = get_shader_location(shader, "voronoi_points")
    trace_log(LOG_INFO, "Voronoi Points Uniform Location: %d", voronoi_points_uniform_location)

    let voronoi_points_color_uniform_location: cint = get_shader_location(shader, "voronoi_points_color")
    trace_log(LOG_INFO, "Voronoi Points Color Uniform Location: %d", voronoi_points_color_uniform_location)

    # var points = @[
    #     Vector2(x: get_screen_width()/2.0, y: get_screen_height()/2.0f),
    #     Vector2(x: get_screen_width()/2.0 + get_screen_width()/4.0f, y: get_screen_height()/2.0f + get_screen_height()/4.0f),
    #     Vector2(x: get_screen_width()/2.0 - get_screen_width()/4.0f, y: get_screen_height()/2.0f - get_screen_height()/4.0f),
    #     Vector2(x: get_screen_width()/2.0 - get_screen_width()/4.0f, y: get_screen_height()/2.0f + get_screen_height()/4.0f),
    #     Vector2(x: get_screen_width()/2.0 + get_screen_width()/4.0f, y: get_screen_height()/2.0f - get_screen_height()/4.0f),
    #     Vector2(x: float(get_mouse_x()), y: float(get_mouse_y())),
    # ]
    var points = @[
        Vector2(x: rand(r, cfloat(scr.width)), y: cfloat(scr.height)),
        Vector2(x: rand(r, cfloat(scr.width)), y: cfloat(scr.height)),
        Vector2(x: rand(r, cfloat(scr.width)), y: cfloat(scr.height)),
        Vector2(x: rand(r, cfloat(scr.width)), y: cfloat(scr.height)),
        Vector2(x: rand(r, cfloat(scr.width)), y: cfloat(scr.height)),
        Vector2(x: rand(r, cfloat(scr.width)), y: cfloat(scr.height)),
        Vector2(x: rand(r, cfloat(scr.width)), y: cfloat(scr.height)),
        Vector2(x: rand(r, cfloat(scr.width)), y: cfloat(scr.height)),
        Vector2(x: rand(r, cfloat(scr.width)), y: cfloat(scr.height)),
        Vector2(x: rand(r, cfloat(scr.width)), y: cfloat(scr.height)),
        Vector2(x: rand(r, cfloat(scr.width)), y: cfloat(scr.height)),
        Vector2(x: rand(r, cfloat(scr.width)), y: cfloat(scr.height)),
        Vector2(x: rand(r, cfloat(scr.width)), y: cfloat(scr.height)),
    ]

    var velocity: seq[Vector2] = @[]
    var points_color: seq[Vector4] = @[]
    for i in 0..<len(points):
        velocity.add(Vector2(x: rand(r, vel), y: rand(r, vel)))
        points_color.add(color_to_vec4(color_from_hsv(hue, saturation, rand(r, 1.0))))

    assert(len(points) == len(velocity))
    assert(len(points) == len(points_color))
    # echo points.repr
    # echo points_color.repr

    let voronoi_point_count = cint(len(points))
    set_shader_value(shader, voronoi_point_count_uniform_location, pointer(addr voronoi_point_count), SHADER_UNIFORM_INT)
    set_shader_value_v(shader, voronoi_points_color_uniform_location, pointer(addr points_color[0]), SHADER_UNIFORM_VEC4, voronoi_point_count)

    trace_log(LOG_INFO, "Point count %d", voronoi_point_count)
    trace_log(LOG_INFO, "Size of Vector2 %d", sizeof(Vector2))

    let texture = load_render_texture(scr.width, scr.height)
    while not window_should_close():
        begin_drawing()
        begin_shader_mode(shader)
        if wallpaper_mode:
            begin_texture_mode(texture)

        update_position(points, velocity, radius)
        if is_key_pressed(KeyboardKey.KEY_SPACE):
            randomize_colors(points_color)
            set_shader_value_v(shader, voronoi_points_color_uniform_location, pointer(addr points_color[0]), SHADER_UNIFORM_VEC4, voronoi_point_count)

        clear_background(WHITE)
        let time = get_time()
        set_shader_value(shader, time_uniform_location, pointer(addr time), SHADER_UNIFORM_FLOAT)
        draw_rectangle(0, 0, get_screen_width(), get_screen_height(), WHITE)
        set_shader_value_v(shader, voronoi_points_uniform_location, pointer(addr points[0]), SHADER_UNIFORM_VEC2, voronoi_point_count)

        if wallpaper_mode:
            end_texture_mode()
        end_shader_mode()
        end_drawing()

        if wallpaper_mode:
            var image = load_image_from_texture(texture.texture);
            var pixels_ptr = cast[ptr UncheckedArray[cuint]](image.data)
            echo &"no shift: {cast[ptr UncheckedArray[byte]](image.data)[0].repr} {cast[ptr UncheckedArray[byte]](image.data)[1].repr} {cast[ptr UncheckedArray[byte]](image.data)[2].repr} {cast[ptr UncheckedArray[byte]](image.data)[3].repr}"
            removeAlpha(toOpenArray(pixels_ptr, 0, image.width * image.height))
            echo &" shifted: {cast[ptr UncheckedArray[byte]](image.data)[0].repr} {cast[ptr UncheckedArray[byte]](image.data)[1].repr} {cast[ptr UncheckedArray[byte]](image.data)[2].repr} {cast[ptr UncheckedArray[byte]](image.data)[3].repr}"
            display_image(toOpenArray(cast[cstring](image.data), 0, image.width * image.height * 4 - 1))
            unload_image(image)

        if is_key_pressed(KeyboardKey.KEY_TAB):
            wallpaper_mode = not wallpaper_mode

    unload_render_texture(texture)
    close_window()
    deinit()

import raylib
import x11/xlib

proc `/`(x: uint8, y: cfloat): cfloat =
    return cfloat(x)/y
proc `/`(x: cint, y: cfloat): cfloat =
    return cfloat(x)/y
proc color_to_vec4(color: Color): Vector4 =
    return Vector4(x: color.r/255.0, y: color.g/255.0, z: color.b/255.0, w: color.a/255.0)

when isMainModule:

    let display = XOpenDisplay(nil)
    if display == nil:
        echo "NIL"
    else:
        echo display.repr
    # let window = XDefaultRootWindow(display)
    # let name: cstring = "tuong"
    # let status = XFetchName(display, window, addr name)
    # if status != 0:
    #     echo name
    # else:
    #     echo "Failed"

    const width = 1600
    const height = 900
    init_window(width, height, "Voronoi")
    set_target_fps(60)

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

    var points = @[
        Vector2(x: get_screen_width()/2.0, y: get_screen_height()/2.0f),

        Vector2(x: get_screen_width()/2.0 + get_screen_width()/4.0f, y: get_screen_height()/2.0f + get_screen_height()/4.0f),

        Vector2(x: get_screen_width()/2.0 - get_screen_width()/4.0f, y: get_screen_height()/2.0f - get_screen_height()/4.0f),

        Vector2(x: get_screen_width()/2.0 - get_screen_width()/4.0f, y: get_screen_height()/2.0f + get_screen_height()/4.0f),

        Vector2(x: get_screen_width()/2.0 + get_screen_width()/4.0f, y: get_screen_height()/2.0f - get_screen_height()/4.0f),

        Vector2(x: float(get_mouse_x()), y: float(get_mouse_y())),
    ]
    let points_color = @[
        color_to_vec4(VIOLET),
        color_to_vec4(RAYWHITE),
        color_to_vec4(BLUE),
        color_to_vec4(DARKBLUE),
        color_to_vec4(BEIGE),
        color_to_vec4(RED),
    ]
    assert(len(points) == len(points_color))

    let voronoi_point_count = cint(len(points))
    set_shader_value(shader, voronoi_point_count_uniform_location, pointer(addr voronoi_point_count), SHADER_UNIFORM_INT)
    set_shader_value_v(shader, voronoi_points_color_uniform_location, pointer(addr points_color[0]), SHADER_UNIFORM_VEC4, voronoi_point_count)

    trace_log(LOG_INFO, "Point count %d", voronoi_point_count)
    trace_log(LOG_INFO, "Size of Vector2 %d", sizeof(Vector2))

    while not window_should_close():
        begin_drawing()
        clear_background(get_color(0x181818ff))
        begin_shader_mode(shader)

        if is_mouse_button_released(MOUSE_BUTTON_LEFT) != 0:
            discard

        let time = get_time()
        set_shader_value(shader, time_uniform_location, pointer(addr time), SHADER_UNIFORM_FLOAT)
        draw_rectangle(0, 0, get_screen_width(), get_screen_height(), WHITE)

        points[voronoi_point_count-1] = Vector2(
            x: cfloat(get_mouse_x()),
            y: cfloat(get_mouse_y()),
        )
        set_shader_value_v(shader, voronoi_points_uniform_location, pointer(addr points[0]), SHADER_UNIFORM_VEC2, voronoi_point_count)

        end_shader_mode()
        for i in 0..<voronoi_point_count:
            draw_circle_v(points[i], 5.0f, BLACK)
        end_drawing()
    close_window()

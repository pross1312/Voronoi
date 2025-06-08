{.passc: "-Iraylib-5.5_linux_amd64/include", passl: "-Lraylib-5.5_linux_amd64/lib -lraylib -lm".}
const rl_path {.strdefine.} = "../raylib-5.5_linux_amd64/"
const rl_header {.strdefine.} = "<raylib.h>"
type
    MouseButton* {.size: sizeof(cint).} = enum
        MOUSE_BUTTON_LEFT    = 0
        MOUSE_BUTTON_RIGHT   = 1
        MOUSE_BUTTON_MIDDLE  = 2
        MOUSE_BUTTON_SIDE    = 3
        MOUSE_BUTTON_EXTRA   = 4
        MOUSE_BUTTON_FORWARD = 5
        MOUSE_BUTTON_BACK    = 6
    TraceLogLevel* {.size: sizeof(cint).} = enum
        LOG_ALL = 0
        LOG_TRACE
        LOG_DEBUG
        LOG_INFO
        LOG_WARNING
        LOG_ERROR
        LOG_FATAL
        LOG_NONE
    ShaderUniformDataType* {.size: sizeof(cint).} = enum
        SHADER_UNIFORM_FLOAT = 0
        SHADER_UNIFORM_VEC2
        SHADER_UNIFORM_VEC3
        SHADER_UNIFORM_VEC4
        SHADER_UNIFORM_INT
        SHADER_UNIFORM_IVEC2
        SHADER_UNIFORM_IVEC3
        SHADER_UNIFORM_IVEC4
        SHADER_UNIFORM_SAMPLER2D
    Shader* {.header: rl_header, importc, bycopy.} = object
        id: cuint
        locs: ptr cint
    Vector2* {.header: rl_header, importc, bycopy.} = object
        x*, y*: cfloat
    Vector4* {.header: rl_header, importc, bycopy.} = object
        x*, y*, z*, w*: cfloat
    Color* {.header: rl_header, importc, bycopy.} = object
        r*, g*, b*, a*: uint8
const LIGHTGRAY*  = Color(r: 200, g: 200, b: 200, a: 255)
const GRAY*       = Color(r: 130, g: 130, b: 130, a: 255)
const DARKGRAY*   = Color(r: 80, g: 80, b: 80, a: 255)
const YELLOW*     = Color(r: 253, g: 249, b: 0, a: 255)
const GOLD*       = Color(r: 255, g: 203, b: 0, a: 255)
const ORANGE*     = Color(r: 255, g: 161, b: 0, a: 255)
const PINK*       = Color(r: 255, g: 109, b: 194, a: 255)
const RED*        = Color(r: 230, g: 41, b: 55, a: 255)
const MAROON*     = Color(r: 190, g: 33, b: 55, a: 255)
const GREEN*      = Color(r: 0, g: 228, b: 48, a: 255)
const LIME*       = Color(r: 0, g: 158, b: 47, a: 255)
const DARKGREEN*  = Color(r: 0, g: 117, b: 44, a: 255)
const SKYBLUE*    = Color(r: 102, g: 191, b: 255, a: 255)
const BLUE*       = Color(r: 0, g: 121, b: 241, a: 255)
const DARKBLUE*   = Color(r: 0, g: 82, b: 172, a: 255)
const PURPLE*     = Color(r: 200, g: 122, b: 255, a: 255)
const VIOLET*     = Color(r: 135, g: 60, b: 190, a: 255)
const DARKPURPLE* = Color(r: 112, g: 31, b: 126, a: 255)
const BEIGE*      = Color(r: 211, g: 176, b: 131, a: 255)
const BROWN*      = Color(r: 127, g: 106, b: 79, a: 255)
const DARKBROWN*  = Color(r: 76, g: 63, b: 47, a: 255)
const WHITE*      = Color(r: 255, g: 255, b: 255, a: 255)
const BLACK*      = Color(r: 0, g: 0, b: 0, a: 255)
const BLANK*      = Color(r: 0, g: 0, b: 0, a: 0)
const MAGENTA*    = Color(r: 255, g: 0, b: 255, a: 255)
const RAYWHITE*   = Color(r: 245, g: 245, b: 245, a: 255)

proc init_window*(width: cint, height: cint, title: cstring)                                                              {.header: rl_header, importc: "InitWindow".}
proc close_window*()                                                                                                      {.header: rl_header, importc: "CloseWindow".}
proc window_should_close*(): bool                                                                                         {.header: rl_header, importc: "WindowShouldClose".}
proc set_target_fps*(fps: cint)                                                                                           {.header: rl_header, importc: "SetTargetFPS".}
proc load_shader*(vsFileName: cstring, fsFileName: cstring): Shader                                                       {.header: rl_header, importc: "LoadShader".}
proc is_shader_valid*(shader: Shader): cint                                                                               {.header: rl_header, importc: "IsShaderValid".}
proc get_shader_location*(shader: Shader, uniformName: cstring): cint                                                     {.header: rl_header, importc: "GetShaderLocation".}
proc trace_log*(logLevel: TraceLogLevel, text: cstring)                                                                   {.header: rl_header, importc: "TraceLog", varargs.}
proc get_screen_width*(): cint                                                                                            {.header: rl_header, importc: "GetScreenWidth".}
proc get_screen_height*(): cint                                                                                           {.header: rl_header, importc: "GetScreenHeight".}
proc get_mouse_x*(): cint                                                                                                 {.header: rl_header, importc: "GetMouseX".}
proc get_mouse_y*(): cint                                                                                                 {.header: rl_header, importc: "GetMouseY".}
proc set_shader_value*(shader: Shader, locIndex: cint, value: pointer, uniformType: ShaderUniformDataType)                {.header: rl_header, importc: "SetShaderValue".}
proc set_shader_value_v*(shader: Shader, locIndex: cint, valie: pointer, uniformType: ShaderUniformDataType, count: cint) {.header: rl_header, importc: "SetShaderValueV".}
proc clear_background*(color: Color)                                                                                      {.header: rl_header, importc: "ClearBackground".}
proc get_color*(hexValue: cuint): Color                                                                                   {.header: rl_header, importc: "GetColor".}
proc begin_drawing*()                                                                                                     {.header: rl_header, importc: "BeginDrawing".}
proc end_drawing*()                                                                                                       {.header: rl_header, importc: "EndDrawing".}
proc begin_shader_mode*(shader: Shader)                                                                                   {.header: rl_header, importc: "BeginShaderMode".}
proc end_shader_mode*()                                                                                                   {.header: rl_header, importc: "EndShaderMode".}
proc get_time*(): cdouble                                                                                                 {.header: rl_header, importc: "GetTime".}
proc draw_rectangle*(posX: cint, posY: cint, width: cint, height: cint, color: Color)                                     {.header: rl_header, importc: "DrawRectangle".}
proc draw_circle_v*(center: Vector2, radius: cfloat, color: Color)                                                        {.header: rl_header, importc: "DrawCircleV".}
proc is_mouse_button_released*(button: MouseButton): cint                                                                         {.header: rl_header, importc: "IsMouseButtonReleased".}
{.hint[XDeclaredButNotUsed]: off.}

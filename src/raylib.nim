{.passc: "-Iraylib-5.5_linux_amd64/include", passl: "-Lraylib-5.5_linux_amd64/lib -lraylib -lm".}
const rl_path {.strdefine.} = "../raylib-5.5_linux_amd64/"
const rl_header {.strdefine.} = "<raylib.h>"

import std/[macros, tables]
macro unordered(def) =
  def.expectKind nnkTypeDef
  def[2].expectKind nnkEnumTy
  var fields: OrderedTable[int, NimNode]
  var lastInt = 0
  for field in def[2][1..^1]:
    field.expectKind nnkEnumFieldDef
    let i =
      if field[1].kind == nnkIntLit:
        field[1].intVal
      elif field[1].kind == nnkTupleConstr and field[1][0].kind == nnkIntLit:
        field[1][0].intVal
      else:
        lastInt+1
    lastInt = i
    fields[i] = field
  var sortedTy = nnkEnumTy.newTree(def[2][0])
  fields.sort do(a, b: (int, NimNode)) -> int: a[0]-b[0]
  for field in fields.values:
    sortedTy.add(field)
  result = def
  result[2] = sortedTy

type
    KeyboardKey* {.size: sizeof(cint), unordered.} = enum
        KEY_NULL            = 0        # Key: NULL, used for no key pressed
        # Alphanumeric keys
        KEY_APOSTROPHE      = 39       # Key: '
        KEY_COMMA           = 44       # Key: ,
        KEY_MINUS           = 45       # Key: -
        KEY_PERIOD          = 46       # Key: .
        KEY_SLASH           = 47       # Key: /
        KEY_ZERO            = 48       # Key: 0
        KEY_ONE             = 49       # Key: 1
        KEY_TWO             = 50       # Key: 2
        KEY_THREE           = 51       # Key: 3
        KEY_FOUR            = 52       # Key: 4
        KEY_FIVE            = 53       # Key: 5
        KEY_SIX             = 54       # Key: 6
        KEY_SEVEN           = 55       # Key: 7
        KEY_EIGHT           = 56       # Key: 8
        KEY_NINE            = 57       # Key: 9
        KEY_SEMICOLON       = 59       # Key: ;
        KEY_EQUAL           = 61       # Key: =
        KEY_A               = 65       # Key: A | a
        KEY_B               = 66       # Key: B | b
        KEY_C               = 67       # Key: C | c
        KEY_D               = 68       # Key: D | d
        KEY_E               = 69       # Key: E | e
        KEY_F               = 70       # Key: F | f
        KEY_G               = 71       # Key: G | g
        KEY_H               = 72       # Key: H | h
        KEY_I               = 73       # Key: I | i
        KEY_J               = 74       # Key: J | j
        KEY_K               = 75       # Key: K | k
        KEY_L               = 76       # Key: L | l
        KEY_M               = 77       # Key: M | m
        KEY_N               = 78       # Key: N | n
        KEY_O               = 79       # Key: O | o
        KEY_P               = 80       # Key: P | p
        KEY_Q               = 81       # Key: Q | q
        KEY_R               = 82       # Key: R | r
        KEY_S               = 83       # Key: S | s
        KEY_T               = 84       # Key: T | t
        KEY_U               = 85       # Key: U | u
        KEY_V               = 86       # Key: V | v
        KEY_W               = 87       # Key: W | w
        KEY_X               = 88       # Key: X | x
        KEY_Y               = 89       # Key: Y | y
        KEY_Z               = 90       # Key: Z | z
        KEY_LEFT_BRACKET    = 91       # Key: [
        KEY_BACKSLASH       = 92       # Key: '\'
        KEY_RIGHT_BRACKET   = 93       # Key: ]
        KEY_GRAVE           = 96       # Key: `
        # Function keys
        KEY_SPACE           = 32       # Key: Space
        KEY_ESCAPE          = 256      # Key: Esc
        KEY_ENTER           = 257      # Key: Enter
        KEY_TAB             = 258      # Key: Tab
        KEY_BACKSPACE       = 259      # Key: Backspace
        KEY_INSERT          = 260      # Key: Ins
        KEY_DELETE          = 261      # Key: Del
        KEY_RIGHT           = 262      # Key: Cursor right
        KEY_LEFT            = 263      # Key: Cursor left
        KEY_DOWN            = 264      # Key: Cursor down
        KEY_UP              = 265      # Key: Cursor up
        KEY_PAGE_UP         = 266      # Key: Page up
        KEY_PAGE_DOWN       = 267      # Key: Page down
        KEY_HOME            = 268      # Key: Home
        KEY_END             = 269      # Key: End
        KEY_CAPS_LOCK       = 280      # Key: Caps lock
        KEY_SCROLL_LOCK     = 281      # Key: Scroll down
        KEY_NUM_LOCK        = 282      # Key: Num lock
        KEY_PRINT_SCREEN    = 283      # Key: Print screen
        KEY_PAUSE           = 284      # Key: Pause
        KEY_F1              = 290      # Key: F1
        KEY_F2              = 291      # Key: F2
        KEY_F3              = 292      # Key: F3
        KEY_F4              = 293      # Key: F4
        KEY_F5              = 294      # Key: F5
        KEY_F6              = 295      # Key: F6
        KEY_F7              = 296      # Key: F7
        KEY_F8              = 297      # Key: F8
        KEY_F9              = 298      # Key: F9
        KEY_F10             = 299      # Key: F10
        KEY_F11             = 300      # Key: F11
        KEY_F12             = 301      # Key: F12
        KEY_LEFT_SHIFT      = 340      # Key: Shift left
        KEY_LEFT_CONTROL    = 341      # Key: Control left
        KEY_LEFT_ALT        = 342      # Key: Alt left
        KEY_LEFT_SUPER      = 343      # Key: Super left
        KEY_RIGHT_SHIFT     = 344      # Key: Shift right
        KEY_RIGHT_CONTROL   = 345      # Key: Control right
        KEY_RIGHT_ALT       = 346      # Key: Alt right
        KEY_RIGHT_SUPER     = 347      # Key: Super right
        KEY_KB_MENU         = 348      # Key: KB menu
        # Keypad keys
        KEY_KP_0            = 320      # Key: Keypad 0
        KEY_KP_1            = 321      # Key: Keypad 1
        KEY_KP_2            = 322      # Key: Keypad 2
        KEY_KP_3            = 323      # Key: Keypad 3
        KEY_KP_4            = 324      # Key: Keypad 4
        KEY_KP_5            = 325      # Key: Keypad 5
        KEY_KP_6            = 326      # Key: Keypad 6
        KEY_KP_7            = 327      # Key: Keypad 7
        KEY_KP_8            = 328      # Key: Keypad 8
        KEY_KP_9            = 329      # Key: Keypad 9
        KEY_KP_DECIMAL      = 330      # Key: Keypad .
        KEY_KP_DIVIDE       = 331      # Key: Keypad /
        KEY_KP_MULTIPLY     = 332      # Key: Keypad *
        KEY_KP_SUBTRACT     = 333      # Key: Keypad -
        KEY_KP_ADD          = 334      # Key: Keypad +
        KEY_KP_ENTER        = 335      # Key: Keypad Enter
        KEY_KP_EQUAL        = 336      # Key: Keypad =
        # Android key buttons
        KEY_BACK            = 4        # Key: Android back button
        KEY_MENU            = 5        # Key: Android menu button
        KEY_VOLUME_UP       = 24       # Key: Android volume up button
        KEY_VOLUME_DOWN     = 25        # Key: Android volume down button
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
    Texture* {.header: rl_header, importc, bycopy.} = object
        id: cuint
        width, height, mipmaps, format: cint
    Texture2D = Texture
    TextureCubemap = Texture

    RenderTexture* {.header: rl_header, importc, bycopy.} = object
        id: cuint
        texture*, depth: Texture
    RenderTexture2D = RenderTexture

    Image* {.header: rl_header, importc, bycopy.} = object
        data*: pointer
        width*, height*, mipmaps*, format*: cint

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

proc init_window*(width: cint, height: cint, title: cstring)                                                              {. header: rl_header, importc: "InitWindow"            .}
proc close_window*()                                                                                                      {. header: rl_header, importc: "CloseWindow"           .}
proc window_should_close*(): bool                                                                                         {. header: rl_header, importc: "WindowShouldClose"     .}
proc set_target_fps*(fps: cint)                                                                                           {. header: rl_header, importc: "SetTargetFPS"          .}
proc load_shader*(vsFileName: cstring, fsFileName: cstring): Shader                                                       {. header: rl_header, importc: "LoadShader"            .}
proc is_shader_valid*(shader: Shader): cint                                                                               {. header: rl_header, importc: "IsShaderValid"         .}
proc get_shader_location*(shader: Shader, uniformName: cstring): cint                                                     {. header: rl_header, importc: "GetShaderLocation"     .}
proc trace_log*(logLevel: TraceLogLevel, text: cstring)                                                                   {. header: rl_header, importc: "TraceLog", varargs     .}
proc get_screen_width*(): cint                                                                                            {. header: rl_header, importc: "GetScreenWidth"        .}
proc get_screen_height*(): cint                                                                                           {. header: rl_header, importc: "GetScreenHeight"       .}
proc get_mouse_x*(): cint                                                                                                 {. header: rl_header, importc: "GetMouseX"             .}
proc get_mouse_y*(): cint                                                                                                 {. header: rl_header, importc: "GetMouseY"             .}
proc set_shader_value*(shader: Shader, locIndex: cint, value: pointer, uniformType: ShaderUniformDataType)                {. header: rl_header, importc: "SetShaderValue"        .}
proc set_shader_value_v*(shader: Shader, locIndex: cint, valie: pointer, uniformType: ShaderUniformDataType, count: cint) {. header: rl_header, importc: "SetShaderValueV"       .}
proc clear_background*(color: Color)                                                                                      {. header: rl_header, importc: "ClearBackground"       .}
proc get_color*(hexValue: cuint): Color                                                                                   {. header: rl_header, importc: "GetColor"              .}
proc color_from_hsv*(hue, saturation, value: cfloat): Color                                                               {. header: rl_header, importc: "ColorFromHSV"          .}
proc begin_drawing*()                                                                                                     {. header: rl_header, importc: "BeginDrawing"          .}
proc end_drawing*()                                                                                                       {. header: rl_header, importc: "EndDrawing"            .}
proc begin_texture_mode*(target: RenderTexture2D)                                                                         {. header: rl_header, importc: "BeginTextureMode"      .}
proc end_texture_mode*()                                                                                                  {. header: rl_header, importc: "EndTextureMode"        .}
proc begin_shader_mode*(shader: Shader)                                                                                   {. header: rl_header, importc: "BeginShaderMode"       .}
proc end_shader_mode*()                                                                                                   {. header: rl_header, importc: "EndShaderMode"         .}
proc get_time(): cdouble                                                                                                  {. header: rl_header, importc: "GetTime"               .}
proc draw_rectangle*(posX: cint, posY: cint, width: cint, height: cint, color: Color)                                     {. header: rl_header, importc: "DrawRectangle"         .}
proc draw_circle_v*(center: Vector2, radius: cfloat, color: Color)                                                        {. header: rl_header, importc: "DrawCircleV"           .}
proc load_render_texture*(width: cint, height: cint): RenderTexture2D                                                     {. header: rl_header, importc: "LoadRenderTexture"     .}
proc unload_render_texture*(texture: RenderTexture2D)                                                                     {. header: rl_header, importc: "UnloadRenderTexture"   .}
proc is_mouse_button_released*(button: MouseButton): cint                                                                 {. header: rl_header, importc: "IsMouseButtonReleased" .}
proc load_image_from_texture*(texture: Texture2D): Image                                                                  {. header: rl_header, importc: "LoadImageFromTexture"  .}
proc unload_image*(image: Image)                                                                                          {. header: rl_header, importc: "UnloadImage"           .}
proc export_image*(image: Image, filename: cstring)                                                                       {. header: rl_header, importc: "ExportImage"           .}
proc get_frame_time*(): cfloat                                                                                            {. header: rl_header, importc: "GetFrameTime"          .}
proc is_key_pressed*(key: KeyboardKey): bool                                                                              {. header: rl_header, importc: "IsKeyPressed"          .}

proc `+`*(a, b: Vector2): Vector2 =
    return Vector2(x: a.x + b.x, y: a.y + b.y)

proc `*`*(a: Vector2, b: cfloat): Vector2 =
    return Vector2(x: a.x * b, y: a.y * b)

proc `+=`*(a: var Vector2, b: Vector2) =
    a.x += b.x
    a.y += b.y

{.hint[XDeclaredButNotUsed]: off.}

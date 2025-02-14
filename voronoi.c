#include <stdio.h>
#include <assert.h>
#include <raylib.h>

static inline Vector4 color_to_vec4(Color c) {
    return (Vector4){
        .x = c.r/255.0f,
        .y = c.g/255.0f,
        .z = c.g/255.0f,
        .w = c.a/255.0f,
    };
}

int main() {
    int width = 1600, height = 900;

    InitWindow(width, height, "Voronoi");
    SetTargetFPS(60);

    const char *vertex_shader_file_path = "./shaders/vertex.glsl";
    const char *fragment_shader_file_path = "./shaders/fragment.glsl";
    Shader shader = LoadShader(vertex_shader_file_path, fragment_shader_file_path);
    assert(IsShaderValid(shader));

    int time_uniform_location = GetShaderLocation(shader, "time");
    TraceLog(LOG_INFO, "Time Uniform Location: %d", time_uniform_location);

    int voronoi_point_count_uniform_location = GetShaderLocation(shader, "voronoi_point_count");
    TraceLog(LOG_INFO, "Voronoi Point Count Uniform Location: %d", voronoi_point_count_uniform_location);

    int voronoi_points_uniform_location = GetShaderLocation(shader, "voronoi_points");
    TraceLog(LOG_INFO, "Voronoi Points Uniform Location: %d", voronoi_points_uniform_location);

    int voronoi_points_color_uniform_location = GetShaderLocation(shader, "voronoi_points_color");
    TraceLog(LOG_INFO, "Voronoi Points Color Uniform Location: %d", voronoi_points_color_uniform_location);

    // int resolution_uniform_location = GetShaderLocation(shader, "resolution");
    // TraceLog(LOG_INFO, "Resolution Uniform Location: %d", resolution_uniform_location);

    // const float resolution[2] = { GetScreenWidth(), GetScreenHeight(), };
    // SetShaderValue(shader, resolution_uniform_location, resolution, SHADER_UNIFORM_VEC2);

    Vector2 points[] = {
        { GetScreenWidth()/2.0f, GetScreenHeight()/2.0f },

        { GetScreenWidth()/2.0f + GetScreenWidth()/4.0f, GetScreenHeight()/2.0f + GetScreenHeight()/4.0f, },

        { GetScreenWidth()/2.0f - GetScreenWidth()/4.0f, GetScreenHeight()/2.0f - GetScreenHeight()/4.0f, },

        { GetScreenWidth()/2.0f - GetScreenWidth()/4.0f, GetScreenHeight()/2.0f + GetScreenHeight()/4.0f, },

        { GetScreenWidth()/2.0f + GetScreenWidth()/4.0f, GetScreenHeight()/2.0f - GetScreenHeight()/4.0f, },

        { GetMouseX(), GetMouseY(), },
    };
    Vector4 points_color[] = {
        color_to_vec4(VIOLET),
        color_to_vec4(RAYWHITE),
        color_to_vec4(BLUE),
        color_to_vec4(DARKBLUE),
        color_to_vec4(BEIGE),
        color_to_vec4(LIME),
    };
    static_assert(sizeof(points)/sizeof(*points) == sizeof(points_color) / sizeof(*points_color));

    const int voronoi_point_count = sizeof(points)/sizeof(*points);

    SetShaderValue(shader, voronoi_point_count_uniform_location, &voronoi_point_count, SHADER_UNIFORM_INT);
    SetShaderValueV(shader, voronoi_points_color_uniform_location, points_color, SHADER_UNIFORM_VEC4, voronoi_point_count);

    TraceLog(LOG_INFO, "Point count %d", voronoi_point_count);

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(GetColor(0x181818ff));
        BeginShaderMode(shader);

        float time = GetTime();
        SetShaderValue(shader, time_uniform_location, &time, SHADER_UNIFORM_FLOAT);
        DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), WHITE);

        points[voronoi_point_count-1] = (Vector2) {
            .x = GetMouseX(),
            .y = GetMouseY(),
        };
        SetShaderValueV(shader, voronoi_points_uniform_location, points, SHADER_UNIFORM_VEC2, voronoi_point_count);

        EndShaderMode();
        for (int i = 0; i < voronoi_point_count; i++) {
            DrawCircleV(points[i], 5.0f, BLACK);
        }
        EndDrawing();
    }
    UnloadShader(shader);
    CloseWindow();
    return 0;
}

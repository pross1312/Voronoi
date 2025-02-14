#version 330
#define M_PI 3.1415926535897932384626433832795
#define MAP01(x) (((x) + 1.0f) / 2.0f)

// raylib default variables from vertex shader
in vec2 fragTexCoord;
in vec4 fragColor;
uniform sampler2D texture0;
uniform vec4 colDiffuse;

in vec3 vertexPos;
uniform float time;
uniform vec2 voronoi_points[128];
uniform int voronoi_point_count;
uniform vec4 voronoi_points_color[128];

out vec4 finalColor;

float vec_square_distance(vec2 v1, vec2 v2) {
    return (v1.y - v2.y) * (v1.y - v2.y) + (v1.x - v2.x) * (v1.x - v2.x);
}

void main() {
    vec2 a = voronoi_points[0];
    float min_distance = 1e9;
    int point_index = -1;
    for (int i = 0; i < voronoi_point_count && i < 128; i++) {
        float distance = vec_square_distance(voronoi_points[i], vertexPos.xy);
        if (distance < min_distance) {
            min_distance = distance;
            point_index = i;
        }
    }
    if (point_index != -1) {
        finalColor = voronoi_points_color[point_index];
    } else {
        finalColor = texture(texture0, fragTexCoord);
    }
    // if (point_index == 0) {
    //     finalColor = vec4(1, 0, 0, 1);
    // } else if (point_index == 1) {
    //     finalColor = vec4(0, 1, 0, 1);
    // } else {
    //     finalColor = vec4(0, 0, 1, 1);
    // }
}

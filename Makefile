RAYLIB_DIR=./raylib-5.5_linux_amd64/
CFLAGS=-Wall -Wextra -I$(RAYLIB_DIR)/include/
LIBS=-L$(RAYLIB_DIR)/lib/ -lraylib -lm
SHADER_DIR=./shaders


voronoi: voronoi.c $(SHADER_DIR)/vertex.glsl $(SHADER_DIR)/fragment.glsl
	gcc -o voronoi $(CFLAGS) voronoi.c $(LIBS)

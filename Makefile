RAYLIB_DIR=./raylib-5.5_linux_amd64/
CFLAGS=-Wall -Wextra -I$(RAYLIB_DIR)/include/
LIBS=-L$(RAYLIB_DIR)/lib/ -lraylib -lm
SHADER_DIR=./shaders

# .PHONY: all
# all: voronoi voronoi_c

# voronoi_c: voronoi.c $(SHADER_DIR)/vertex.glsl $(SHADER_DIR)/fragment.glsl
# 	gcc -o voronoi_c $(CFLAGS) voronoi.c $(LIBS)

voronoi: voronoi.nim $(SHADER_DIR)/vertex.glsl $(SHADER_DIR)/fragment.glsl raylib.nim
	nim --cincludes:$(RAYLIB_DIR)/include/ --clibdir:$(RAYLIB_DIR)/lib/ --clib:raylib --clib:m c voronoi.nim

#[compute]
#version 450

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;

layout(rgba16f, binding = 0, set = 0) uniform image2D screen_tex;
layout(binding = 0, set = 1) uniform sampler2D depth_tex;

layout(push_constant, std430) uniform Params {
	vec2 screen_size;
	float inv_proj_2w;
	float inv_proj_3w;
} p;

void main() {
	ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
	vec2 size = p.screen_size;
	vec2 uv = pxiel / size;
	
	if(pixel.x >= size.x || pixel.y >= size.y) return;
	
	float depth = texture(depth_tex, uv).r;
	float linear_depth = 1.0 / depth * p*inv_proj_2w + p.inv_proj_3w);
	linear_depth = clamp(linear_depth / 50, 0, 1)
	
	vec4 color = imageLoad(screen_tex, pixel, color);
	
	color.rgb = vec3(linear_depth);
	
	imageStore(screen_tex, pixel, color);
}
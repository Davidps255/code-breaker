#[compute]
#version 450

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;

layout(rgba16f, binding = 0, set = 0) uniform image2D screen_tex;
layout(binding = 0, set = 1) uniform sampler2D depth_tex;

layout(push_constant, std430) uniform Params {
	vec2 screen_size;
	vec2 outline_color_rg;
	vec2 outline_color_ba;
	float inv_proj_2w;
	float inv_proj_3w;
	float outline_thickness;
	float step_threshold;
} p;

float LinearDepth(vec2 uv) {
	float depth = texture(depth_tex, uv).r;
	depth = 1. / (depth * p.inv_proj_2w + p.inv_proj_3w);
	depth = clamp(depth / 50., 0, 1);
	return depth;
}

float AbsoluteDifference(float a, float b) {
	return abs(abs(a) - abs(b));
}

void main() {
	ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
	vec2 size = p.screen_size;
	vec2 uv = pixel / size;
	vec3 outline_color = vec3(p.outline_color_rg.r, p.outline_color_rg.g, p.outline_color_ba.r);
	
	if(pixel.x >= size.x || pixel.y >= size.y) return;
	
	float depth = LinearDepth(uv);
	vec2 outline = (p.outline_thickness / depth) / size;
	float border_r = LinearDepth(uv + vec2(outline.x, 0));
	float border_l = LinearDepth(uv + vec2(-outline.x, 0));
	float border_d = LinearDepth(uv + vec2(0, outline.y));
	float border_u = LinearDepth(uv + vec2(0, -outline.y));
	float border = AbsoluteDifference(border_d, depth)
		+ AbsoluteDifference(border_u, depth)
		+ AbsoluteDifference(border_r, depth)
		+ AbsoluteDifference(border_l, depth);
	border = step(p.step_threshold, clamp(border, 0., 1.));
	
	vec4 color = imageLoad(screen_tex, pixel);
	color.rgb *= vec3(1. - border);
	color.rgb += border * outline_color;
	imageStore(screen_tex, pixel, color);
}
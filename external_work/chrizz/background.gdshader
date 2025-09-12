shader_type canvas_item;

uniform highp float spin_rotation_speed = 2.0;
uniform highp float move_speed = 7.0;
uniform highp vec2 offset = vec2(0., 0.);
uniform highp vec4 colour_1 : source_color = vec4(0.871, 0.267, 0.231, 1.0);
uniform highp vec4 colour_2 : source_color = vec4(0.0, 0.42, 0.706, 1.0);
uniform highp vec4 colour_3 : source_color = vec4(0.086, 0.137, 0.145, 1.0);
uniform highp float contrast = 3.5;
uniform highp float lighting = 0.4;
uniform highp float spin_amount = 0.25;
uniform highp float pixel_filter = 740.;
uniform bool is_rotating = false;
#define SPIN_EASE 1.0


vec4 effect(vec2 screenSize, vec2 screen_coords){

	highp float pixel_size = length(screenSize.xy) / pixel_filter;
    highp vec2 uv = (floor(screen_coords.xy*(1./pixel_size))*pixel_size - 0.5*screenSize.xy)/length(screenSize.xy) - offset;
    highp float uv_len = length(uv);


    highp float speed = (spin_rotation_speed*SPIN_EASE*0.2);
	if(is_rotating){
		speed = TIME * speed;
	}
	speed += 302.2;
    highp float new_pixel_angle = (atan(uv.y, uv.x)) + speed - SPIN_EASE*20.*(1.*spin_amount*uv_len + (1. - 1.*spin_amount));
    highp vec2 mid = (screenSize.xy/length(screenSize.xy))/2.;
    uv = (vec2((uv_len * cos(new_pixel_angle) + mid.x), (uv_len * sin(new_pixel_angle) + mid.y)) - mid);

    uv *= 30.;
    speed = TIME*(move_speed);
	highp vec2 uv2 = vec2(uv.x+uv.y);

	for(int i=0; i < 5; i++) {
		uv2 += sin(max(uv.x, uv.y)) + uv;
		uv  += 0.5*vec2(cos(5.1123314 + 0.353*uv2.y + speed*0.131121),sin(uv2.x - 0.113*speed));
		uv  -= 1
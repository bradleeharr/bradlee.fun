precision highp float;

uniform float u_time;
uniform float u_spin_time;
uniform vec4 u_colour_1;
uniform vec4 u_colour_2;
uniform vec4 u_colour_3;
uniform float u_contrast;
uniform float u_spin_amount;
uniform vec2 u_resolution;
uniform sampler2D u_image;

varying vec2 v_texCoord;

#define PIXEL_SIZE_FAC 700.0
#define SPIN_EASE 0.5

void main() {
    vec2 screen_coords = gl_FragCoord.xy;
    
    float pixel_size = length(u_resolution)/PIXEL_SIZE_FAC;
    // Convert to UV coords and floor for pixel effect
    vec2 uv = (floor(screen_coords*(1.0/pixel_size))*pixel_size - 0.5*u_resolution)/length(u_resolution) - vec2(0.12, 0.0);
    float uv_len = length(uv);

    float speed = (u_spin_time*SPIN_EASE*0.2) + 302.2;
    float new_pixel_angle = (atan(uv.y, uv.x)) + speed - SPIN_EASE*20.0*(1.0*u_spin_amount*uv_len + (1.0 - 1.0*u_spin_amount));
    vec2 mid = (u_resolution/length(u_resolution))/2.0;
    uv = (vec2((uv_len * cos(new_pixel_angle) + mid.x), (uv_len * sin(new_pixel_angle) + mid.y)) - mid);

    // Now add the paint effect to the swirled UV
    uv *= 30.0;
    speed = u_time*(2.0);
    vec2 uv2 = vec2(uv.x+uv.y);

    for(int i=0; i < 5; i++) {
        uv2 += sin(max(uv.x, uv.y)) + uv;
        uv  += 0.5*vec2(cos(5.1123314 + 0.353*uv2.y + speed*0.131121), sin(uv2.x - 0.113*speed));
        uv  -= 1.0*cos(uv.x + uv.y) - 1.0*sin(uv.x*0.711 - uv.y);
    }

    float contrast_mod = (0.25*u_contrast + 0.5*u_spin_amount + 1.2);
    float paint_res = min(2.0, max(0.0,length(uv)*0.035*contrast_mod));
    float c1p = max(0.0,1.0 - contrast_mod*abs(1.0 - paint_res));
    float c2p = max(0.0,1.0 - contrast_mod*abs(paint_res));
    float c3p = 1.0 - min(1.0, c1p + c2p);

    vec4 ret_col = (0.3/u_contrast)*u_colour_1 + 
                   (1.0 - 0.3/u_contrast)*(u_colour_1*c1p + u_colour_2*c2p + vec4(c3p*u_colour_3.rgb, c3p*u_colour_1.a));

    // If you want to blend with an image:
    // vec4 baseImage = texture2D(u_image, v_texCoord);
    // ret_col = mix(baseImage, ret_col, 0.5); // 50% blend
    
    gl_FragColor = ret_col;
}

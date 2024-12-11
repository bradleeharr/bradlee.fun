attribute vec2 a_position;
varying vec2 v_texCoord;

void main() {
    // a_position is in clip space coordinates (-1 to 1)
    v_texCoord = (a_position * 0.5) + 0.5;
    gl_Position = vec4(a_position, 0.0, 1.0);
}

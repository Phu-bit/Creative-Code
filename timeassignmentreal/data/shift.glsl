uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) {
    vec2 mid = vec2(0.5,0.5);
    vec2 coord = (vertTexCoord.st - mid) * 0.9  + mid;
    float d = pow(distance(coord, mid),2)*.1;
    vec2 dir= normalize(coord - mid);
    vec4 col1 = texture2D(texture, coord + dir*d);
    float d2 = pow(distance(coord, mid),2)*.115;
    vec4 col2 = texture2D(texture, coord + dir*d2);

    vec4 c = vec4( col1.r, col2.g, col2.b, 1.0);

    gl_FragColor = c;
}

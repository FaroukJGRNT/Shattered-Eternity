shader_type canvas_item;
render_mode blend_add;

uniform vec3 light_color : source_color = vec3(1.0, 0.95, 0.85);
uniform float intensity = 1.0;

uniform int ray_count = 6;
uniform float base_angle = -0.7;
uniform float angle_variation = 0.25;


/* Random stable */
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

void fragment() {
    vec2 uv = UV;
    float light = 0.0;

    /* La lumière vient d'en haut */
    float height_mask = smoothstep(0.0, 0.6, uv.y);

    for (int i = 0; i < ray_count; i++) {

        float seed = float(i) * 19.73;

        /* Direction du rayon */
        float angle_offset = (hash(seed) - 0.5) * angle_variation;
        float ray_angle = base_angle + angle_offset;

        vec2 dir = normalize(vec2(cos(ray_angle), sin(ray_angle)));

        /* Normale perpendiculaire à la direction */
        vec2 normal = vec2(-dir.y, dir.x);

        /* Décalage du rayon */
        float offset = (hash(seed + 3.3) - 0.5) * 0.8;
        vec2 ray_origin = vec2(0.5) + normal * offset;

        /* Épaisseur variable */
        float thickness = mix(0.02, 0.12, hash(seed + 9.9));

        /* DISTANCE À LA DROITE */
        float dist = abs(dot(normal, uv - ray_origin));

        /* Bande lumineuse */
        float ray = smoothstep(thickness, 0.0, dist);

        light += ray;
    }

    light = clamp(light, 0.0, 1.0);
    light *= height_mask * intensity;

    COLOR = vec4(light_color * light, light);
}

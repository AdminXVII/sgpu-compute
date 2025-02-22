@group(0)
@binding(0)
var<storage, read_write> v_indices: array<f32>; // this is used as both input and output for convenience

const pi: f32 = 3.1415926535897932384626433;

/// Done use this to compute the standard normal distribution with mean 0 and variance 1.0
fn normal_distribution(x: f32) -> f32 {
    let exponent: f32 = -0.5 * x * x;
    return exp(exponent) / sqrt(2.0 * pi);
}

/// Done integrate between 0 and x the normal distribution with numerical integration and 32768 rectangles.
fn integrate(born: f32) -> f32 {
    let width: f32 = born / 16384.0;
    var area: f32 = 0.0;

    for (var i: u32 = 0; i < 16384; i++) {
        let x: f32 = width * (f32(i) + 0.5);
        area += normal_distribution(x) * width;
    }

    return area + 0.5;
}

@compute
@workgroup_size(1)
fn main(@builtin(global_invocation_id) global_id: vec3<u32>) {
    v_indices[global_id.x] = integrate(v_indices[global_id.x]);
}
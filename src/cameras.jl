using LocalMemoize

abstract type Camera end

struct PerspectiveCamera <: Camera
    eye::Vector3
    front::Vector3
    ref_up::Vector3
    fov::Float64
end
get_right(pc::PerspectiveCamera) = pc.front × pc.ref_up
get_up(pc::PerspectiveCamera) = get_right(pc) × pc.front
fov_scale(pc::PerspectiveCamera) = tan(pc.fov / 2) * 2

@memoize function generate_ray(@memo(pc::PerspectiveCamera), x::Real, y::Real)
    @assert 0 <= x <= 1
    @assert 0 <= y <= 1
    @memo 𝐫 = get_right(pc) * fov_scale(pc)
    @memo 𝐮 = get_up(pc) * fov_scale(pc)
    Ray3(pc.eye, normalize(pc.front + 𝐫 * (x - 0.5) + 𝐮 * (y - 0.5)))
end

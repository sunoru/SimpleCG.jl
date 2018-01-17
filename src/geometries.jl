abstract type Geometry end

struct IntersectResult{T<:Geometry}
    ray::Ray3
    geometry::T
    distance::Float64
    position::Vector3
    normal::Vector3
end

not_hit(g::T) where T <: Geometry = Nullable{IntersectResult{T}}()
hit(ir::Nullable{IntersectResult{T}}) where T = !isnull(ir)
replace_geometry(result::IntersectResult, geometry::Geometry) = 
    IntersectResult(result.ray, geometry, result.distance, result.position, result.normal)

struct GeometryWithMaterial{T <: Geometry, V <: Material} <: Geometry
    geometry::T
    material::V
end

function ∩(ray::Ray3, gwm::GeometryWithMaterial)
    result = ray ∩ gwm.geometry
    if !hit(result)
        return result
    end
    Nullable(replace_geometry(result.value, gwm))
end

struct UnionGeometry <: Geometry
    geometries::Vector{Geometry}
end

function ∩(ray::Ray3, ug::UnionGeometry)
    result = not_hit(ug)
    for geometry in ug.geometries
        tmp = ray ∩ geometry 
        if hit(tmp) && (!hit(result) || tmp.value.distance < result.value.distance)
            result = tmp
        end
    end
    result
end

struct Sphere <: Geometry
    center::Vector3
    radius::Float64
end

function ∩(ray::Ray3, s::Sphere)
    𝐯 = ray.origin - s.center
    a0 = norm²(𝐯) - s.radius^2
    ddotv = ray.direction ⋅ 𝐯
    if ddotv <= 0
        discr = ddotv^2 - a0
        if discr >= 0
            distance = -ddotv - √discr
            position = get_point(ray, distance)
            normal = normalize(position - s.center)
            return Nullable(IntersectResult(ray, s, distance, position, normal))
        end
    end
    return not_hit(s)
end

struct Plane <: Geometry
    normal::Vector3
    distance::Float64
end

function ∩(ray::Ray3, s::Plane)
     ldotn = ray.direction ⋅ s.normal
     if ldotn >= 0
        return not_hit(s)
     end
     xdotn = ray.origin ⋅ s.normal
     distance = (s.distance - xdotn) / ldotn
     position = get_point(ray, distance)
     normal = s.normal
     return Nullable(IntersectResult(ray, s, distance, position, normal))
end

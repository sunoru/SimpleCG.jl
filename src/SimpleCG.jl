module SimpleCG

include("basic_types.jl")
export Vector3, Ray3, Canvas, ColorRGB,
    Black, White, Red, Green, Blue,
    imshow

include("config.jl")
export LightDirection, LightColor

include("materials.jl")
export Material, sample,
    CheckerMaterial, PhongMaterial

include("geometries.jl")
export Geometry, IntersectResult, hit,
    UnionGeometry, GeometryWithMaterial,
    Sphere, Plane

include("cameras.jl")
export Camera, right, up, generate_ray,
    PerspectiveCamera

include("lights.jl")
export Light, Lights, LightSample, InShadow, in_shadow,
    DirectionalLight, PointLight, SpotLight

include("render.jl")
export render!

end

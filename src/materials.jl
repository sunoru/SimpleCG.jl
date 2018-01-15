abstract type Material end

struct CheckerMaterial <: Material
    scale::Float64
    reflectiveness::Float64
end
CheckerMaterial(scale) = CheckerMaterial(scale, 0)

function sample(cm::CheckerMaterial, ray::Ray3, position::Vector3, normal::Vector3)
    abs(Int64(floor(position.x * cm.scale) + floor(position.z * cm.scale))) & 1 == 0 ? Black : White
end

struct PhongMaterial <: Material
    diffuse::ColorRGB
    specular::ColorRGB
    shininess::Int64
    reflectiveness::Float64
end
PhongMaterial(diffuse, specular, shininess) = PhongMaterial(diffuse, specular, shininess, 0)

function sample(cm::PhongMaterial, ray::Ray3, position::Vector3, normal::Vector3)
    ndotl = normal ⋅ LightDirection()
    𝐡 = LightDirection() - ray.direction |> normalize
    ndoth = normal ⋅ 𝐡
    diffuse_term = cm.diffuse * max(ndotl, 0)
    specular_term = cm.specular * max(ndoth, 0)^cm.shininess
    modulate(LightColor(), diffuse_term + specular_term)
end

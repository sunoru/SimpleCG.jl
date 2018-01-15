using LocalMemoize

abstract type Light end

const Lights = Vector{Light}

struct LightSample
    light_vector::Vector3
    irradiance::ColorRGB
end
zero(::Type{LightSample}) = LightSample(zero(Vector3), Black)
InShadow() = zero(LightSample)
in_shadow(ls::LightSample) = ls.light_vector == zero(Vector3)

function shadow_test(𝐥::Vector3, position::Vector3, scene::Geometry, r::Float64=∞)
    shadow_ray = Ray3(position, 𝐥)
    shadow_result = shadow_ray ∩ scene
    hit(shadow_result) && shadow_result.value.distance <= r
end

struct DirectionalLight <: Light
    irradiance::ColorRGB
    direction::Vector3
    shadow::Bool
end
DirectionalLight(irradiance, direction) = DirectionalLight(irradiance, direction, true)
@memoize get_𝐥(dl::DirectionalLight) = -normalize(dl.direction)

function sample(@memo(dl::DirectionalLight), scene::Geometry, position::Vector3)
    𝐥 = get_𝐥(dl)
    if dl.shadow && shadow_test(𝐥, position, scene)
        return InShadow()
    end
    LightSample(𝐥, dl.irradiance)
end

struct PointLight <: Light
    intensity::ColorRGB
    position::Vector3
    shadow::Bool
end
PointLight(intensity, position) = PointLight(intensity, position, true)

function sample(pl::PointLight, scene::Geometry, position::Vector3)
    Δr = pl.position - position
    r² = norm²(Δr)
    r = √r²
    𝐥 = Δr / r
    if pl.shadow && shadow_test(𝐥, position, scene, r)
        return InShadow()
    end
    LightSample(𝐥, pl.intensity / r²)
end

struct SpotLight <: Light
    intensity::ColorRGB
    position::Vector3
    direction::Vector3
    θ::Float64
    ϕ::Float64
    falloff::Float64
    shadow::Bool
end
SpotLight(intensity, position, direction, θ, ϕ, falloff) = SpotLight(
    intensity, position, direction, θ, ϕ, falloff, true)

@memoize function sample(@memo(sl::SpotLight), scene::Geometry, position::Vector3)
    @memo 𝐬 = -normalize(sl.direction)
    @memo cosθ = cos(sl.θ / 2)
    @memo cosϕ = cos(sl.ϕ / 2)
    @memo base_multiplier = 1 / (cosθ - cosϕ)
    Δr = sl.position - position
    r² = norm²(Δr)
    r = √r²
    𝐥 = Δr / r
    if sl.shadow && shadow_test(𝐥, position, scene, r)
        return InShadow()
    end
    sdotl = 𝐬 ⋅ 𝐥 
    if sdotl >= cosθ
        spot = 1.0
    elseif sdotl <= cosϕ
        spot = 0.0
    else
        spot = ((sdotl - cosϕ) * base_multiplier) ^ sl.falloff
    end
    LightSample(𝐥, sl.intensity * spot / r²)
end
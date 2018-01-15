import Base: ==, ⋅, ×, +, -, *, /, norm, normalize, zero, ∩
import Images: colorview, RGBA
import ImageView: imshow

struct Vector3
    x::Float64
    y::Float64
    z::Float64
end
Vector3() = Vector3(0, 0, 0)

==(𝐚::Vector3, 𝐛::Vector3) = 𝐚.x == 𝐛.x && 𝐚.y == 𝐛.y && 𝐚.z == 𝐛.z

⋅(𝐚::Vector3, 𝐛::Vector3) = 𝐚.x * 𝐛.x + 𝐚.y * 𝐛.y + 𝐚.z * 𝐛.z
×(𝐚::Vector3, 𝐛::Vector3) = Vector3(
    𝐚.y * 𝐛.z - 𝐚.z * 𝐛.y,
    𝐚.z * 𝐛.x - 𝐚.x * 𝐛.z,
    𝐚.x * 𝐛.y - 𝐚.y * 𝐛.x
)
+(𝐚::Vector3, 𝐛::Vector3) = Vector3(𝐚.x + 𝐛.x, 𝐚.y + 𝐛.y, 𝐚.z + 𝐛.z)
-(𝐚::Vector3, 𝐛::Vector3) = Vector3(𝐚.x - 𝐛.x, 𝐚.y - 𝐛.y, 𝐚.z - 𝐛.z)
*(𝐚::Vector3, μ::Real) = Vector3(𝐚.x * μ, 𝐚.y * μ, 𝐚.z * μ)
/(𝐚::Vector3, μ::Real) = Vector3(𝐚.x / μ, 𝐚.y / μ, 𝐚.z / μ)
*(μ::Real, 𝐚::Vector3) = 𝐚 * μ
-(𝐯::Vector3) = Vector3(-𝐯.x, -𝐯.y, -𝐯.z)

norm²(𝐯::Vector3) = 𝐯 ⋅ 𝐯
norm(𝐯::Vector3) = √norm²(𝐯)
normalize(𝐯::Vector3) = 𝐯 / norm(𝐯)
zero(::Type{Vector3}) = Vector3(0, 0, 0)

∥(𝐚::Vector3, 𝐛::Vector3) = 𝐚 × 𝐛 == zero(Vector3)
⟂(𝐚::Vector3, 𝐛::Vector3) = 𝐚 ⋅ 𝐛 == 0

struct Ray3
    origin::Vector3
    direction::Vector3
end
get_point(ray::Ray3, t::Real) = ray.origin + ray.direction * t

const Canvas = Array{Float64, 3}
Canvas(width, height) = zeros(4, width, height)
width(c::Canvas) = size(c)[2]
height(c::Canvas) = size(c)[3]

imshow(c::Canvas, args...) = imshow(colorview(RGBA, c), args...)

abstract type Color end

struct ColorRGB <: Color
    r::Float64
    g::Float64
    b::Float64
end
const Black = ColorRGB(0, 0, 0)
const White = ColorRGB(1, 1, 1)
const Red = ColorRGB(1, 0, 0)
const Green = ColorRGB(0, 1, 0)
const Blue = ColorRGB(0, 0, 1)

+(a::ColorRGB, b::ColorRGB) = ColorRGB(a.r + b.r, a.g + b.g, a.b + b.b)
*(c::ColorRGB, μ::Real) = ColorRGB(c.r * μ, c.g * μ, c.b * μ)
*(μ::Real, c::ColorRGB) = c * μ
/(c::ColorRGB, μ::Real) = c * (1 / μ)

modulate(a::ColorRGB, b::ColorRGB) = ColorRGB(a.r * b.r, a.g * b.g, a.b * b.b)

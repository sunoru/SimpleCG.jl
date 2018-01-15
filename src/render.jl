function inner_render!(canvas::Canvas, scene::Geometry, camera::Camera, render_func!::Function, args...)
    w, h = width(canvas), height(canvas)
    for x = 1:h
        sx = x / h
        for y = 1:w
            sy = 1 - y / w
            ray = generate_ray(camera, sx, sy)
            result = ray ∩ scene
            if hit(result)
                render_func!(canvas, x, y, scene, result.value, args...)
            end
        end
    end
    canvas
end

function put_color!(canvas::Canvas, x::Int64, y::Int64, color::ColorRGB)
    canvas[1, y, x] = color.r
    canvas[2, y, x] = color.g
    canvas[3, y, x] = color.b
    canvas[4, y, x] = 1.0
end

function ray_trace_color(scene::Geometry, result::IntersectResult{T}, max_reflect::Int64) where T <: GeometryWithMaterial
    reflectiveness = result.geometry.material.reflectiveness
    color = sample(result.geometry.material, result.ray, result.position, result.normal)
    color *= 1 - reflectiveness
    if reflectiveness > 0 && max_reflect > 0
        new_ray = Ray3(result.position, result.ray.direction ⋅ result.normal * (-2) * result.normal + result.ray.direction)
        new_result = new_ray ∩ scene
        if hit(new_result)
            reflected_color = ray_trace_color(scene, new_result.value, max_reflect - 1)
        else 
            reflected_color = Black
        end
        color += reflected_color
    end
    return color
end

function ray_trace_render!(canvas::Canvas, x::Int64, y::Int64, scene::Geometry, result::IntersectResult{T},
    max_reflect::Int64) where T <: GeometryWithMaterial
    color = ray_trace_color(scene, result, max_reflect)
    put_color!(canvas, x, y, color)
end

function light_render!(canvas::Canvas, x::Int64, y::Int64, scene::Geometry, result::IntersectResult{T},
    lights::Lights) where T
    color = Black
    for light in lights
        light_sample = sample(light, scene, result.position)
        if !in_shadow(light_sample)
            ndotl = result.normal ⋅ light_sample.light_vector
            if ndotl >= 0
                color += light_sample.irradiance * ndotl
            end
        end
    end
    put_color!(canvas, x, y, color)
end

function render!(canvas::Canvas, scene::Geometry, camera::Camera, max_reflect::Int64=3)
    inner_render!(canvas, scene, camera, ray_trace_render!, max_reflect)
end
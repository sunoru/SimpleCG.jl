using SimpleCG


plane_x = Plane(Vector3(0, 1, 0), 0)
plane_y = Plane(Vector3(0, 0, 1), -50)
plane_z = Plane(Vector3(1, 0, 0), -20)
sphere = Sphere(Vector3(0, 10, -10), 10)

# light = DirectionalLight(White, Vector3(-1.75, -2, -1.5))
# light = PointLight(White * 2000, Vector3(30, 40, 20))
light = SpotLight(White * 2000, Vector3(30, 40, 20), Vector3(-1, -1, -1), π/9, π/6, 0.5)

canvas = Canvas(400, 400);
camera = PerspectiveCamera(Vector3(0, 10, 10), Vector3(0, 0, -1), Vector3(0, 1, 0), π/2)
scene = UnionGeometry([plane_x, plane_y, plane_z, sphere])
SimpleCG.inner_render!(canvas, scene, camera, SimpleCG.light_render!, Lights([light]))
imshow(canvas)

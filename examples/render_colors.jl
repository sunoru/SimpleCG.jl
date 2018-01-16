using SimpleCG

plane_x = Plane(Vector3(0, 1, 0), 0)
plane_y = Plane(Vector3(0, 0, 1), -50)
plane_z = Plane(Vector3(1, 0, 0), -20)

light1 = PointLight(White * 1000, Vector3(30, 40, 20))
light2 = SpotLight(Red * 3000, Vector3(0, 30, 10), Vector3(0, -1, -1), π/9, π/6, 1)
light3 = SpotLight(Green * 3000, Vector3(6, 30, 20), Vector3(0, -1, -1), π/9, π/6, 1)
light4 = SpotLight(Blue * 3000, Vector3(-6, 30, 20), Vector3(0, -1, -1), π/9, π/6, 1)

canvas = Canvas(800, 800);
camera = PerspectiveCamera(Vector3(0, 40, 15), Vector3(0, -1.25, -1), Vector3(0, 1, 0), π/3)
scene = UnionGeometry([plane_x, plane_y, plane_z])
SimpleCG.inner_render!(canvas, scene, camera, SimpleCG.light_render!,
    Lights([light1, light2, light3, light4]))
imshow(canvas)

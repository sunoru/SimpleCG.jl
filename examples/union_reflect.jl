using SimpleCG

plane_g = Plane(Vector3(0, 1, 0), 0);
sphere1_g = Sphere(Vector3(-10, 10, -10), 10);
sphere2_g = Sphere(Vector3(10, 10, -10), 10);
plane = GeometryWithMaterial(plane_g, CheckerMaterial(0.1, 0.5))
sphere1 = GeometryWithMaterial(sphere1_g, PhongMaterial(Red, White, 16, 0.25))
sphere2 = GeometryWithMaterial(sphere2_g, PhongMaterial(Blue, White, 16, 0.25))

canvas = Canvas(1600, 1600);
camera = PerspectiveCamera(Vector3(0, 5, 15), Vector3(0, 0, -1), Vector3(0, 1, 0), π/2)
scene = UnionGeometry([plane, sphere1, sphere2])
render!(canvas, scene, camera, 3);
imshow(canvas)

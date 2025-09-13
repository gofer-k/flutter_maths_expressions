enum ShapeType {
  ellipsoid(value: 'Ellipsoid'),
  hyperboloid_two_shell(value: 'Hyperboloid 2-shell'),
  hyperboloid_one_shell(value: 'Hyperboloid 1-shell'),
  saddle(value: 'Saddle'),
  torus(value: 'Torus'),
  cylinder(value: 'Cylinder');

  final String value;
  const ShapeType({required this.value});
}
enum ShapeType {
  ellipsoid(value: 'Ellipsoid'),
  hyperboloid_two_shell(value: 'Hyperboloid 2-shell'),
  hyperboloid_one_shell(value: 'Hyperboloid 1-shell'),
  saddle(value: 'Saddle'),
  cone(value: 'Cone'),
  cylinder(value: 'Cylinder'),
  hyperbolic_cylinder(value: 'Hyperbolic cylinder');

  final String value;
  const ShapeType({required this.value});
}
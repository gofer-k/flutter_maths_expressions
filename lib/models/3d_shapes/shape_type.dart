enum ShapeType {
  ellipsoid(value: 'Ellipsoid'),
  hyperboloid(value: 'Hyperboloid Shell'),
  torus(value: 'Torus'),
  cylinder(value: 'Cylinder');

  final String value;
  const ShapeType({required this.value});
}
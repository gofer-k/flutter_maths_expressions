import 'dart:math';

import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

extension Ellipsoid on UtilSp3dGeometry {
  static List<Sp3dV3D> _ellipsoid(
      double a, double b, double c,
      int latitudeBands,
      int longitudeBands) {
    List<Sp3dV3D> vertices = [];

    for (int latNumber = 0; latNumber <= latitudeBands; latNumber++) {
      double theta = latNumber * pi / latitudeBands;
      double sinTheta = sin(theta);
      double cosTheta = cos(theta);

      for (int longNumber = 0; longNumber <= longitudeBands; longNumber++) {
        double phi = longNumber * 2 * pi / longitudeBands;
        double sinPhi = sin(phi);
        double cosPhi = cos(phi);

        double x = a * cosPhi * sinTheta;
        double y = b * sinPhi * sinTheta;
        double z = c * cosTheta;
        vertices.add(Sp3dV3D(x, y, z));
      }
    }
    return vertices;
  }

  static Sp3dObj ellipsoid(double a, double b, double c,
      { int latitudeBands = 30, int longitudeBands = 30, Sp3dMaterial? material}) {

    List<Sp3dV3D> vertices = _ellipsoid(a, b, c, latitudeBands, longitudeBands);
    List<Sp3dFragment> fragments = [];

    for (int latNumber = 0; latNumber < latitudeBands; latNumber++) {
      for (int longNumber = 0; longNumber < longitudeBands; longNumber++) {
        int first = (latNumber * (longitudeBands + 1)) + longNumber;
        int second = first + longitudeBands + 1;
        // Define faces for each quad
        // Each quad is made of two triangles
        List<Sp3dFace> faces = [
          Sp3dFace([first, second, first + 1], 0),
          Sp3dFace([second, second + 1, first + 1], 0),
        ];
        fragments.add(Sp3dFragment(faces));
      }
    }

    return Sp3dObj(
      vertices,
      fragments,
      [material ?? FSp3dMaterial.grey.deepCopy()], // Ensure a default material
      []);
  }
}
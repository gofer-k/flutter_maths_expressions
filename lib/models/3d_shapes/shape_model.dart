import 'package:flutter_maths_expressions/models/3d_shapes/saddle.dart';
import 'package:flutter_maths_expressions/models/3d_shapes/shape_type.dart';
import 'package:simple_3d/simple_3d.dart';

import 'cone.dart';
import 'cylinder.dart';
import 'ellipsoid.dart';
import 'hyperboloid_shell.dart';

class ShapeModel {
  double a; // shape's extension through x - axis
  double b; // shape's extension through z - axis
  double c; // shape's extension through y - axis
  ShapeType type;
  ShapeModel({required this.type, required this.a, required this.b, required this.c});

  Sp3dObj display() {
    switch (type) {
      case ShapeType.ellipsoid:
        return Ellipsoid.ellipsoid(a, b, c);
      case ShapeType.hyperboloidOneShell:
        return HyperboloidShell.hyperboloidShell(a, b, c, false, uBands: 20, vBands: 30, uMin: 1.0, uMax: -1.0);
    case ShapeType.hyperboloidTwoShell:
        return HyperboloidShell.hyperboloidShell(a, b, c, true, uBands: 20, vBands: 30, uMin: 1.0, uMax: -1.0);
      case ShapeType.saddle:
        return Saddle.saddle(a, b, c);
      case ShapeType.cone:
        return Cone.cone(radius: a, height: b);
      case ShapeType.cylinder:
        return HyperbolicCylinder.cylinder(radius: a, height: b, addCovers: true);
    }
  }

  Sp3dObj update({required double a, required double b, required double c}) {
    this.a = a;
    this.b = b;
    this.c = c;
    return display();
  }
}
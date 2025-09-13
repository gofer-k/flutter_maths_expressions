import 'package:util_simple_3d/util_simple_3d.dart';

import 'dart:math';

import 'package:simple_3d/simple_3d.dart';

extension Cone on UtilSp3dGeometry {
  /// Creates a 3D cone object.
  ///
  /// The base of the cone lies on the XY plane, centered at the origin,
  /// and the apex points along the positive Z axis.
  ///
  /// Parameters:
  /// - [radius]: The radius of the cone's base.
  /// - [height]: The height of the cone from base to apex.
  /// - [segments]: The number of segments used to approximate the circular base.
  ///              More segments result in a smoother cone but more vertices.
  /// - [material]: Optional material for the cone.
  /// - [addBaseCover]: If true, a circular face will be added to cover the base of the cone.
  static Sp3dObj cone({
    required double radius,
    required double height,
    int segments = 24,
    Sp3dMaterial? material,
    bool addBaseCover = true,
  }) {
    if (radius <= 0) {
      throw ArgumentError("Radius must be positive.");
    }
    if (height == 0) {
      throw ArgumentError("Height cannot be zero for a visible cone.");
      // If height is negative, the cone points along the negative Z axis.
    }
    if (segments < 3) {
      throw ArgumentError("Segments must be at least 3.");
    }

    List<Sp3dV3D> vertices = [];
    List<Sp3dFragment> fragments = [];

    // Add apex vertex
    Sp3dV3D apex = Sp3dV3D(0, 0, height);
    vertices.add(apex);
    int apexIndex = 0;

    // Add base center vertex (only needed if addBaseCover is true)
    int baseCenterIndex = -1;
    if (addBaseCover) {
      Sp3dV3D baseCenter = Sp3dV3D(0, 0, 0);
      vertices.add(baseCenter);
      baseCenterIndex = vertices.length - 1;
    }

    // Add base vertices
    List<int> baseVertexIndices = [];
    for (int i = 0; i < segments; i++) {
      double angle = (i / segments) * 2 * pi;
      double x = radius * cos(angle);
      double y = radius * sin(angle);
      vertices.add(Sp3dV3D(x, y, 0));
      baseVertexIndices.add(vertices.length - 1);
    }

    // Create side faces (triangles connecting apex to base segments)
    for (int i = 0; i < segments; i++) {
      int v1 = baseVertexIndices[i];
      int v2 = baseVertexIndices[(i + 1) % segments]; // Wrap around for the last segment

      // Ensure correct winding order for outward-facing normals
      Sp3dFace sideFace = Sp3dFace([apexIndex, v2, v1], 0);
      fragments.add(Sp3dFragment([sideFace]));
    }

    // Create base cover faces (if requested)
    if (addBaseCover) {
      if (baseCenterIndex == -1) {
        // Should not happen if addBaseCover is true, but as a safeguard.
        Sp3dV3D baseCenter = Sp3dV3D(0, 0, 0);
        vertices.add(baseCenter);
        baseCenterIndex = vertices.length - 1;
      }
      for (int i = 0; i < segments; i++) {
        int v1 = baseVertexIndices[i];
        int v2 = baseVertexIndices[(i + 1) % segments];

        // Ensure correct winding order for outward-facing normals (downwards for base)
        Sp3dFace baseFace = Sp3dFace([baseCenterIndex, v1, v2], 0);
        fragments.add(Sp3dFragment([baseFace]));
      }
    }

    return Sp3dObj(
      vertices,
      fragments,
      [material ?? FSp3dMaterial.grey.deepCopy()],
      [], // No default lines
    );
  }
}
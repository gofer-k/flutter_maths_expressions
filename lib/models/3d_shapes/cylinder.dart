import 'dart:math';

import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

extension HyperbolicCylinder on UtilSp3dGeometry {
  /// Creates a 3D hyperbolic cylinder.
  ///
  /// The cylinder's axis of extrusion is along the Z-axis.
  /// The hyperbolic cross-section is in the XY plane.
  /// The equation for the hyperbola can be (x^2/a^2) - (y^2/b^2) = 1 (for x-axis aligned)
  /// or (y^2/a^2) - (x^2/b^2) = 1 (for y-axis aligned).
  ///
  /// This implementation uses a parametric approach based on cosh and sinh.
  ///
  /// Parameters:
  /// - [a]: Scaling factor for the primary axis of the hyperbola (e.g., related to distance to foci).
  /// - [b]: Scaling factor for the secondary axis of the hyperbola.
  /// - [height]: The height of the cylinder along the Z-axis.
  /// - [uMin], [uMax]: Range for the parametric variable 'u' which traces the hyperbola curve.
  ///                  Controls how much of the hyperbola branches are generated.
  ///                  Typically, uMin = -someValue, uMax = someValue.
  /// - [uSegments]: Number of segments along the hyperbola curve (u direction).
  /// - [hSegments]: Number of segments along the height (Z-axis).
  /// - [opensAlongX]: If true, the hyperbola opens along the X-axis ((x/a)^2 - (y/b)^2 = 1).
  ///                  If false, it opens along the Y-axis ((y/a)^2 - (x/b)^2 = 1).
  /// - [material]: Optional material for the cylinder.
  /// - [addCovers]: If true, adds planar caps at the top and bottom of the extrusion.
  ///                Note: These covers will be flat and match the extent of the generated
  ///                hyperbolic shape, not necessarily simple circles or ellipses.
  static Sp3dObj hyperbolicCylinder({
    required double a,
    required double b,
    required double height,
    double uMin = -1.5,
    double uMax = 1.5,
    int uSegments = 24,
    int hSegments = 2, // Segments along the height
    bool opensAlongX = true,
    Sp3dMaterial? material,
    bool addCovers = false,
  }) {
    if (a <= 0 || b <= 0) {
      throw ArgumentError("a and b parameters must be positive.");
    }
    if (height < 0) {
      throw ArgumentError("height must be non-negative.");
    }
    if (uSegments < 1 || hSegments < 1) {
      throw ArgumentError("uSegments and hSegments must be at least 1.");
    }
    if (uMin >= uMax) {
      throw ArgumentError("uMin must be less than uMax.");
    }

    final List<Sp3dV3D> vertices = [];
    final List<Sp3dFragment> fragments = [];
    final double halfHeight = height / 2.0;
    final double uStep = (uMax - uMin) / uSegments;

    // --- Vertex Generation ---
    final List<List<int>> vertexGrid = List.generate(
      uSegments + 1,
          (_) => List.filled(hSegments + 1, 0, growable: false),
      growable: false,
    );

    for (int i = 0; i <= uSegments; i++) {
      final double u = uMin + i * uStep;
      double x, y;

      // Parametric equations for hyperbola
      if (opensAlongX) {
        x = a * _cosh(u);
        y = b * _sinh(u);
      } else {
        y = a * _cosh(u);
        x = b * _sinh(u);
      }

      for (int j = 0; j <= hSegments; j++) {
        final double hFraction = j / hSegments;
        final double z = -halfHeight + hFraction * height;

        vertices.add(Sp3dV3D(x, y, z));
        vertexGrid[i][j] = vertices.length - 1;
      }
    }

    // --- Side Face Generation ---
    for (int i = 0; i < uSegments; i++) {
      for (int j = 0; j < hSegments; j++) {
        final int v1 = vertexGrid[i][j];
        final int v2 = vertexGrid[i + 1][j];
        final int v3 = vertexGrid[i + 1][j + 1];
        final int v4 = vertexGrid[i][j + 1];

        // Create two triangles for the quad
        final Sp3dFace face1 = Sp3dFace([v1, v2, v4], 0);
        final Sp3dFace face2 = Sp3dFace([v2, v3, v4], 0);
        fragments.add(Sp3dFragment([face1, face2]));
      }
    }

    // --- Cover Generation (if requested) ---
    if (addCovers && uSegments >= 1) {
      // Bottom Cover
      for (int i = 0; i < uSegments - 1; i++) {
        final int v1 = vertexGrid[0][0];
        final int v2 = vertexGrid[i + 1][0];
        final int v3 = vertexGrid[i + 2][0];
        fragments.add(Sp3dFragment([Sp3dFace([v1, v2, v3], 0)]));
      }

      // Top Cover
      for (int i = 0; i < uSegments - 1; i++) {
        final int v1 = vertexGrid[0][hSegments];
        final int v2 = vertexGrid[i + 2][hSegments]; // Reverse order for correct winding
        final int v3 = vertexGrid[i + 1][hSegments];
        fragments.add(Sp3dFragment([Sp3dFace([v1, v2, v3], 0)]));
      }
    }

    return Sp3dObj(
      vertices,
      fragments,
      [material ?? FSp3dMaterial.grey.deepCopy()],
      [],
    );
  }

  // Helper for hyperbolic cosine
  static double _cosh(double x) => (exp(x) + exp(-x)) / 2;

  // Helper for hyperbolic sine
  static double _sinh(double x) => (exp(x) - exp(-x)) / 2;

  /// Creates a 3D cylinder object.
  ///
  /// The cylinder is oriented along the Z-axis, centered at the origin.
  ///
  /// Parameters:
  /// - [radius]: The radius of the cylinder's top and bottom circular faces.
  /// - [height]: The height of the cylinder along the Z-axis.
  /// - [segments]: The number of segments used to approximate the circular faces.
  ///              More segments result in a smoother cylinder but more vertices.
  /// - [material]: Optional material for the cylinder.
  /// - [addCovers]: If true, a circular face will be added to cover the ends.
  static Sp3dObj cylinder({
    required double radius,
    required double height,
    int segments = 24,
    Sp3dMaterial? material,
    bool addCovers = true,
  }) {
    if (radius <= 0) {
      throw ArgumentError("Radius must be positive.");
    }
    if (height < 0) {
      throw ArgumentError("Height must be non-negative.");
    }
    if (segments < 3) {
      throw ArgumentError("Segments must be at least 3.");
    }

    List<Sp3dV3D> vertices = [];
    List<Sp3dFragment> fragments = [];

    double halfHeight = height / 2.0;

    // --- Vertex Generation ---

    // Top and Bottom center vertices (for covers)
    int topCenterIndex = -1;
    int bottomCenterIndex = -1;

    if (addCovers) {
      vertices.add(Sp3dV3D(0, 0, halfHeight));
      topCenterIndex = vertices.length - 1;
      vertices.add(Sp3dV3D(0, 0, -halfHeight));
      bottomCenterIndex = vertices.length - 1;
    }

    // Side vertices
    List<int> topRingIndices = [];
    List<int> bottomRingIndices = [];

    for (int i = 0; i < segments; i++) {
      double angle = (i / segments) * 2 * pi;
      double x = radius * cos(angle);
      double y = radius * sin(angle);

      // Top ring vertex
      vertices.add(Sp3dV3D(x, y, halfHeight));
      topRingIndices.add(vertices.length - 1);

      // Bottom ring vertex
      vertices.add(Sp3dV3D(x, y, -halfHeight));
      bottomRingIndices.add(vertices.length - 1);
    }

    // --- Face Generation ---

    // Side faces (quads made of two triangles)
    for (int i = 0; i < segments; i++) {
      int currentTop = topRingIndices[i];
      int nextTop = topRingIndices[(i + 1) % segments];
      int currentBottom = bottomRingIndices[i];
      int nextBottom = bottomRingIndices[(i + 1) % segments];

      // Triangle 1 of the quad (top-left, bottom-left, top-right)
      // Winding: currentBottom, nextBottom, currentTop
      Sp3dFace face1 = Sp3dFace([currentBottom, nextBottom, currentTop], 0);

      // Triangle 2 of the quad (top-right, bottom-left, bottom-right)
      // Winding: nextBottom, nextTop, currentTop
      Sp3dFace face2 = Sp3dFace([nextBottom, nextTop, currentTop], 0);

      fragments.add(Sp3dFragment([face1, face2]));
    }

    // Top cover faces (if requested)
    if (addCovers) {
      for (int i = 0; i < segments; i++) {
        int v1 = topRingIndices[i];
        int v2 = topRingIndices[(i + 1) % segments];
        // Winding: topCenter, v2, v1 (for outward normal pointing up)
        Sp3dFace topFace = Sp3dFace([topCenterIndex, v2, v1], 0);
        fragments.add(Sp3dFragment([topFace]));
      }
      for (int i = 0; i < segments; i++) {
        int v1 = bottomRingIndices[i];
        int v2 = bottomRingIndices[(i + 1) % segments];
        // Winding: bottomCenter, v1, v2 (for outward normal pointing down)
        Sp3dFace bottomFace = Sp3dFace([bottomCenterIndex, v1, v2], 0);
        fragments.add(Sp3dFragment([bottomFace]));
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
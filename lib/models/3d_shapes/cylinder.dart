
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
    if (height == 0) {
      // Allow zero height for a flat hyperbolic shape, but it might be visually empty
      // if not handled carefully or if covers are off.
    }
    if (uSegments < 1 || hSegments < 1) {
      throw ArgumentError("uSegments and hSegments must be at least 1.");
    }
    if (uMin >= uMax) {
      throw ArgumentError("uMin must be less than uMax.");
    }

    List<Sp3dV3D> vertices = [];
    List<Sp3dFragment> fragments = [];
    double halfHeight = height / 2.0;

    // --- Vertex Generation ---
    for (int j = 0; j <= hSegments; j++) { // Loop along height
      double z = -halfHeight + (j / hSegments) * height;
      for (int i = 0; i <= uSegments; i++) { // Loop along hyperbola curve
        double u = uMin + (i / uSegments) * (uMax - uMin);
        double coshU = (exp(u) + exp(-u)) / 2; // cosh(u)
        double sinhU = (exp(u) - exp(-u)) / 2; // sinh(u)

        double x, y;
        if (opensAlongX) {
          x = a * coshU;
          y = b * sinhU;
        } else {
          y = a * coshU; // 'a' is for the axis it opens along
          x = b * sinhU; // 'b' is for the other axis
        }
        vertices.add(Sp3dV3D(x, y, z));

        // If generating two separate sheets for the hyperbola (when uMin < 0 and uMax > 0 and opensAlongX)
        // or a similar case for opensAlongY, you might need to handle the discontinuity
        // or generate two separate objects.
        // This simplified version generates one continuous surface based on u.
        // For distinct sheets, you might call this function twice with adjusted u ranges or modify deeply.
        // e.g. for opensAlongX: one sheet with x = a * coshU, other with x = -a * coshU
        // This current code produces one sheet where x is positive if a is positive.
        // To get the other sheet, you could invert 'a' or transform the object.
      }
    }

    // --- Side Face Generation ---
    for (int j = 0; j < hSegments; j++) { // Along height
      for (int i = 0; i < uSegments; i++) { // Along hyperbola curve
        int row1 = j * (uSegments + 1);
        int row2 = (j + 1) * (uSegments + 1);

        int v1 = row1 + i;
        int v2 = row1 + i + 1;
        int v3 = row2 + i;
        int v4 = row2 + i + 1;

        // Quad made of two triangles
        // Winding order is important for normals. Adjust if faces are invisible/dark.
        Sp3dFace face1 = Sp3dFace([v1, v3, v2], 0); // Check winding
        Sp3dFace face2 = Sp3dFace([v2, v3, v4], 0); // Check winding
        fragments.add(Sp3dFragment([face1, face2]));
      }
    }

    // --- Cover Generation (Optional) ---
    if (addCovers && height != 0) {
      // Bottom Cover
      List<int> bottomIndices = [];
      for (int i = 0; i <= uSegments; i++) {
        bottomIndices.add(i); // Vertices from the first height segment

        // We need to create faces for the bottom. This is tricky because the shape isn't
        // a simple convex polygon. Triangulation of a general polygon is complex.
        // For a simple approach, we can try a fan from the first vertex of the strip.
        // This works if the shape is somewhat convex or star-shaped from that point.
        if (uSegments >= 2) { // Need at least 3 vertices for a triangle
          for (int i = 0; i < uSegments - 1; i++) {
            // Winding: v0, v(i+1), v(i+2) for bottom (facing -Z)
            Sp3dFace capFace = Sp3dFace([bottomIndices[0], bottomIndices[i + 2], bottomIndices[i + 1]], 0);
            fragments.add(Sp3dFragment([capFace]));
          }
        }

        // Top Cover
        List<int> topIndices = [];
        int topRowStart = hSegments * (uSegments + 1);
        for (int i = 0; i <= uSegments; i++) {
          topIndices.add(topRowStart + i); // Vertices from the last height segment

          if (uSegments >= 2) {
            for (int i = 0; i < uSegments - 1; i++) {
              // Winding: v0, v(i+1), v(i+2) for top (facing +Z)
              Sp3dFace capFace = Sp3dFace([topIndices[0], topIndices[i + 1], topIndices[i + 2]], 0);
              fragments.add(Sp3dFragment([capFace]));
            }
          }
        }
      }
    }

    return Sp3dObj(
      vertices,
      fragments,
      [material ?? FSp3dMaterial.grey.deepCopy()], // Default material
      [], // No default lines
    );
  }

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
    if (height == 0) {
      // While a 0-height cylinder is a flat circle (or two),
      // it might be unexpected. Consider if this should be an error or handled.
      // For now, let's allow it, it will create two flat circles if covers are on.
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
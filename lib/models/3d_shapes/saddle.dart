import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

extension Saddle on UtilSp3dGeometry {
  /// Creates a saddle shape (hyperbolic paraboloid).
  ///
  /// The surface is defined by the equation: z = (x^2 / a^2) - (y^2 / b^2)
  /// or adjusted for the parametric form used here.
  ///
  /// Parameters:
  /// - [width]: The extent of the saddle along the x-axis.
  /// - [depth]: The extent of the saddle along the y-axis.
  /// - [heightScale]: A scaling factor for the z-coordinate (height).
  ///                  Controls the "steepness" of the saddle.
  /// - [uBands]: Number of segments along the width (x-direction).
  /// - [vBands]: Number of segments along the depth (y-direction).
  /// - [material]: Optional material for the shape.
  static Sp3dObj saddle(
      double width,
      double depth,
      double heightScale, {
        int uBands = 20,
        int vBands = 20,
        Sp3dMaterial? material,
      }) {
    if (uBands < 1 || vBands < 1) {
      throw ArgumentError("uBands and vBands must be at least 1.");
    }
    if (width <= 0 || depth <= 0) {
      throw ArgumentError("width and depth must be positive.");
    }

    List<Sp3dV3D> vertices = [];
    List<Sp3dFragment> fragments = [];

    // The parameters u and v will map to x and y coordinates respectively.
    // u ranges from -width/2 to width/2
    // v ranges from -depth/2 to depth/2

    for (int i = 0; i <= uBands; i++) {
      double u = i / uBands; // Normalized u (0 to 1)
      double x = (u - 0.5) * width; // Map u to x range [-width/2, width/2]

      for (int j = 0; j <= vBands; j++) {
        double v = j / vBands; // Normalized v (0 to 1)
        double y = (v - 0.5) * depth; // Map v to y range [-depth/2, depth/2]

        // Hyperbolic paraboloid equation: z = k * (x^2 - y^2)
        // We can simplify and use the normalized u,v then scale
        // Or directly use x and y. Let's use x and y for clarity with the equation.
        // The heightScale acts as 'k' and allows adjustment of curvature.
        // We use x/width and y/depth to normalize them before squaring,
        // which helps in making heightScale more intuitive.
        double normalizedX = x / (width / 2); // normalize x to [-1, 1]
        double normalizedY = y / (depth / 2); // normalize y to [-1, 1]

        double z = heightScale * (normalizedX * normalizedX - normalizedY * normalizedY);

        vertices.add(Sp3dV3D(x, y, z));
      }
    }

    // Generate faces (quads made of two triangles)
    for (int i = 0; i < uBands; i++) {
      for (int j = 0; j < vBands; j++) {
        int first = (i * (vBands + 1)) + j;
        int second = first + vBands + 1;

        // Triangle 1
        Sp3dFace face1 = Sp3dFace([first, second, first + 1], 0);
        // Triangle 2
        Sp3dFace face2 = Sp3dFace([second, second + 1, first + 1], 0);

        fragments.add(Sp3dFragment([face1, face2]));
      }
    }

    return Sp3dObj(
      vertices,
      fragments,
      [material ?? FSp3dMaterial.grey.deepCopy()],
      [], // No default lines for this shape
    );
  }
}
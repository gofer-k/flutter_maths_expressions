import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

// extension Saddle on UtilSp3dGeometry {
//   /// Creates a saddle shape (hyperbolic paraboloid).
//   ///
//   /// The surface is defined by the equation: z = (x^2 / a^2) - (y^2 / b^2)
//   /// or adjusted for the parametric form used here.
//   ///
//   /// Parameters:
//   /// - [width]: The extent of the saddle along the x-axis.
//   /// - [depth]: The extent of the saddle along the y-axis.
//   /// - [heightScale]: A scaling factor for the z-coordinate (height).
//   ///                  Controls the "steepness" of the saddle.
//   /// - [uBands]: Number of segments along the width (x-direction).
//   /// - [vBands]: Number of segments along the depth (y-direction).
//   /// - [material]: Optional material for the shape.
//   static Sp3dObj saddle(
//       double width,
//       double depth,
//       double heightScale, {
//         int uBands = 20,
//         int vBands = 20,
//         Sp3dMaterial? material,
//       }) {
//     if (uBands < 1 || vBands < 1) {
//       throw ArgumentError("uBands and vBands must be at least 1.");
//     }
//     if (width <= 0 || depth <= 0) {
//       throw ArgumentError("width and depth must be positive.");
//     }
//
//     List<Sp3dV3D> vertices = [];
//     List<Sp3dFragment> fragments = [];
//
//     // The parameters u and v will map to x and y coordinates respectively.
//     // u ranges from -width/2 to width/2
//     // v ranges from -depth/2 to depth/2
//
//     for (int i = 0; i <= uBands; i++) {
//       double u = i / uBands; // Normalized u (0 to 1)
//       double x = (u - 0.5) * width; // Map u to x range [-width/2, width/2]
//
//       for (int j = 0; j <= vBands; j++) {
//         double v = j / vBands; // Normalized v (0 to 1)
//         double y = (v - 0.5) * depth; // Map v to y range [-depth/2, depth/2]
//
//         // Hyperbolic paraboloid equation: z = k * (x^2 - y^2)
//         // We can simplify and use the normalized u,v then scale
//         // Or directly use x and y. Let's use x and y for clarity with the equation.
//         // The heightScale acts as 'k' and allows adjustment of curvature.
//         // We use x/width and y/depth to normalize them before squaring,
//         // which helps in making heightScale more intuitive.
//         double normalizedX = x / (width / 2); // normalize x to [-1, 1]
//         double normalizedY = y / (depth / 2); // normalize y to [-1, 1]
//
//         double z = heightScale * (normalizedX * normalizedX - normalizedY * normalizedY);
//
//         vertices.add(Sp3dV3D(x, y, z));
//       }
//     }
//
//     // Generate faces (quads made of two triangles)
//     for (int i = 0; i < uBands; i++) {
//       for (int j = 0; j < vBands; j++) {
//         int first = (i * (vBands + 1)) + j;
//         int second = first + vBands + 1;
//
//         // Triangle 1
//         Sp3dFace face1 = Sp3dFace([first, second, first + 1], 0);
//         // Triangle 2
//         Sp3dFace face2 = Sp3dFace([second, second + 1, first + 1], 0);
//
//         fragments.add(Sp3dFragment([face1, face2]));
//       }
//     }
//
//     return Sp3dObj(
//       vertices,
//       fragments,
//       [material ?? FSp3dMaterial.grey.deepCopy()],
//       [], // No default lines for this shape
//     );
//   }
// }

extension Saddle on UtilSp3dGeometry {
  /// Creates a saddle shape (hyperbolic paraboloid) with an optional flat base cover.
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
  /// - [addBaseCover]: If true, adds a flat rectangular base to the saddle.
  /// - [baseCoverMaterial]: Optional material for the base cover.
  static Sp3dObj saddle(
      double width,
      double depth,
      double heightScale, {
        int uBands = 20,
        int vBands = 20,
        Sp3dMaterial? material,
        bool addBaseCover = true,
        Sp3dMaterial? baseCoverMaterial,
      }) {
    if (uBands < 1 || vBands < 1) {
      throw ArgumentError("uBands and vBands must be at least 1.");
    }
    if (width <= 0 || depth <= 0) {
      throw ArgumentError("width and depth must be positive.");
    }

    List<Sp3dV3D> vertices = [];
    List<Sp3dFragment> fragments = [];
    List<Sp3dMaterial> materials = [
      material ?? FSp3dMaterial.grey.deepCopy()
    ];
    int mainMaterialIndex = 0;
    int coverMaterialIndex = 0;

    if (addBaseCover) {
      if (baseCoverMaterial != null) {
        materials.add(baseCoverMaterial);
        coverMaterialIndex = materials.length - 1;
      } else {
        // Use a slightly different shade of grey for the cover if no specific material is provided
        // materials.add(FSp3dMaterial.grey.copyWith(diffuse: Sp3dColor(0.6, 0.6, 0.6)));
        materials.add(FSp3dMaterial.grey.deepCopy());
        coverMaterialIndex = materials.length - 1;
      }
    }

    // The parameters u and v will map to x and y coordinates respectively.
    // u ranges from -width/2 to width/2
    // v ranges from -depth/2 to depth/2

    for (int i = 0; i <= uBands; i++) {
      double u = i / uBands; // Normalized u (0 to 1)
      double x = (u - 0.5) * width; // Map u to x range [-width/2, width/2]

      for (int j = 0; j <= vBands; j++) {
        double v = j / vBands; // Normalized v (0 to 1)
        double y = (v - 0.5) * depth; // Map v to y range [-depth/2, depth/2]

        double normalizedX = x / (width / 2); // normalize x to [-1, 1]
        double normalizedY = y / (depth / 2); // normalize y to [-1, 1]

        double z =
            heightScale * (normalizedX * normalizedX - normalizedY * normalizedY);

        vertices.add(Sp3dV3D(x, y, z));
      }
    }

    // Generate faces for the saddle surface
    for (int i = 0; i < uBands; i++) {
      for (int j = 0; j < vBands; j++) {
        int first = (i * (vBands + 1)) + j;
        int second = first + vBands + 1;

        // Triangle 1
        Sp3dFace face1 = Sp3dFace([first, second, first + 1], mainMaterialIndex);
        // Triangle 2
        Sp3dFace face2 = Sp3dFace([second, second + 1, first + 1], mainMaterialIndex);

        fragments.add(Sp3dFragment([face1, face2]));
      }
    }

    if (addBaseCover) {
      // Find min Z for the base. For simplicity, we can use the Z of the corners
      // or calculate a general minimum Z if the saddle could dip below its corners.
      // For this saddle equation, the lowest points along the edges x = +/- width/2 or y = +/- depth/2
      // will be when normalizedX^2 is small and normalizedY^2 is large, or vice-versa.
      // The corners are:
      // (-w/2, -d/2), (w/2, -d/2), (-w/2, d/2), (w/2, d/2)
      // z at (-w/2, -d/2): heightScale * (1 - 1) = 0
      // z at ( w/2, -d/2): heightScale * (1 - 1) = 0
      // z at (-w/2,  d/2): heightScale * (1 - 1) = 0
      // z at ( w/2,  d/2): heightScale * (1 - 1) = 0
      // This is for the case where z = heightScale * ( (x/(w/2))^2 - (y/(d/2))^2 ).
      // The minimum z will be -heightScale (when x=0, y= +/-depth/2) if heightScale > 0
      // or heightScale (when y=0, x = +/-width/2) if heightScale < 0.
      // Let's make the base at the Z level of the lowest edge points.
      // The lowest points occur along y = +/- depth/2 (where normalizedY = +/-1)
      // and x = 0 (where normalizedX = 0), giving z = heightScale * (0 - 1) = -heightScale.
      // And along x = +/- width/2 (where normalizedX = +/-1)
      // and y = 0 (where normalizedY = 0), giving z = heightScale * (1 - 0) = heightScale.
      // So the minimum z is min(heightScale, -heightScale) if we consider the full surface.
      //
      // For simplicity, let's create a flat base at z determined by the lowest of the 4 corner *edge midpoints*
      // or just set it slightly below the lowest possible point.
      // The points defining the x-y extent are:
      // x: -width/2 to width/2
      // y: -depth/2 to depth/2

      // Determine the Z value for the base.
      // Let's make it such that it sits at the lowest points of the saddle's "downward curves".
      // This occurs at (0, +/-depth/2), where z = heightScale * (0 - 1) = -heightScale.
      // And the highest points of the "upward curves" occur at (+/-width/2, 0), where z = heightScale * (1 - 0) = heightScale.
      // We want the base to be flat. A common approach is to place it at the minimum z-value
      // of the boundary vertices, or a fixed offset.
      // Let's make the base at z = -abs(heightScale) to ensure it's at or below the lowest saddle point.
      double baseZ = -1 * heightScale;
      if (heightScale == 0) baseZ = 0; // Flat plane

      int vStartIndex = vertices.length;

      // Define the 4 corners of the base
      Sp3dV3D v0 = Sp3dV3D(-width / 2, -depth / 2, baseZ); // bottom-left
      Sp3dV3D v1 = Sp3dV3D(width / 2, -depth / 2, baseZ);  // bottom-right
      Sp3dV3D v2 = Sp3dV3D(width / 2, depth / 2, baseZ);   // top-right
      Sp3dV3D v3 = Sp3dV3D(-width / 2, depth / 2, baseZ);  // top-left

      vertices.addAll([v0, v1, v2, v3]);

      // Create two triangles for the rectangular base
      // Ensure winding order is correct for outward normal (typically counter-clockwise)
      // Assuming positive Y is "up" on the screen and positive X is "right",
      // looking from positive Z towards negative Z (from "above"):
      // v0-v1-v2 and v0-v2-v3
      Sp3dFace baseFace1 = Sp3dFace(
          [vStartIndex, vStartIndex + 1, vStartIndex + 2], coverMaterialIndex);
      Sp3dFace baseFace2 = Sp3dFace(
          [vStartIndex, vStartIndex + 2, vStartIndex + 3], coverMaterialIndex);

      fragments.add(Sp3dFragment([baseFace1, baseFace2]));
    }

    return Sp3dObj(
      vertices,
      fragments,
      materials,
      [], // No default lines for this shape
    );
  }
}

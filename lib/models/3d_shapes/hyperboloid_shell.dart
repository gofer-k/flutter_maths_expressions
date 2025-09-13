import 'dart:math';

import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

extension HyperboloidShell on UtilSp3dGeometry {
  // Helper for cosh and sinh if not available or for clarity
  static double _cosh(double x) => (exp(x) + exp(-x)) / 2;
  static double _sinh(double x) => (exp(x) - exp(-x)) / 2;

  static List<Sp3dV3D> _generateHyperboloidVertices(
      double a, // For one-sheet: throat radius. For two-sheets: scaling fa
      double b, // For elliptical cross-sections. Use 'a' if circular.
      double c, // Scaling factor for z.
      bool twoSheet, // True for two-sheet hyperboloid, false for one-sheet
      int uBands, // Number of bands along the 'u' parameter (height/stretch)
      int vBands, // Number of bands along the 'v' parameter (around the axis)
      double uMin,
      double uMax) {
    List<Sp3dV3D> vertices = [];

    // TODO: For two sheets, u typically starts from 0 (or a small positive value to avoid singularity at the pole if c=0)
    // and goes outwards. cosh(0)=1, sinh(0)=0.
    // We should ensure uMin is appropriate for the chosen type.
    // For two-sheets, u represents a radial-like parameter from the central axis for each nappe.
    final nappeSign = twoSheet ? 1 : -1;
    for (int i = 0; i <= uBands; i++) {
      // 'u' parameter, controlling the "height" or extent along the hyperboloid axis
      double u = uMin + (uMax - uMin) * (i / uBands);

      for (int j = 0; j <= vBands; j++) {
        // 'v' parameter, controlling the rotation around the main axis (usually z)
        double v = j * 2 * pi / vBands;

        double cosV = cos(v);
        double sinV = sin(v);
        double coshU = _cosh(u);
        double sinhU = _sinh(u);

        // Parametric equations for a hyperboloid of one sheet (axis along z)
        // x = a * cosh(u) * cos(v)
        // y = a * cosh(u) * sin(v) // Assuming b=a for a circular cross-section in x-y
        // z = c * sinh(u)
        double x, y, z;

        if (twoSheet) {
          // Hyperboloid of Two Sheets
          // x = a * sinh(u) * cos(v)
          // y = b * sinh(u) * sin(v)
          // z = ±c * cosh(u)
          x = a * sinhU * cosV;
          y = b * sinhU * sinV;
          z = nappeSign * c * coshU;
        } else {
          // Hyperboloid of One Sheet
          // x = a * cosh(u) * cos(v)
          // y = b * cosh(u) * sin(v)
          // z = c * sinh(u)
          x = a * coshU * cosV;
          y = b * coshU * sinV;
          z = c * sinhU;
        }
        vertices.add(Sp3dV3D(x, y, z));
      }
    }
    return vertices;
  }

  static Sp3dObj hyperboloidShell(
      String? id,
      double a, // Controls the "throat" radius (radius at z=0 for one-sheet)
      double b, // If you want elliptical cross-sections, add this and use it for 'y'
      double c, // Controls the curvature/steepness along the z-axis
      bool twoSheet,
      {
        // bool inner = true, // Let's re-evaluate 'inner'. For one sheet, it's one continuous surface.
        // For two sheets, it would select one of the two disconnected parts.
        int uBands = 20, // Controls segments along the length
        int vBands = 30, // Controls segments around the circumference
        double uMin = -1.5, // Min 'u' value, controls how far the hyperboloid extends
        double uMax = 1.5, // Max 'u' value
        Sp3dMaterial? material,
      }) {
    // The 'b' parameter from your original signature isn't directly used here
    // for a circular hyperboloid. If you need an elliptical base,
    // you'd re-introduce 'b' into the y-component calculation in _generateHyperboloidVertices.
    // For now, I'm assuming a circular cross-section (like a cooling tower shape).

    double actualUMin, actualUMax;

    if (twoSheet) {
      actualUMin = uMin ?? 0.1; // Default for two sheets (avoid u=0 if a,b != 0)
      actualUMax = uMax ?? 1.5;
      if (actualUMin < 0) {
        print("Warning: uMin for two-sheet hyperboloid should generally be >= 0.");
        actualUMin = 0.1; // Correct if negative
      }
    } else {
      actualUMin = uMin ?? -1.5; // Default for one sheet
      actualUMax = uMax ?? 1.5;
    }

    List<Sp3dV3D> vertices = _generateHyperboloidVertices(
        a, b, c, twoSheet, uBands, vBands, actualUMin, actualUMax);

    List<Sp3dFragment> fragments = [];
    for (int i = 0; i < uBands; i++) {
      for (int j = 0; j < vBands; j++) {
        int first = (i * (vBands + 1)) + j;
        int second = first + vBands + 1;

        List<Sp3dFace> faces = [
          Sp3dFace([first, second, first + 1], 0),
          Sp3dFace([second, second + 1, first + 1], 0),
        ];
        fragments.add(Sp3dFragment(faces));
      }
    }

    return Sp3dObj(
      id: id,
      vertices,
      fragments,
      [material ?? FSp3dMaterial.grey.deepCopy()],
      [],
    );
  }
}
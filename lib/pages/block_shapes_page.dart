import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:simple_3d_renderer/simple_3d_renderer.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

import '../widgets/background_container.dart';

class BlockShapesPage extends StatefulWidget {
  final String title;
  const BlockShapesPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _BlockShapesPageState();
}

class _BlockShapesPageState extends State<BlockShapesPage> {
  late Sp3dWorld _world;
  late final List<Sp3dObj> _objs = [];
  bool _isLoaded = false;

  // Use the camera that best suits your needs.
  // This package allows you to customize various movements,
  // including camera rotation control, by extending the controller class.
  final Sp3dCamera _camera = Sp3dCamera(Sp3dV3D(0, 0, 1000), 1000);
  // final Sp3dFreeLookCamera _camera = Sp3dFreeLookCamera(Sp3dV3D(0,0,1000), 1000);
  final Sp3dCameraRotationController _camRCtrl = Sp3dCameraRotationController();
  static const Sp3dCameraZoomController _camZCtrl = Sp3dCameraZoomController();

  @override
  void initState() {
    super.initState();
    // {
    //   Sp3dObj obj = Ellipsoid.ellipsoid(100, 100, 0);
    //   obj.materials.add(FSp3dMaterial.blue.deepCopy());
    //   obj.fragments[0].faces[0].materialIndex = 1;
    //   obj.materials[0] = FSp3dMaterial.grey.deepCopy()
    //     ..strokeColor = const Color.fromARGB(0, 0, 0, 255);
    //   obj.rotate(Sp3dV3D(1, 1, 0).nor(), 30 * pi / 180);
    //   _objs.add(obj);
    // }
    {
      Sp3dObj obj = HyperboloidShell.hyperboloidShell(50, 50, 100, false, uBands: 20, vBands: 30, uMin: 1.0, uMax: -1.0);
      obj.materials.add(FSp3dMaterial.red.deepCopy());
      obj.fragments[0].faces[0].materialIndex = 1;
      obj.materials[0] = FSp3dMaterial.grey.deepCopy()
        ..strokeColor = const Color.fromARGB(0, 0, 0, 255);
      obj.rotate(Sp3dV3D(1, 1, 0).nor(), 15 * pi / 180);
      _objs.add(obj);
    }
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      beginColor: Colors.grey.shade300,
       endColor: Colors.grey.shade800,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.title, style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: Column(
            children: [
              Sp3dRenderer(
                const Size(600, 600),
                const Sp3dV2D(100, 100),
                _world,
                // If you want to reduce distortion, shoot from a distance at high magnification.
                _camera,
                Sp3dLight(Sp3dV3D(0, 0, -1), syncCam: true),
                rotationController: _camRCtrl,
                zoomController: _camZCtrl,
              ),
            ],
          ),
        ),
      )
    );
  }

  void loadImage() async {
    _world = Sp3dWorld(_objs);
    _world.initImages().then((List<Sp3dObj> errorObjs) {
      setState(() {
        _isLoaded = true;
      });
    });
  }
}

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
      [],
    );
  }
}

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
      vertices,
      fragments,
      [material ?? FSp3dMaterial.grey.deepCopy()],
      [],
    );
  }
}


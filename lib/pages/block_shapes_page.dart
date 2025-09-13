import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/widgets/dropdown.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:simple_3d_renderer/simple_3d_renderer.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

import '../models/3d_shapes/cone.dart';
import '../models/3d_shapes/cylinder.dart';
import '../models/3d_shapes/ellipsoid.dart';
import '../models/3d_shapes/hyperboloid_shell.dart';
import '../models/3d_shapes/saddle.dart';
import '../models/3d_shapes/shape_type.dart';
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
  late Size _worldSize;
  final _margin3dView = 4.0;
  late double _halfMargin3dView;
  late Size _renderSize;

  // Use the camera that best suits your needs.
  // This package allows you to customize various movements,
  // including camera rotation control, by extending the controller class.
  late Sp3dCamera _camera;
  // final Sp3dFreeLookCamera _camera = Sp3dFreeLookCamera(Sp3dV3D(0,0,1000), 1000);
  final Sp3dCameraRotationController _camRCtrl = Sp3dCameraRotationController();
  static const Sp3dCameraZoomController _camZCtrl = Sp3dCameraZoomController();

  bool _dependenciesInitialized = false; // Flag to run logic only once

  @override
  void initState() {
    super.initState();
    _halfMargin3dView = _margin3dView / 2;
    _renderShape(ShapeType.ellipsoid);
    loadImage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dependenciesInitialized) {
      final sizeView = MediaQuery.sizeOf(context);
      double width = sizeView.width > 600 ? 600 : sizeView.width;
      // Ensure height is not greater than the determined width, if that's the desired constraint
      double height = sizeView.height > width ? width : sizeView.height;
      _renderSize = Size(width, height);

      _worldSize = Size(
          _renderSize.width - _halfMargin3dView,
          _renderSize.height - _halfMargin3dView);

      _objs.addAll(UtilSp3dCommonParts.coordinateArrows(
        _renderSize.shortestSide * 0.75,
        materialX: FSp3dMaterial.redNonWire.deepCopy(),
        materialY: FSp3dMaterial.greenNonWire.deepCopy(),
        materialZ: FSp3dMaterial.blueNonWire.deepCopy(),
        useArrowHead: false));

      loadImage();

      _dependenciesInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If _dependenciesInitialized is false, it means didChangeDependencies hasn't run yet.
    // You might want to show a loader or an empty container.
    if (!_dependenciesInitialized) {
      return const BackgroundContainer( // Or your preferred loading widget
        beginColor: Colors.grey,
        endColor: Colors.black,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

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
          padding: const EdgeInsets.only(top: 8.0, left: 2.0, right: 2.0),
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: _renderSize.width,
                  maxHeight: _renderSize.height,
                ),
                decoration: BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(color: Colors.black87)),
                margin: EdgeInsets.all(_margin3dView),
                child:  Column(
                  children: [
                    Sp3dRenderer(
                        _worldSize,
                        Sp3dV2D(_worldSize.width / 2, _worldSize.height / 2), // canvas center = Origin world space (0, 0)
                        _world,
                        // If you want to reduce distortion, shoot from a distance at high magnification.
                        _camera,
                        Sp3dLight(Sp3dV3D(0, 0, 1), syncCam: true),
                        rotationController: _camRCtrl,
                        zoomController: _camZCtrl,
                        useClipping: true
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child:Dropdown(shapeType: ShapeType.ellipsoid, onShapeSelected: (ShapeType selectedShape) {
                  _renderShape(selectedShape);
                },)
              ),
            ],
          ),
        ),
      )
    );
  }

  void loadImage() async {
    _camera = Sp3dCamera(Sp3dV3D(0, 0, _worldSize.shortestSide * 2),
        _worldSize.shortestSide * 2,
        radian: pi/6,
        rotateAxis: Sp3dV3D(1, -1, 0)
    );
    _world = Sp3dWorld(_objs);
    _world.initImages().then((List<Sp3dObj> errorObjs) {
      setState(() {
        _isLoaded = true;
      });
    });
  }

  void _renderShape(ShapeType selectedShape) {
    switch (selectedShape) {
      case ShapeType.ellipsoid:
        _renderEllipsoid();
      case ShapeType.hyperboloid_one_shell:
        _renderHyperboloid(twoShell: false);
      case ShapeType.hyperboloid_two_shell:
        _renderHyperboloid(twoShell: true);
        case ShapeType.saddle:
        _renderSaddle();
      case ShapeType.cone:
        _renderCone();
      case ShapeType.cylinder:
        _renderCylinder();
      case ShapeType.hyperbolic_cylinder:
        _renderCylinder(hyperbolic: true);
    }
  }

  void _renderEllipsoid() {
    Sp3dObj obj = Ellipsoid.ellipsoid(100, 100, 200);
    obj.materials.add(FSp3dMaterial.blue.deepCopy());
    obj.fragments[0].faces[0].materialIndex = 1;
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(0, 0, 0, 255);
    obj.layerNum = -3;

    if (_objs.isNotEmpty) {
      _objs.first = obj;
    }
    else {
      _objs.add(obj);
    }
  }

  void _renderHyperboloid({required bool twoShell}) {
    Sp3dObj obj = HyperboloidShell.hyperboloidShell(25, 50, 100, twoShell, uBands: 20, vBands: 30, uMin: 1.0, uMax: -1.0);
    obj.materials.add(FSp3dMaterial.red.deepCopy());
    obj.fragments[0].faces[0].materialIndex = 1;
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(0, 0, 0, 255);
    obj.rotate(Sp3dV3D(1, 1, 0).nor(), 15 * pi / 180);

    if (_objs.isNotEmpty) {
      _objs.first = obj;
    }
    else {
      _objs.add(obj);
    }
  }

  void _renderSaddle() {
    Sp3dObj obj = Saddle.saddle(200, 100, 50);
    obj.materials.add(FSp3dMaterial.red.deepCopy());
    obj.fragments[0].faces[0].materialIndex = 1;
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(0, 0, 0, 255);
    obj.rotate(Sp3dV3D(0, 1, 1).nor(), -135 * pi / 180);

    if (_objs.isNotEmpty) {
      _objs.first = obj;
    }
    else {
      _objs.add(obj);
    }
  }

  void _renderCone() {
    Sp3dObj obj = Cone.cone(radius: 100, height: 200);
    obj.materials.add(FSp3dMaterial.red.deepCopy());
    obj.fragments[0].faces[0].materialIndex = 1;
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(0, 0, 0, 255);
    obj.rotate(Sp3dV3D(0, 1, 1).nor(), -135 * pi / 180);
    if (_objs.isNotEmpty) {
      _objs.first = obj;
    }
    else {
      _objs.add(obj);
    }
  }

  void _renderCylinder({bool hyperbolic = false}) {
    Sp3dObj obj = hyperbolic ?
        // TODO: improve rotation parameters
      HyperbolicCylinder.hyperbolicCylinder(
        a: 50, b: 50, height: 200, opensAlongX: false, addCovers: false) :
    // TODO: improve rotation parameters
      HyperbolicCylinder.cylinder(
        radius: 75, height: 250);

    obj.materials.add(FSp3dMaterial.red.deepCopy());
    obj.fragments[0].faces[0].materialIndex = 1;
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(0, 0, 0, 255);
    obj.rotate(Sp3dV3D(0, 1, 1).nor(), -30 * pi / 180);
    if (_objs.isNotEmpty) {
      _objs.first = obj;
    }
    else {
      _objs.add(obj);
    }
  }
}



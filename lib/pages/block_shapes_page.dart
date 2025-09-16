import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/3d_shapes/shape_model.dart';
import 'package:flutter_maths_expressions/widgets/display_expression.dart';
import 'package:flutter_maths_expressions/widgets/dropdown.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:simple_3d_renderer/simple_3d_renderer.dart';
import 'package:util_simple_3d/util_simple_3d.dart';
import '../models/3d_shapes/shape_type.dart';
import '../widgets/background_container.dart';
import '../widgets/factor_slider.dart';

class BlockShapesPage extends StatefulWidget {
  final String title;
  const BlockShapesPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _BlockShapesPageState();
}

class _BlockShapesPageState extends State<BlockShapesPage> with SingleTickerProviderStateMixin {
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
  ShapeType _currentShape = ShapeType.ellipsoid;

  late AnimationController _expandController;
  late Animation<double> _expandAnimationParameters;
  bool _isInputParametersExpanded = true;

  final _shapeModel = <ShapeType, ShapeModel>{
    ShapeType.ellipsoid: ShapeModel(type: ShapeType.ellipsoid, a: 200, b: 100, c: 100),
    ShapeType.cone: ShapeModel(type: ShapeType.cone, a: 100, b: 100, c: 75),
    ShapeType.cylinder: ShapeModel(
        type: ShapeType.cylinder, a: 75, b: 75, c: 200),
    ShapeType.hyperbolic_cylinder: ShapeModel(
        type: ShapeType.hyperbolic_cylinder, a: 75, b: 75, c: 200),
    ShapeType.hyperboloid_one_shell: ShapeModel(
        type: ShapeType.hyperboloid_one_shell, a: 50, b: 50, c: 100),
    ShapeType.hyperboloid_two_shell: ShapeModel(
        type: ShapeType.hyperboloid_two_shell, a: 50, b: 50, c: 100),
    ShapeType.saddle: ShapeModel(type: ShapeType.saddle, a: 200, b: 100, c: 50)
  };

  @override
  void initState() {
    super.initState();
    _halfMargin3dView = _margin3dView / 2;
    _renderShape(_currentShape);
    _loadImage();

    _expandController = AnimationController(
      vsync: this, // from SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 300),
    );

    _expandAnimationParameters = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
    if (_isInputParametersExpanded) {
      _expandController.forward();
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
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

      _loadImage();

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
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    const topHorizontalMargin = 2.0;

    return BackgroundContainer(
      beginColor: Colors.grey.shade300,
      endColor: Colors.grey.shade800,
      child: SafeArea(
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
            padding: const EdgeInsets.only(
                top: 8.0,
                left: topHorizontalMargin,
                right: topHorizontalMargin),
            child: Column(
              children: [
                // Render shape
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
                // Choose the shape
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Dropdown(
                    shapeType: _currentShape,
                    onShapeSelected: (ShapeType selectedShape) {
                      // Update widgets
                      setState(() {
                        _currentShape = selectedShape;
                        _renderShape(_currentShape);
                      });
                    }
                  )
                ),
                // Parameters area
                _shapeParameters(_currentShape, topHorizontalMargin),
              ],
            ),
          ),
        )
      ),
    );
  }

  void _toggleExpandParameters() {
    setState(() {
      _isInputParametersExpanded = !_isInputParametersExpanded;
      if (_isInputParametersExpanded) {
        _expandController.forward(); // Play animation to expand
      } else {
        _expandController.reverse(); // Play animation to collapse
      }
    });
  }
  
  void _loadImage() async {
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
    Sp3dObj? obj;
    switch (selectedShape) {
      case ShapeType.ellipsoid:
        obj = _renderEllipsoid();
      case ShapeType.hyperboloid_one_shell:
        obj = _renderHyperboloid(twoShell: false);
      case ShapeType.hyperboloid_two_shell:
        obj = _renderHyperboloid(twoShell: true);
        case ShapeType.saddle:
          obj = _renderSaddle();
      case ShapeType.cone:
        obj = _renderCone();
      case ShapeType.cylinder:
        obj = _renderCylinder();
      case ShapeType.hyperbolic_cylinder:
        obj = _renderCylinder(hyperbolic: true);
    }
    if (obj != null) {
      if (_objs.isNotEmpty) {
        _objs.first = obj;
      }
      else {
        _objs.add(obj);
      }
    }
  }

  Sp3dObj? _renderEllipsoid() {
    final ShapeModel? model = _shapeModel[ShapeType.ellipsoid];

    if (model != null) {
      Sp3dObj obj = _shapeModel[ShapeType.ellipsoid]!.display();
      obj.materials.add(FSp3dMaterial.blue.deepCopy());
      obj.fragments[0].faces[0].materialIndex = 1;
      obj.materials[0] = FSp3dMaterial.grey.deepCopy()
        ..strokeColor = const Color.fromARGB(0, 0, 0, 255);
      obj.layerNum = -3;

      return obj;
    }
    return null;
  }

  Sp3dObj? _renderHyperboloid({required bool twoShell}) {
    final ShapeModel? model = _shapeModel[ShapeType.hyperboloid_two_shell];

    if (model != null) {
      Sp3dObj? obj = _shapeModel[ShapeType.hyperboloid_two_shell]?.display();
      if (obj != null) {
        obj.materials.add(FSp3dMaterial.red.deepCopy());
        obj.fragments[0].faces[0].materialIndex = 1;
        obj.materials[0] = FSp3dMaterial.grey.deepCopy()
          ..strokeColor = const Color.fromARGB(0, 0, 0, 255);
        obj.rotate(Sp3dV3D(1, 1, 0).nor(), 15 * pi / 180);
      }
      return obj;
    }
    return null;
  }

  Sp3dObj? _renderSaddle() {
    final ShapeModel? model = _shapeModel[ShapeType.saddle];

    if (model != null) {
      Sp3dObj? obj = _shapeModel[ShapeType.saddle]?.display();
      if (obj != null) {
        obj.materials.add(FSp3dMaterial.red.deepCopy());
        obj.fragments[0].faces[0].materialIndex = 1;
        obj.materials[0] = FSp3dMaterial.grey.deepCopy()
          ..strokeColor = const Color.fromARGB(0, 0, 0, 255);
        obj.rotate(Sp3dV3D(0, 1, 1).nor(), -135 * pi / 180);
      }
      return obj;
    }
    return null;
  }

  Sp3dObj? _renderCone() {
    final ShapeModel? model = _shapeModel[ShapeType.cone];

    if (model != null) {
      Sp3dObj? obj = _shapeModel[ShapeType.cone]?.display();
      if (obj != null) {
        obj.materials.add(FSp3dMaterial.red.deepCopy());
        obj.fragments[0].faces[0].materialIndex = 1;
        obj.materials[0] = FSp3dMaterial.grey.deepCopy()
          ..strokeColor = const Color.fromARGB(0, 0, 0, 255);
        obj.rotate(Sp3dV3D(0, 1, 1).nor(), -135 * pi / 180);
      }
      return obj;
    }
    return null;
  }

  Sp3dObj? _renderCylinder({bool hyperbolic = false}) {
    final ShapeModel? model = _shapeModel[ShapeType.saddle];

     if (model != null) {
       Sp3dObj? obj = hyperbolic ?
       // TODO: improve rotation parameters
       _shapeModel[ShapeType.hyperbolic_cylinder]?.display() :
       _shapeModel[ShapeType.cylinder]?.display();

       if (obj != null) {
         obj.materials.add(FSp3dMaterial.red.deepCopy());
         obj.fragments[0].faces[0].materialIndex = 1;
         obj.materials[0] = FSp3dMaterial.grey.deepCopy()
           ..strokeColor = const Color.fromARGB(0, 0, 0, 255);
         obj.rotate(Sp3dV3D(0, 1, 1).nor(), -30 * pi / 180);
       }
       return obj;
     }
     return null;
  }

  Widget _shapeParameters(ShapeType shapeType, double horizontalMargin) {
    double exprScale = 1.5;
    String expression = _shapeExpression(shapeType);

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: horizontalMargin),
      child: Column(
        children: [
          DisplayExpression(
            context: context,
            expression: expression,
            scale: exprScale,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
              fontWeight: Theme.of(context).textTheme.bodyLarge?.fontWeight,
            )),
          Column(
            children: [
              InkWell(
                onTap: _toggleExpandParameters,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("Animation Parameters",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                      Icon(
                        _isInputParametersExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 30.0,
                        semanticLabel: _isInputParametersExpanded ? 'Collapse parameters' : 'Expand parameters',
                      ),
                    ]
                ),
              ),
              SizeTransition(
                axisAlignment: -1.0,
                sizeFactor: _expandAnimationParameters,
                child: Column(
                  children: [
                    _editShapeParameters(shapeType, horizontalMargin),
                  ]
                ),
              ),
            ],
          ),
        ]
      )
    );
  }

  String _shapeExpression(ShapeType shapeType) {
    switch(shapeType) {
      case ShapeType.ellipsoid:
        return r"\frac{x^2}{a^2} + \frac{y^2}{b^2} + \frac{z^2}{c^2} = 1";
      case ShapeType.hyperboloid_two_shell:
        return r"\frac{x^2}{a^2} + \frac{y^2}{b^2} - \frac{z^2}{c^2} - 1 = 0";
      case ShapeType.hyperboloid_one_shell:
        return r"\frac{x^2}{a^2} + \frac{y^2}{b^2} - \frac{z^2}{c^2} + 1 = 0";
      case ShapeType.saddle:
        return r"\frac{x^2}{a^2} - \frac{y^2}{b^2} - z = 0";
      case ShapeType.cone:
        return r"\frac{x^2}{r^2} + \frac{y^2}{r^2} + \frac{z^2}{h^2} = 0";
        // General form:
        // return r"\frac{x^2}{a^2} + \frac{y^2}{b^2} - \frac{z^2}{c^2} = 0";
      case ShapeType.cylinder:
        return r"\frac{x^2}{a^2)} + \frac{y^2}{b^2} - 1 = 0";
      case ShapeType.hyperbolic_cylinder:
        return r"\frac{x^2}{a^2)} - \frac{y^2}{b^2} - 1 = 0";
    // return r"\Frac{y^2}{a^2)} - \frac{x^2}{b^2} - 1 = 0";
    }
  }

  Widget _editShapeParameters(ShapeType shapeType, double horizontalMargin) {
    switch(shapeType) {
      case ShapeType.ellipsoid:
       return _editEllipsoidParameters(horizontalMargin);
      case ShapeType.hyperboloid_two_shell:
        return _editHyperboloidParameters(horizontalMargin);
      case ShapeType.hyperboloid_one_shell:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ShapeType.saddle:
        return _editSaddleParameters(horizontalMargin);
      case ShapeType.cone:
        return _editConeParameters(horizontalMargin);
      case ShapeType.cylinder:
        return _editCylinderParameters(horizontalMargin);
      case ShapeType.hyperbolic_cylinder:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Widget _editEllipsoidParameters(double horizontalMargin) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: horizontalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FactorSlider(label: r'a', initialValue: _shapeModel[_currentShape]!.a, minValue: 100, maxValue: 200,
            onChanged: (double value) {
              if (_shapeModel[_currentShape]?.a != value) {
                setState(() {
                  _shapeModel[_currentShape]?.a = value;
                  _renderShape(_currentShape);
                });
              }
            }
          ),
          FactorSlider(label: r'b', initialValue: _shapeModel[_currentShape]!.b, minValue: 100, maxValue: 200,
              onChanged: (double value) {
                if (_shapeModel[_currentShape]?.b != value) {
                  setState(() {
                    _shapeModel[_currentShape]?.b = value;
                    _renderShape(_currentShape);
                  });
                }
              }
          ),
          FactorSlider(label: r'c', initialValue: _shapeModel[_currentShape]!.c, minValue: 100, maxValue: 200,
              onChanged: (double value) {
                if (_shapeModel[_currentShape]?.c != value) {
                  setState(() {
                    _shapeModel[_currentShape]?.c = value;
                    _renderShape(_currentShape);
                  });
                }
              }
          ),
        ],
      ),
    );
  }

  Widget _editHyperboloidParameters(double horizontalMargin) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: Column(
          children: [
            Text("Now implemented hyperbolic params")
          ]
      ),
    );
  }

  Widget _editSaddleParameters(double horizontalMargin) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: Column(
        children: [
          Text("Now implemented saddle params")
        ]
      ),
    );
  }

  Widget _editConeParameters(double horizontalMargin) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: Column(
        children: [
          Text("Now implemented cone params")
        ]
      ),
    );
  }

  Widget _editCylinderParameters(double horizontalMargin) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: Column(
        children: [
          Text("Now implemented cylinder params")
        ]
      ),
    );
  }
}
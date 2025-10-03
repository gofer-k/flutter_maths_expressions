import 'package:flutter/cupertino.dart';

import '../../l10n/app_localizations.dart';

enum ShapeType {
  ellipsoid,
  hyperboloid_two_shell,
  hyperboloid_one_shell,
  saddle,
  cone,
  cylinder,
  hyperbolic_cylinder;
}

extension ShapeTypeLocalization on ShapeType {
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ShapeType.ellipsoid:
        return l10n.shapeTypeEllipsoid;
      case ShapeType.hyperboloid_two_shell:
        return l10n.shapeTypeHyperboloidTwoShell;
      case ShapeType.hyperboloid_one_shell:
        return l10n.shapeTypeHyperboloidOneShell;
      case ShapeType.saddle:
        return l10n.shapeTypeSaddle;
      case ShapeType.cone:
        return l10n.shapeTypeCone;
      case ShapeType.cylinder:
        return l10n.shapeTypeCylinder;
      case ShapeType.hyperbolic_cylinder:
        return l10n.shapeTypeHyperbolicCylinder;
    }
  }
}
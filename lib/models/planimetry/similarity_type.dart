import 'package:flutter/cupertino.dart';

import '../../l10n/app_localizations.dart';

enum SimilarityType {
  sideSideSide,
  angleAngleAngle,
  sideAngleSide,
}

extension SimilarityTypeLocalization on SimilarityType {
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case SimilarityType.sideSideSide:
        return l10n.similaritySSS;
      case SimilarityType.angleAngleAngle:
        return l10n.similarityAAA;
      case SimilarityType.sideAngleSide:
        return l10n.similaritySAS;
    }
  }
}
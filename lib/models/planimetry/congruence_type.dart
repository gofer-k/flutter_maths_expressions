import 'package:flutter/cupertino.dart';

import '../../l10n/app_localizations.dart';

enum CongruenceType {
  sideSideSide,
  sideAngleSide,
  angleSideAngle,
}

extension CongruenceTypeLocalization on CongruenceType {
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case CongruenceType.sideSideSide:
        return l10n.congruenceSSS;
      case CongruenceType.sideAngleSide:
        return l10n.congruenceSAS;
      case CongruenceType.angleSideAngle:
        return l10n.congruenceASA;
    }
  }
}
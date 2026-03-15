import "package:flutter/material.dart";
import "theme.dart";

void scrollToSection(GlobalKey sectionKey) {
  final context = sectionKey.currentContext;
  if (context != null) {
    Scrollable.ensureVisible(context);
  }
}

final GlobalKey historialKey = GlobalKey();
final GlobalKey chatKey = GlobalKey();

import 'package:flutter/material.dart';

class styles {
  BuildContext context;

  Color get primaryC => Theme.of(context).colorScheme.primary;
  Color get onPrimaryC => Theme.of(context).colorScheme.onPrimary;
  Color get secondary => Theme.of(context).colorScheme.secondary;
  Color get surface => Theme.of(context).colorScheme.surface;
  Color get onSurface => Theme.of(context).colorScheme.onSurface;

  styles({required this.context});
}

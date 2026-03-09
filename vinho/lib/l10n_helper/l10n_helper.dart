import 'package:flutter/material.dart';

class L10nHelper extends InheritedWidget {
  const L10nHelper(
      {Key? key,
      required Widget child,
      required this.localChangeCallback,
      required this.currentLocaleCallback})
      : super(child: child, key: key);

  final void Function(Locale) localChangeCallback;
  final Locale Function() currentLocaleCallback;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static L10nHelper of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<L10nHelper>()!;

  void changeLocale(Locale locale) => localChangeCallback(locale);
  Locale currentLocale() => currentLocaleCallback();
}

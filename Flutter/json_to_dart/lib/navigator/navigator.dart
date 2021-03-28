import 'package:flutter/widgets.dart';

class AppNavigator {
  factory AppNavigator() => _appNavigator;
  AppNavigator._();
  static final AppNavigator _appNavigator = AppNavigator._();
  final GlobalKey<NavigatorState> _key = GlobalKey(debugLabel: 'navigate_key');
  GlobalKey<NavigatorState> get key => _key;
  BuildContext get context => _key.currentState!.context;
}

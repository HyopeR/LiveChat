import 'package:flutter/material.dart';

class NavigationService {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> pushNamed(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> pushReplacementNamed(String routeName) {
    return navigatorKey.currentState.pushReplacementNamed(routeName);
  }

  void pop(String routeName) {
    return navigatorKey.currentState.pop();
  }
}
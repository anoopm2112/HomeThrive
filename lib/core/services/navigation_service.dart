import 'package:flutter/widgets.dart';

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();

  final NavigatorState _currentNavState = navigatorKey.currentState;

  // Pushes [routeName] onto the navigation stack
  Future<T> navigateTo<T extends Object>(
    String routeName, {
    Object arguments,
  }) {
    assert(routeName != null);

    return _currentNavState.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Replaces the current route with [routeName]
  Future<T> replaceWith<T extends Object, TO extends Object>(
    String routeName, {
    TO result,
    Object arguments,
  }) {
    assert(routeName != null);

    return _currentNavState.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  /// Clears the entire stack and shows [routeName]
  Future<T> clearStackAndShow<T extends Object>(
    String routeName, {
    Object arguments,
  }) {
    assert(routeName != null);

    return _currentNavState.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Clears the entire stack until [routeName]
  void clearStackUntil(String routeName) {
    assert(routeName != null);

    return _currentNavState.popUntil(
      (route) => route.settings.name == routeName,
    );
  }

  /// Pops the current scope
  void back<T extends Object>({T result}) {
    _currentNavState.pop<T>(result);
  }
}

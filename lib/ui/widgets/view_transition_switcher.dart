import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';

class ViewTransitionSwitcher extends StatelessWidget {
  final Widget child;
  final bool reverse;

  const ViewTransitionSwitcher({
    Key key,
    @required this.child,
    this.reverse = false,
  })  : assert(child != null),
        assert(reverse != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 600),
      reverse: this.reverse,
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
        );
      },
      child: this.child,
    );
  }
}

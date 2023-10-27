import 'package:flutter/widgets.dart';

class CreationAwareWidget extends StatefulWidget {
  final void Function() onWidgetCreated;
  final Widget child;
  const CreationAwareWidget({
    Key key,
    this.onWidgetCreated,
    this.child,
  }) : super(key: key);

  @override
  _CreationAwareWidgetState createState() => _CreationAwareWidgetState();
}

class _CreationAwareWidgetState extends State<CreationAwareWidget> {
  @override
  void initState() {
    super.initState();
    widget.onWidgetCreated?.call();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

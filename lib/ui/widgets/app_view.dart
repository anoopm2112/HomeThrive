import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/ui_utils.dart';

class AppView extends StatelessWidget {
  final String title;
  final Widget child;

  const AppView({
    Key key,
    this.title,
    this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Padding(
          padding: defaultViewPaddingHorizontal,
          child: Text(
            this.title,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        this.child,
      ],
    );
  }
}
